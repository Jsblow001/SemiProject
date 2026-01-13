package hk.admin.controller;

import java.util.List;

import hk.order.model.OrderDAO;
import hk.order.model.OrderDAO_imple;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import sp.common.controller.AbstractController;

public class AdminClaimListController extends AbstractController {

	 private OrderDAO odao = new OrderDAO_imple();

	    @Override
	    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

	        List list = odao.getClaimList();

	        request.setAttribute("claimList", list);

	        super.setRedirect(false);
	        super.setViewPage("/WEB-INF/hk_admin/claimList.jsp");
	    }

}
