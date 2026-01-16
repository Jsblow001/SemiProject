package hk.member.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import hk.member.domain.AddressDTO;
import hk.member.domain.MemberCountDTO;
import hk.member.domain.MemberDTO;
import sp.util.security.AES256;
import sp.util.security.SecretMyKey;
import sp.util.security.Sha256;

/*
 * [MemberDAO_imple]
 * - 회원 관련 DAO 구현 클래스
 * - Tomcat DBCP(DataSource) 사용
 * - 비밀번호 : SHA-256
 * - 이메일/휴대폰 : AES256
 *
 *   현재 상태
 *   - 로그인 : 정상
 *   - 회원가입 : 정상
 */
public class MemberDAO_imple implements MemberDAO {

    // ===== DBCP =====
    private DataSource ds;
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;

    // ===== 암호화 =====
    private AES256 aes;

    // ===== 생성자 =====
    public MemberDAO_imple() {
        try {
            Context initContext = new InitialContext();
            Context envContext  = (Context) initContext.lookup("java:/comp/env");

            ds  = (DataSource) envContext.lookup("SemiProject");
            aes = new AES256(SecretMyKey.KEY);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ===== 자원 반납 =====
    private void close() {
        try {
            if (rs != null)    { rs.close(); rs = null; }
            if (pstmt != null) { pstmt.close(); pstmt = null; }
            if (conn != null)  { conn.close(); conn = null; }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    
 // ======================================================
 // 회원가입 (TBL_MEMBER + TBL_ADDRESS 동시 처리)
 // ======================================================
 @Override
 public int registerMember(MemberDTO member, AddressDTO address) throws SQLException {

     int result = 0;

     try {
         conn = ds.getConnection();
         conn.setAutoCommit(false); // ★ 트랜잭션 시작

         // ==================================================
         // 1️⃣ TBL_MEMBER INSERT (기존 컬럼명 그대로)
         // ==================================================
         String sqlMember =
                 " INSERT INTO TBL_MEMBER "
               + " (MEMBER_ID, NAME, PASSWD, EMAIL, MOBILE, "
               + "   POSTCODE, ADDRESS, DETAILADDRESS, EXTRAADDRESS, "
               + "   GENDER, BIRTHDAY, POINT, STATUS, "
               + "   REGISTERDAY, LASTPWDCHANGEDATE, GRADE_CODE) "
               + " VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "
               + "         5000, 1, SYSDATE, SYSDATE, 1) ";

         pstmt = conn.prepareStatement(sqlMember);

         pstmt.setString(1, member.getUserid());
         pstmt.setString(2, member.getName());
         pstmt.setString(3, Sha256.encrypt(member.getPasswd()));
         pstmt.setString(4, aes.encrypt(member.getEmail()));
         pstmt.setString(5, member.getMobile() != null ? aes.encrypt(member.getMobile()) : null);
         pstmt.setString(6, member.getPostcode());
         pstmt.setString(7, member.getAddress());
         pstmt.setString(8, member.getDetailaddress());
         pstmt.setString(9, member.getExtraaddress());
         pstmt.setString(10, member.getGender());
         pstmt.setString(11, member.getBirthday());

         int memberInsertCnt = pstmt.executeUpdate();

         // ==================================================
         // 2️⃣ TBL_ADDRESS INSERT (기본 배송지)
         // ==================================================
         if (memberInsertCnt == 1) {

             String sqlAddress =
                     " INSERT INTO TBL_ADDRESS "
                   + " (ADDR_ID, FK_MEMBER_ID, POSTCODE, ADDRESS, DETAILADDRESS, EXTRAADDRESS) "
                   + " VALUES (SEQ_ADDR_ID.NEXTVAL, ?, ?, ?, ?, ?) ";

             pstmt.close(); // 기존 pstmt 정리
             pstmt = conn.prepareStatement(sqlAddress);

             pstmt.setString(1, member.getUserid());
             pstmt.setString(2, address.getPostcode());
             pstmt.setString(3, address.getAddress());
             pstmt.setString(4, address.getDetailaddress());
             pstmt.setString(5, address.getExtraaddress());

             pstmt.executeUpdate();

             conn.commit(); // ★ 둘 다 성공 → 커밋
             result = 1;
         }

     } catch (Exception e) {
         if (conn != null) {
             try { conn.rollback(); } catch (SQLException ex) {}
         }
         e.printStackTrace();
         result = 0;
     } finally {
         close();
     }

     return result;
 }


    
    // ======================================================
    // 이메일 중복검사 
    // ======================================================
	@Override
	public boolean isUseridExists(String userid) throws SQLException {
		  boolean result = false;

		    try {
		        conn = ds.getConnection();

		        String sql = "select count(*) from tbl_member where member_id = ?";

		        pstmt = conn.prepareStatement(sql);
		        pstmt.setString(1, userid);

		        rs = pstmt.executeQuery();

		        if(rs.next()) {
		            result = rs.getInt(1) > 0;
		        }
		    } catch (Exception e) {
	            e.printStackTrace();
		    } finally {
		        close();
		    }

		    return result;
	}

    
	    // ======================================================
	   // 로그인 처리 (수정본)
	   // ======================================================
	   @Override
	   public MemberDTO login(Map<String, String> paraMap) throws SQLException {

	       MemberDTO member = null;

	       try {
	           conn = ds.getConnection();

	           // SQL 문은 이미 필요한 컬럼들을 Join해서 잘 가져오고 있습니다.
	           String sql = " SELECT M.member_id, "
	                      + "        M.name, "
	                      + "        M.email, "
	                      + "        M.mobile, "
	                      + "        M.postcode, "
	                      + "        M.address, "
	                      + "        M.detailaddress, "
	                      + "        M.extraaddress, "
	                      + "        M.gender, "
	                      + "        M.birthday, "
	                      + "        M.point, "
	                      + "        M.status, "
	                      + "        M.registerday, "
	                      + "        M.grade_code, "
	                      + "        M.idle, "
	                      + "        G.grade_name "
	                      + " FROM tbl_member M "
	                      + " JOIN tbl_grade G ON M.grade_code = G.grade_code "
	                      + " WHERE M.member_id = ? AND M.passwd = ? ";

	           pstmt = conn.prepareStatement(sql);
	           pstmt.setString(1, paraMap.get("userid"));
	           pstmt.setString(2, Sha256.encrypt(paraMap.get("passwd"))); 

	           rs = pstmt.executeQuery();

	           if (rs.next()) {
	               member = new MemberDTO();

	               // 1. 기본 정보 담기
	               member.setUserid(rs.getString("member_id"));
	               member.setName(rs.getString("name"));
	               
	               // 2. 암호화된 정보 복호화해서 담기 (핵심!)
	               member.setEmail(aes.decrypt(rs.getString("email")));
	               member.setMobile(aes.decrypt(rs.getString("mobile")));
	               
	               // 3. 주소 및 상세 정보 담기 (기존에 누락된 부분)
	               member.setPostcode(rs.getString("postcode"));
	               member.setAddress(rs.getString("address"));
	               member.setDetailaddress(rs.getString("detailaddress"));
	               member.setExtraaddress(rs.getString("extraaddress"));
	               
	               member.setGender(rs.getString("gender"));
	               member.setBirthday(rs.getString("birthday"));
	               member.setPoint(rs.getInt("point"));
	               
	               member.setStatus(rs.getInt("status"));
	               member.setRegisterday(rs.getString("registerday"));
	               member.setGrade_code(rs.getString("grade_code"));
	               member.setGrade_name(rs.getString("grade_name"));
	               
	               // 휴면 회원 추가
	               member.setIdle(rs.getInt("idle"));
	           }

	       } catch (Exception e) {
	           e.printStackTrace();
	       } finally {
	           close();
	       }

	       return member;
	   }
    
    
    // ======================================================
    // 아이디 찾기
    // ======================================================
    @Override
    public String findUseridByNameEmail(String name, String email) {

        String userid = null;

        try {
            conn = ds.getConnection();

            String sql = " SELECT MEMBER_ID "
                       + " FROM TBL_MEMBER "
                       + " WHERE NAME = ? "
                       + "   AND EMAIL = ? ";

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, name);
            pstmt.setString(2, aes.encrypt(email));

            rs = pstmt.executeQuery();

            if (rs.next()) {
                userid = rs.getString("MEMBER_ID");
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close();
        }

        return userid;
    }

    
    // ======================================================
    // 비밀번호 찾기 (회원 존재 여부)
    // ======================================================
    @Override
    public boolean isUserExistsForPwd(String userid, String email) {

        boolean isExist = false;

        try {
            conn = ds.getConnection();

            String sql = " SELECT 1 "
                       + " FROM TBL_MEMBER "
                       + " WHERE MEMBER_ID = ? "
                       + "   AND EMAIL = ? ";

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userid);
            pstmt.setString(2, aes.encrypt(email));

            rs = pstmt.executeQuery();
            isExist = rs.next();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close();
        }

        return isExist;
    }

    
    // ======================================================
    // 비밀번호 찾기 후 비밀번호 업데이트
    // ======================================================
    @Override
    public boolean updatePassword(String userid, String passwd) {

        boolean result = false;

        try {
            conn = ds.getConnection();

            String sql = " UPDATE TBL_MEMBER "
                       + " SET PASSWD = ?, LASTPWDCHANGEDATE = SYSDATE "
                       + " WHERE MEMBER_ID = ? ";

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, Sha256.encrypt(passwd)); //  암호화 통일
            pstmt.setString(2, userid);

            int n = pstmt.executeUpdate();
            result = (n == 1);

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close();
        }

        return result;
    }

    
    
    // ===============================
    // 회원정보 수정
    // ===============================
    @Override
    public int updateMember(MemberDTO member) throws SQLException {

        int result = 0;

        try {
            conn = ds.getConnection();

            String sql = " UPDATE tbl_member SET "
                       + "       name   = ?, "
                       + "       passwd = ?, "
                       + "       email  = ?, "
                       + "       mobile = ? "
                       + " WHERE MEMBER_ID = ? ";

            pstmt = conn.prepareStatement(sql);

            pstmt.setString(1, member.getName());
            pstmt.setString(2, Sha256.encrypt(member.getPasswd()));  // 비밀번호 암호화
            pstmt.setString(3, aes.encrypt(member.getEmail()));     // 이메일 암호화
            pstmt.setString(4, aes.encrypt(member.getMobile()));    // 휴대폰 암호화
            pstmt.setString(5, member.getUserid());

            result = pstmt.executeUpdate();
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        finally {
            close();
        }

        return result;
    }

    
    
    // ===============================
    // 회원 탈퇴 (status = 0)
    // ===============================
    @Override
	public int withdrawMember(String userid) throws SQLException {
    	
    	int result = 0;

        try {
            conn = ds.getConnection();

            String sql = " UPDATE tbl_member "
                       + " SET status = 0 "
                       + " WHERE member_id = ? ";

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userid);

            result = pstmt.executeUpdate();  // 1이면 성공
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        finally {
            close();
        }

        return result;
	}

    
    
    // ===============================
    // 관리자 페이지 內 회원 요약 데이터 조회 - 전체회원 수
    // ===============================
    @Override
	public int getTotalMemberCount() throws SQLException {
    	
		/* [수정 전] -> ResultSet 종료 에러
		 * int count = 0;
		 * 
		 * try { conn = ds.getConnection();
		 * 
		 * String sql = " SELECT COUNT(*) " + " FROM tbl_member " +
		 * " WHERE MEMBER_ID != 'admin' ";
		 * 
		 * pstmt = conn.prepareStatement(sql); rs = pstmt.executeQuery();
		 * 
		 * if (rs.next()) { count = rs.getInt(1); } } finally { close(); }
		 * 
		 * return count;
		 */
    	
    	// 수정 전 과 같은 논리이지만 자원관리 방식만 다름
    	String sql = "SELECT COUNT(*) FROM tbl_member "
    			   + " WHERE MEMBER_ID != 'admin' ";

    	// try with resources
        try ( // rs 에 표 count(*) 들어감
            Connection conn = ds.getConnection();
            PreparedStatement pstmt = conn.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery();
        ) { // 표 첫번째 컬럼 값 꺼내기
            return rs.next() ? rs.getInt(1) : 0;
        }
	}
    
    
    
    // ===============================
    // 관리자 페이지 內 회원 요약 데이터 조회 - 정상회원 수
    // ===============================
	@Override
	public int getActiveMemberCount() throws SQLException {
		
		String sql = " SELECT COUNT(*) FROM tbl_member "
	               + " WHERE status = 1 "
	               + "   AND member_id != 'admin' ";

	    try (
	        Connection conn = ds.getConnection();
	        PreparedStatement pstmt = conn.prepareStatement(sql);
	        ResultSet rs = pstmt.executeQuery();
	    ) {
	        return rs.next() ? rs.getInt(1) : 0;
	    }
	}
	
	
	
	// ===============================
    // 관리자 페이지 內 회원 요약 데이터 조회 - 탈퇴회원 수
    // ===============================
	@Override
	public int getDeleteMemberCount() throws SQLException {
		
		String sql = " SELECT COUNT(*) FROM tbl_member "
	               + " WHERE status = 0 "
	               + "   AND member_id != 'admin' ";

	    try (
	        Connection conn = ds.getConnection();
	        PreparedStatement pstmt = conn.prepareStatement(sql);
	        ResultSet rs = pstmt.executeQuery();
	    ) {
	        return rs.next() ? rs.getInt(1) : 0;
	    }
	}

    
    
    
    // ===============================
    // 관리자 페이지 內 회원 전체 목록 조회
    // ===============================
	 @Override
	 public List<MemberDTO> selectAllMemberForAdmin(int startRno, int endRno) throws SQLException {
	
	     List<MemberDTO> memberList = new ArrayList<>();
	
	     try {
	         conn = ds.getConnection();
	
	         String sql =
	                 " SELECT MEMBER_ID, name, gender, email, registerday, status, idle, admin_memo " +
	                 " FROM tbl_member " +
	                 " WHERE MEMBER_ID != 'admin' " +
	                 " ORDER BY registerday DESC " +
	                 " OFFSET ? ROWS FETCH NEXT ? ROWS ONLY ";
	
	         pstmt = conn.prepareStatement(sql);
	         pstmt.setInt(1, startRno - 1);
	         pstmt.setInt(2, endRno - startRno + 1);
	         rs = pstmt.executeQuery();
	
	         while (rs.next()) {
	
	             MemberDTO member = new MemberDTO();
	
	             member.setUserid(rs.getString("MEMBER_ID"));
	             member.setName(rs.getString("name"));
	             member.setGender(rs.getString("gender"));  // 추가
	             member.setEmail(aes.decrypt(rs.getString("email"))); // 복호화
	             member.setRegisterday(rs.getString("registerday"));
	
	             //추가
	             member.setStatus(rs.getInt("status"));
	             
	             // 추가
	             member.setIdle(rs.getInt("idle"));
	             member.setAdmin_memo(rs.getString("admin_memo"));
	             
	             memberList.add(member);
	         }
	     }
	     catch (Exception e) {
	         e.printStackTrace();
	     }
	     finally {
	         close();
	     }
	
	     return memberList;
	 }

	// ======================================================
	// 관리자 페이지 內 메인 페이지 -  회원 요약 데이터 (오늘 회원가입 수)
	// ======================================================
	 @Override
	 public int getTodayRegisterCount() throws SQLException {

	     int count = 0;

 	     try {
	        conn = ds.getConnection();

	        String sql = " SELECT COUNT(*) "
	                   + " FROM tbl_member "
	                   + " WHERE TRUNC(registerday) = TRUNC(SYSDATE) ";

	        pstmt = conn.prepareStatement(sql);
	        rs = pstmt.executeQuery();

	        if (rs.next()) {
	            count = rs.getInt(1);
	        }
	     }
	     finally {
	        close();
	     }

	     return count;
	 }

	 
	 
	// ======================================================
	// 관리자 페이지 內 최근 7일 가입자 수 (합계)
	// ======================================================
	 @Override
	 public int getLast7DaysRegisterCount() throws SQLException {
		 
		 int count = 0;

		    try {
		        conn = ds.getConnection();

		        String sql = " SELECT COUNT(*) "
		                   + " FROM tbl_member "
		                   + " WHERE member_id != 'admin' "
		                   + "   AND registerday >= TRUNC(SYSDATE) - 6 ";

		        pstmt = conn.prepareStatement(sql);
		        rs = pstmt.executeQuery();

		        if (rs.next()) {
		            count = rs.getInt(1);
		        }
		    }
		    catch (Exception e) {
		        e.printStackTrace();
		    }
		    finally {
		        close();
		    }

		    return count;
	}
	 
	 
	 
	// ======================================================
	// 관리자 페이지 內 최근 7일 날짜별 가입자 수 (그래프)
	// ======================================================
	 @Override
		public List<Map<String, Object>> getLast7DaysRegisterList() throws SQLException {
		 List<Map<String, Object>> list = new ArrayList<>();

		    try {
		        conn = ds.getConnection();

		        String sql =
		              " SELECT TO_CHAR(registerday, 'MM-DD') AS reg_date "
		            + "      , COUNT(*) AS cnt "
		            + " FROM tbl_member "
		            + " WHERE registerday >= TRUNC(SYSDATE) - 6 "
		            + "   AND status = 1 "
		            + " GROUP BY TO_CHAR(registerday, 'MM-DD') "
		            + " ORDER BY reg_date ";

		        pstmt = conn.prepareStatement(sql);
		        rs = pstmt.executeQuery();

		        while (rs.next()) {
		            Map<String, Object> map = new HashMap<>();
		            map.put("date", rs.getString("reg_date"));
		            map.put("count", rs.getInt("cnt"));

		            list.add(map);
		        }
		    }
		    finally {
		        close();
		    }

		    return list;
		}
	 
	 
	// ======================================================
	// 관리자 페이지 內 회원 검색 조회
	// ======================================================
	@Override
	public List<MemberDTO> selectMemberBySearch(String searchType, String searchWord) {
		
		List<MemberDTO> memberList = new ArrayList<>();

		    try {
		        conn = ds.getConnection();

		        String sql = " SELECT MEMBER_ID, name, email, registerday, status, idle "
		                   + " FROM tbl_member "
		                   + " WHERE MEMBER_ID != 'admin' ";

		        // ===============================
		        // 검색 조건 분기
		        // ===============================
		        if ("userid".equals(searchType)) {
		            sql += " AND MEMBER_ID LIKE '%' || ? || '%' ";
		        }
		        else if ("name".equals(searchType)) {
		            sql += " AND name LIKE '%' || ? || '%' ";
		        }

		        sql += " ORDER BY registerday DESC ";

		        pstmt = conn.prepareStatement(sql);
		        pstmt.setString(1, searchWord);

		        rs = pstmt.executeQuery();

		        while (rs.next()) {

		            MemberDTO member = new MemberDTO();

		            member.setUserid(rs.getString("MEMBER_ID"));
		            member.setName(rs.getString("name"));
		            member.setEmail(aes.decrypt(rs.getString("email"))); // 이메일 복호화
		            member.setRegisterday(rs.getString("registerday"));
		            member.setStatus(rs.getInt("status"));

		            // 추가
		             member.setIdle(rs.getInt("idle"));
		            
		            memberList.add(member);
		        }
		    }
		    catch (Exception e) {
		        e.printStackTrace();
		    }
		    finally {
		        close();
		    }

		    return memberList;
	}

	
	
	// ======================================================
	// 관리자 페이지 內 최근 가입 회원 TOP N
	// ======================================================
	@Override
	public List<MemberDTO> getRecentMemberList(int topN) {

		List<MemberDTO> memberList = new ArrayList<>();

	    try {
	        conn = ds.getConnection();

	        String sql = " SELECT member_id, name, registerday "
	                   + " FROM tbl_member "
	                   + " WHERE member_id != 'admin' "
	                   + " ORDER BY registerday DESC "
	                   + " FETCH FIRST " + topN + " ROWS ONLY ";

	        pstmt = conn.prepareStatement(sql);

	        rs = pstmt.executeQuery();

	        while (rs.next()) {

	            MemberDTO member = new MemberDTO();
	            member.setUserid(rs.getString("member_id"));
	            member.setName(rs.getString("name"));
	            member.setRegisterday(rs.getString("registerday"));

	            memberList.add(member);
	        }
	    }
	    catch (Exception e) {
	        e.printStackTrace();
	    }
	    finally {
	        close();
	    }

	    return memberList;
	}

	
	
	// ======================================================
	// 관리자 페이지 內 등급별 회원수
	// ======================================================
	@Override
	public List<MemberCountDTO> getGradeCountList() throws SQLException {
		 
		List<MemberCountDTO> list = new ArrayList<>();

		    try {
		        conn = ds.getConnection();

		        String sql = " SELECT g.grade_name AS key, COUNT(*) AS cnt " 
		                   + " FROM tbl_member m "
		                   + " JOIN tbl_grade g ON m.grade_code = g.grade_code "
		                   +  " WHERE m.status = 1 "         // 정상회원만
		                   +  " GROUP BY g.grade_name, g.grade_code " 
		                   + " ORDER BY g.grade_code ";

		        pstmt = conn.prepareStatement(sql);
		        rs = pstmt.executeQuery();

		        while (rs.next()) {
		            MemberCountDTO dto = new MemberCountDTO();
		            dto.setKey(rs.getString("key"));
		            dto.setCnt(rs.getInt("cnt"));
		            list.add(dto);
		        }

		    } finally {
		        close();
		    }

		    return list;
	}

	
	
	// ======================================================
	// 관리자 페이지 內 등급별 회원수
	// ======================================================
	@Override
	public List<MemberCountDTO> getGenderCountList() throws SQLException {
		
		List<MemberCountDTO> list = new ArrayList<>();

	    try {
	        conn = ds.getConnection();

	        String sql = " SELECT NVL(DECODE(gender, '1', '남자', '2', '여자'), '미입력') AS key, "
	        		   + "    COUNT(*) AS cnt "
	                   + " FROM tbl_member "
	                   + " WHERE status = 1 "
	                   + " GROUP BY gender ";

	        pstmt = conn.prepareStatement(sql);
	        rs = pstmt.executeQuery();

	        while (rs.next()) {
	            MemberCountDTO dto = new MemberCountDTO();
	            dto.setKey(rs.getString("key")); // "남자", "여자"
	            dto.setCnt(rs.getInt("cnt"));
	            list.add(dto);
	        }

	    } finally {
	        close();
	    }

	    return list;
	}

	
	
	
	// ======================================================
	// 관리자 페이지 內 회원 상세 조회
	// (입력받은 userid 를 가지고 한명의 회원정보를 가져오기)
	// ======================================================
	@Override
	public MemberDTO selectOneMember(String userid) {

	    MemberDTO member = null;

	    try {
	        conn = ds.getConnection();

	        String sql = 
	            " SELECT m.member_id, "
	            + "       m.name, "
	            + "       m.gender, "
	            + "       m.email, "
	            + "       m.mobile, "
	            + "       m.registerday, "
	            + "       m.status, "
	            + "       m.point,  "
	            + "       m.grade_code, "
	            + "       m.admin_memo, "
	            + "       TO_CHAR(m.memo_updatedate, 'yyyy-mm-dd hh24:mi:ss') AS memo_updatedate, "
	            + "       g.grade_name "
	            + " FROM tbl_member m "
	            + " JOIN tbl_grade g ON m.grade_code = g.grade_code "
	            + " WHERE m.member_id = ? ";

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, userid);

	        rs = pstmt.executeQuery();

	        if (rs.next()) {

	            member = new MemberDTO();

	            member.setUserid(rs.getString("member_id"));
	            member.setName(rs.getString("name"));
	            member.setGender(rs.getString("gender"));             // 1 / 2 / null
	            member.setEmail(aes.decrypt(rs.getString("email")));  // 이메일 복호화
	            member.setMobile(aes.decrypt(rs.getString("mobile")));
	            member.setRegisterday(rs.getString("registerday"));
	            member.setStatus(rs.getInt("status"));               // 1:정상 / 0:탈퇴
	        
	            // 추가(등급)
	            member.setGrade_code(rs.getString("grade_code"));
	            member.setGrade_name(rs.getString("grade_name"));
	            
	            member.setAdmin_memo(rs.getString("admin_memo"));
	            member.setMemo_updatedate(rs.getString("memo_updatedate"));
	            
	            member.setPoint(rs.getInt("Point"));

	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        close();
	    }

	    return member;
	}

	
	
	// 관리자 페이지 內 회원 더미 50명 추가
	@Override
	public int createDummyMembers(int count) throws SQLException {

	    int success = 0;

	    // === 이름 풀 ===
	    String[] lastNames = {"김","이","박","최","정","강","조","윤","장","임","한","오","서","신","권","황","안","송","류","전"};
	    String[] firstNames = {"민준","서준","도윤","예준","시우","주원","하준","지호","지후","준우",
	                           "서연","서윤","지우","하윤","민서","지민","윤서","채원","수아","지아",
	                           "현우","건우","민재","우진","승민","수현","예린","다은","소연","유나"};

	    // === 주소 풀 ===
	    String[] postcodes = {"06134","06236","05510","04147","03027","04727","13529","16499","48060","63012"};
	    String[] roads = {
	            "서울 강남구 테헤란로", "서울 송파구 올림픽로", "서울 마포구 월드컵북로", "서울 성동구 왕십리로",
	            "경기 성남시 분당구 판교로", "경기 수원시 영통구 센트럴타운로", "인천 연수구 컨벤시아대로",
	            "부산 해운대구 APEC로", "대구 수성구 동대구로", "제주 제주시 연북로"
	    };
	    String[] extras = {"(역삼동)", "(잠실동)", "(상암동)", "(행당동)", "(삼평동)", "(이의동)", "(송도동)", "(우동)", "(범어동)", "(연동)"};

	    // === YYMM 기반 seed (예: 2601) ===
	    java.time.LocalDate now = java.time.LocalDate.now();
	    String seed = String.format("%02d%02d", now.getYear() % 100, now.getMonthValue());

	    for (int i = 1; i <= count; i++) {

	        // 1) 성별
	        String gender = (Math.random() < 0.5) ? "1" : "2";

	        // 2) 이름
	        String name = lastNames[(int)(Math.random() * lastNames.length)]
	                    + firstNames[(int)(Math.random() * firstNames.length)];

	        // 3) 생년월일
	        int year = 1975 + (int)(Math.random() * 32); // 1975~2006
	        int month = 1 + (int)(Math.random() * 12);
	        int day = 1 + (int)(Math.random() * 28);
	        String birthday = year + "-" + String.format("%02d", month) + "-" + String.format("%02d", day);

	        // 4) 주소
	        int idx = (int)(Math.random() * roads.length);
	        String postcode = postcodes[idx];
	        String address = roads[idx] + " " + (10 + (int)(Math.random() * 250));
	        String detailaddress = (1 + (int)(Math.random() * 120)) + "동 " + (1 + (int)(Math.random() * 2000)) + "호";
	        String extraaddress = extras[idx];

	        // 5) 아이디 / 이메일 (짧고 깔끔)
	        String userid = "u" + seed + "_" + String.format("%03d", i);
	        String email  = "u" + seed + "_" + String.format("%03d", i) + "@test.com";

	        // 6) 모바일
	        String mobile = "010" + String.format("%08d", (int)(Math.random() * 100000000));

	        // 7) 포인트 / 등급 / 상태
	        int point = (int)(Math.random() * 20001);

	        String grade;
	        double r = Math.random();
	        if (r < 0.80) grade = "1";      // 일반
	        else if (r < 0.95) grade = "2"; // 실버
	        else grade = "3";              // 골드

	        int status = (Math.random() < 0.95) ? 1 : 0;

	        // 8) DTO 구성
	        MemberDTO m = new MemberDTO();
	        m.setUserid(userid);
	        m.setName(name);
	        m.setPasswd("1234");
	        m.setEmail(email);
	        m.setMobile(mobile);
	        m.setPostcode(postcode);
	        m.setAddress(address);
	        m.setDetailaddress(detailaddress);
	        m.setExtraaddress(extraaddress);
	        m.setGender(gender);
	        m.setBirthday(birthday);

	        AddressDTO addr = new AddressDTO();
	        addr.setPostcode(postcode);
	        addr.setAddress(address);
	        addr.setDetailaddress(detailaddress);
	        addr.setExtraaddress(extraaddress);

	        // 9) 회원가입 메서드 호출
	        int n = registerMember(m, addr);

	        if (n == 1) {
	            success++;

	            // 10) 포인트 / 등급 / 상태 업데이트
	            try {
	                conn = ds.getConnection();

	                String sqlUpdate =
	                        " UPDATE tbl_member "
	                      + " SET point = ?, status = ?, grade_code = ? "
	                      + " WHERE member_id = ? ";

	                pstmt = conn.prepareStatement(sqlUpdate);
	                pstmt.setInt(1, point);
	                pstmt.setInt(2, status);
	                pstmt.setString(3, grade);
	                pstmt.setString(4, userid);

	                pstmt.executeUpdate();

	            } finally {
	                close();
	            }
	        }
	    }

	    return success;
	}

	
	
	// 휴면 회원 해제하기
	@Override
	public int idleRelease(String userid) throws SQLException {

	    int n = 0;

	    try {
	        conn = ds.getConnection();

	        String sql = " update tbl_member "
	                   + " set idle = 0 "
	                   + "     idle_changedate = sysdate "
	                   + " where member_id = ? ";

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, userid);

	        n = pstmt.executeUpdate();

	    } finally {
	        close();
	    }

	    return n;
	}

	
	
	// 관리자 페이지 내 휴면회원 수 
	@Override
	public int getIdleMemberCount() throws SQLException {

	    int count = 0;

	    try {
	        conn = ds.getConnection();

	        String sql = " SELECT COUNT(*) "
	                   + " FROM tbl_member "
	                   + " WHERE member_id != 'admin' "
	                   + "   AND status = 1 "     // 정상회원 중에서
	                   + "   AND idle = 1 ";      // 휴면만

	        pstmt = conn.prepareStatement(sql);
	        rs = pstmt.executeQuery();

	        if(rs.next()) {
	            count = rs.getInt(1);
	        }

	    } finally {
	        close();
	    }

	    return count;
	}

	
	
	// 관리자 페이지 휴면회원 조회
	@Override
	public List<MemberDTO> selectIdleMemberListForAdmin() throws SQLException {

	    List<MemberDTO> list = new ArrayList<>();

	    try {
	        conn = ds.getConnection();

	        String sql = " SELECT member_id, name, email, registerday "
	                   + " FROM tbl_member "
	                   + " WHERE status = 1 AND idle = 1 "
	                   + " ORDER BY registerday DESC ";

	        pstmt = conn.prepareStatement(sql);
	        rs = pstmt.executeQuery();

	        while(rs.next()) {
	            MemberDTO m = new MemberDTO();
	            m.setUserid(rs.getString("member_id"));
	            m.setName(rs.getString("name"));
	            m.setEmail(aes.decrypt(rs.getString("email")));
	            m.setRegisterday(rs.getString("registerday"));

	            list.add(m);
	        }
	    } catch (Exception e) {
	    } finally {
	        close();
	    }

	    return list;
	}

	
	
	// 관리자 페이지 휴면회원 해제
	@Override
	public int idleReleaseMany(String[] useridArr) throws SQLException {

	    int totalCnt = 0;

	    try {
	        conn = ds.getConnection();
	        conn.setAutoCommit(false);

	        String sql = " update tbl_member "
	                   + " set idle = 0 "
	                   + "   , idle_changedate = sysdate "
	                   + " where member_id = ? ";

	        pstmt = conn.prepareStatement(sql);

	        for(String userid : useridArr) {
	            pstmt.setString(1, userid);
	            totalCnt += pstmt.executeUpdate();
	        }

	        conn.commit();

	    } catch(SQLException e) {
	        if(conn != null) conn.rollback();
	        throw e;
	    } finally {
	        close();
	    }

	    return totalCnt;
	}

	
	
	// 관리자 페이지 블랙리스트 등 메모 저장
	@Override
	public int updateAdminMemo(String userid, String adminMemo) throws SQLException {

	    int n = 0;

	    try {
	        conn = ds.getConnection();

	        String sql = " UPDATE tbl_member "
	                   + " SET admin_memo = ?, memo_updatedate = SYSDATE "
	                   + " WHERE member_id = ? ";

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, adminMemo);
	        pstmt.setString(2, userid);

	        n = pstmt.executeUpdate();

	    } finally {
	        close();
	    }

	    return n;
	}

}
