package sp.index.controller;

import java.sql.SQLException;
import java.util.List;

import hk.member.domain.MemberDTO;
import sp.common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import ih.product.domain.ProductDTO;
import ih.product.model.ProductDAO;
import ih.product.model.ProductDAO_imple;

public class IndexController extends AbstractController {

	private ProductDAO pdao = new ProductDAO_imple();
 // 또는
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		try {
			ProductDAO pdao = new ProductDAO_imple();

			HttpSession session = request.getSession();
			MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");

			// ✅ 로그인 O: userid, 로그인 X: "" (null 금지)
			String userid = (loginuser != null) ? loginuser.getUserid() : "";

			// 1=sunglasses, 2=eyeglasses
			List<ProductDTO> sungList = pdao.selectProductByCategory("1", userid);
			List<ProductDTO> eyeList  = pdao.selectProductByCategory("2", userid);

			// 앞에서 8개만
			request.setAttribute("sunglasses8", sungList.size() > 8 ? sungList.subList(0, 8) : sungList);
			request.setAttribute("eyeglasses8", eyeList.size() > 8 ? eyeList.subList(0, 8) : eyeList);

			// ✅ JSP에서 로그인 여부 체크용 (선택)
			request.setAttribute("loginuser", loginuser);

			
			super.setRedirect(false);
			super.setViewPage("/WEB-INF/index.jsp");
			
		} catch(Exception e) {
			e.printStackTrace();
			
			super.setRedirect(true);
			super.setViewPage(request.getContextPath()+"/error.jsp");
		}
		
	}

}









