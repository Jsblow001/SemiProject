package ih.product.controller;

import java.util.HashMap;
import java.util.Map;

import hk.member.domain.MemberDTO;
import ih.product.domain.ProductDTO;
import ih.product.model.ProductDAO;
import ih.product.model.ProductDAO_imple;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import sp.common.controller.AbstractController;

public class OrderAddController extends AbstractController {

	ProductDAO pdao = new ProductDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        // 로그인 여부 확인
        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");
        
        if(loginuser == null) {
            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/login.sp");
            return;
        }

        String method = request.getMethod(); // GET 또는 POST
        
        if (!"POST".equalsIgnoreCase(method)) {
            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/index.sp");
            return;
        }

        String productId = request.getParameter("product_id");
        String qty = request.getParameter("qty");
        String addr_id = request.getParameter("fk_addr_id"); 
        String salePrice = request.getParameter("sale_price"); 
        
        // 총 주문액 계산 (상품금액 * 수량)
        int i_qty = Integer.parseInt(qty);
        int i_salePrice = Integer.parseInt(salePrice);
        int totalPrice = i_qty * i_salePrice;
        
        int totalPoint = (int)(totalPrice * 0.01);

        Map<String, Object> paraMap = new HashMap<>();
        paraMap.put("userid", loginuser.getUserid());
        paraMap.put("product_id", productId);
        paraMap.put("qty", i_qty);
        paraMap.put("sale_price", i_salePrice);
        paraMap.put("totalPrice", totalPrice);
        paraMap.put("totalPoint", totalPoint);
        paraMap.put("addr_id", addr_id); // tbl_order의 FK

        // (tbl_order, tbl_order_detail, tbl_product 재고차감) 메서드
        int n = pdao.orderAdd(paraMap);

        if (n == 1) {
            // 주문 성공 시 -> 주문 완료 페이지로 이동
            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/product/orderComplete.sp");
        } else {
            // 주문 실패 시
            request.setAttribute("message", "주문 처리 중 오류가 발생했습니다.");
            request.setAttribute("loc", "javascript:history.back()");
            
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
        }
    }
}