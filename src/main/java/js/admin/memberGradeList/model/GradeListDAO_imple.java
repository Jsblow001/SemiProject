package js.admin.memberGradeList.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import hk.member.domain.MemberDTO;
import hk.order.domain.OrderDTO;

public class GradeListDAO_imple implements GradeListDAO {
	
	private DataSource ds;
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;

    public GradeListDAO_imple() {
        try {
            Context initContext = new InitialContext();
            Context envContext = (Context) initContext.lookup("java:/comp/env");
            ds = (DataSource) envContext.lookup("SemiProject"); 
        } catch (NamingException e) {
            e.printStackTrace();
        }
    }

    private void close() {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) { e.printStackTrace(); }
    }

	// 1. 해당 등급의 전체 인원수 조회
	@Override
	public int getTotalMemberCountByGrade(String grade) throws SQLException {
	    int count = 0;
	    try {
	        conn = ds.getConnection();
	        String sql = " SELECT COUNT(*) FROM tbl_member WHERE grade_code = ? AND status = 1 ";
	        
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, grade);
	        rs = pstmt.executeQuery();
	        
	        if(rs.next()) count = rs.getInt(1);
	        
	    } finally {
	        close();
	    }
	    return count;
	}

	// 2. 실시간 승급 대상자 및 누적 금액 조회 (가장 중요!)
	@Override
	public List<MemberDTO> getPromotionCandidates(String grade, int threshold) throws SQLException {
	    List<MemberDTO> candidateList = new ArrayList<>();
	    try {
	        conn = ds.getConnection();
	        
	        // 제공해주신 테이블 컬럼명에 맞춘 쿼리 (odrtotalprice, fk_member_id 등)
	        String sql = " SELECT * FROM ( " +
	                     "   SELECT member_id, name, " +
	                     "          (SELECT NVL(SUM(odrtotalprice), 0) FROM tbl_order " +
	                     "           WHERE fk_member_id = m.member_id AND payment_status = 1) AS total_amount " +
	                     "   FROM tbl_member m " +
	                     "   WHERE grade_code = ? AND status = 1 " +
	                     " ) temp " +
	                     " WHERE total_amount >= ? " +
	                     " ORDER BY total_amount DESC ";
	        
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, grade);
	        pstmt.setInt(2, threshold);
	        
	        rs = pstmt.executeQuery();
	        
	        while(rs.next()) {
	            MemberDTO m = new MemberDTO();
	            m.setUserid(rs.getString("member_id")); // 테이블 컬럼명이 member_id
	            m.setName(rs.getString("name"));
	            m.setTotal_amount(rs.getInt("total_amount")); // 실시간 합산 금액
	            
	            candidateList.add(m);
	        }
	    } finally {
	        close();
	    }
	    return candidateList;
	}

	// 3. 실제 등급 업데이트 (승급 확정 버튼 클릭 시 호출)
	@Override
	public int updateMemberGrade(String memberId, String newGrade) throws SQLException {
	    int result = 0;
	    try {
	        conn = ds.getConnection();
	        String sql = " UPDATE tbl_member SET grade_code = ? WHERE member_id = ? ";
	        
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, newGrade);
	        pstmt.setString(2, memberId);
	        
	        result = pstmt.executeUpdate();
	    } finally {
	        close();
	    }
	    return result;
	}

	// GradeListDAO_imple.java 내부 예시
	public int getMemberTotalAmount(String userid) throws SQLException {
	    int totalAmount = 0;
	    try {
	        conn = ds.getConnection();
	        // 결제 완료(1) 상태인 주문들의 총합
	        String sql = " SELECT nvl(sum(odrtotalprice), 0) " +
	                     " FROM tbl_order " +
	                     " WHERE fk_member_id = ? AND payment_status = 1 ";
	        
	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, userid);
	        rs = pstmt.executeQuery();
	        if(rs.next()) totalAmount = rs.getInt(1);
	    } finally {
	        close();
	    }
	    return totalAmount;
	}
	
}
