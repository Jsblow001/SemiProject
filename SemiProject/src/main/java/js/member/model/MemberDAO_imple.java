package js.member.model;

import java.sql.*;
import java.util.Map;
import javax.naming.*;
import javax.sql.DataSource;

import js.member.domain.MemberDTO;

public class MemberDAO_imple implements MemberDAO {

	private DataSource ds; // context.xml 에 설정된 DBCP 객체
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	public MemberDAO_imple() {
        try {
            Context initContext = new InitialContext();
            Context envContext  = (Context)initContext.lookup("java:/comp/env");
            ds = (DataSource)envContext.lookup("jdbc/myoracle"); // context.xml의 name과 일치해야 함
        } catch (NamingException e) {
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
	
	@Override
	public int updateMember(MemberDTO member) throws SQLException {
	    int result = 0;
	    try {
	        conn = ds.getConnection();
	        
	        String sql = " UPDATE tbl_member SET name = ?, email = ?, mobile = ?, "
	                   + " postcode = ?, address = ?, detailaddress = ?, extraaddress = ?, "
	                   + " gender = ?, birthday = ? ";
	        
	        // 새 비밀번호를 입력한 경우에만 비밀번호 업데이트 SQL 추가
	        if (member.getPasswd() != null && !member.getPasswd().trim().isEmpty()) {
	            sql += " , passwd = ? ";
	        }
	        
	        sql += " WHERE member_id = ? ";

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, member.getName());
	        pstmt.setString(2, member.getEmail());
	        pstmt.setString(3, member.getMobile());
	        pstmt.setString(4, member.getPostcode());
	        pstmt.setString(5, member.getAddress());
	        pstmt.setString(6, member.getDetailaddress());
	        pstmt.setString(7, member.getExtraaddress());
	        pstmt.setString(8, member.getGender());
	        pstmt.setString(9, member.getBirthday());

	        if (member.getPasswd() != null && !member.getPasswd().trim().isEmpty()) {
	            pstmt.setString(10, member.getPasswd()); // SHA-256 암호화 권장
	            pstmt.setString(11, member.getMember_id());
	        } else {
	            pstmt.setString(10, member.getMember_id());
	        }

	        result = pstmt.executeUpdate();
	    } finally {
	        close();
	    }
	    return result;
	}

	
}