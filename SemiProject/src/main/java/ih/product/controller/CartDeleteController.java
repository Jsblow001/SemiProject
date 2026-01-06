package ih.product.controller;

import org.json.JSONObject;

import ih.product.model.ProductDAO;
import ih.product.model.ProductDAO_imple;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import sp.common.controller.AbstractController;

public class CartDeleteController extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String cart_id = request.getParameter("cart_id");

		ProductDAO pdao = new ProductDAO_imple();
		int n = pdao.deleteCart(cart_id);

		JSONObject jsonObj = new JSONObject();
		jsonObj.put("result", n); // 성공 시 1, 실패 시 0

		String json = jsonObj.toString();
		request.setAttribute("json", json);
		
		super.setRedirect(false);
		super.setViewPage("/WEB-INF/ih_jsonview.jsp");
		
	}

}
