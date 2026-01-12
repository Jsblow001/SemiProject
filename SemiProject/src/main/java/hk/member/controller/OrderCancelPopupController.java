package hk.member.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import sp.common.controller.AbstractController;

public class OrderCancelPopupController extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		request.setAttribute("odrcode", request.getParameter("odrcode"));
        request.setAttribute("status", request.getParameter("status"));

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/hk_member/orderCancelPopup.jsp");
	
	}

}
