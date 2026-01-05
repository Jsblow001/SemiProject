package hk.order.model;

import java.util.List;
import hk.order.domain.OrderDTO;
import hk.order.domain.OrderDetailDTO;

public interface OrderDAO {

    // 마이페이지 주문 목록
    List<OrderDTO> selectMyOrderList(String memberId);

    // 주문 상세
    List<OrderDetailDTO> selectOrderDetail(int odrCode);
}
