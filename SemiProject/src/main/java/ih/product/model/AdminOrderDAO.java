package ih.product.model;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

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

    // 배송 상태별 건수 조회
	Map<String, Integer> getDeliveryStatusCount() throws SQLException;

	// 운송장 업데이트
	int updateInvoice(String odrdetailno, String invoice_no) throws SQLException;
	
	// 운송장 출력을 위한 주문 정보 불러오기
	AdminOrderDTO getOrderDetail(String odrcode) throws SQLException;
	
	// 운송장 출력을 위한 주문 세부 정보 불러오기
	List<AdminOrderDTO> getOrderDetailList(String odrcode) throws SQLException;

	// 페이징처리 - 관리자 주문 리스트
	List<AdminOrderDTO> selectPagingOrderList(Map<String, String> paraMap) throws SQLException;
	
	// 최근 7일 데이터 조회
	List<Map<String, String>> getOrderTrend() throws SQLException;

	// 페이징 처리 - 관리자 배송 리스트
	int getTotalOrderCount() throws SQLException;
}