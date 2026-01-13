package hk.member.controller;

import hk.order.model.OrderDAO;
import hk.order.model.OrderDAO_imple;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import sp.common.controller.AbstractController;

public class OrderCancelRequestController extends AbstractController {

	private OrderDAO odao = new OrderDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        int odrDetailNo = Integer.parseInt(request.getParameter("odrdetailno"));
        String type = request.getParameter("type");      // CANCEL / RETURN / EXCHANGE
        String reason = request.getParameter("reason");

        int result = odao.requestClaim(odrDetailNo, type, reason);

        if(result == 1){
            request.setAttribute("msg", "신청이 완료되었습니다.");
        } else {
            request.setAttribute("msg", "이미 처리된 상품입니다.");
        }

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/hk_member/orderCancelResult.jsp");

    }

}
