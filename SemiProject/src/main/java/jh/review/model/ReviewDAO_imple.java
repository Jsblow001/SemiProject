package jh.review.model;

import java.sql.*;
import java.util.*;
import javax.naming.*;
import javax.sql.DataSource;

import jh.review.domain.ReviewDTO;

public class ReviewDAO_imple implements ReviewDAO {

    private DataSource ds;
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;

    public ReviewDAO_imple() {
        try {
            Context initContext = new InitialContext();
            Context envContext  = (Context)initContext.lookup("java:/comp/env");
            ds = (DataSource)envContext.lookup("SemiProject");
        } catch (NamingException e) {
            e.printStackTrace();
        }
    }

    private void close() {
        try {
            if(rs != null)    { rs.close(); rs=null; }
            if(pstmt != null) { pstmt.close(); pstmt=null; }
            if(conn != null)  { conn.close(); conn=null; }
        } catch(SQLException e) {
            e.printStackTrace();
        }
    }
    
    // 컨트롤러에서 트랜잭션 잡을 때 conn 얻는 용도
    @Override
    public Connection getConnection() throws SQLException {
        return ds.getConnection();
    }

    // =========================
    // 1) 총 리뷰 수
    // =========================
    @Override
    public int getTotalReviewCount(Map<String, String> paraMap) throws SQLException {

        int totalCount = 0;
        String searchWord = paraMap.get("searchWord");
        if(searchWord == null) searchWord = "";
        searchWord = searchWord.trim();

        try {
            conn = ds.getConnection();

            StringBuilder sql = new StringBuilder();
            sql.append(" select count(*) ")
               .append(" from tbl_product_review r ")
               .append(" where 1=1 ");

            if(!searchWord.isBlank()) {
                sql.append(" and ( lower(r.review_title) like '%'||lower(?)||'%' ")
                   .append("    or lower(r.review_content) like '%'||lower(?)||'%' ) ");
            }

            pstmt = conn.prepareStatement(sql.toString());

            int idx = 1;
            if(!searchWord.isBlank()) {
                pstmt.setString(idx++, searchWord);
                pstmt.setString(idx++, searchWord);
            }

            rs = pstmt.executeQuery();
            rs.next();
            totalCount = rs.getInt(1);

        } finally {
            close();
        }

        return totalCount;
    }

