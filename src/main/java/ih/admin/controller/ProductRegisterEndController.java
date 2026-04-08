package ih.admin.controller;

import java.io.File;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import sp.common.controller.AbstractController;
import ih.product.domain.ProductDTO;
import ih.product.model.*;

public class ProductRegisterEndController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        // 저장 경로 설정
        String uploadDir = request.getServletContext().getRealPath("/img");
        System.out.println(uploadDir);
        
        // 로컬 개발용 폴더에도
        String devImgDir = "C:\\git\\SemiProject\\SemiProject\\src\\main\\webapp\\img"; // 로컬 개발용
        

        // 파일 데이터 처리 
        Part pimagePart = request.getPart("pimage"); 
        String originalFileName = pimagePart.getSubmittedFileName(); 
        String savedFileName = "";

        if (originalFileName != null && !originalFileName.isEmpty()) {
            savedFileName = System.nanoTime() + "_" + originalFileName;
            // 1) 실행 중 웹앱 경로에 저장
            File dir = new File(uploadDir);
            if(!dir.exists()) dir.mkdirs(); 
            pimagePart.write(uploadDir + File.separator + savedFileName);
            
            // 2) (로컬 개발용) 소스 폴더에도 복사 저장
            File devDir = new File(devImgDir);
            if(!devDir.exists()) devDir.mkdirs();
            
            java.nio.file.Path from = java.nio.file.Paths.get(uploadDir, savedFileName);
            java.nio.file.Path to   = java.nio.file.Paths.get(devImgDir, savedFileName);

            java.nio.file.Files.copy(from, to, java.nio.file.StandardCopyOption.REPLACE_EXISTING);
        }

        // 데이터 읽기
        String product_name = request.getParameter("product_name");
        int fk_category_id = Integer.parseInt(request.getParameter("fk_category_id"));
        int sale_price = Integer.parseInt(request.getParameter("sale_price"));
        int list_price = Integer.parseInt(request.getParameter("list_price"));
        
        int stock = 0; 
        if(request.getParameter("stock") != null && !request.getParameter("stock").isEmpty()) {
            stock = Integer.parseInt(request.getParameter("stock"));
        } else {
            stock = 10; 
        }

        int fk_spec_id = Integer.parseInt(request.getParameter("fk_spec_id")); // JSP에서 넘어온 값 사용
        String product_description = request.getParameter("product_description");

        // DTO
        ProductDTO pdto = new ProductDTO();
        pdto.setProduct_name(product_name);
        pdto.setFk_category_id(fk_category_id);
        pdto.setSale_price(sale_price);
        pdto.setList_price(list_price);
        pdto.setStock(stock);
        pdto.setFk_spec_id(fk_spec_id);
        pdto.setProduct_description(product_description);
        pdto.setPimage(savedFileName); 

        // DB Insert (DAO 호출)
        ProductDAO pdao = new ProductDAO_imple();
        int n = pdao.productInsert(pdto);

        // 결과 처리 (Alert 메시지 띄우기)
        String message = "";
        String loc = "";

        if(n == 1) {
            message = "상품 등록을 성공하였습니다.";
            loc = request.getContextPath() + "/admin/allproductList.sp"; // 상품목록 페이지로 이동
        } else {
            message = "상품 등록에 실패하였습니다.";
            loc = "javascript:history.back()"; // 이전 등록 폼으로 가기
        }

        request.setAttribute("message", message);
        request.setAttribute("loc", loc);

        super.setRedirect(false); // forward 방식 (request 담긴 값 유지)
        super.setViewPage("/WEB-INF/msg.jsp"); 
    }
}