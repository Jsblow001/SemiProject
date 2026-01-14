package ih.product.controller;

import java.util.List;
import java.util.Map;

import hk.member.domain.MemberDTO;
import ih.product.domain.ProductDTO;
import ih.product.model.ProductDAO;
import ih.product.model.ProductDAO_imple;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import sp.common.controller.AbstractController;

public class OrderFormController extends AbstractController {

    ProductDAO pdao = new ProductDAO_imple();
    
    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        // 로그인 여부 확인
        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");

        if (loginuser == null) {
            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/login.sp");
            return;
        }

        String cartIds = request.getParameter("cartIds");      // 장바구니 주문 시 
        String productId = request.getParameter("product_id"); // 상세페이지 바로구매 시
        String qty = request.getParameter("qty");              // 상세페이지 바로구매 시

        if(cartIds == null && productId == null) {
            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/index.sp");
            return;
        }

        // 배송지 목록 가져오기 (공통)
        List<Map<String, String>> addrList = pdao.getAddressList(loginuser.getUserid());
        request.setAttribute("addrList", addrList);

        // 주문 유형(상세페이지, 장바구니)
        if (cartIds != null && !cartIds.trim().isEmpty()) {
            // 장바구니 주문
            List<Map<String, Object>> orderList = pdao.getCartListByCartIds(cartIds);
            
            int totalPrice = 0;
            for(Map<String, Object> map : orderList) {
                // 각 상품별 (판매가 * 장바구니수량) 합산
                int sale_price = Integer.parseInt(String.valueOf(map.get("sale_price")));
                int cart_qty = Integer.parseInt(String.valueOf(map.get("cart_qty")));
                totalPrice += (sale_price * cart_qty);
            }
            
            int totalPoint = (int)(totalPrice * 0.01);

            request.setAttribute("orderList", orderList);
            request.setAttribute("totalPrice", totalPrice);
            request.setAttribute("totalPoint", totalPoint);
            request.setAttribute("orderType", "cart"); // JSP에서 리스트 출력을 결정하는 플래그

        } else if (productId != null && qty != null){
            // 상세페이지에서 단일 상품 바로구매
            ProductDTO pdto = pdao.getProductDetail(productId);
            
            
            int i_qty = Integer.parseInt(qty); 
            int totalPrice = pdto.getSale_price() * i_qty;
            int totalPoint = (int)(totalPrice * 0.01); 

            request.setAttribute("pdto", pdto);
            request.setAttribute("qty", i_qty);
            request.setAttribute("totalPrice", totalPrice);
            request.setAttribute("totalPoint", totalPoint);
            request.setAttribute("orderType", "direct");
        }

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/ih_product/orderForm.jsp");
    }
}