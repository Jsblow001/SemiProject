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
        
        // 삭제할 상품 번호 받기
        String productId = request.getParameter("product_id");
        
        // 관리자 권한 체크를 위해 세션 가져오기
        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");
        
        // 상품번호가 없거나 관리자가 아니면 차단
        if(productId == null || loginuser == null || !"admin".equals(loginuser.getUserid())) {
            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/index.sp");
            return;
        }

        ProductDAO pdao = new ProductDAO_imple();
        
        // 상품 정보 조회
        ProductDTO pdto = pdao.selectOneProduct(productId, loginuser.getUserid());

        if(pdto != null) {
            String pimage = pdto.getPimage(); 
            
            // DB에서 상품 정보 삭제 
            int result = pdao.deleteProduct(productId);

            if(result == 1) {
                // DB 삭제 성공 
                String uploadPath = request.getServletContext().getRealPath("/img");
                if(pimage != null && !pimage.isEmpty()) {
                    File file = new File(uploadPath + File.separator + pimage);
                    
                    if(file.exists()) {
                        file.delete(); // 파일 삭제 실행
                    }
                }
                
                // 삭제 완료 
                super.setRedirect(true);
                super.setViewPage(request.getContextPath() + "/admin/allproductList.sp");
            } else {
                // DB 삭제 실패 시
                request.setAttribute("message", "상품 삭제에 실패했습니다.");
                super.setRedirect(false);
                super.setViewPage("/WEB-INF/msg.jsp");
            }
        } else {
            // 상품 조회가 않는 경우 (이미 삭제되었거나 번호가 잘못됨)
            request.setAttribute("message", "해당 상품이 존재하지 않습니다.");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
        }
    }
}