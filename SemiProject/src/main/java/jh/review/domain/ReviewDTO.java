package jh.review.domain;

import java.util.ArrayList;
import java.util.List;

public class ReviewDTO {

    // ===== tbl_product_review =====
    private long review_id;
    private int fk_product_id;
    private String fk_member_id;

    private String review_date;      // yyyy-mm-dd (문자열로 내려줌)
    private int rating;
    private String review_title;
    private String review_content;

    private String praise_keywords;  // DB 원본(콤마 문자열)

    // ===== join/view 용 =====
    private String writer;           // "김**"
    private int verified;            // 1/0
    private String date;             // "오늘 작성" / "3일 전 작성" / "25.12.24 작성"
    private String badge;            // "NEW" or ""
    private String productCode;      // 지금은 product_name 사용(추후 code 컬럼 생기면 교체)
    private String product_name;     // 조인용(필요시)

    private int commentCount;        // 관리자 댓글 0/1
    private String adminReply;       // 관리자 댓글 내용

    private List<String> photos = new ArrayList<>();  // 최대 2장 노출
    private List<String> tags = new ArrayList<>();    // 칭찬 키워드(복수)

    // ===== getter/setter =====
    public long getReview_id() { return review_id; }
    public void setReview_id(long review_id) { this.review_id = review_id; }

    public int getFk_product_id() { return fk_product_id; }
    public void setFk_product_id(int fk_product_id) { this.fk_product_id = fk_product_id; }

    public String getFk_member_id() { return fk_member_id; }
    public void setFk_member_id(String fk_member_id) { this.fk_member_id = fk_member_id; }

    public String getReview_date() { return review_date; }
    public void setReview_date(String review_date) { this.review_date = review_date; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }

    public String getReview_title() { return review_title; }
    public void setReview_title(String review_title) { this.review_title = review_title; }

    public String getReview_content() { return review_content; }
    public void setReview_content(String review_content) { this.review_content = review_content; }

    public String getPraise_keywords() { return praise_keywords; }
    public void setPraise_keywords(String praise_keywords) { this.praise_keywords = praise_keywords; }

    public String getWriter() { return writer; }
    public void setWriter(String writer) { this.writer = writer; }

    public int getVerified() { return verified; }
    public void setVerified(int verified) { this.verified = verified; }

    public String getDate() { return date; }
    public void setDate(String date) { this.date = date; }

    public String getBadge() { return badge; }
    public void setBadge(String badge) { this.badge = badge; }

    public String getProductCode() { return productCode; }
    public void setProductCode(String productCode) { this.productCode = productCode; }

    public String getProduct_name() { return product_name; }
    public void setProduct_name(String product_name) { this.product_name = product_name; }

    public int getCommentCount() { return commentCount; }
    public void setCommentCount(int commentCount) { this.commentCount = commentCount; }

    public String getAdminReply() { return adminReply; }
    public void setAdminReply(String adminReply) { this.adminReply = adminReply; }

    public List<String> getPhotos() { return photos; }
    public void setPhotos(List<String> photos) { this.photos = photos; }

    public List<String> getTags() { return tags; }
    public void setTags(List<String> tags) { this.tags = tags; }
}
