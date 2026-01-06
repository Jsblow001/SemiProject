package ih.product.controller;

import java.util.List;
import java.util.Map;

import hk.member.domain.MemberDTO;
import ih.product.domain.ProductDTO;
import ih.product.model.ProductDAO;
import ih.product.model.ProductDAO_imple;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import sp.common.controller.AbstractController;

public class OrderFormController extends AbstractController {

	ProductDAO pdao = new ProductDAO_imple();
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		// 로그인 여부 확인
        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");

        if (loginuser == null) {
            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/login.sp");
            return;
        }

        String productId = request.getParameter("product_id");
        String qty = request.getParameter("cart_qty"); // 구매하려는 수량

        if(productId == null || qty == null) {
            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/index.sp");
            return;
        }

        ProductDTO pdto = pdao.getProductDetail(productId);
        
        // 로그인한 사용자의 배송지 목록 가져오기 (tbl_address 조회)
        List<Map<String, String>> addrList = pdao.getAddressList(loginuser.getUserid());

        int i_qty = Integer.parseInt(qty);
        int totalPrice = pdto.getSale_price() * i_qty;
        int totalPoint = (int)(totalPrice * 0.01); 

        request.setAttribute("pdto", pdto);
        request.setAttribute("qty", qty);
        request.setAttribute("totalPrice", totalPrice);
        request.setAttribute("totalPoint", totalPoint);
        request.setAttribute("addrList", addrList);

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/ih_product/orderForm.jsp");
		
	}

}
