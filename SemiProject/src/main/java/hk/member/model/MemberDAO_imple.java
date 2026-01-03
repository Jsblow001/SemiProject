package hk.member.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

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
    // 회원가입
    // ======================================================
    @Override
    public int registerMember(MemberDTO member) throws SQLException {

        int result = 0;

        try {
            conn = ds.getConnection();

            String sql = " INSERT INTO TBL_MEMBER "
                       + " (MEMBER_ID, NAME, PASSWD, EMAIL, MOBILE, "
                       + "   POSTCODE, ADDRESS, DETAILADDRESS, EXTRAADDRESS, "
                       + "   GENDER, BIRTHDAY, POINT, "
                       + "   STATUS, REGISTERDAY, LASTPWDCHANGEDATE, GRADE_CODE) "
                       + " VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0, 1, SYSDATE, SYSDATE, 1) ";

            pstmt = conn.prepareStatement(sql);

            pstmt.setString(1, member.getUserid());
            pstmt.setString(2, member.getName());
            pstmt.setString(3, Sha256.encrypt(member.getPasswd())); //  passwd 기준
            pstmt.setString(4, aes.encrypt(member.getEmail()));
            pstmt.setString(5, member.getMobile() != null ? aes.encrypt(member.getMobile()) : null);
            pstmt.setString(6, member.getPostcode());
            pstmt.setString(7, member.getAddress());
            pstmt.setString(8, member.getDetailaddress());
            pstmt.setString(9, member.getExtraaddress());
            pstmt.setString(10, member.getGender());
            pstmt.setString(11, member.getBirthday());

            result = pstmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
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
    // 로그인 처리
    // ======================================================
    @Override
    public MemberDTO login(Map<String, String> paraMap) throws SQLException {

        MemberDTO member = null;

        try {
            conn = ds.getConnection();

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
            		   + "        G.grade_name "
            		   + " FROM tbl_member M "
            		   + " JOIN tbl_grade G ON M.grade_code = G.grade_code "
            		   + " WHERE M.member_id = ? AND M.passwd = ? AND M.status = 1 ";

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, paraMap.get("userid"));
            pstmt.setString(2, Sha256.encrypt(paraMap.get("passwd"))); // 변경

            rs = pstmt.executeQuery();

            if (rs.next()) {
                member = new MemberDTO();

                member.setUserid(rs.getString("member_id"));
                member.setName(rs.getString("name"));
                member.setEmail(aes.decrypt(rs.getString("email")));
                member.setStatus(rs.getInt("status"));
                member.setRegisterday(rs.getString("registerday"));
                member.setGrade_name(rs.getString("grade_name"));; // ★ 카멜케이스

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
    // 관리자 페이지 內 회원목록 조회
    // ===============================
	 @Override
	 public List<MemberDTO> selectAllMemberForAdmin() throws SQLException {
	
	     List<MemberDTO> memberList = new ArrayList<>();
	
	     try {
	         conn = ds.getConnection();
	
	         String sql = " SELECT MEMBER_ID, name, email, registerday, status "
	                    + " FROM tbl_member "
	                    + " WHERE MEMBER_ID != 'admin' "
	                    + " ORDER BY registerday DESC ";
	
	         pstmt = conn.prepareStatement(sql);
	         rs = pstmt.executeQuery();
	
	         while (rs.next()) {
	
	             MemberDTO member = new MemberDTO();
	
	             member.setUserid(rs.getString("MEMBER_ID"));
	             member.setName(rs.getString("name"));
	             member.setEmail(aes.decrypt(rs.getString("email"))); // 복호화
	             member.setRegisterday(rs.getString("registerday"));
	
	             //추가
	             member.setStatus(rs.getInt("status"));
	             
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
	// 관리자 페이지 內 회원 검색 조회
	// ======================================================
	@Override
	public List<MemberDTO> selectMemberBySearch(String searchType, String searchWord) {
		 List<MemberDTO> memberList = new ArrayList<>();

		    try {
		        conn = ds.getConnection();

		        String sql = " SELECT MEMBER_ID, name, email, registerday, status "
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
    // 이하 기능 미구현 (다음 단계)
    // ======================================================
}
