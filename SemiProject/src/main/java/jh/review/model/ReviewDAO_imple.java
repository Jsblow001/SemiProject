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
    public List<Map<String, Object>> selectMidRankProducts(String sortKey, int limit) throws SQLException {

        List<Map<String, Object>> list = new ArrayList<>();

        try {
            conn = ds.getConnection();

            String sql;

            switch (sortKey) {

                // 1) 리뷰 많은순
                case "reviewCount":
                    sql =
                        " SELECT p.product_id, p.product_name AS code, " +
                        "        COUNT(r.review_id) AS review_cnt, " +
                        "        NVL(ROUND(AVG(r.rating), 1), 0) AS avg_rating, " +
                        "        TO_CHAR(p.stock_date, 'yyyy-mm-dd') AS stock_date " +
                        " FROM tbl_product p " +
                        " LEFT JOIN tbl_product_review r " +
                        "   ON r.fk_product_id = p.product_id " +
                        " GROUP BY p.product_id, p.product_name, p.stock_date " +
                        " ORDER BY review_cnt DESC, p.product_id DESC " +
                        " FETCH FIRST ? ROWS ONLY ";
                    break;

                // 2) 리뷰 평점순 (리뷰 있는 상품만)
                case "avgRating":
                    sql =
                        " SELECT p.product_id, p.product_name AS code, " +
                        "        COUNT(r.review_id) AS review_cnt, " +
                        "        ROUND(AVG(r.rating), 1) AS avg_rating, " +
                        "        TO_CHAR(p.stock_date, 'yyyy-mm-dd') AS stock_date " +
                        " FROM tbl_product p " +
                        " JOIN tbl_product_review r " +
                        "   ON r.fk_product_id = p.product_id " +
                        " GROUP BY p.product_id, p.product_name, p.stock_date " +
                        " ORDER BY avg_rating DESC, review_cnt DESC, p.product_id DESC " +
                        " FETCH FIRST ? ROWS ONLY ";
                    break;

                // 3) 최근 판매량순 (최근 주문일 큰 순 → 그 다음 판매수량)
                case "recentSales":
                    sql =
                        " SELECT p.product_id, p.product_name AS code, " +
                        "        MAX(o.odrdate) AS last_sale_date, " +
                        "        SUM(od.odrqty) AS sale_qty, " +
                        "        COUNT(r.review_id) AS review_cnt, " +
                        "        NVL(ROUND(AVG(r.rating), 1), 0) AS avg_rating, " +
                        "        TO_CHAR(p.stock_date, 'yyyy-mm-dd') AS stock_date " +
                        " FROM tbl_product p " +
                        " JOIN tbl_order_detail od " +
                        "   ON od.fk_product_id = p.product_id " +
                        " JOIN tbl_order o " +
                        "   ON o.odrcode = od.fk_odrcode " +
                        " LEFT JOIN tbl_product_review r " +
                        "   ON r.fk_product_id = p.product_id " +
                        " WHERE o.payment_status = 1 " +   // ✅ A안: 결제완료만 집계 (JOIN 뒤에!)
                        " GROUP BY p.product_id, p.product_name, p.stock_date " +
                        " ORDER BY MAX(o.odrdate) DESC, SUM(od.odrqty) DESC, p.product_id DESC " +
                        " FETCH FIRST ? ROWS ONLY ";
                    break;




                // 4) 최근 상품순 (입고일 최신)
                case "newProduct":
                    sql =
                        " SELECT p.product_id, p.product_name AS code, " +
                        "        COUNT(r.review_id) AS review_cnt, " +
                        "        NVL(ROUND(AVG(r.rating), 1), 0) AS avg_rating, " +
                        "        TO_CHAR(p.stock_date, 'yyyy-mm-dd') AS stock_date " +
                        " FROM tbl_product p " +
                        " LEFT JOIN tbl_product_review r " +
                        "   ON r.fk_product_id = p.product_id " +
                        " GROUP BY p.product_id, p.product_name, p.stock_date " +
                        " ORDER BY p.stock_date DESC, p.product_id DESC " +
                        " FETCH FIRST ? ROWS ONLY ";
                    break;

                default:
                    throw new SQLException("Unknown sortKey: " + sortKey);
            }

            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, limit);

            rs = pstmt.executeQuery();

            while (rs.next()) {
                Map<String, Object> m = new HashMap<>();

                m.put("productId", rs.getLong("product_id"));
                m.put("code", rs.getString("code"));

                // 이미지 컬럼이 DB에 없으니 일단 기본값(또는 null)로
                m.put("main", "img/product/default.png");

                // 공통
                m.put("count", rs.getInt("review_cnt"));
                m.put("rating", rs.getDouble("avg_rating"));
                m.put("stockDate", rs.getString("stock_date"));

                // recentSales 전용
                if ("recentSales".equals(sortKey)) {
                    m.put("salesQty", rs.getInt("sale_qty"));
                }

                list.add(m);
            }

        } finally {
            close(); // 너 프로젝트에서 쓰는 자원반납 메서드
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

            if(rs.next()) {
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

                dto.setWriter(rs.getString("writer"));
                dto.setVerified(rs.getInt("verified"));

                dto.setAdminReply(rs.getString("admin_reply"));

                // photos (전체)
                String photoCsv = rs.getString("photo_csv");
                if(photoCsv != null && !photoCsv.trim().isEmpty()) {
                    dto.setPhotos(java.util.Arrays.asList(photoCsv.split(",")));
                }

                // tags
                String pk = rs.getString("praise_keywords");
                if(pk != null && !pk.trim().isEmpty()) {
                    dto.setTags(java.util.Arrays.asList(pk.split("\\s*,\\s*")));
                }
            }

        } finally {
            close();
        }

        return dto;
    }






}
