package ih.product.model;

import java.sql.SQLException;
import java.util.List;

import ih.product.domain.AdminOrderDTO;

public interface AdminOrderDAO {
    
    // 전체 주문 내역 조회 (회원 정보 포함)
    List<AdminOrderDTO> selectAllOrder() throws SQLException;
    
    // 주문 상태 변경 (Ajax용)
    int updateOrderStatus(String odrcode, String status) throws SQLException;

    // 주문 메인 정보 조회 (회원 정보 포함)
    AdminOrderDTO selectOneOrder(String odrcode) throws SQLException;

    // 주문 상세 상품 목록 조회 (상품 정보 포함)
    List<AdminOrderDTO> selectOrderDetailList(String odrcode) throws SQLException;
}