package ih.admin.controller;

import org.json.JSONObject;

import ih.product.model.ProductDAO;
import ih.product.model.ProductDAO_imple;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import sp.common.controller.AbstractController;

public class AdminCancelOrderController extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String odrcode = request.getParameter("odrcode");
        String method = request.getMethod();

        if(!"POST".equalsIgnoreCase(method)) {
            return;
        }

        ProductDAO pdao = new ProductDAO_imple();
        
        // DB 업데이트 (배송상태를 4:주문취소 로 변경하는 로직)
        int result = pdao.updateOrderCancel(odrcode);

        JSONObject jsObj = new JSONObject();
        jsObj.put("result", result); // 성공 시 1, 실패 시 0

        String json = jsObj.toString();
        request.setAttribute("json", json);

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/ih_jsonview.jsp");
		
	}

}
