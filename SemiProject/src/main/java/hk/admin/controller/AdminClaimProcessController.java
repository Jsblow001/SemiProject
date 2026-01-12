package hk.admin.controller;

import jakarta.servlet.http.*;
import sp.common.controller.AbstractController;
import hk.order.model.*;

public class AdminClaimProcessController extends AbstractController {

    private OrderDAO odao = new OrderDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        int odrDetailNo = Integer.parseInt(request.getParameter("odrdetailno"));
        String action = request.getParameter("action"); // APPROVE / REJECT

        odao.processClaim(odrDetailNo, action);

        super.setRedirect(true);
        super.setViewPage(request.getContextPath() + "/admin/claimList.sp");
        
        System.out.println("odrdetailno = " + odrDetailNo);
        System.out.println("action = " + action);
    }
}
