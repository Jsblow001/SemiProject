package ih.product.model;

import java.sql.*;
import java.util.*;
import javax.naming.*;
import javax.sql.DataSource;

import ih.product.domain.AdminOrderDTO;
import sp.util.security.AES256;

public class AdminOrderDAO_imple implements AdminOrderDAO {

    private DataSource ds;
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;

    // 생성자
    public AdminOrderDAO_imple() {
        try {
            Context initContext = new InitialContext();
            Context envContext = (Context)initContext.lookup("java:/comp/env");
            ds = (DataSource)envContext.lookup("SemiProject"); 
        } catch (NamingException e) {
            e.printStackTrace();
        }
    }

    // 자원반납 메소드
    private void close() {
        try {
            if(rs != null)    {rs.close(); rs=null;}
            if(pstmt != null) {pstmt.close(); pstmt=null;}
            if(conn != null)  {conn.close(); conn=null;}
        } catch(SQLException e) {
            e.printStackTrace();
        }
    }
    
    // 전체 주문 내역 조회
    @Override
    public List<AdminOrderDTO> selectAllOrder() throws SQLException {
        List<AdminOrderDTO> orderList = new ArrayList<>();
        try {
            conn = ds.getConnection();

            String sql = " SELECT O.odrcode, O.fk_member_id, M.name, P.product_name, O.odrtotalprice, O.odrdate, O.payment_status, D.deliverystatus "
                       + " FROM tbl_order O "
                       + " JOIN tbl_member M ON O.fk_member_id = M.member_id "
                       + " JOIN tbl_order_detail D ON O.odrcode = D.fk_odrcode " 
                       + " JOIN tbl_product P ON D.fk_product_id = P.product_id " 
                       + " ORDER BY O.odrdate DESC ";
            
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while(rs.next()) {
                AdminOrderDTO odto = new AdminOrderDTO();
                odto.setOdrcode(rs.getString("odrcode"));
                odto.setFk_userid(rs.getString("fk_member_id"));
                odto.setName(rs.getString("name"));
                odto.setpName(rs.getString("product_name"));
                odto.setTotalprice(rs.getInt("odrtotalprice"));
                odto.setOdrdate(rs.getString("odrdate"));
                odto.setPayment_status(rs.getInt("payment_status")); 
                odto.setDeliverystatus(rs.getInt("deliverystatus"));
                
                orderList.add(odto);
            }
        } finally {
            close();
        }
        return orderList;
    }

