package hk.order.model;

import java.sql.SQLException;
import java.util.List;
import hk.order.domain.OrderDTO;
import hk.order.domain.OrderDetailDTO;

public interface OrderDAO {

    // 마이페이지 주문 목록 (주문처리상태, 기간 필터, 페이징 처리)
	List<OrderDTO> selectMyOrderList(String memberId, String status, String startDate, String endDate, int startRow, int endRow) throws SQLException;

    // 주문 상세
    List<OrderDetailDTO> selectOrderDetail(int odrCode) throws SQLException;

	// 주문 총 건수 (페이지바용)
    int getOrderTotalCount(String userid, String status, String startDate, String endDate) throws SQLException;

	List<OrderDetailDTO> getOrderDetailList(int odrcode) throws SQLException;
    
     
}
