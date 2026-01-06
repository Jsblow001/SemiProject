package jh.notice.model;

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

import jh.notice.domain.NoticeDTO;

public class NoticeDAO_imple implements NoticeDAO {

    private DataSource ds;
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;

    public NoticeDAO_imple() {
        try {
            Context initContext = new InitialContext();
            Context envContext  = (Context) initContext.lookup("java:/comp/env");
            ds = (DataSource) envContext.lookup("SemiProject"); // ✅ 너 QnA랑 동일한 JNDI로 맞춰
        } catch(Exception e) {
            e.printStackTrace();
        }
    }

    private void close() {
        try {
            if(rs != null)    { rs.close(); rs = null; }
            if(pstmt != null) { pstmt.close(); pstmt = null; }
            if(conn != null)  { conn.close(); conn = null; }
        } catch(SQLException e) {
            e.printStackTrace();
        }
    }

    private String buildSearchWhere(String searchType) {
        // subject | content | subject_content
        if("subject".equals(searchType)) {
            return " and subject like '%'||?||'%' ";
        }
        else if("content".equals(searchType)) {
            return " and content like '%'||?||'%' ";
        }
        else if("subject_content".equals(searchType)) {
            return " and ( subject like '%'||?||'%' or content like '%'||?||'%' ) ";
        }
        return "";
    }

    private int bindSearchParams(PreparedStatement pstmt, int startIndex, String searchType, String searchWord) throws SQLException {
        // searchType에 따라 바인딩 개수 다름
        if("subject".equals(searchType) || "content".equals(searchType)) {
            pstmt.setString(startIndex, searchWord);
            return startIndex + 1;
        }
        else if("subject_content".equals(searchType)) {
            pstmt.setString(startIndex, searchWord);
            pstmt.setString(startIndex + 1, searchWord);
            return startIndex + 2;
        }
        return startIndex;
    }

    @Override
    public List<NoticeDTO> selectFixedList(Map<String, String> paraMap) throws SQLException {

        List<NoticeDTO> fixedList = new ArrayList<>();

        String searchType = paraMap.get("searchType");
        String searchWord = paraMap.get("searchWord");
        if(searchType == null) searchType = "";
        if(searchWord == null) searchWord = "";
        searchWord = searchWord.trim();

        try {
            conn = ds.getConnection();

            String sql =
                    " select notice_id, fk_admin_id, subject, " +
                    "        to_char(regdate,'yy-mm-dd') as regdate, " +
                    "        to_char(updatedate,'yy-mm-dd') as updatedate, " +
                    "        content, is_fixed " +
                    " from tbl_notice " +
                    " where is_fixed = 1 ";

            // ✅ 관리자 검색조건(일반은 paraMap에 빈값 넣어서 자동 무시됨)
            if(!searchType.isBlank() && !searchWord.isBlank()) {
                sql += buildSearchWhere(searchType);
            }

            sql += " order by notice_id desc ";

            pstmt = conn.prepareStatement(sql);

            int bindIndex = 1;
            if(!searchType.isBlank() && !searchWord.isBlank()) {
                bindIndex = bindSearchParams(pstmt, bindIndex, searchType, searchWord);
            }

            rs = pstmt.executeQuery();

            while(rs.next()) {
                NoticeDTO noticeDto = new NoticeDTO();
                noticeDto.setNoticeId(rs.getInt("notice_id"));
                noticeDto.setAdminId(rs.getString("fk_admin_id"));
                noticeDto.setSubject(rs.getString("subject"));
                noticeDto.setRegDate(rs.getString("regdate"));
                noticeDto.setUpdateDate(rs.getString("updatedate"));
                noticeDto.setContent(rs.getString("content"));
                noticeDto.setIsFixed(rs.getInt("is_fixed"));

                fixedList.add(noticeDto);
            }

        } finally {
            close();
        }

        return fixedList;
    }

    @Override
    public List<NoticeDTO> selectNoticePaging(Map<String, String> paraMap) throws SQLException {

        List<NoticeDTO> noticeList = new ArrayList<>();

        String searchType = paraMap.get("searchType");
        String searchWord = paraMap.get("searchWord");
        if(searchType == null) searchType = "";
        if(searchWord == null) searchWord = "";
        searchWord = searchWord.trim();

        int currentShowPageNo = Integer.parseInt(paraMap.get("currentShowPageNo"));
        int sizePerPage = Integer.parseInt(paraMap.get("sizePerPage"));

        try {
            conn = ds.getConnection();

            String sql =
                    " select notice_id, fk_admin_id, subject, " +
                    "        to_char(regdate,'yy-mm-dd') as regdate, " +
                    "        to_char(updatedate,'yy-mm-dd') as updatedate, " +
                    "        content, is_fixed " +
                    " from tbl_notice " +
                    " where is_fixed = 0 ";

            if(!searchType.isBlank() && !searchWord.isBlank()) {
                sql += buildSearchWhere(searchType);
            }

            sql += " order by notice_id desc " +
                   " offset (? - 1) * ? rows " +
                   " fetch next ? rows only ";

            pstmt = conn.prepareStatement(sql);

            int bindIndex = 1;
            if(!searchType.isBlank() && !searchWord.isBlank()) {
                bindIndex = bindSearchParams(pstmt, bindIndex, searchType, searchWord);
            }

            pstmt.setInt(bindIndex, currentShowPageNo);
            pstmt.setInt(bindIndex + 1, sizePerPage);
            pstmt.setInt(bindIndex + 2, sizePerPage);

            rs = pstmt.executeQuery();

            while(rs.next()) {
                NoticeDTO noticeDto = new NoticeDTO();
                noticeDto.setNoticeId(rs.getInt("notice_id"));
                noticeDto.setAdminId(rs.getString("fk_admin_id"));
                noticeDto.setSubject(rs.getString("subject"));
                noticeDto.setRegDate(rs.getString("regdate"));
                noticeDto.setUpdateDate(rs.getString("updatedate"));
                noticeDto.setContent(rs.getString("content"));
                noticeDto.setIsFixed(rs.getInt("is_fixed"));

                noticeList.add(noticeDto);
            }

        } finally {
            close();
        }

        return noticeList;
    }

