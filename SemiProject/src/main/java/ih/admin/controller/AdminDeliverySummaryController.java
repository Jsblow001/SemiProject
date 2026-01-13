package ih.admin.controller;

import java.util.List;
import java.util.Map;

import ih.product.domain.AdminOrderDTO;
import ih.product.model.AdminOrderDAO;
import ih.product.model.AdminOrderDAO_imple;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import sp.common.controller.AbstractController;

public class AdminDeliverySummaryController extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		AdminOrderDAO odao = new AdminOrderDAO_imple();
	    
	    List<AdminOrderDTO> orderList = odao.selectAllOrder();
	    
	    Map<String, Integer> summary = odao.getDeliveryStatusCount();
	    
	    request.setAttribute("orderList", orderList);
	    request.setAttribute("summary", summary);
	    
	    super.setRedirect(false);
	    super.setViewPage("/WEB-INF/ih_admin/deliverySummary.jsp");
		
	}

}
