package ih.product.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import sp.common.controller.AbstractController;

public class OrderCompleteController extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		request.setAttribute("message", "주문이 성공적으로 완료되었습니다!");
        
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/ih_product/orderComplete.jsp");
		
	}

}
