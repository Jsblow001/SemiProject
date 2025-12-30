package jh.qna.model;

import java.sql.*;
import java.util.*;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import jh.qna.domain.QnaDTO;
import jh.qna.domain.QnaFileDTO;

public class QnaDAO_imple implements QnaDAO {

    private DataSource ds; 
    private Connection conn;            // (목록조회 등 "DAO가 conn 열 때"만 사용)
    private PreparedStatement pstmt;
    private ResultSet rs;

    // 생성자 (커넥션 풀 설정)
    public QnaDAO_imple() {
        try {
            Context initContext = new InitialContext();
            Context envContext  = (Context)initContext.lookup("java:/comp/env");
            ds = (DataSource)envContext.lookup("SemiProject");
        } catch (NamingException e) {
            e.printStackTrace();
        }
    }

    // ✅ (A) DAO가 conn을 열었을 때만 쓰는 close(): conn까지 닫음
    private void close() {
        try {
            if(rs != null)    {rs.close(); rs=null;}
            if(pstmt != null) {pstmt.close(); pstmt=null;}
            if(conn != null)  {conn.close(); conn=null;}
        } catch(SQLException e) {
            e.printStackTrace();
        }
    }

    // ✅ (B) 트랜잭션용(conn 파라미터 받는 메서드)에서 쓰는 close: pstmt/rs만 닫음
    private void closeStmtRs() {
        try {
            if(rs != null)    {rs.close(); rs=null;}
            if(pstmt != null) {pstmt.close(); pstmt=null;}
        } catch(SQLException e) {
            e.printStackTrace();
        }
    }

    // 컨트롤러에서 트랜잭션 잡을 때 conn 얻는 용도
    public Connection getConnection() throws SQLException {
        return ds.getConnection();
    }

    // ======================================================
    // 1) QnA 글 insert 후 qna_id 반환 (트랜잭션 conn 사용)
    // ======================================================
    @Override
    public long insertQna(Connection conn, QnaDTO dto) throws SQLException {
        long qnaId = 0;

        try {
            String sql =
                " INSERT INTO tbl_qna (QNA_ID, FK_MEMBER_ID, SUBJECT, CONTENT, IS_SECRET, REGDATE) " +
                " VALUES (SEQ_QNA_ID.nextval, ?, ?, ?, ?, SYSDATE) ";

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, dto.getFkMemberId());
            pstmt.setString(2, dto.getSubject());
            pstmt.setString(3, dto.getContent());
            pstmt.setInt(4, dto.getIsSecret());

            int n = pstmt.executeUpdate();
            if(n != 1) throw new SQLException("QnA insert 실패");

            // ✅ 여기서 close() 호출하면 안 됨 (conn 닫힘)
            closeStmtRs();

            // ✅ 같은 conn에서 currval 조회
            String sql2 = " SELECT SEQ_QNA_ID.currval AS QNA_ID FROM dual ";
            pstmt = conn.prepareStatement(sql2);
            rs = pstmt.executeQuery();

            if(rs.next()) qnaId = rs.getLong("QNA_ID");

        } finally {
            closeStmtRs(); // ✅ conn은 컨트롤러가 닫는다
        }

