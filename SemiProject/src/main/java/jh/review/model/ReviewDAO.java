package jh.review.model;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import jh.review.domain.ReviewDTO;

public interface ReviewDAO {

    // 리뷰 목록(페이징+정렬+검색) : JSP allReviews에 들어갈 DTO 리스트
    int getTotalReviewCount(Map<String, String> paraMap) throws SQLException;
    List<ReviewDTO> selectReviewListPaging(Map<String, String> paraMap) throws SQLException;

    // 리뷰 작성: 결제완료 구매이력 중 "아직 리뷰 안 쓴 상품" 목록
    List<Map<String, String>> selectPurchasesForReview(String userid) throws SQLException;

    // 리뷰 등록
    long getReviewSeqNextVal() throws SQLException;
    int insertReview(ReviewDTO dto) throws SQLException;

    // 리뷰 이미지 등록(복수)
    int insertReviewImage(long review_id, String image_filename) throws SQLException;
    
    // 리뷰 뷰단 중앙부 캐러셀 노출용(최근판매량순 등등)
    List<Map<String, Object>> selectMidRankProducts(String sortKey, int limit) throws SQLException;
}