    // =========================
    // 2) 리뷰 목록 페이징
    // sort: recent | rating
    // sizePerPage: 기본 5
    // =========================
    @Override
    public List<ReviewDTO> selectReviewListPaging(Map<String, String> paraMap) throws SQLException {

        List<ReviewDTO> list = new ArrayList<>();

        String sort = paraMap.get("sort");                 // recent | rating
        String searchWord = paraMap.get("searchWord");     // 제목+내용
        String currentShowPageNo = paraMap.get("currentShowPageNo");
        String sizePerPage = paraMap.get("sizePerPage");

        if(sort == null || sort.isBlank()) sort = "recent";
        if(searchWord == null) searchWord = "";
        searchWord = searchWord.trim();

        if(currentShowPageNo == null || currentShowPageNo.isBlank()) currentShowPageNo = "1";
        if(sizePerPage == null || sizePerPage.isBlank()) sizePerPage = "5";

        int nCurrentPage = Integer.parseInt(currentShowPageNo);
        int nSizePerPage = Integer.parseInt(sizePerPage);

        String orderBy;
        if("rating".equalsIgnoreCase(sort)) {
            orderBy = " order by r.rating desc, r.review_date desc, r.review_id desc ";
        } else {
            orderBy = " order by r.review_date desc, r.review_id desc ";
        }

        try {
            conn = ds.getConnection();

            StringBuilder sql = new StringBuilder();
            sql.append(" select ")
               .append("   r.review_id, r.fk_product_id, r.fk_member_id, ")
               .append("   r.review_title, r.rating, r.review_content, r.praise_keywords, ")
               .append("   to_char(r.review_date,'yyyy-mm-dd') as review_date, ")
               .append("   p.product_name, ")
               .append("   substr(m.name,1,1) || '**' as writer, ")

               // 구매인증(결제완료 구매이력 존재)
               .append("   case when exists ( ")
               .append("       select 1 ")
               .append("         from tbl_order o join tbl_order_detail d ")
               .append("           on o.odrcode = d.fk_odrcode ")
               .append("        where o.fk_member_id = r.fk_member_id ")
               .append("          and d.fk_product_id = r.fk_product_id ")
               .append("          and o.payment_status = 1 ")
               .append("   ) then 1 else 0 end as verified, ")

               // date 라벨(JSP는 r.date 사용)
               .append("   case ")
               .append("     when trunc(sysdate) - trunc(r.review_date) = 0 then '오늘 작성' ")
               .append("     when trunc(sysdate) - trunc(r.review_date) between 1 and 6 ")
               .append("       then (trunc(sysdate) - trunc(r.review_date)) || '일 전 작성' ")
               .append("     else to_char(r.review_date,'yy.mm.dd') || ' 작성' ")
               .append("   end as date_label, ")

               // badge: 7일 이내면 NEW
               .append("   case when trunc(sysdate) - trunc(r.review_date) between 0 and 6 then 'NEW' else '' end as badge, ")

               // 관리자 댓글(리뷰당 1개, status=1만)
               .append("   case when c.review_comment_id is not null then 1 else 0 end as comment_count, ")
               .append("   c.comment_content as admin_reply, ")

               // 사진 최대 2개 (CSV)
               .append("   ( ")
               .append("     select listagg(x.image_filename, ',') within group(order by x.review_image_id) ")
               .append("     from ( ")
               .append("       select ri.review_image_id, ri.image_filename, ")
               .append("              row_number() over(order by ri.review_image_id) as rn ")
               .append("         from tbl_review_image ri ")
               .append("        where ri.fk_review_id = r.review_id ")
               .append("     ) x ")
               .append("     where x.rn <= 2 ")
               .append("   ) as photo_csv ")

               .append(" from tbl_product_review r ")
               .append(" join tbl_product p on p.product_id = r.fk_product_id ")
               .append(" join tbl_member  m on m.member_id = r.fk_member_id ")
               .append(" left join tbl_review_comment c ")
               .append("   on c.fk_review_id = r.review_id and c.status = 1 ")
               .append(" where 1=1 ");

            if(!searchWord.isBlank()) {
                sql.append(" and ( lower(r.review_title) like '%'||lower(?)||'%' ")
                   .append("    or lower(r.review_content) like '%'||lower(?)||'%' ) ");
            }

            sql.append(orderBy);
            sql.append(" offset (? - 1) * ? rows fetch next ? rows only ");

            pstmt = conn.prepareStatement(sql.toString());

            int idx = 1;
            if(!searchWord.isBlank()) {
                pstmt.setString(idx++, searchWord);
                pstmt.setString(idx++, searchWord);
            }
            pstmt.setInt(idx++, nCurrentPage);
            pstmt.setInt(idx++, nSizePerPage);
            pstmt.setInt(idx++, nSizePerPage);

            rs = pstmt.executeQuery();

            while(rs.next()) {
                ReviewDTO dto = new ReviewDTO();

                dto.setReview_id(rs.getLong("review_id"));
                dto.setFk_product_id(rs.getInt("fk_product_id"));
                dto.setFk_member_id(rs.getString("fk_member_id"));

                dto.setReview_title(rs.getString("review_title"));
                dto.setRating(rs.getInt("rating"));
                dto.setReview_content(rs.getString("review_content"));
                dto.setPraise_keywords(rs.getString("praise_keywords"));
                dto.setReview_date(rs.getString("review_date"));

                dto.setProduct_name(rs.getString("product_name"));

                // ✅ JSP는 productCode를 쓰고 있음 → 당장은 product_name을 꽂아준다
                // (실제 제품 코드 컬럼이 생기면 여기만 교체)
                dto.setProductCode(rs.getString("product_name"));

                dto.setWriter(rs.getString("writer"));
                dto.setVerified(rs.getInt("verified"));
                dto.setDate(rs.getString("date_label"));
                dto.setBadge(rs.getString("badge"));

                dto.setCommentCount(rs.getInt("comment_count"));
                dto.setAdminReply(rs.getString("admin_reply"));

                // photo_csv -> photos(List)
                String photoCsv = rs.getString("photo_csv");
                if(photoCsv != null && !photoCsv.trim().isEmpty()) {
                    String[] arr = photoCsv.split(",");
                    dto.setPhotos(Arrays.asList(arr));
                }

                // praise_keywords -> tags(List)
                String pk = rs.getString("praise_keywords");
                if(pk != null && !pk.trim().isEmpty()) {
                    String[] arr = pk.split("\\s*,\\s*");
                    dto.setTags(Arrays.asList(arr));
                }

                list.add(dto);
            }

        } finally {
            close();
        }

        return list;
    }

    // =========================
    // 3) 리뷰 작성 가능한 구매이력(결: 결제완료=1) + 이미 리뷰 작성한 상품 제외
    // =========================
    @Override
    public List<Map<String, String>> selectPurchasesForReview(String userid) throws SQLException {

        List<Map<String, String>> list = new ArrayList<>();

        try {
            conn = ds.getConnection();

            String sql =
                " select od.fk_product_id as product_id, " +
                "        p.product_name, " +
                "        to_char(max(o.odrdate), 'yyyy-mm-dd') as last_order_date, " +
                "        max(o.odrcode) keep (dense_rank last order by o.odrdate) as last_odrcode " +
                "   from tbl_order o " +
                "   join tbl_order_detail od on od.fk_odrcode = o.odrcode " +
                "   join tbl_product p on p.product_id = od.fk_product_id " +
                "  where o.fk_member_id = ? " +
                "    and o.payment_status = 1 " +
                "    and not exists ( " +
                "        select 1 from tbl_product_review r " +
                "         where r.fk_member_id = o.fk_member_id " +
                "           and r.fk_product_id = od.fk_product_id " +
                "    ) " +
                "  group by od.fk_product_id, p.product_name " +
                "  order by max(o.odrdate) desc ";

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userid);

            rs = pstmt.executeQuery();

            while(rs.next()) {
                Map<String, String> m = new HashMap<>();
                m.put("product_id", rs.getString("product_id"));
                m.put("product_name", rs.getString("product_name"));
                m.put("last_order_date", rs.getString("last_order_date"));
                m.put("last_odrcode", rs.getString("last_odrcode"));
                list.add(m);
            }

        } finally {
            close();
        }

