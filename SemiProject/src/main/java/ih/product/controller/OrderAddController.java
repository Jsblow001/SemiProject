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

        // 파라미터 받기
        String cartIds = request.getParameter("cartIds");   
        String productId = request.getParameter("product_id"); 
        String qty = request.getParameter("qty");
        String addr_id = request.getParameter("fk_addr_id"); 
        String totalPriceStr = request.getParameter("total_price"); 
        String salePrice = request.getParameter("sale_price");
        String usePointStr = request.getParameter("use_point");
        
        if(usePointStr == null || usePointStr.isEmpty()) usePointStr = "0";
        if(totalPriceStr == null || totalPriceStr.isEmpty()) totalPriceStr = "0";
        if(salePrice == null || salePrice.isEmpty()) salePrice = "0";

        // -------------------------------------------------------------
        // 판매 중지 상품 실시간 검증 로직 
        // -------------------------------------------------------------
        boolean isAllAvailable = true;
        String unavailableProductName = "";

        if(cartIds != null && !cartIds.isEmpty()) {
            // 장바구니 주문 시: 선택한 모든 장바구니 아이템의 pstatus 확인
            String[] arr_cartId = cartIds.split(",");
            for(String cart_id : arr_cartId) {
                // 장바구니 번호로 상품의 실시간 정보를 가져오는 메소드 
                ProductDTO pdto = pdao.getProductByCartId(cart_id); 
                if(pdto == null || pdto.getPstatus() == 0) {
                    isAllAvailable = false;
                    unavailableProductName = (pdto != null) ? pdto.getProduct_name() : "일부";
                    break;
                }
            }
        } else {
            // 단건 주문 시: 해당 상품의 pstatus 확인
            ProductDTO pdto = pdao.selectOneProduct(productId, loginuser.getUserid());
            if(pdto == null || pdto.getPstatus() == 0) {
                isAllAvailable = false;
                unavailableProductName = (pdto != null) ? pdto.getProduct_name() : "해당";
            }
        }

        if(!isAllAvailable) {
            request.setAttribute("message", "[" + unavailableProductName + "] 상품은 판매가 종료되어 주문할 수 없습니다.");
            request.setAttribute("loc", request.getContextPath() + "/product/cartList.sp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }
        // -------------------------------------------------------------

        // 파라미터 
        Map<String, Object> paraMap = new HashMap<>();
        paraMap.put("userid", loginuser.getUserid());
        paraMap.put("addr_id", addr_id);
        paraMap.put("cartIds", cartIds); 
        paraMap.put("usePoint", usePointStr);

        if(cartIds != null && !cartIds.isEmpty()) {
            paraMap.put("totalPrice", Integer.parseInt(totalPriceStr));
            paraMap.put("totalPoint", (int)(Integer.parseInt(totalPriceStr) * 0.01));
            paraMap.put("orderType", "cart");
        } else {
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

        // DB 트랜잭션 처리
        int n = pdao.orderAdd(paraMap);

        if (n == 1) {
            int currentPoint = loginuser.getPoint();
            int used = Integer.parseInt(usePointStr);
            int earned = (int)paraMap.get("totalPoint");
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