package ih.admin.controller;

import java.io.File;
import hk.member.domain.MemberDTO;
import sp.common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import ih.product.domain.ProductDTO;
import ih.product.model.*;

public class ProductDeleteController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        String productId = request.getParameter("product_id");
        String currentShowPageNo = request.getParameter("currentShowPageNo");
        String category = request.getParameter("category");
        
        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");
        
        if(productId == null || loginuser == null || !"admin".equals(loginuser.getUserid())) {
            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/index.sp");
            return;
        }

        ProductDAO pdao = new ProductDAO_imple();
        
        ProductDTO pdto = pdao.selectOneProduct(productId, loginuser.getUserid());

        if(currentShowPageNo == null || currentShowPageNo.isEmpty()) currentShowPageNo = "1";
        if(category == null || category.isEmpty()) category = "";
        
        if(pdto != null) {
            String pimage = pdto.getPimage(); 
            
            int result = pdao.deleteProduct(productId);

            if(result == 1) {
                ProductDTO checkDto = pdao.selectOneProduct(productId, loginuser.getUserid());
                
                if(checkDto == null) {
                    String uploadPath = request.getServletContext().getRealPath("/img");
                    if(pimage != null && !pimage.isEmpty()) {
                        File file = new File(uploadPath + File.separator + pimage);
                        if(file.exists()) {
                            file.delete(); 
                        }
                    }
                }
                
                super.setRedirect(true);
                super.setViewPage(request.getContextPath() + "/product/productList.sp?category=" + category + "&currentShowPageNo=" + currentShowPageNo);
            
            } else {
                // DB 처리 실패 시
                request.setAttribute("message", "상품 삭제에 실패했습니다.");
                request.setAttribute("loc", "javascript:history.back()");
                super.setRedirect(false);
                super.setViewPage("/WEB-INF/msg.jsp");
            }
            
        } else {
            // 상품 자체가 존재하지 않는 경우
            request.setAttribute("message", "해당 상품이 존재하지 않거나 이미 삭제되었습니다.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
        }
    } 
}