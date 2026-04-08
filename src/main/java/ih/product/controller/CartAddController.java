package ih.product.controller;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONObject;

import hk.member.domain.MemberDTO;
import ih.product.model.ProductDAO;
import ih.product.model.ProductDAO_imple;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import sp.common.controller.AbstractController;

public class CartAddController extends AbstractController {

	ProductDAO pdao = new ProductDAO_imple();
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		// 로그인 여부 확인
        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");
        
        JSONObject jsonObj = new JSONObject();
        
        if(loginuser == null) {
            // 로그인이 안 된 경우
        	jsonObj.put("result", 0);
        	jsonObj.put("message", "로그인이 필요한 서비스입니다.");
        } 
        else {
            // 로그인이 된 경우 -> 장바구니 등록 
            String product_id = request.getParameter("product_id");
            String cart_qty = request.getParameter("cart_qty");
            String userid = loginuser.getUserid(); 
            
            Map<String, String> paraMap = new HashMap<>();
            paraMap.put("userid", userid);
            paraMap.put("product_id", product_id);
            paraMap.put("cart_qty", cart_qty);
            
            int n = pdao.addCart(paraMap); 
            
            jsonObj.put("result", n);
            jsonObj.put("message", (n==1)?"장바구니에 담겼습니다.":"장바구니 담기 실패");
        }
        
        String json = jsonObj.toString();
        request.setAttribute("json", json);
        
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/ih_jsonview.jsp");
		
	} // end of public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception ----

}
