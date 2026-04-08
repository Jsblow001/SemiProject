package ih.admin.controller;

import sp.common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import hk.member.domain.MemberDTO;
import ih.product.domain.ProductDTO;
import ih.product.model.*;

public class ProductUpdateController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        // 수정할 상품의 ID 가져오기
        String productId = request.getParameter("product_id");
        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");
        
        String userid = (loginuser != null) ? loginuser.getUserid() : null;
        if(productId != null) {
            ProductDAO pdao = new ProductDAO_imple();
            
            // 해당 ID의 상품 상세 정보 가져오기
            ProductDTO pdto = pdao.selectOneProduct(productId, userid);
            
            // 데이터를 request에 담아 수정 폼으로 보내기
            request.setAttribute("pdto", pdto);
            
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/ih_admin/productUpdate.jsp");
            
        } else {
            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/admin/allProductList.sp");
        }
    }
}