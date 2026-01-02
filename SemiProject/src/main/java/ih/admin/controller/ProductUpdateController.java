package ih.admin.controller;

import sp.common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import ih.product.domain.ProductDTO;
import ih.product.model.*;

public class ProductUpdateController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        // 1. 어떤 상품을 수정할지 ID를 가져옵니다.
        String productId = request.getParameter("product_id");

        if(productId != null) {
            ProductDAO pdao = new ProductDAO_imple();
            
            // 2. 해당 ID의 상품 상세 정보를 가져옵니다. (기존 상세조회 메소드 재활용)
            ProductDTO pdto = pdao.selectOneProduct(productId);
            
            // 3. 데이터를 request에 담아 수정 폼으로 보냅니다.
            request.setAttribute("pdto", pdto);
            
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/ih_admin/productUpdate.jsp");
            
        } else {
            // ID가 없으면 목록으로 튕겨냅니다.
            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/admin/allProductList.sp");
        }
    }
}