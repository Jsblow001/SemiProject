package ih.product.controller;

import java.util.List;

import hk.member.domain.MemberDTO;
import ih.product.domain.CartDTO;
import ih.product.model.ProductDAO;
import ih.product.model.ProductDAO_imple;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import sp.common.controller.AbstractController;

public class CartListController extends AbstractController {

	private ProductDAO pdao = new ProductDAO_imple();
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
	    
	    // 로그인 확인
	    HttpSession session = request.getSession();
	    MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");
	    
	    if(loginuser == null) {
			// 로그인 안 된 상황
	    	request.setAttribute("message", "장바구니를 이용하시려면 먼저 로그인하세요.");
            request.setAttribute("loc", request.getContextPath() + "/login.sp");
            
            super.setRedirect(false); // forward
            super.setViewPage("/WEB-INF/msg.jsp"); // alert 띄워주는 공통 JSP
            return;
		}
	    
    	String userid = loginuser.getUserid();
        
        // DAO - 장바구니 목록 가져오기
        List<CartDTO> cartList = pdao.getCartList(userid);

        request.setAttribute("cartList", cartList);
        
        // JSP 전달
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/ih_product/cartList.jsp");
	    
	}

}
