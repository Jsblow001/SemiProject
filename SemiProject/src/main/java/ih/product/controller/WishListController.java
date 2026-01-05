package ih.product.controller;

import java.util.List;

import hk.member.domain.MemberDTO;
import ih.product.domain.ProductDTO;
import ih.product.model.ProductDAO;
import ih.product.model.ProductDAO_imple;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import sp.common.controller.AbstractController;

public class WishListController extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		// 로그인 되어져있는지 확인
		HttpSession session = request.getSession(); 
		MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");
		
		if(loginuser == null) {
			// 로그인 안 된 상황
			super.setRedirect(true);
			super.setViewPage(request.getContextPath() + "/login.sp");
			return;
		}
		
		String userid = loginuser.getUserid();
		ProductDAO pdao = new ProductDAO_imple();
		
		List<ProductDTO> wishList = pdao.getWishList(userid);
		
		request.setAttribute("wishList", wishList);
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/ih_product/wishList.jsp");
		
	} // end of public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception ----

}
