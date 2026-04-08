package hk.admin.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import sp.common.controller.AbstractController;
import hk.order.model.OrderDAO;
import hk.order.model.OrderDAO_imple;

public class AdminClaimCompleteController extends AbstractController {

    private OrderDAO odao = new OrderDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        int odrDetailNo = Integer.parseInt(request.getParameter("odrdetailno"));

        int result = odao.completeClaim(odrDetailNo);

        // 결과 체크는 선택
        super.setRedirect(true);
        super.setViewPage(request.getContextPath() + "/admin/claimList.sp");
    }
}
