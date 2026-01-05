package ih.admin.controller;

import sp.common.controller.AbstractController;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import ih.product.domain.ProductDTO;
import ih.product.model.*;
import java.io.File;

// 파일을 처리하기 위한 설정
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 15    // 15MB
)
public class ProductUpdateEndController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        if(!"POST".equalsIgnoreCase(request.getMethod())) {
            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/ih_admin/allProductList.sp");
            return;
        }

        // 일반 텍스트 데이터 받기
        int product_id = Integer.parseInt(request.getParameter("product_id"));
        int fk_category_id = Integer.parseInt(request.getParameter("fk_category_id"));
        String product_name = request.getParameter("product_name");
        int sale_price = Integer.parseInt(request.getParameter("sale_price"));
        int stock = Integer.parseInt(request.getParameter("stock"));
        String product_description = request.getParameter("product_description");
        String old_pimage = request.getParameter("old_pimage");

        // 파일 데이터 처리
        Part part = request.getPart("pimage"); 
        String final_pimage = old_pimage; // 기본값은 기존 이미지

        // 새로운 파일을 선택했는지 확인
        String contentDisposition = part.getHeader("content-disposition");
        String fileName = "";
        for (String temp : contentDisposition.split(";")) {
            if (temp.trim().startsWith("filename")) {
                fileName = temp.substring(temp.indexOf("=") + 2, temp.length() - 1);
            }
        }

        // 새로운 파일이 업로드된 경우
        if (fileName != null && !fileName.isEmpty()) {
            String uploadPath = request.getServletContext().getRealPath("/img");
            
            // 파일명 중복 방지 - 현재시간 추가
            final_pimage = System.currentTimeMillis() + "_" + fileName;
            part.write(uploadPath + File.separator + final_pimage);
            
        }

        // DTO
        ProductDTO pdto = new ProductDTO();
        pdto.setProduct_id(product_id);
        pdto.setFk_category_id(fk_category_id);
        pdto.setProduct_name(product_name);
        pdto.setSale_price(sale_price);
        pdto.setStock(stock);
        pdto.setProduct_description(product_description);
        pdto.setPimage(final_pimage);

        // DB 업데이트
        ProductDAO pdao = new ProductDAO_imple();
        int result = pdao.updateProduct(pdto);
        
        if(result == 1) {
            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/admin/allproductList.sp");      
        } else {
        	
        }
    }
}