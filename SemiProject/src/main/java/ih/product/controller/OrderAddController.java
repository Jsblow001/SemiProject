package ih.product.controller;

import java.util.HashMap;
import java.util.Map;

import hk.member.domain.MemberDTO;
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

        String method = request.getMethod(); 
        if (!"POST".equalsIgnoreCase(method)) {
            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/index.sp");
            return;
        }

        // --- (JSP)로부터 전달받은 파라미터 ---
        String cartIds = request.getParameter("cartIds");   
        String productId = request.getParameter("product_id"); 
        String qty = request.getParameter("qty");
        String addr_id = request.getParameter("fk_addr_id"); 
        String totalPriceStr = request.getParameter("total_price"); 
        String salePrice = request.getParameter("sale_price");
        String usePointStr = request.getParameter("use_point");
        if(usePointStr == null || usePointStr.isEmpty()) {
            usePointStr = "0";
        }

        if(totalPriceStr == null || totalPriceStr.isEmpty()) {
            totalPriceStr = "0";
        }

        if(salePrice == null || salePrice.isEmpty()) {
            salePrice = "0";
        }

        Map<String, Object> paraMap = new HashMap<>();
        paraMap.put("userid", loginuser.getUserid());
        paraMap.put("addr_id", addr_id);
        paraMap.put("cartIds", cartIds); 
        paraMap.put("usePoint", usePointStr); // [추가] DAO로 전달할 사용 포인트

        if(cartIds != null && !cartIds.isEmpty()) {
            // 장바구니 주문
            paraMap.put("totalPrice", Integer.parseInt(totalPriceStr));
            paraMap.put("totalPoint", (int)(Integer.parseInt(totalPriceStr) * 0.01));
            paraMap.put("orderType", "cart");
        } else {
            // 상세페이지 단건 주문
            int i_qty = Integer.parseInt(qty);
            int i_salePrice = Integer.parseInt(salePrice);
            int totalPrice = i_qty * i_salePrice;
            
            paraMap.put("product_id", productId);
            paraMap.put("qty", i_qty);
            paraMap.put("sale_price", i_salePrice);
            paraMap.put("totalPrice", totalPrice);
            paraMap.put("totalPoint", (int)(totalPrice * 0.01));
            paraMap.put("orderType", "direct");
        }

        // DB 트랜잭션 처리 (주문 + 재고차감 + 장바구니비우기 + 포인트차감/적립)
        int n = pdao.orderAdd(paraMap);

        if (n == 1) {
            // 기존 포인트 - 사용 포인트 + 적립 포인트
            int currentPoint = loginuser.getPoint();
            int used = Integer.parseInt(usePointStr);
            int earned = Integer.parseInt(String.valueOf(paraMap.get("totalPoint")));
            loginuser.setPoint(currentPoint - used + earned);

            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/product/orderComplete.sp");
        } else {
            request.setAttribute("message", "주문 처리 중 오류가 발생했습니다.");
            request.setAttribute("loc", "javascript:history.back()");
            
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
        }
    }
}