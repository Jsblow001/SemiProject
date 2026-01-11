package ih.product.model;

import java.sql.*;
import java.util.*;
import javax.naming.*;
import javax.sql.DataSource;

import ih.product.domain.AdminOrderDTO;

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

            String sql = " SELECT O.odrcode, O.fk_member_id, M.name, O.odrtotalprice, O.odrdate, O.payment_status " +
                    " FROM tbl_order O JOIN tbl_member M " +
                    " ON O.fk_member_id = M.member_id " +
                    " ORDER BY O.odrdate DESC ";
            
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            
            while(rs.next()) {
            	AdminOrderDTO odto = new AdminOrderDTO();
                odto.setOdrcode(rs.getString("odrcode"));
                odto.setFk_userid(rs.getString("fk_member_id")); // DTO 필드명 확인 필요
                odto.setName(rs.getString("name"));
                odto.setTotalprice(rs.getInt("odrtotalprice"));
                odto.setOdrdate(rs.getString("odrdate"));
                odto.setDelivery_status(rs.getInt("payment_status"));
                
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
            String sql = " UPDATE tbl_order_detail SET deliverystatus = ? WHERE fk_odrcode = ? ";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, status);
            pstmt.setString(2, odrcode);
            result = pstmt.executeUpdate();
            
        } finally {
        	close();
        }
        return result;
    }
}