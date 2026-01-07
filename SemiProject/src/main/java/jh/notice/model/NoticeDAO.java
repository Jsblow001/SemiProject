package jh.notice.model;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import jh.notice.domain.NoticeDTO;

public interface NoticeDAO {

    // page=1일 때만 사용(고정글 상단 출력)
    List<NoticeDTO> selectFixedList(Map<String, String> paraMap) throws SQLException;

    // 비고정글(is_fixed=0) 페이징 조회
    List<NoticeDTO> selectNoticePaging(Map<String, String> paraMap) throws SQLException;

    // 비고정글(is_fixed=0) 기준 총페이지
    int getTotalPage(Map<String, String> paraMap) throws SQLException;

    // 관리자 글쓰기
    int insertNotice(NoticeDTO noticeDto) throws SQLException;
    
    // 공지글 하나 상세보기
    NoticeDTO selectOne(int noticeId) throws SQLException;
    
    // 공지글 수정
    int updateNotice(NoticeDTO noticeDto) throws SQLException;
    
    // 공지글 삭제
    int deleteNotice(int noticeId) throws SQLException;

    // 공지글 총개수 구하는 메서드
    int getTotalNoticeCount(Map<String, String> paraMap) throws SQLException;



}
