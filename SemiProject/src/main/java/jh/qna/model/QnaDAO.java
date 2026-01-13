package jh.qna.model;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import jh.qna.domain.QnaDTO;
import jh.qna.domain.QnaFileDTO;

public interface QnaDAO {

	Connection getConnection() throws SQLException;
	
    long insertQna(Connection conn, QnaDTO dto) throws SQLException;
    
    int insertQnaFile(Connection conn, QnaFileDTO fileDto) throws SQLException;

    List<QnaFileDTO> selectFilesByQnaId(Connection conn, long qnaId) throws SQLException;

    int deleteFilesByQnaId(Connection conn, long qnaId) throws SQLException;
    
    int deleteQna(Connection conn, long qnaId) throws SQLException;

    
    QnaDTO selectOneQna(int qnaId) throws Exception;

    // 댓글목록조회
	Object selectCommentList(int qnaId) throws Exception;

	// 댓글 등록
	void insertComment(int qnaId, String loginId, String content) throws Exception;

	// 총 qna 페이지 개수 세기
	int getTotalQnaPage(Map<String, String> paraMap) throws Exception;

	// 페이징 처리 완료한 리스트
	List<QnaDTO> selectQnaPaging(Map<String, String> paraMap) throws Exception;

	// 페이징처리시 보여주는 순번공식 제작
	int getTotalQnaCount(Map<String, String> paraMap) throws Exception;

	// qna 수정
	int updateQna(QnaDTO updated) throws Exception;
	
	// qna 수정 오버로드
	int updateQna(Connection conn, QnaDTO updated) throws Exception;
	
	// qna 수정 시 파일 업데이트
	int updateQnaFile(Connection conn, QnaFileDTO fileDto) throws SQLException;
	
	// qna 첨부했던 파일 삭제
	int deleteQnaFile(Connection conn, long fileId) throws SQLException;

	
	List<QnaFileDTO> selectQnaFileList(Connection conn, long fkQnaId) throws SQLException;

	
	QnaFileDTO selectOneQnaFile(Connection conn, long qnaFileId) throws SQLException;

	

}
