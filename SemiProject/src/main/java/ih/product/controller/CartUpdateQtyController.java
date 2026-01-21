package ih.product.controller;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONObject;

import ih.product.model.ProductDAO;
import ih.product.model.ProductDAO_imple;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import sp.common.controller.AbstractController;

public class CartUpdateQtyController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        String cart_id = request.getParameter("cart_id");
        String change = request.getParameter("change");

        Map<String, String> paraMap = new HashMap<>();
        paraMap.put("cart_id", cart_id);
        paraMap.put("change", change);

        ProductDAO pdao = new ProductDAO_imple();
        int n = pdao.updateCartQty(paraMap);

        JSONObject jsonObj = new JSONObject();
        if(n == 1) {
            jsonObj.put("result", 1);
        } else {
            jsonObj.put("result", 0);
            jsonObj.put("message", "수량 변경이 불가능합니다. (재고 부족 또는 최소 수량 1개)");
        }

        String json = jsonObj.toString();
        request.setAttribute("json", json);
        
        super.setRedirect(false); 
        super.setViewPage("/WEB-INF/ih_jsonview.jsp");
    }
}