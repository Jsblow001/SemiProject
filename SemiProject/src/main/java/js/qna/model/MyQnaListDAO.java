package js.qna.model;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import jh.qna.domain.QnaDTO; // QnaDTO 패키지 경로에 맞게 수정하세요

public interface MyQnaListDAO {

    // 로그인한 사용자의 총 문의글 개수를 조회 (페이징 바 생성을 위함)
    int getMyTotalQnaCount(String userid) throws SQLException;

    // 로그인한 사용자의 문의글 목록을 페이징 처리하여 조회
    List<QnaDTO> selectMyQnaList(Map<String, String> paraMap) throws SQLException;
    
    // 답변 미완료된 qna 갯수 확인
    int noCommentCnt() throws SQLException;

    // 미답변 목록 조회
    List<QnaDTO> selectNoCommentList(Map<String, String> paraMap) throws SQLException;

}