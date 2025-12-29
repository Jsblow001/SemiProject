package ih.product.controller;

import sp.common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import ih.product.domain.ProductDTO;
import ih.product.model.*;

public class ProductDetailController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        // 1. 목록에서 넘겨준 상품번호(product_id)를 받는다.
        String product_id = request.getParameter("product_id");
        
        // 2. DB에서 해당 상품의 정보를 가져온다.
        ProductDAO pdao = new ProductDAO_imple();
        ProductDTO pdto = pdao.selectOneProduct(product_id);
        
        if(pdto != null) {
            // 3. 데이터를 JSP에 전달한다.
            request.setAttribute("pdto", pdto);
            
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/ih_product/productDetail.jsp");
        } else {
            // 상품이 없을 경우 처리
            request.setAttribute("message", "해당 상품은 존재하지 않습니다.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/msg.jsp");
        }
    }
}