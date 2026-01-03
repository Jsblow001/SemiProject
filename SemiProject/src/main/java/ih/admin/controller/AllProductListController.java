package ih.admin.controller;

import java.util.List;
import sp.common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import ih.product.domain.ProductDTO;
import ih.product.model.*;

public class AllProductListController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        // 카테고리 부분 읽어오기
        String category = request.getParameter("category");
        
        ProductDAO pdao = new ProductDAO_imple();
        
        // 카테고리 값 전달하여 리스트 조회
        List<ProductDTO> productList = pdao.selectAllProduct(category);
        
        request.setAttribute("productList", productList);
        request.setAttribute("currentCategory", category);
        
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/ih_admin/allproductList.jsp");
    }
}