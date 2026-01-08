package js.qna.model;

import java.sql.*;
import java.util.*;
import javax.naming.*;
import javax.sql.DataSource;

import jh.qna.domain.QnaDTO; // 본인의 DTO 패키지 경로로 수정하세요

public class MyQnaListDAO_imple implements MyQnaListDAO {

    private DataSource ds;
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;

    // 생성자: DBCP 설정
    public MyQnaListDAO_imple() {
        try {
            Context initContext = new InitialContext();
            Context envContext = (Context) initContext.lookup("java:/comp/env");
            ds = (DataSource) envContext.lookup("SemiProject"); 
        } catch (NamingException e) {
            e.printStackTrace();
        }
    }

    // 자원 반납 메서드
    private void close() {
        try {
            if (rs != null)    { rs.close();    rs = null; }
            if (pstmt != null) { pstmt.close(); pstmt = null; }
            if (conn != null)  { conn.close();  conn = null; }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // 1. 내 문의글 총 개수 조회 (페이징 바용)
    @Override
    public int getMyTotalQnaCount(String userid) throws SQLException {
        int totalCount = 0;
        try {
            conn = ds.getConnection();
            // 테이블명이 tbl_qna가 맞는지, 컬럼명이 FK_MEMBER_ID가 맞는지 확인
            String sql = " SELECT COUNT(*) FROM tbl_qna WHERE FK_MEMBER_ID = ? ";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userid);
            
            rs = pstmt.executeQuery();
            if (rs.next()) {
                totalCount = rs.getInt(1);
            }
        } finally {
            close();
        }
        return totalCount;
    }

    // 2. 내 문의글 목록 조회 (페이징 적용)
    @Override
    public List<QnaDTO> selectMyQnaList(Map<String, String> paraMap) throws SQLException {
        List<QnaDTO> qnaList = new ArrayList<>();
        
        try {
            conn = ds.getConnection();
            
            // [수정된 SQL] 단순히 ANSWER만 가져오는 게 아니라 관리자 댓글 존재 여부를 체크합니다.
            String sql = " SELECT QNA_ID, SUBJECT, REGDATE, IS_SECRET, ANSWERED " +
                         " FROM ( " +
                         "    SELECT row_number() over(order by q.QNA_ID desc) AS rno, " +
                         "           q.QNA_ID, q.SUBJECT, q.REGDATE, q.IS_SECRET, " +
                         "           CASE WHEN EXISTS ( " +
                         "               SELECT 1 FROM qna_comment c " +
                         "               WHERE c.fk_qna_id = q.qna_id " +
                         "                 AND UPPER(TRIM(c.fk_member_id)) = 'ADMIN' " + // 관리자 아이디 체크
                         "           ) THEN 1 ELSE 0 END AS ANSWERED " +
                         "    FROM tbl_qna q " +
                         "    WHERE q.FK_MEMBER_ID = ? " +
                         " ) V " +
                         " WHERE rno BETWEEN ? AND ? ";

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, paraMap.get("userid"));
            
            int currentShowPageNo = Integer.parseInt(paraMap.get("currentShowPageNo"));
            int sizePerPage = Integer.parseInt(paraMap.get("sizePerPage"));
            pstmt.setInt(2, (currentShowPageNo - 1) * sizePerPage + 1);
            pstmt.setInt(3, currentShowPageNo * sizePerPage);

            rs = pstmt.executeQuery();
            
            while (rs.next()) {
                QnaDTO qdto = new QnaDTO();
                qdto.setQnaId(rs.getLong("QNA_ID"));
                qdto.setSubject(rs.getString("SUBJECT"));
                qdto.setRegDate(rs.getDate("REGDATE")); 
                qdto.setIsSecret(rs.getInt("IS_SECRET"));

                // [핵심] SQL에서 계산해온 ANSWERED(1 또는 0) 값을 DTO에 세팅합니다.
                qdto.setAnswered(rs.getInt("ANSWERED") == 1);
                
                qnaList.add(qdto);
            }
        } finally {
            close();
        }
        return qnaList;
    }

}