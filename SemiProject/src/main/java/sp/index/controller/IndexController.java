package sp.index.controller;

import java.sql.SQLException;
import java.util.List;

import sp.common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import product.model.ProductDAO;
import product.model.ProductDAO_imple;

public class IndexController extends AbstractController {

	private ProductDAO pdao = new ProductDAO_imple();
 // 또는
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		try {
			//List<ImageDTO> imgList = pdao.imageSelectAll();
			//request.setAttribute("imgList", imgList);
			
			super.setRedirect(false);
			super.setViewPage("/WEB-INF/index.jsp");
			
		} catch(Exception e) {
			e.printStackTrace();
			
			super.setRedirect(true);
			super.setViewPage(request.getContextPath()+"/error.jsp");
		}
		
	}

}