        return qnaId;
    }

    // ======================================================
    // 2) 첨부 insert (트랜잭션 conn 사용)
    // ======================================================
    @Override
    public int insertQnaFile(Connection conn, QnaFileDTO fileDto) throws SQLException {
        int result = 0;

        try {
            String sql =
                " INSERT INTO tbl_qna_file " +
                " (QNA_FILE_ID, FK_QNA_ID, ORG_FILENAME, SAVE_FILENAME, FILE_SIZE, CONTENT_TYPE, REGDATE) " +
                " VALUES (SEQ_QNA_FILE_ID.nextval, ?, ?, ?, ?, ?, SYSDATE) ";

            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, fileDto.getFkQnaId());
            pstmt.setString(2, fileDto.getOrgFilename());
            pstmt.setString(3, fileDto.getSaveFilename());
            pstmt.setLong(4, fileDto.getFileSize());
            pstmt.setString(5, fileDto.getContentType());

            result = pstmt.executeUpdate();

        } finally {
            closeStmtRs(); // ✅ conn 닫지 않음
        }

        return result;
    }

    // ======================================================
    // 3) qna_id로 첨부 목록 조회 (트랜잭션 conn 사용)
    // ======================================================
    @Override
    public List<QnaFileDTO> selectFilesByQnaId(Connection conn, long qnaId) throws SQLException {

        List<QnaFileDTO> list = new ArrayList<>();

        try {
            String sql =
                " SELECT QNA_FILE_ID, FK_QNA_ID, ORG_FILENAME, SAVE_FILENAME, FILE_SIZE, CONTENT_TYPE " +
                " FROM tbl_qna_file " +
                " WHERE FK_QNA_ID = ? " +
                " ORDER BY QNA_FILE_ID ";

            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, qnaId);

            rs = pstmt.executeQuery();

            while(rs.next()) {
                QnaFileDTO f = new QnaFileDTO();
                f.setQnaFileId(rs.getLong("QNA_FILE_ID"));
                f.setFkQnaId(rs.getLong("FK_QNA_ID"));
                f.setOrgFilename(rs.getString("ORG_FILENAME"));
                f.setSaveFilename(rs.getString("SAVE_FILENAME"));
                f.setFileSize(rs.getLong("FILE_SIZE"));
                f.setContentType(rs.getString("CONTENT_TYPE"));
                list.add(f);
            }

        } finally {
            closeStmtRs(); // ✅ conn 닫지 않음
        }

        return list;
    }

    // ======================================================
    // 4) 첨부 row 삭제 (트랜잭션 conn 사용)
    // ======================================================
    @Override
    public int deleteFilesByQnaId(Connection conn, long qnaId) throws SQLException {
        int result = 0;

        try {
            String sql = " DELETE FROM tbl_qna_file WHERE FK_QNA_ID = ? ";
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, qnaId);
            result = pstmt.executeUpdate();
        } finally {
            closeStmtRs();
        }

        return result;
    }

    // ======================================================
    // 5) 글 삭제 (트랜잭션 conn 사용)
    // ======================================================
    @Override
    public int deleteQna(Connection conn, long qnaId) throws SQLException {
        int result = 0;

        try {
            String sql = " DELETE FROM tbl_qna WHERE QNA_ID = ? ";
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, qnaId);
            result = pstmt.executeUpdate();
        } finally {
            closeStmtRs();
        }

        return result;
    }

    // ======================================================
    // 6) 목록 조회 (DAO 내부에서 conn 열고 닫는 ProductDAO 스타일)
    // ======================================================
    @Override
    public List<Map<String, Object>> selectQnaList(String searchType, String keyword) throws SQLException {

        List<Map<String, Object>> list = new ArrayList<>();

        try {
            conn = ds.getConnection(); // ✅ 멤버 conn 사용

            boolean hasKeyword = (keyword != null && !keyword.trim().isEmpty());
            String where = "";

            if(hasKeyword) {
                if("writer".equals(searchType)) {
                    where = " WHERE FK_MEMBER_ID LIKE ? ";
                } else if("title_writer".equals(searchType)) {
                    where = " WHERE (SUBJECT LIKE ? OR FK_MEMBER_ID LIKE ?) ";
                } else { // title 또는 null
                    where = " WHERE SUBJECT LIKE ? ";
                }
            }

            String sql =
                " SELECT QNA_ID, FK_MEMBER_ID, SUBJECT, " +
                "        TO_CHAR(REGDATE,'YY-MM-DD') AS REGDATE, " +
                "        IS_SECRET, ANSWER " +
                " FROM tbl_qna " +
                where +
                " ORDER BY QNA_ID DESC ";

            pstmt = conn.prepareStatement(sql);

            if(hasKeyword) {
                String kw = "%" + keyword.trim() + "%";
                if("title_writer".equals(searchType)) {
                    pstmt.setString(1, kw);
                    pstmt.setString(2, kw);
                } else {
                    pstmt.setString(1, kw);
                }
            }

            rs = pstmt.executeQuery();

            while(rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("no", rs.getLong("QNA_ID"));
                row.put("notice", false);
                row.put("reply", rs.getString("ANSWER") != null);
                row.put("secret", rs.getInt("IS_SECRET") == 1);
                row.put("title", rs.getString("SUBJECT"));
                row.put("author", rs.getString("FK_MEMBER_ID"));
                row.put("date", rs.getString("REGDATE")); // ✅ 이미 YY-MM-DD로 뽑힘
                row.put("hit", false);
                list.add(row);
            }

        } finally {
            close(); // ✅ conn까지 닫음
        }

        return list;
    }

	

}
