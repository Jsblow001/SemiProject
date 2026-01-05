package jh.qna.model;

import java.io.UnsupportedEncodingException;
import java.security.GeneralSecurityException;
import java.sql.*;
import java.util.*;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import jh.qna.domain.QnaCommentDTO;
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
    public List<QnaDTO> selectQnaList(Map<String, String> paraMap) throws SQLException {

        List<QnaDTO> list = new ArrayList<>();

        // ---- 파라미터(기본값) ----
        String searchType = (paraMap == null) ? null : paraMap.get("searchType");
        String keyword    = (paraMap == null) ? null : paraMap.get("keyword");

        int currentShowPageNo = 1;
        int sizePerPage = 10;

        try {
            if (paraMap != null) {
                String p = paraMap.get("currentShowPageNo");
                String s = paraMap.get("sizePerPage");
                if (p != null && !p.trim().isEmpty()) currentShowPageNo = Integer.parseInt(p.trim());
                if (s != null && !s.trim().isEmpty()) sizePerPage = Integer.parseInt(s.trim());
            }
        } catch (NumberFormatException e) {
            currentShowPageNo = 1;
            sizePerPage = 10;
        }

        if (currentShowPageNo <= 0) currentShowPageNo = 1;
        if (sizePerPage <= 0) sizePerPage = 10;

        boolean hasKeyword = (keyword != null && !keyword.trim().isEmpty());

        // ---- WHERE 조립(검색 없으면 where = "" 이라 전체 조회) ----
        String where = "";
        if (hasKeyword) {
            if ("writer".equals(searchType)) {
                where = " WHERE q.FK_MEMBER_ID LIKE ? ";
            } else if ("title_writer".equals(searchType)) {
                where = " WHERE (q.SUBJECT LIKE ? OR q.FK_MEMBER_ID LIKE ?) ";
            } else { // title or default
                where = " WHERE (q.SUBJECT LIKE ? OR q.CONTENT LIKE ?) ";
                // ※ 네 요구: "제목이나 내용에 검색어 포함"을 기본으로 잡음
            }
        }

        String sql =
            " SELECT q.QNA_ID, q.FK_MEMBER_ID, q.SUBJECT, q.REGDATE, " +
            "        q.IS_SECRET, q.ANSWER, " +
            "        CASE WHEN EXISTS ( " +
            "            SELECT 1 FROM qna_comment c " +
            "            WHERE c.fk_qna_id = q.qna_id " +
            "        ) THEN 1 ELSE 0 END AS has_reply, " +
            "        CASE WHEN EXISTS ( " +
            "            SELECT 1 FROM qna_comment c " +
            "            WHERE c.fk_qna_id = q.qna_id " +
            "              AND c.fk_member_id = 'admin' " +
            "        ) THEN 1 ELSE 0 END AS answered " +
            " FROM tbl_qna q " +
              where +
            " ORDER BY q.QNA_ID DESC " +
            " OFFSET (? - 1) * ? ROWS " +
            " FETCH NEXT ? ROWS ONLY ";

        try {
            conn = ds.getConnection();
            pstmt = conn.prepareStatement(sql);

            int idx = 1;

            // 1) 검색 바인딩
            if (hasKeyword) {
                String kw = "%" + keyword.trim() + "%";
                if ("title_writer".equals(searchType)) {
                    pstmt.setString(idx++, kw); // SUBJECT LIKE ?
                    pstmt.setString(idx++, kw); // FK_MEMBER_ID LIKE ?
                } else if ("writer".equals(searchType)) {
                    pstmt.setString(idx++, kw); // FK_MEMBER_ID LIKE ?
                } else {
                    pstmt.setString(idx++, kw); // SUBJECT LIKE ?
                    pstmt.setString(idx++, kw); // CONTENT LIKE ?
                }
            }

            // 2) 페이징 바인딩(항상)
            pstmt.setInt(idx++, currentShowPageNo);
            pstmt.setInt(idx++, sizePerPage);
            pstmt.setInt(idx++, sizePerPage);

            rs = pstmt.executeQuery();

            while (rs.next()) {
                QnaDTO qna = new QnaDTO();

                qna.setQnaId(rs.getLong("QNA_ID"));
                qna.setFkMemberId(rs.getString("FK_MEMBER_ID"));
                qna.setSubject(rs.getString("SUBJECT"));
                qna.setRegDate(rs.getDate("REGDATE"));
                qna.setIsSecret(rs.getInt("IS_SECRET"));
                qna.setAnswer(rs.getString("ANSWER"));

                // QnaDTO에 아래 boolean 필드(get/set) 있어야 함
                qna.setHasReply(rs.getInt("has_reply") == 1);
                qna.setAnswered(rs.getInt("answered") == 1);

                list.add(qna);
            }

        } finally {
            close();
        }

        return list;
    }




    // 글 조회
    public QnaDTO selectOneQna(int qnaId) throws Exception {

        QnaDTO dto = null;

        String sql =
            " SELECT QNA_ID, FK_MEMBER_ID, FK_ADMIN_ID, SUBJECT, REGDATE, UPDATEDATE, " +
            "        CONTENT, IS_SECRET, ANSWER " +
            " FROM tbl_qna " +
            " WHERE QNA_ID = ? ";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, qnaId);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    dto = new QnaDTO();

                    dto.setQnaId(rs.getInt("QNA_ID"));
                    dto.setFkMemberId(rs.getString("FK_MEMBER_ID"));
                    dto.setFkAdminId(rs.getString("FK_ADMIN_ID"));
                    dto.setSubject(rs.getString("SUBJECT"));

                    dto.setRegDate(rs.getDate("REGDATE"));
                    dto.setUpdateDate(rs.getDate("UPDATEDATE"));

                    dto.setContent(rs.getString("CONTENT"));
                    dto.setIsSecret(rs.getInt("IS_SECRET"));

                    // ANSWER는 CLOB인데 rs.getString()으로 받아도 대부분 OK
                    dto.setAnswer(rs.getString("ANSWER"));
                }
            }
        }

        return dto;
    }

    // 댓글목록조회
    public List<QnaCommentDTO> selectCommentList(int qnaId) throws Exception {

        List<QnaCommentDTO> list = new ArrayList<>();

        String sql =
            " SELECT comment_id, fk_qna_id, fk_member_id, content, regdate " +
            " FROM qna_comment " +
            " WHERE fk_qna_id = ? " +
            " ORDER BY comment_id ASC ";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, qnaId);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    QnaCommentDTO c = new QnaCommentDTO();
                    c.setCommentId(rs.getInt("comment_id"));
                    c.setFkQnaId(rs.getInt("fk_qna_id"));
                    c.setFkMemberId(rs.getString("fk_member_id"));
                    c.setContent(rs.getString("content"));
                    c.setRegDate(rs.getDate("regdate"));
                    list.add(c);
                }
            }
        }

        return list;
    }

    // 댓글 등록
    public void insertComment(int qnaId, String memberId, String content) throws Exception {

        String sql =
            " INSERT INTO qna_comment(comment_id, fk_qna_id, fk_member_id, content, regdate) " +
            " VALUES (seq_qna_comment.NEXTVAL, ?, ?, ?, SYSDATE) ";

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setInt(1, qnaId);
            pstmt.setString(2, memberId);
            pstmt.setString(3, content);

            pstmt.executeUpdate();
        }
    }

    
    // 검색에 따른 총페이지수알아오기
    @Override
    public int getTotalQnaPage(Map<String, String> paraMap) throws SQLException {

        int totalPage = 0;

        try {
            conn = ds.getConnection();

            String sql =
                " select ceil(count(*)/?) "
              + " from tbl_qna q "
              + " where 1=1 ";

            String searchType = paraMap.get("searchType");
            String searchWord = paraMap.get("searchWord");
            String sizePerPageStr = paraMap.get("sizePerPage");

            if (searchType == null) searchType = "";
            if (searchWord == null) searchWord = "";
            if (sizePerPageStr == null || sizePerPageStr.isBlank()) sizePerPageStr = "10";  // ✅ 기본값

            if (!searchType.isBlank() && !searchWord.isBlank()) {
                switch (searchType) {
                    case "writer":
                        sql += " and q.fk_member_id like '%'||?||'%' ";
                        break;
                    case "subject":
                        sql += " and q.subject like '%'||?||'%' ";
                        break;
                    case "content":
                        sql += " and q.content like '%'||?||'%' ";
                        break;
                    case "subject_content":
                        sql += " and ( q.subject like '%'||?||'%' or q.content like '%'||?||'%' ) ";
                        break;
                    default:
                        searchType = "";
                }
            }

            pstmt = conn.prepareStatement(sql);

            int sizePerPage;
            try {
                sizePerPage = Integer.parseInt(sizePerPageStr);
            } catch (NumberFormatException e) {
                sizePerPage = 10; // ✅ 이상하면 기본값
            }

            pstmt.setInt(1, sizePerPage);

            if (!searchType.isBlank() && !searchWord.isBlank()) {
                if ("subject_content".equals(searchType)) {
                    pstmt.setString(2, searchWord);
                    pstmt.setString(3, searchWord);
                } else {
                    pstmt.setString(2, searchWord);
                }
            }

            rs = pstmt.executeQuery();
            rs.next();
            totalPage = rs.getInt(1);

        } finally {
            close();
        }

        return totalPage;
    }




	
	// 페이징처리 완료한 리스트
    @Override
    public List<QnaDTO> selectQnaPaging(Map<String, String> paraMap) throws SQLException {

        List<QnaDTO> list = new ArrayList<>();

        try {
            conn = ds.getConnection();

            String sql =
                " select q.qna_id, q.fk_member_id, q.fk_admin_id, q.subject, q.is_secret, q.answer, "
              + "        q.regdate, q.updatedate, "
              + "        case when q.answer is not null and length(trim(q.answer)) > 0 then 1 else 0 end as answered, "
              + "        case when exists (select 1 from qna_comment c where c.fk_qna_id = q.qna_id) then 1 else 0 end as has_reply "
              + " from tbl_qna q "
              + " where 1=1 ";

            String searchType = paraMap.get("searchType");
            String searchWord = paraMap.get("searchWord");
            if(searchType == null) searchType = "";
            if(searchWord == null) searchWord = "";

            if(!searchType.isBlank() && !searchWord.isBlank()) {
                switch (searchType) {
                    case "writer":
                        sql += " and q.fk_member_id like '%'||?||'%' ";
                        break;
                    case "subject":
                        sql += " and q.subject like '%'||?||'%' ";
                        break;
                    case "content":
                        sql += " and q.content like '%'||?||'%' ";
                        break;
                    case "subject_content":
                        sql += " and ( q.subject like '%'||?||'%' or q.content like '%'||?||'%' ) ";
                        break;
                    default:
                        // 무시
                        searchType = "";
                }
            }

            int currentShowPageNo = Integer.parseInt(paraMap.get("currentShowPageNo"));
            int sizePerPage = Integer.parseInt(paraMap.get("sizePerPage"));

            sql += " order by q.qna_id desc "
                 + " offset (?-1)*? rows fetch next ? rows only ";

            pstmt = conn.prepareStatement(sql);

            int idx = 1;

            if(!searchType.isBlank() && !searchWord.isBlank()) {
                if("subject_content".equals(searchType)) {
                    pstmt.setString(idx++, searchWord);
                    pstmt.setString(idx++, searchWord);
                } else {
                    pstmt.setString(idx++, searchWord);
                }
            }

            pstmt.setInt(idx++, currentShowPageNo);
            pstmt.setInt(idx++, sizePerPage);
            pstmt.setInt(idx++, sizePerPage);

            rs = pstmt.executeQuery();

            while(rs.next()) {
                QnaDTO dto = new QnaDTO();
                dto.setQnaId(rs.getLong("qna_id"));
                dto.setFkMemberId(rs.getString("fk_member_id"));
                dto.setFkAdminId(rs.getString("fk_admin_id"));
                dto.setSubject(rs.getString("subject"));
                dto.setIsSecret(rs.getInt("is_secret"));
                dto.setAnswer(rs.getString("answer"));

                dto.setRegDate(rs.getDate("regdate"));
                dto.setUpdateDate(rs.getDate("updatedate"));

                dto.setAnswered(rs.getInt("answered") == 1);
                dto.setHasReply(rs.getInt("has_reply") == 1);

                list.add(dto);
            }

        } finally {
            close();
        }

        return list;
    }






	// 페이징처리시 보여주는 순번공식 제작
    @Override
    public int getTotalQnaCount(Map<String, String> paraMap) throws SQLException {

        int totalCount = 0;

        try {
            conn = ds.getConnection();

            String sql =
                " select count(*) "
              + " from tbl_qna q "
              + " where 1=1 ";

            String searchType = paraMap.get("searchType");
            String searchWord = paraMap.get("searchWord");

            if (searchType == null) searchType = "";
            if (searchWord == null) searchWord = "";

            if (!searchType.isBlank() && !searchWord.isBlank()) {
                switch (searchType) {
                    case "writer":
                        sql += " and q.fk_member_id like '%'||?||'%' ";
                        break;
                    case "subject":
                        sql += " and q.subject like '%'||?||'%' ";
                        break;
                    case "content":
                        sql += " and q.content like '%'||?||'%' ";
                        break;
                    case "subject_content":
                        sql += " and ( q.subject like '%'||?||'%' or q.content like '%'||?||'%' ) ";
                        break;
                    default:
                        searchType = "";
                }
            }

            pstmt = conn.prepareStatement(sql);

            if (!searchType.isBlank() && !searchWord.isBlank()) {
                if ("subject_content".equals(searchType)) {
                    pstmt.setString(1, searchWord);
                    pstmt.setString(2, searchWord);
                } else {
                    pstmt.setString(1, searchWord);
                }
            }

            rs = pstmt.executeQuery();
            rs.next();
            totalCount = rs.getInt(1);

        } finally {
            close();
        }

        return totalCount;
    }

    
    // qna 수정
	@Override
	public int updateQna(QnaDTO updated) throws Exception {
		int n = 0;
	    Connection conn = null;
	    java.sql.PreparedStatement pstmt = null;

	    try {
	        conn = getConnection();

	        String sql =
	            " UPDATE tbl_qna " +
	            "    SET subject = ?, content = ?, is_secret = ?, updatedate = SYSDATE " +
	            "  WHERE QNA_ID = ? ";

	        pstmt = conn.prepareStatement(sql);
	        pstmt.setString(1, updated.getSubject());
	        pstmt.setString(2, updated.getContent());
	        pstmt.setInt(3, updated.getIsSecret());
	        pstmt.setLong(4, updated.getQnaId());

	        n = pstmt.executeUpdate();

	    } finally {
	        if(pstmt != null) pstmt.close();
	        if(conn != null) conn.close();
	    }

	    return n;
	}










	

}
