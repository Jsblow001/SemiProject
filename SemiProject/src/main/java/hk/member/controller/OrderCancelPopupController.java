package hk.member.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import sp.common.controller.AbstractController;
import hk.order.model.OrderDAO;
import hk.order.model.OrderDAO_imple;
import hk.order.domain.OrderDetailDTO;
import java.util.List;

public class OrderCancelPopupController extends AbstractController {

    private OrderDAO odao = new OrderDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        // 1. request 파라미터는 String
        String odrcodeStr = request.getParameter("odrcode");
        String status     = request.getParameter("status");

        // 2. String → int 변환
        int odrcode = Integer.parseInt(odrcodeStr);

        // 3. 주문에 속한 상품 목록 조회
        List<OrderDetailDTO> detailList = odao.getOrderDetailList(odrcode);

        // 4. JSP로 전달
        request.setAttribute("odrcode", odrcode);
        request.setAttribute("status", status);
        request.setAttribute("detailList", detailList);

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/hk_member/orderCancelPopup.jsp");
        
        //System.out.println("odrcode = " + odrcode);
        //System.out.println("detailList size = " + detailList.size());
    }
}
