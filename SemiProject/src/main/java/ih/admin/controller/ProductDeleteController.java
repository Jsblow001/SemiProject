package ih.admin.controller;

import java.io.File;
import sp.common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import ih.product.domain.ProductDTO;
import ih.product.model.*;

public class ProductDeleteController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        // 삭제할 상품 번호 받기
        String productId = request.getParameter("product_id");

        if(productId != null) {
            ProductDAO pdao = new ProductDAO_imple();
            
            ProductDTO pdto = pdao.selectOneProduct(productId);
            String pimage = pdto.getPimage();

            // DB 상품 정보 삭제
            int result = pdao.deleteProduct(productId);

            if(result == 1) {
                // DB 삭제 성공 시 서버에 저장된 실제 이미지 파일 삭제
                String uploadPath = request.getServletContext().getRealPath("/img");
                File file = new File(uploadPath + File.separator + pimage);
                
                if(file.exists()) {
                    file.delete(); // 파일 삭제 실행
                }
                
                // 삭제 완료 후 목록으로 이동
                super.setRedirect(true);
                super.setViewPage(request.getContextPath() + "/admin/allproductList.sp");
            }
        }
    }
}