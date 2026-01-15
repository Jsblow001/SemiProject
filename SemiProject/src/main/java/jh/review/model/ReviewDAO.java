package jh.review.model;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import jh.review.domain.ReviewDTO;

public interface ReviewDAO {

	Connection getConnection() throws SQLException;
	
    // 리뷰 목록(페이징+정렬+검색) : JSP allReviews에 들어갈 DTO 리스트
    int getTotalReviewCount(Map<String, String> paraMap) throws SQLException;
    List<ReviewDTO> selectReviewListPaging(Map<String, String> paraMap) throws SQLException;

    // 리뷰 작성: 결제완료 구매이력 중 "아직 리뷰 안 쓴 상품" 목록
    List<Map<String, String>> selectPurchasesForReview(String userid) throws SQLException;

    // 리뷰 등록
    long getReviewSeqNextVal() throws SQLException;
    
    int insertReview(Connection conn, ReviewDTO dto) throws SQLException;

    
    // 리뷰 뷰단 중앙부 캐러셀 노출용(최근판매량순 등등)
    List<Map<String, Object>> selectMidRankProducts(String sortKey, int limit, String userid) throws SQLException;
	
    // 리뷰 이미지 등록(복수)
    int insertReviewImage(Connection conn, long review_id, String image_filename) throws SQLException;
	
    
    // 삭제용
    List<String> selectReviewImageFilenames(Connection conn, long reviewId) throws SQLException;
    int deleteReviewComments(Connection conn, long reviewId) throws SQLException;
    int deleteReviewImages(Connection conn, long reviewId) throws SQLException;
    int deleteReview(Connection conn, long reviewId) throws SQLException;
    
    // 권한체크용(상세/삭제 공통으로 써먹음)
    ReviewDTO selectReviewOne(long reviewId) throws SQLException;   // 이미 있으면 생략
    
    // 리뷰 상세 1건 보기 
    ReviewDTO selectReviewDetail(long reviewId) throws SQLException;
    
    // 마이페이지 최근 리뷰 n개 조회
    List<ReviewDTO> selectMyRecentReviews(String userid, int limit) throws SQLException;

    // 내 리뷰 전체보기 - 총 개수
    int getTotalMyReviewCount(Map<String, String> paraMap) throws SQLException;

    // 내 리뷰 전체보기 - 페이징 목록
    List<ReviewDTO> selectMyReviewListPaging(Map<String, String> paraMap) throws SQLException;

    // 관리자 리뷰 댓글달기 (update + insert)
    int upsertReviewComment(long reviewId, String adminId, String commentContent) throws SQLException;

}
