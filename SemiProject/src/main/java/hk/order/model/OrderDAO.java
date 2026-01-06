package hk.order.model;

import java.sql.SQLException;
import java.util.List;
import hk.order.domain.OrderDTO;
import hk.order.domain.OrderDetailDTO;

public interface OrderDAO {

    // 마이페이지 주문 목록 (주문처리상태, 기간)
	List<OrderDTO> selectMyOrderList(String memberId, String status, String startDate, String endDate) throws SQLException;

    // 주문 상세
    List<OrderDetailDTO> selectOrderDetail(int odrCode) throws SQLException;
}
