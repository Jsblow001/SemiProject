package hk.order.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import hk.order.domain.OrderDTO;
import hk.order.domain.OrderDetailDTO;

public class OrderDAO_imple implements OrderDAO {

	// 필드 선언
    private DataSource ds;
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;

    // 생성자 : DataSource 연결 
    public OrderDAO_imple() {
        try {
            Context initContext = new InitialContext();
            Context envContext = (Context) initContext.lookup("java:/comp/env");
            ds = (DataSource) envContext.lookup("SemiProject");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    // 자원 반납
    private void close() {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }

    // ==================================================
    // 1. 마이페이지 주문 목록 (페이징)
    // ==================================================
    @Override
    public List<OrderDTO> selectMyOrderList(
            String memberId,
            String status,
            String startDate,
            String endDate,
            int startRow,
            int endRow) throws SQLException {

        List<OrderDTO> list = new ArrayList<>();

        try {
            conn = ds.getConnection();

            String sql =
                " SELECT * FROM ( " +
                "   SELECT ROWNUM AS rno, A.* FROM ( " +
                "     SELECT o.odrcode, o.odrdate, o.odrtotalprice, o.payment_status, " +
                "            MIN(p.product_name) AS product_name, " +
                "            SUM(d.odrqty) AS total_qty, " +
                "            CASE o.payment_status " +
                "              WHEN 0 THEN '결제대기' " +
                "              WHEN 1 THEN '결제완료' " +
                "              WHEN 2 THEN '결제취소' " +
                "            END AS payment_status_name " +
                "     FROM tbl_order o " +
                "     JOIN tbl_order_detail d ON o.odrcode = d.fk_odrcode " +
                "     JOIN tbl_product p ON d.fk_product_id = p.product_id " +
                "     WHERE o.fk_member_id = ? ";

            // 상태 조건 (공백 방어)
            if (status != null && !status.trim().isEmpty()) {
                sql += " AND o.payment_status = ? ";
            }

            // 기간 조건
            if (startDate != null && !startDate.trim().isEmpty()) {
                sql += " AND o.odrdate >= TO_DATE(?, 'YYYY-MM-DD') ";
            }

            if (endDate != null && !endDate.trim().isEmpty()) {
                sql += " AND o.odrdate < TO_DATE(?, 'YYYY-MM-DD') + 1 ";
            }

            /* ===== GROUP BY + ORDER BY ===== */
            sql +=
                " GROUP BY o.odrcode, o.odrdate, o.odrtotalprice, o.payment_status " +
                " ORDER BY o.odrdate DESC " +
                "   ) A " +
                " ) WHERE rno BETWEEN ? AND ? ";

            pstmt = conn.prepareStatement(sql);

            int idx = 1;

            // 회원 아이디
            pstmt.setString(idx++, memberId);

            // 상태
            if (status != null && !status.trim().isEmpty()) {
                pstmt.setInt(idx++, Integer.parseInt(status.trim()));
            }

            // 시작일
            if (startDate != null && !startDate.trim().isEmpty()) {
                pstmt.setString(idx++, startDate.trim());
            }

            // 종료일
            if (endDate != null && !endDate.trim().isEmpty()) {
                pstmt.setString(idx++, endDate.trim());
            }

            // 페이징
            pstmt.setInt(idx++, startRow);
            pstmt.setInt(idx++, endRow);

            rs = pstmt.executeQuery();

            while (rs.next()) {
                OrderDTO dto = new OrderDTO();
                dto.setOdrCode(rs.getInt("odrcode"));
                dto.setOdrDate(rs.getDate("odrdate"));
                dto.setOdrTotalPrice(rs.getInt("odrtotalprice"));
                dto.setPaymentStatus(rs.getInt("payment_status"));
                dto.setPaymentStatusName(rs.getString("payment_status_name"));
                dto.setProductName(rs.getString("product_name"));
                dto.setTotalQty(rs.getInt("total_qty"));
                list.add(dto);
            }

        } finally {
            close();
        }

        return list;
    }

    // ==================================================
    // 2. 주문 총 건수 (페이지바용)
    // ==================================================
    @Override
    public int getOrderTotalCount(
            String userid,
            String status,
            String startDate,
            String endDate) throws SQLException {

        int count = 0;

        try {
            conn = ds.getConnection();

            String sql =
                " SELECT COUNT(DISTINCT o.odrcode) " +
                " FROM tbl_order o " +
                " WHERE o.fk_member_id = ? ";

            // 상태 조건 (공백 방어)
            if (status != null && !status.trim().isEmpty()) {
                sql += " AND o.payment_status = ? ";
            }

            // 기간 조건
            if (startDate != null && !startDate.trim().isEmpty()) {
                sql += " AND o.odrdate >= TO_DATE(?, 'YYYY-MM-DD') ";
            }

            if (endDate != null && !endDate.trim().isEmpty()) {
                sql += " AND o.odrdate < TO_DATE(?, 'YYYY-MM-DD') + 1 ";
            }

            pstmt = conn.prepareStatement(sql);

            int idx = 1;
            pstmt.setString(idx++, userid);

            if (status != null && !status.trim().isEmpty()) {
                pstmt.setInt(idx++, Integer.parseInt(status.trim()));
            }

            if (startDate != null && !startDate.trim().isEmpty()) {
                pstmt.setString(idx++, startDate.trim());
            }

            if (endDate != null && !endDate.trim().isEmpty()) {
                pstmt.setString(idx++, endDate.trim());
            }

            rs = pstmt.executeQuery();

            if (rs.next()) {
                count = rs.getInt(1);
            }

        } finally {
            close();
        }

        return count;
    }

    // ==================================================
    // 3. 주문 상세 조회 (주문번호 기준) + 이미지 추가
    // ==================================================
    @Override
    public List<OrderDetailDTO> selectOrderDetail(int odrCode) {

        List<OrderDetailDTO> list = new ArrayList<>();

        try {
            conn = ds.getConnection();

            String sql =
                " SELECT d.odrdetailno, d.odrqty, d.odrprice, " +
                "        d.deliverystatus, d.deliverydate, " +
                "        p.product_name, " +
                "        p.pimage,        " +
                "        CASE d.deliverystatus " +
                "            WHEN 0 THEN '배송준비중' " +
                "            WHEN 1 THEN '배송중' " +
                "            WHEN 2 THEN '배송완료' " +
                "        END AS delivery_status_name " +
                " FROM tbl_order_detail d " +
                " JOIN tbl_product p ON d.fk_product_id = p.product_id " +
                " WHERE d.fk_odrcode = ? " +
                " ORDER BY d.odrdetailno ";

            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, odrCode);
            rs = pstmt.executeQuery();

            while (rs.next()) {

                OrderDetailDTO dto = new OrderDetailDTO();

                dto.setOdrDetailNo(rs.getInt("odrdetailno"));
                dto.setOdrQty(rs.getInt("odrqty"));
                dto.setOdrPrice(rs.getInt("odrprice"));
                dto.setDeliveryStatus(rs.getInt("deliverystatus"));
                dto.setDeliveryStatusName(rs.getString("delivery_status_name"));
                dto.setDeliveryDate(rs.getString("deliverydate"));
                dto.setProductName(rs.getString("product_name"));
                dto.setProductImage(rs.getString("pimage"));

                list.add(dto);
            }

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close();
        }

        return list;
    }

}
