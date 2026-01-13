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
    // 1. 마이페이지 주문 목록 (+페이징)
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

            // delivery status 4추가 되면서 터짐 방지 -> left join
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
                "     LEFT JOIN tbl_order_detail d ON o.odrcode = d.fk_odrcode " +
                "     LEFT JOIN tbl_product p ON d.fk_product_id = p.product_id " +
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

    
    
    // 주문취소/교환/반품 팝업창 상품 목록 조회
    @Override
    public List<OrderDetailDTO> getOrderDetailList(int odrcode) throws SQLException {

        List<OrderDetailDTO> list = new ArrayList<>();

        try {
            conn = ds.getConnection();

            String sql =
                " SELECT d.odrdetailno " +
                "      , d.fk_odrcode " +
                "      , d.fk_product_id " +
                "      , d.odrqty " +
                "      , d.odrprice " +
                "      , d.deliverystatus " +
                "      , TO_CHAR(d.deliverydate,'YYYY-MM-DD') AS deliverydate " +
                "      , p.product_name " +
                "      , p.pimage " +
                " FROM tbl_order_detail d " +
                " JOIN tbl_product p " +
                "   ON d.fk_product_id = p.product_id " +
                " WHERE d.fk_odrcode = ? " +
                " ORDER BY d.odrdetailno ";

            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, odrcode);

            rs = pstmt.executeQuery();

            while(rs.next()) {
                OrderDetailDTO dto = new OrderDetailDTO();
                dto.setOdrDetailNo(rs.getInt("odrdetailno"));
                dto.setOdrCode(rs.getInt("fk_odrcode"));
                dto.setProductId(rs.getInt("fk_product_id"));
                dto.setOdrQty(rs.getInt("odrqty"));
                dto.setOdrPrice(rs.getInt("odrprice"));
                dto.setDeliveryStatus(rs.getInt("deliverystatus"));
                dto.setDeliveryDate(rs.getString("deliverydate"));
                dto.setProductName(rs.getString("product_name"));
                dto.setProductImage(rs.getString("pimage"));
                list.add(dto);
            }

        } finally {
            close();
        }

        return list;
    }

    
    
    // 주문취소/교환/반품 신청
    @Override
    public int requestClaim(int odrDetailNo, String type, String reason) throws SQLException {

        int result = 0;

        try {
            conn = ds.getConnection();

            String sql =
                " UPDATE tbl_order_detail " +
                " SET CLAIM_TYPE = ?, " +
                "     CLAIM_STATUS = 'REQUEST', " +
                "     CLAIM_REASON = ? " +
                " WHERE ODRDETAILNO = ? " +
                "   AND CLAIM_TYPE IS NULL ";

            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, type);
            pstmt.setString(2, reason);
            pstmt.setInt(3, odrDetailNo);

            result = pstmt.executeUpdate();

        } finally {
            close();
        }

        return result;
    }

    
    
    // 주문취소/교환/반품 신청 요청목록 조회
    @Override
    public List<OrderDetailDTO> getClaimList() throws SQLException {

        List<OrderDetailDTO> list = new ArrayList<>();

        try {
            conn = ds.getConnection();

            String sql =
                " SELECT d.odrdetailno " +
                "      , d.fk_odrcode " +
                "      , d.odrqty " +
                "      , d.claim_type " +
                "      , d.claim_status " +
                "      , d.claim_reason " +
                "      , p.product_name " +
                " FROM tbl_order_detail d " +
                " JOIN tbl_product p " +
                "   ON d.fk_product_id = p.product_id " +
                " WHERE d.claim_status = 'REQUEST' " +
                " ORDER BY d.odrdetailno DESC ";

            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while(rs.next()){
                OrderDetailDTO dto = new OrderDetailDTO();
                dto.setOdrDetailNo(rs.getInt("odrdetailno"));
                dto.setOdrCode(rs.getInt("fk_odrcode"));
                dto.setOdrQty(rs.getInt("odrqty"));
                dto.setClaimType(rs.getString("claim_type"));
                dto.setClaimStatus(rs.getString("claim_status"));
                dto.setClaimReason(rs.getString("claim_reason"));
                dto.setProductName(rs.getString("product_name"));

                list.add(dto);
            }

        } finally {
            close();
        }

        return list;
    }


    
    // 주문취소/반품/교환 신청 관리자 승인/반려 처리 -> 주문취소 (결제취소, 배송취소)
    @Override
    public int processClaim(int odrDetailNo, String action) throws SQLException {

        int result = 0;

        try {
            conn = ds.getConnection();

            String status = action.equals("APPROVE") ? "APPROVED" : "REJECTED";

            // 1. 클레임 상태 변경
            String sql1 =
                " UPDATE tbl_order_detail " +
                " SET claim_status = ? " +
                " WHERE odrdetailno = ? ";

            pstmt = conn.prepareStatement(sql1);
            pstmt.setString(1, status);
            pstmt.setInt(2, odrDetailNo);
            result = pstmt.executeUpdate();

            // 승인일 때만 주문 취소 처리
            if("APPROVE".equals(action)) {

                // 2. 주문번호 조회
                String sql2 =
                    " SELECT fk_odrcode FROM tbl_order_detail WHERE odrdetailno = ? ";

                pstmt = conn.prepareStatement(sql2);
                pstmt.setInt(1, odrDetailNo);
                rs = pstmt.executeQuery();
                rs.next();
                int odrCode = rs.getInt(1);

                // 3. 주문 결제 상태를 결제취소로
                String sql3 =
                    " UPDATE tbl_order SET payment_status = 2 WHERE odrcode = ? ";

                pstmt = conn.prepareStatement(sql3);
                pstmt.setInt(1, odrCode);
                pstmt.executeUpdate();

                // 4. 해당 상품 배송 상태도 취소
                String sql4 =
                    " UPDATE tbl_order_detail SET deliverystatus = 4 WHERE odrdetailno = ? ";

                pstmt = conn.prepareStatement(sql4);
                pstmt.setInt(1, odrDetailNo);
                pstmt.executeUpdate();
            }

        } finally {
            close();
        }

        return result;
    }



}