    // 주문 상태 변경
    @Override
    public int updateOrderStatus(String odrcode, String status) throws SQLException {
        int result = 0;
        
        try {
            conn = ds.getConnection();
            
            conn.setAutoCommit(false);
            
            String sql = " UPDATE tbl_order_detail SET deliverystatus = ? WHERE fk_odrcode = ? ";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, status);
            pstmt.setString(2, odrcode);
            
            result = pstmt.executeUpdate();
            
            if(result > 0) {
                conn.commit(); 
            }
        } catch(SQLException e) {
        	if(conn != null) conn.rollback(); 
            e.printStackTrace();
        } finally {
            close();
        }
        return result;
    }
    
    //  주문 메인 정보 조회 (회원/배송지 정보)
    @Override
    public AdminOrderDTO selectOneOrder(String odrcode) throws SQLException {
        AdminOrderDTO odto = null;
        try {
            conn = ds.getConnection();
            String sql = " SELECT O.odrcode, O.fk_member_id, M.name, M.mobile, M.email, M.postcode, M.address, M.detailaddress, " +
                         "        O.odrtotalprice, O.odrtotalpoint, O.odrdate, O.payment_status, G.grade_name " +
                         " FROM tbl_order O JOIN tbl_member M ON O.fk_member_id = M.member_id " +
                         " JOIN tbl_grade G ON M.grade_code = G.grade_code " +
                         " WHERE O.odrcode = ? ";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, odrcode);
            rs = pstmt.executeQuery();
            
            if(rs.next()) {
            	
            	odto = new AdminOrderDTO();
                odto.setOdrcode(rs.getString("odrcode"));
                odto.setFk_userid(rs.getString("fk_member_id"));
                odto.setName(rs.getString("name"));
                /*
                try {
                    String mobile = rs.getString("mobile");
                    String email = rs.getString("email");

                    odto.setMobile(AES256.decrypt(mobile)); 
                    odto.setEmail(AES256.decrypt(email));
                    
                } catch (Exception e) {
                    // 복호화 실패 시 원본 출력
                    odto.setMobile(rs.getString("mobile"));
                    odto.setEmail(rs.getString("email"));
                }
                */
                odto.setOdrcode(rs.getString("odrcode"));
                odto.setFk_userid(rs.getString("fk_member_id"));
                odto.setName(rs.getString("name"));
                odto.setMobile(rs.getString("mobile"));
                odto.setEmail(rs.getString("email"));
                odto.setPostcode(rs.getString("postcode"));
                odto.setAddress(rs.getString("address"));
                odto.setDetailaddress(rs.getString("detailaddress"));
                odto.setOdrtotalprice(rs.getInt("odrtotalprice"));
                odto.setOdrtotalpoint(rs.getInt("odrtotalpoint"));
                odto.setOdrdate(rs.getString("odrdate"));
                odto.setPayment_status(rs.getInt("payment_status"));
            }
        } finally {
            close();
        }
        return odto;
    }

    // 주문 상세 상품 리스트 조회
    @Override
    public List<AdminOrderDTO> selectOrderDetailList(String odrcode) throws SQLException {
        List<AdminOrderDTO> detailList = new ArrayList<>();

        try {
            conn = ds.getConnection();
            
            String sql = " SELECT D.odrdetailno, P.product_name, D.odrqty, D.odrprice, D.deliverystatus, D.invoice_no" +
                         " FROM tbl_order_detail D JOIN tbl_product P " +
                         " ON D.fk_product_id = P.product_id " +
                         " WHERE D.fk_odrcode = ? ";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, odrcode);
            rs = pstmt.executeQuery();
            
            while(rs.next()) {
                AdminOrderDTO odto = new AdminOrderDTO();
                odto.setOdrdetailno(rs.getInt("odrdetailno"));
                odto.setPname(rs.getString("product_name")); 
                odto.setOdrqty(rs.getInt("odrqty"));
                odto.setOdrprice(rs.getInt("odrprice"));
                odto.setDeliverystatus(rs.getInt("deliverystatus"));
                String dbInvoice = rs.getString("invoice_no");

                // DB에 송장번호가 null이면 테스트용 랜덤 번호
                if(dbInvoice == null || dbInvoice.trim().isEmpty()) {

                    int randomNum = (int)(Math.random() * 899999) + 100000;
                    odto.setInvoice_no("TEST-" + randomNum);
                } else {
                    odto.setInvoice_no(dbInvoice);
                }
                
                detailList.add(odto);
            }
        } finally {
            close();
        }
        return detailList;
    }
	
    // 배송 상태별 건수 조회 (대시보드용)
    @Override
    public Map<String, Integer> getDeliveryStatusCount() throws SQLException {
        Map<String, Integer> statusMap = new HashMap<>();
        statusMap.put("count1", 0);
        statusMap.put("count2", 0);
        statusMap.put("count3", 0);
        statusMap.put("count4", 0);

        try {

            conn = ds.getConnection(); 

            String sql = " SELECT deliverystatus, count(*) AS cnt " +
                         " FROM tbl_order_detail " +
                         " GROUP BY deliverystatus ";
            
            pstmt = conn.prepareStatement(sql); 
            rs = pstmt.executeQuery();
            
            while(rs.next()) {
                int status = rs.getInt("deliverystatus");
                int cnt = rs.getInt("cnt");
                statusMap.put("count" + status, cnt);
            }
        } finally {
            close(); 
        }
        return statusMap;
    }
    
    // 운송장 업데이트
    public int updateInvoice(String odrdetailno, String invoice_no) throws SQLException {
        int result = 0;
        try {
            conn = ds.getConnection();
            // 송장을 넣으면 배송상태도 '2(배송중)'으로 함께 바꾸는 것이 실무 정석입니다.
            String sql = " update tbl_order_detail set invoice_no = ?, deliverystatus = 2 " +
                         " where odrdetailno = ? ";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, invoice_no);
            pstmt.setString(2, odrdetailno);
            
            result = pstmt.executeUpdate();
        } finally {
            close();
        }
        return result;
    }
}