        return list;
    }

    // =========================
    // 4) 리뷰 등록
    // =========================
    @Override
    public long getReviewSeqNextVal() throws SQLException {
        long val = 0;
        try {
            conn = ds.getConnection();
            String sql = " select seq_review_id.nextval from dual ";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            rs.next();
            val = rs.getLong(1);
        } finally {
            close();
        }
        return val;
    }

    
    @Override
    public int insertReview(Connection conn, ReviewDTO dto) throws SQLException {

        int result = 0;
        PreparedStatement pstmt = null;

        try {
            String sql =
                " insert into tbl_product_review " +
                " (review_id, fk_product_id, fk_member_id, review_date, rating, review_title, review_content, praise_keywords) " +
                " values (?, ?, ?, sysdate, ?, ?, ?, ?) ";

            pstmt = conn.prepareStatement(sql);

            pstmt.setLong(1, dto.getReview_id());
            pstmt.setInt(2, dto.getFk_product_id());
            pstmt.setString(3, dto.getFk_member_id());
            pstmt.setInt(4, dto.getRating());
            pstmt.setString(5, dto.getReview_title());
            pstmt.setString(6, dto.getReview_content());
            pstmt.setString(7, dto.getPraise_keywords()); // null 가능

            result = pstmt.executeUpdate();

        } finally {
            if(pstmt != null) pstmt.close();
        }

        return result;
    }


    
    
    @Override
    public int insertReviewImage(Connection conn, long review_id, String image_filename) throws SQLException {
        int result = 0;
        PreparedStatement pstmt = null;
        try {
            String sql =
                " insert into tbl_review_image (review_image_id, fk_review_id, image_filename) " +
                " values (seq_review_image_id.nextval, ?, ?) ";
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, review_id);
            pstmt.setString(2, image_filename);
            result = pstmt.executeUpdate();
        } finally {
            if(pstmt != null) pstmt.close();
        }
        return result;
    }

    
    
    
    @Override
    public List<Map<String, Object>> selectMidRankProducts(String sortKey, int limit, String userid) throws SQLException {

        List<Map<String, Object>> list = new ArrayList<>();

        try {
            conn = ds.getConnection();

            String sql;

            switch (sortKey) {

                // 1) 리뷰 많은순
                case "reviewCount":
                    sql =
                        " SELECT p.product_id, p.product_name AS code, p.pimage, " +
                        "        COUNT(r.review_id) AS review_cnt, " +
                        "        NVL(ROUND(AVG(r.rating), 1), 0) AS avg_rating, " +
                        "        TO_CHAR(p.stock_date, 'yyyy-mm-dd') AS stock_date, " +
                        "        (SELECT COUNT(*) FROM tbl_wishlist " +
                        "          WHERE product_id = p.product_id AND member_id = ?) AS is_wish " +
                        " FROM tbl_product p " +
                        " LEFT JOIN tbl_product_review r " +
                        "   ON r.fk_product_id = p.product_id " +
                        " GROUP BY p.product_id, p.product_name, p.pimage, p.stock_date " +
                        " ORDER BY review_cnt DESC, p.product_id DESC " +
                        " FETCH FIRST ? ROWS ONLY ";
                    break;

                // 2) 리뷰 평점순 (리뷰 있는 상품만)
                case "avgRating":
                    sql =
                        " SELECT p.product_id, p.product_name AS code, p.pimage, " +
                        "        COUNT(r.review_id) AS review_cnt, " +
                        "        ROUND(AVG(r.rating), 1) AS avg_rating, " +
                        "        TO_CHAR(p.stock_date, 'yyyy-mm-dd') AS stock_date, " +
                        "        (SELECT COUNT(*) FROM tbl_wishlist " +
                        "          WHERE product_id = p.product_id AND member_id = ?) AS is_wish " +
                        " FROM tbl_product p " +
                        " JOIN tbl_product_review r " +
                        "   ON r.fk_product_id = p.product_id " +
                        " GROUP BY p.product_id, p.product_name, p.pimage, p.stock_date " +
                        " ORDER BY avg_rating DESC, review_cnt DESC, p.product_id DESC " +
                        " FETCH FIRST ? ROWS ONLY ";
                    break;

                // 3) 최근 30일 판매량순 (월간)
                case "recentSales":
                    sql =
                        " SELECT p.product_id, p.product_name AS code, p.pimage, " +
                        "        MAX(o.odrdate) AS last_sale_date, " +
                        "        SUM(od.odrqty) AS sale_qty, " +
                        "        COUNT(r.review_id) AS review_cnt, " +
                        "        NVL(ROUND(AVG(r.rating), 1), 0) AS avg_rating, " +
                        "        TO_CHAR(p.stock_date, 'yyyy-mm-dd') AS stock_date, " +
                        "        (SELECT COUNT(*) FROM tbl_wishlist " +
                        "          WHERE product_id = p.product_id AND member_id = ?) AS is_wish " +
                        " FROM tbl_product p " +
                        " JOIN tbl_order_detail od " +
                        "   ON od.fk_product_id = p.product_id " +
                        " JOIN tbl_order o " +
                        "   ON o.odrcode = od.fk_odrcode " +
                        " LEFT JOIN tbl_product_review r " +
                        "   ON r.fk_product_id = p.product_id " +
                        " WHERE o.payment_status = 1 " +
                        "   AND o.odrdate >= TRUNC(SYSDATE) - 30 " +
                        " GROUP BY p.product_id, p.product_name, p.pimage, p.stock_date " +
                        " ORDER BY SUM(od.odrqty) DESC, MAX(o.odrdate) DESC, p.product_id DESC " +
                        " FETCH FIRST ? ROWS ONLY ";
                    break;

                // 4) 최근 상품순 (입고일 최신)
                case "newProduct":
                    sql =
                        " SELECT p.product_id, p.product_name AS code, p.pimage, " +
                        "        COUNT(r.review_id) AS review_cnt, " +
                        "        NVL(ROUND(AVG(r.rating), 1), 0) AS avg_rating, " +
                        "        TO_CHAR(p.stock_date, 'yyyy-mm-dd') AS stock_date, " +
                        "        (SELECT COUNT(*) FROM tbl_wishlist " +
                        "          WHERE product_id = p.product_id AND member_id = ?) AS is_wish " +
                        " FROM tbl_product p " +
                        " LEFT JOIN tbl_product_review r " +
                        "   ON r.fk_product_id = p.product_id " +
                        " GROUP BY p.product_id, p.product_name, p.pimage, p.stock_date " +
                        " ORDER BY p.stock_date DESC, p.product_id DESC " +
                        " FETCH FIRST ? ROWS ONLY ";
                    break;

                default:
                    throw new SQLException("Unknown sortKey: " + sortKey);
            }

            pstmt = conn.prepareStatement(sql);

            // ✅ userid가 null이어도 바인딩 가능 (is_wish=0으로 나옴)
            pstmt.setString(1, userid);
            pstmt.setInt(2, limit);

            rs = pstmt.executeQuery();

            while (rs.next()) {
                Map<String, Object> m = new HashMap<>();

                m.put("productId", rs.getLong("product_id"));
                m.put("code", rs.getString("code"));
                m.put("pimage", rs.getString("pimage"));

                m.put("count", rs.getInt("review_cnt"));
                m.put("rating", rs.getDouble("avg_rating"));
                m.put("stockDate", rs.getString("stock_date"));
                m.put("isWish", rs.getInt("is_wish"));

                if ("recentSales".equals(sortKey)) {
                    m.put("salesQty", rs.getInt("sale_qty"));
                }

                list.add(m);
            }

        } finally {
            close();
        }

        return list;
    }


    
    
    @Override
    public ReviewDTO selectReviewOne(long reviewId) throws SQLException {

        ReviewDTO dto = null;

        try {
            conn = ds.getConnection();

            String sql =
                " select review_id, fk_product_id, fk_member_id, rating, review_title, review_content, praise_keywords, " +
                "        to_char(review_date,'yyyy-mm-dd') as review_date " +
                "   from tbl_product_review " +
                "  where review_id = ? ";

            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, reviewId);

            rs = pstmt.executeQuery();
            if(rs.next()) {
                dto = new ReviewDTO();
                dto.setReview_id(rs.getLong("review_id"));
                dto.setFk_product_id(rs.getInt("fk_product_id"));
                dto.setFk_member_id(rs.getString("fk_member_id"));
                dto.setRating(rs.getInt("rating"));
                dto.setReview_title(rs.getString("review_title"));
                dto.setReview_content(rs.getString("review_content"));
                dto.setPraise_keywords(rs.getString("praise_keywords"));
                dto.setReview_date(rs.getString("review_date"));
            }

        } finally {
            close();
        }

        return dto;
    }
    
    @Override
    public List<String> selectReviewImageFilenames(Connection conn, long reviewId) throws SQLException {

        List<String> list = new ArrayList<>();
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            String sql =
                " select image_filename " +
                "   from tbl_review_image " +
                "  where fk_review_id = ? " +
                "  order by review_image_id ";

            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, reviewId);

            rs = pstmt.executeQuery();
            while(rs.next()) {
                list.add(rs.getString("image_filename"));
            }

        } finally {
            if(rs != null) rs.close();
            if(pstmt != null) pstmt.close();
        }

        return list;
    }
    
    @Override
    public int deleteReviewComments(Connection conn, long reviewId) throws SQLException {

        PreparedStatement pstmt = null;
        try {
            String sql = " delete from tbl_review_comment where fk_review_id = ? ";
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, reviewId);
            return pstmt.executeUpdate();
        } finally {
            if(pstmt != null) pstmt.close();
        }
    }

    @Override
    public int deleteReviewImages(Connection conn, long reviewId) throws SQLException {

        PreparedStatement pstmt = null;
        try {
            String sql = " delete from tbl_review_image where fk_review_id = ? ";
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, reviewId);
            return pstmt.executeUpdate();
        } finally {
            if(pstmt != null) pstmt.close();
        }
    }
    
    @Override
    public int deleteReview(Connection conn, long reviewId) throws SQLException {

        PreparedStatement pstmt = null;
        try {
            String sql = " delete from tbl_product_review where review_id = ? ";
            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, reviewId);
            return pstmt.executeUpdate();
        } finally {
            if(pstmt != null) pstmt.close();
        }
    }
    
    @Override
    public ReviewDTO selectReviewDetail(long reviewId) throws SQLException {

        ReviewDTO dto = null;

        try {
            conn = ds.getConnection();

            String sql =
                " select "
              + "   r.review_id, r.fk_product_id, r.fk_member_id, "
              + "   r.review_title, r.rating, r.review_content, r.praise_keywords, "
              + "   to_char(r.review_date,'yyyy-mm-dd') as review_date, "
              + "   p.product_name, "
              + "   p.pimage, "   // ✅ 추가 (상품 이미지 파일명)
              + "   substr(m.name,1,1) || '**' as writer, "
              + "   case when exists ( "
              + "       select 1 "
              + "         from tbl_order o join tbl_order_detail d "
              + "           on o.odrcode = d.fk_odrcode "
              + "        where o.fk_member_id = r.fk_member_id "
              + "          and d.fk_product_id = r.fk_product_id "
              + "          and o.payment_status = 1 "
              + "   ) then 1 else 0 end as verified, "
              + "   c.comment_content as admin_reply, "
              + "   (select listagg(ri.image_filename, ',') within group(order by ri.review_image_id) "
              + "      from tbl_review_image ri "
              + "     where ri.fk_review_id = r.review_id "
              + "   ) as photo_csv "
              + " from tbl_product_review r "
              + " join tbl_product p on p.product_id = r.fk_product_id "
              + " join tbl_member  m on m.member_id = r.fk_member_id "
              + " left join tbl_review_comment c "
              + "   on c.fk_review_id = r.review_id and c.status = 1 "
              + " where r.review_id = ? ";

            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, reviewId);

            rs = pstmt.executeQuery();

            if (rs.next()) {
                dto = new ReviewDTO();

                dto.setReview_id(rs.getLong("review_id"));
                dto.setFk_product_id(rs.getInt("fk_product_id"));
                dto.setFk_member_id(rs.getString("fk_member_id"));

                dto.setReview_title(rs.getString("review_title"));
                dto.setRating(rs.getInt("rating"));
                dto.setReview_content(rs.getString("review_content"));
                dto.setPraise_keywords(rs.getString("praise_keywords"));
                dto.setReview_date(rs.getString("review_date"));

                dto.setProduct_name(rs.getString("product_name"));
                dto.setProductCode(rs.getString("product_name"));

                dto.setPimage(rs.getString("pimage")); // ✅ 추가

                dto.setWriter(rs.getString("writer"));
                dto.setVerified(rs.getInt("verified"));

                dto.setAdminReply(rs.getString("admin_reply"));

                // photos
                String photoCsv = rs.getString("photo_csv");
                if (photoCsv != null && !photoCsv.trim().isEmpty()) {
                    dto.setPhotos(java.util.Arrays.asList(photoCsv.split("\\s*,\\s*")));
                }

                // tags
                String pk = rs.getString("praise_keywords");
                if (pk != null && !pk.trim().isEmpty()) {
                    dto.setTags(java.util.Arrays.asList(pk.split("\\s*,\\s*")));
                }
            }

        } finally {
            close();
        }

        return dto;
    }



    // 마이페이지 최근 리뷰 n개 조회
    @Override
    public List<ReviewDTO> selectMyRecentReviews(String userid, int limit) throws SQLException {

        List<ReviewDTO> list = new ArrayList<>();

        try {
            conn = ds.getConnection();

            String sql =
                " select r.review_id, " +
                "        to_char(r.review_date,'yyyy-mm-dd') as review_date, " +
                "        r.review_title, r.rating, " +
                "        p.product_name, " +
                "        case when c.review_comment_id is not null then 1 else 0 end as comment_count " +
                "   from tbl_product_review r " +
                "   join tbl_product p on p.product_id = r.fk_product_id " +
                "   left join tbl_review_comment c " +
                "     on c.fk_review_id = r.review_id and c.status = 1 " +
                "  where r.fk_member_id = ? " +
                "  order by r.review_date desc, r.review_id desc " +
                "  fetch first ? rows only ";

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, userid);
            pstmt.setInt(2, limit);

            rs = pstmt.executeQuery();

            while (rs.next()) {
                ReviewDTO dto = new ReviewDTO();

                dto.setReview_id(rs.getLong("review_id"));
                dto.setReview_date(rs.getString("review_date"));
                dto.setReview_title(rs.getString("review_title"));
                dto.setRating(rs.getInt("rating"));
                dto.setProduct_name(rs.getString("product_name"));

                // ✅ 답변 여부(1=완료, 0=대기)
                dto.setCommentCount(rs.getInt("comment_count"));

                list.add(dto);
            }

        } finally {
            close();
        }

        return list;
    }


    // 내 리뷰 전체보기 - 총 개수
    @Override
    public int getTotalMyReviewCount(Map<String, String> paraMap) throws SQLException {

        int totalCount = 0;

        String userid = paraMap.get("userid");
        String searchWord = paraMap.get("searchWord");

        if(searchWord == null) searchWord = "";
        searchWord = searchWord.trim();

        try {
            conn = ds.getConnection();

            StringBuilder sql = new StringBuilder();
            sql.append(" select count(*) ")
               .append(" from tbl_product_review r ")
               .append(" where r.fk_member_id = ? ");

            if(!searchWord.isBlank()) {
                sql.append(" and ( lower(r.review_title) like '%'||lower(?)||'%' ")
                   .append("    or lower(r.review_content) like '%'||lower(?)||'%' ) ");
            }

            pstmt = conn.prepareStatement(sql.toString());

            int idx = 1;
            pstmt.setString(idx++, userid);

            if(!searchWord.isBlank()) {
                pstmt.setString(idx++, searchWord);
                pstmt.setString(idx++, searchWord);
            }

            rs = pstmt.executeQuery();
            rs.next();
            totalCount = rs.getInt(1);

        } finally {
            close();
        }

        return totalCount;
    }
    
    
    
    // 내 리뷰 전체보기 - 페이징 목록
    @Override
    public List<ReviewDTO> selectMyReviewListPaging(Map<String, String> paraMap) throws SQLException {

        List<ReviewDTO> list = new ArrayList<>();

        String userid = paraMap.get("userid");
        String sort = paraMap.get("sort"); // recent | rating
        String searchWord = paraMap.get("searchWord");
        String currentShowPageNo = paraMap.get("currentShowPageNo");
        String sizePerPage = paraMap.get("sizePerPage");

        if(sort == null || sort.isBlank()) sort = "recent";
        if(searchWord == null) searchWord = "";
        searchWord = searchWord.trim();

        if(currentShowPageNo == null || currentShowPageNo.isBlank()) currentShowPageNo = "1";
        if(sizePerPage == null || sizePerPage.isBlank()) sizePerPage = "10";

        int nCurrentPage = Integer.parseInt(currentShowPageNo);
        int nSizePerPage = Integer.parseInt(sizePerPage);

        String orderBy =
            "rating".equalsIgnoreCase(sort)
            ? " order by r.rating desc, r.review_date desc, r.review_id desc "
            : " order by r.review_date desc, r.review_id desc ";

        try {
            conn = ds.getConnection();

            StringBuilder sql = new StringBuilder();
            sql.append(" select ")
               .append("   r.review_id, ")
               .append("   to_char(r.review_date,'yyyy-mm-dd') as review_date, ")
               .append("   r.review_title, ")
               .append("   r.rating, ")
               .append("   p.product_name, ")
               .append("   case when c.review_comment_id is not null then 1 else 0 end as comment_count ")
               .append(" from tbl_product_review r ")
               .append(" join tbl_product p on p.product_id = r.fk_product_id ")
               .append(" left join tbl_review_comment c ")
               .append("   on c.fk_review_id = r.review_id and c.status = 1 ")
               .append(" where r.fk_member_id = ? ");

            if(!searchWord.isBlank()) {
                sql.append(" and ( lower(r.review_title) like '%'||lower(?)||'%' ")
                   .append("    or lower(r.review_content) like '%'||lower(?)||'%' ) ");
            }

            sql.append(orderBy);
            sql.append(" offset (? - 1) * ? rows fetch next ? rows only ");

            pstmt = conn.prepareStatement(sql.toString());

            int idx = 1;
            pstmt.setString(idx++, userid);

            if(!searchWord.isBlank()) {
                pstmt.setString(idx++, searchWord);
                pstmt.setString(idx++, searchWord);
            }

            pstmt.setInt(idx++, nCurrentPage);
            pstmt.setInt(idx++, nSizePerPage);
            pstmt.setInt(idx++, nSizePerPage);

            rs = pstmt.executeQuery();

            while(rs.next()) {
                ReviewDTO dto = new ReviewDTO();
                dto.setReview_id(rs.getLong("review_id"));
                dto.setReview_date(rs.getString("review_date"));
                dto.setReview_title(rs.getString("review_title"));
                dto.setRating(rs.getInt("rating"));
                dto.setProduct_name(rs.getString("product_name"));
                dto.setCommentCount(rs.getInt("comment_count"));
                list.add(dto);
            }

        } finally {
            close();
        }

        return list;
    }


    // 관리자 리뷰 댓글달기 (update + insert)
    @Override
    public int upsertReviewComment(long reviewId, String adminId, String commentContent) throws SQLException {

        int result = 0;

        try {
            conn = ds.getConnection();

            // 1) 해당 리뷰에 status=1 댓글이 이미 있는지 확인
            String sqlCheck =
                " select count(*) " +
                "   from tbl_review_comment " +
                "  where fk_review_id = ? and status = 1 ";

            pstmt = conn.prepareStatement(sqlCheck);
            pstmt.setLong(1, reviewId);
            rs = pstmt.executeQuery();
            rs.next();

            int cnt = rs.getInt(1);

            rs.close(); rs = null;
            pstmt.close(); pstmt = null;

            if(cnt > 0) {
                // 2-A) 있으면 update (내용 + 관리자ID 갱신)
                String sqlUpdate =
                    " update tbl_review_comment " +
                    "    set comment_content = ?, " +
                    "        fk_admin_id = ? " +
                    "  where fk_review_id = ? and status = 1 ";

                pstmt = conn.prepareStatement(sqlUpdate);
                pstmt.setString(1, commentContent);
                pstmt.setString(2, adminId);
                pstmt.setLong(3, reviewId);

                result = pstmt.executeUpdate();
            }
            else {
                // 2-B) 없으면 insert (FK_ADMIN_ID 반드시 포함!!)
                String sqlInsert =
                    " insert into tbl_review_comment " +
                    " (review_comment_id, fk_review_id, fk_admin_id, comment_content, status) " +
                    " values (seq_review_comment_id.nextval, ?, ?, ?, 1) ";

                pstmt = conn.prepareStatement(sqlInsert);
                pstmt.setLong(1, reviewId);
                pstmt.setString(2, adminId);
                pstmt.setString(3, commentContent);

                result = pstmt.executeUpdate();
            }

        } finally {
            close();
        }

        return (result >= 1 ? 1 : 0);
    }
    
    
    // 제품 상세 페이지 리뷰 불러오기
 // 제품 상세 페이지 리뷰 불러오기
    @Override
    public List<ReviewDTO> getReviewsByProductId(String product_id) throws SQLException {

        List<ReviewDTO> list = new ArrayList<>();

        try {
            conn = ds.getConnection();

            String sql =
                " SELECT r.review_id, r.fk_product_id, r.fk_member_id, " +
                "        r.rating, r.review_title, r.review_content, " +
                "        r.praise_keywords, r.review_date, " +
                "        p.pimage, p.product_name " +
                " FROM tbl_product_review r " +
                " JOIN tbl_product p " +
                "   ON p.product_id = r.fk_product_id " +
                " WHERE r.fk_product_id = ? " +
                " ORDER BY r.review_date DESC ";

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, product_id);

            rs = pstmt.executeQuery();

            while (rs.next()) {
                ReviewDTO dto = new ReviewDTO();

                dto.setReview_id(rs.getLong("review_id"));
                dto.setFk_product_id(rs.getInt("fk_product_id"));
                dto.setFk_member_id(rs.getString("fk_member_id"));
                dto.setRating(rs.getInt("rating"));
                dto.setReview_title(rs.getString("review_title"));
                dto.setReview_content(rs.getString("review_content"));
                dto.setPraise_keywords(rs.getString("praise_keywords"));
                dto.setReview_date(rs.getString("review_date"));

                // ✅ 상품 JOIN에서 가져온 값
                dto.setPimage(rs.getString("pimage"));
                dto.setProduct_name(rs.getString("product_name"));

                list.add(dto);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if(rs != null) rs.close(); } catch(Exception e) {}
            try { if(pstmt != null) pstmt.close(); } catch(Exception e) {}
            try { if(conn != null) conn.close(); } catch(Exception e) {}
        }

        return list;
    }

    
    
    // 리뷰 신고(인서트)
    @Override
    public int insertReviewReport(long review_id, String member_id, String reportContent) throws SQLException {

        int n = 0;

        try {
            conn = ds.getConnection();

            String sql =
                " insert into tbl_review_report(report_id, fk_review_id, fk_member_id, report_content, report_date) "
              + " values(seq_review_report.nextval, ?, ?, ?, sysdate) ";

            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, review_id);
            pstmt.setString(2, member_id);
            pstmt.setString(3, reportContent);

            n = pstmt.executeUpdate();

        } finally {
            close();
        }

        return n;
    }
    
    
    
    // 신고목록조회 
    @Override
    public List<Map<String, String>> selectReviewReports(long review_id) throws SQLException {

        List<Map<String, String>> list = new ArrayList<>();

        try {
            conn = ds.getConnection();

            String sql =
                " select m.name as reporter_name, "
              + "        rr.report_content, "
              + "        to_char(rr.report_date,'yyyy-mm-dd hh24:mi') as report_date "
              + "   from tbl_review_report rr "
              + "   join tbl_member m "
              + "     on rr.fk_member_id = m.member_id "
              + "  where rr.fk_review_id = ? "
              + "  order by rr.report_date desc ";

            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, review_id);
            rs = pstmt.executeQuery();

            while(rs.next()) {
                Map<String, String> map = new HashMap<>();
                map.put("reporter_name", rs.getString("reporter_name"));
                map.put("report_content", rs.getString("report_content"));
                map.put("report_date", rs.getString("report_date"));
                list.add(map);
            }

        } finally {
            close();
        }

        return list;
    }
    
    
    // 미답변 총 개수
    @Override
    public int getTotalUnansweredReviewCount() throws Exception {

        int totalCount = 0;

        try {
            conn = ds.getConnection();

            String sql =
                " select count(*) "
              + "   from tbl_product_review r "
              + "  where not exists ( "
              + "        select 1 "
              + "          from tbl_review_comment c "
              + "         where c.fk_review_id = r.review_id "
              + "           and c.status = 1 "
              + "  ) ";

            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            if(rs.next()) totalCount = rs.getInt(1);

        } finally {
            close();
        }

        return totalCount;
    }
    
    
    // 미답변 페이징 목록
    @Override
    public List<ReviewDTO> selectUnansweredReviewPaging(Map<String, String> paraMap) throws Exception {

        List<ReviewDTO> list = new ArrayList<>();

        int currentShowPageNo = Integer.parseInt(paraMap.get("currentShowPageNo"));
        int sizePerPage = Integer.parseInt(paraMap.get("sizePerPage"));

        int startRno = (currentShowPageNo - 1) * sizePerPage + 1;
        int endRno   = startRno + sizePerPage - 1;

        try {
            conn = ds.getConnection();

            String sql =
                " select * "
              + "   from ( "
              + "         select row_number() over(order by r.review_date desc) as rno, "
              + "                r.review_id, r.fk_product_id, p.product_name, "
              + "                r.fk_member_id, to_char(r.review_date,'yyyy-mm-dd') as review_date, "
              + "                r.rating, substr(m.name,1,1) || '**' as writer, "
              + "                r.review_content "
              + "           from tbl_product_review r "
              + "           join tbl_product p on r.fk_product_id = p.product_id "
              + "           join tbl_member  m on r.fk_member_id = m.member_id "
              + "          where not exists ( "
              + "                select 1 "
              + "                  from tbl_review_comment c "
              + "                 where c.fk_review_id = r.review_id "
              + "                   and c.status = 1 "
              + "          ) "
              + "        ) "
              + "  where rno between ? and ? ";

            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, startRno);
            pstmt.setInt(2, endRno);

            rs = pstmt.executeQuery();

            while(rs.next()) {
                ReviewDTO dto = new ReviewDTO();
                dto.setReview_id(rs.getLong("review_id"));
                dto.setFk_product_id(rs.getInt("fk_product_id"));
                dto.setProduct_name(rs.getString("product_name"));
                dto.setFk_member_id(rs.getString("fk_member_id"));
                dto.setReview_date(rs.getString("review_date"));
                dto.setRating(rs.getInt("rating"));
                dto.setWriter(rs.getString("writer"));
                dto.setReview_content(rs.getString("review_content"));
                list.add(dto);
            }

        } finally {
            close();
        }

        return list;
    }
    
    
    // 신고된 리뷰 총 개수 (리뷰 단위로 중복 제거)
    @Override
    public int getTotalReportedReviewCount() throws Exception {

        int totalCount = 0;

        try {
            conn = ds.getConnection();

            String sql =
                " select count(*) "
              + "   from ( "
              + "         select fk_review_id "
              + "           from tbl_review_report "
              + "          group by fk_review_id "
              + "        ) ";

            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            if(rs.next()) totalCount = rs.getInt(1);

        } finally {
            close();
        }

        return totalCount;
    }
    
    
    // 신고된 리뷰 페이징 목록 (최근 신고일 기준 정렬)
    @Override
    public List<Map<String, String>> selectReportedReviewPaging(Map<String, String> paraMap) throws Exception {

        List<Map<String, String>> list = new ArrayList<>();

        int currentShowPageNo = Integer.parseInt(paraMap.get("currentShowPageNo"));
        int sizePerPage = Integer.parseInt(paraMap.get("sizePerPage"));

        int startRno = (currentShowPageNo - 1) * sizePerPage + 1;
        int endRno   = startRno + sizePerPage - 1;

        try {
            conn = ds.getConnection();

            String sql =
                " select * "
              + "   from ( "
              + "         select row_number() over(order by x.last_report_date desc) as rno, "
              + "                r.review_id, "
              + "                p.product_name, "
              + "                substr(m.name,1,1) || '**' as writer, "
              + "                to_char(r.review_date,'yyyy-mm-dd') as review_date, "
              + "                to_char(x.last_report_date,'yyyy-mm-dd hh24:mi') as last_report_date, "
              + "                x.report_count "
              + "           from tbl_product_review r "
              + "           join ( "
              + "                 select fk_review_id, "
              + "                        max(report_date) as last_report_date, "
              + "                        count(*) as report_count "
              + "                   from tbl_review_report "
              + "                  group by fk_review_id "
              + "           ) x on r.review_id = x.fk_review_id "
              + "           join tbl_product p on r.fk_product_id = p.product_id "
              + "           join tbl_member  m on r.fk_member_id = m.member_id "
              + "        ) "
              + "  where rno between ? and ? ";

            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, startRno);
            pstmt.setInt(2, endRno);

            rs = pstmt.executeQuery();

            while(rs.next()) {
                Map<String, String> map = new HashMap<>();
                map.put("review_id", String.valueOf(rs.getLong("review_id")));
                map.put("product_name", rs.getString("product_name"));
                map.put("writer", rs.getString("writer"));
                map.put("review_date", rs.getString("review_date"));
                map.put("last_report_date", rs.getString("last_report_date"));
                map.put("report_count", String.valueOf(rs.getInt("report_count")));
                list.add(map);
            }

        } finally {
            close();
        }

        return list;
    }





    



}
