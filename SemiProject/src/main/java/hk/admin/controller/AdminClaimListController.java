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

	    	// 신청 목록
	        List list = odao.getClaimList();

	        // 처리대기 건수
	        int pendingCount = odao.getPendingClaimCount();
	        
	        // request 에 담기
	        request.setAttribute("claimList", list);
	        request.setAttribute("pendingCount", pendingCount);
	        
	        super.setRedirect(false);
	        super.setViewPage("/WEB-INF/hk_admin/claimList.jsp");
	    }

}