    @Override
    public int getTotalPage(Map<String, String> paraMap) throws SQLException {

        int totalPage = 0;

        String searchType = paraMap.get("searchType");
        String searchWord = paraMap.get("searchWord");
        if(searchType == null) searchType = "";
        if(searchWord == null) searchWord = "";
        searchWord = searchWord.trim();

        int sizePerPage = Integer.parseInt(paraMap.get("sizePerPage"));

        try {
            conn = ds.getConnection();

            String sql =
                    " select ceil(count(*) / ?) " +
                    " from tbl_notice " +
                    " where is_fixed = 0 ";

            if(!searchType.isBlank() && !searchWord.isBlank()) {
                sql += buildSearchWhere(searchType);
            }

            pstmt = conn.prepareStatement(sql);

            int bindIndex = 1;
            pstmt.setInt(bindIndex, sizePerPage);
            bindIndex++;

            if(!searchType.isBlank() && !searchWord.isBlank()) {
                bindIndex = bindSearchParams(pstmt, bindIndex, searchType, searchWord);
            }

            rs = pstmt.executeQuery();
            rs.next();
            totalPage = rs.getInt(1);

        } finally {
            close();
        }

        return totalPage;
    }

    @Override
    public int insertNotice(NoticeDTO noticeDto) throws SQLException {

        int n = 0;

        try {
            conn = ds.getConnection();

            String sql =
                    " insert into tbl_notice(notice_id, fk_admin_id, subject, regdate, updatedate, content, is_fixed) " +
                    " values(seq_notice_id.nextval, ?, ?, sysdate, null, ?, ?) ";

            pstmt = conn.prepareStatement(sql);

            pstmt.setString(1, noticeDto.getAdminId());
            pstmt.setString(2, noticeDto.getSubject());
            pstmt.setString(3, noticeDto.getContent());
            pstmt.setInt(4, noticeDto.getIsFixed());

            n = pstmt.executeUpdate();

        } finally {
            close();
        }

        return n;
    }
    
    
    @Override
    public NoticeDTO selectOne(int noticeId) throws SQLException {

        NoticeDTO noticeDto = null;

        try {
            conn = ds.getConnection();

            String sql =
                    " select notice_id, fk_admin_id, subject, " +
                    "        to_char(regdate,'yyyy-mm-dd hh24:mi') as regdate, " +
                    "        to_char(updatedate,'yyyy-mm-dd hh24:mi') as updatedate, " +
                    "        content, is_fixed " +
                    " from tbl_notice " +
                    " where notice_id = ? ";

            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, noticeId);

            rs = pstmt.executeQuery();

            if(rs.next()) {
                noticeDto = new NoticeDTO();
                noticeDto.setNoticeId(rs.getInt("notice_id"));
                noticeDto.setAdminId(rs.getString("fk_admin_id"));
                noticeDto.setSubject(rs.getString("subject"));
                noticeDto.setRegDate(rs.getString("regdate"));
                noticeDto.setUpdateDate(rs.getString("updatedate"));
                noticeDto.setContent(rs.getString("content"));
                noticeDto.setIsFixed(rs.getInt("is_fixed"));
            }

        } finally {
            close();
        }

        return noticeDto;
    }
    
    
    @Override
    public int updateNotice(NoticeDTO noticeDto) throws SQLException {

        int n = 0;

        try {
            conn = ds.getConnection();

            String sql =
                " update tbl_notice set " +
                "   subject = ?, " +
                "   content = ?, " +
                "   is_fixed = ?, " +
                "   updatedate = sysdate " +
                " where notice_id = ? ";

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, noticeDto.getSubject());
            pstmt.setString(2, noticeDto.getContent());
            pstmt.setInt(3, noticeDto.getIsFixed());
            pstmt.setInt(4, noticeDto.getNoticeId());

            n = pstmt.executeUpdate();

        } finally {
            close();
        }

        return n;
    }
    
    
    @Override
    public int deleteNotice(int noticeId) throws SQLException {

        int n = 0;

        try {
            conn = ds.getConnection();

            String sql = " delete from tbl_notice where notice_id = ? ";
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, noticeId);

            n = pstmt.executeUpdate();

        } finally {
            close();
        }

        return n;
    }
    
    
}
