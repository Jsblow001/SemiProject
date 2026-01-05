package js.admin.revenue.model;

import java.sql.*;
import java.util.*;
import javax.naming.*;
import javax.sql.DataSource;

public class RevenueDAO_imple implements RevenueDAO {

    private DataSource ds;
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;

    public RevenueDAO_imple() {
        try {
            Context initContext = new InitialContext();
            Context envContext = (Context) initContext.lookup("java:/comp/env");
            ds = (DataSource) envContext.lookup("SemiProject"); 
        } catch (NamingException e) {
            e.printStackTrace();
        }
    }

    private void close() {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    @Override
    public List<Map<String, Object>> getWeeklyRevenue() {
        List<Map<String, Object>> list = new ArrayList<>();
        try {
            conn = ds.getConnection();
         // 주간 수익: 날짜를 문자열로 뽑되, 정렬은 원본 날짜(odrdate)의 최소값순으로!
            String sql = " SELECT TO_CHAR(odrdate, 'MM/DD') AS label, SUM(odrtotalprice) AS value " +
                         " FROM tbl_order " +
                         " WHERE odrdate >= TRUNC(SYSDATE) - 6 AND payment_status = 1 " +
                         " GROUP BY TO_CHAR(odrdate, 'MM/DD') " +
                         " ORDER BY MIN(odrdate) ASC "; // 이 부분이 핵심입니다.
                         
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("label", rs.getString("label"));
                map.put("value", rs.getLong("value"));
                list.add(map);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally { close(); }
        return list;
    }

    @Override
    public List<Map<String, Object>> getMonthlyRevenue() {
        List<Map<String, Object>> list = new ArrayList<>();
        try {
            conn = ds.getConnection();
            // 최근 5주(약 35일) 동안의 데이터를 보여주도록 변경
            String sql = " SELECT TO_CHAR(TRUNC(odrdate, 'IW'), 'MM\"월 \"W\"주차\"') AS label, SUM(odrtotalprice) AS value " +
                         " FROM tbl_order " +
                         " WHERE odrdate >= TRUNC(SYSDATE) - 35 AND payment_status = 1 " + // 이번 달 한정이 아닌 최근 5주로 확대
                         " GROUP BY TO_CHAR(TRUNC(odrdate, 'IW'), 'MM\"월 \"W\"주차\"') " +
                         " ORDER BY MIN(odrdate) ASC ";
                         
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("label", rs.getString("label"));
                map.put("value", rs.getLong("value"));
                list.add(map);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally { close(); }
        return list;
    }
    
    @Override
    public String getBestSellerName() {
        String bestSeller = "데이터 없음";
        
        try {
            conn = ds.getConnection();
            
            // 실제 테이블 컬럼명(PRODUCT_NAME, FK_PRODUCT_ID, PRODUCT_ID, ODRQTY)을 반영한 쿼리
            String sql = " SELECT product_name " +
                         " FROM ( " +
                         "     SELECT P.product_name, SUM(D.odrqty) AS total_qty " +
                         "     FROM tbl_order_detail D JOIN tbl_product P " +
                         "     ON D.fk_product_id = P.product_id " + // 조인 조건 수정
                         "     GROUP BY P.product_name " +
                         "     ORDER BY total_qty DESC " +
                         " ) WHERE ROWNUM = 1 ";
            
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            if (rs.next()) {
                bestSeller = rs.getString("product_name");
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            close(); // 자원 반납
        }
        
        return bestSeller;
    }
}