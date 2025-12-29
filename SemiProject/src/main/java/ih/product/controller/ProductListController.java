package ih.product.controller;

import java.util.List;
import sp.common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import ih.product.domain.ProductDTO;
import ih.product.model.*;

public class ProductListController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        // 1. 사용자가 클릭한 카테고리 정보 가져오기 (예: sunglasses, 1, eyeglasses 등)
        String categoryParam = request.getParameter("category");
        
        // 2. 오라클 ORA-01722 에러 방지를 위한 카테고리 ID 변환 (문자 -> 숫자ID)
        // DB의 FK_CATEGORY_ID가 NUMBER 타입이므로 숫자로 매핑해줘야 합니다.
        String categoryId = "1"; // 기본값 (sunglasses)
        String categoryName = "SUNGLASSES"; // 화면 출력용 이름
        
        if(categoryParam != null && !categoryParam.trim().isEmpty()) {
            switch (categoryParam.toLowerCase()) {
                case "sunglasses":
                case "1":
                    categoryId = "1";
                    categoryName = "SUNGLASSES";
                    break;
                case "eyeglasses":
                case "2":
                    categoryId = "2";
                    categoryName = "EYEGLASSES";
                    break;
                case "accessory":
                case "3":
                    categoryId = "3";
                    categoryName = "ACCESSORY";
                    break;
                case "collaboration":
                case "4":
                    categoryId = "4";
                    categoryName = "COLLABORATION";
                    break;
                default:
                    categoryId = "1";
                    categoryName = "SUNGLASSES";
                    break;
            }
        }

        // 3. DAO를 통해 실제 DB 데이터 가져오기
        ProductDAO pdao = new ProductDAO_imple();
        
        // 실제 숫자로 변환된 categoryId를 넘깁니다.
        List<ProductDTO> productList = pdao.selectProductByCategory(categoryId);
        
        // 4. JSP단에서 사용할 수 있도록 데이터를 request에 담기
        request.setAttribute("productList", productList);
        request.setAttribute("category", categoryName); // 화면 제목용 (예: SUNGLASSES)
        request.setAttribute("currentCategory", categoryId); // 혹시 모를 ID값 유지용

        // 5. 뷰 페이지 설정 및 이동 (Forward)
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/ih_product/product.jsp"); 
        
    }
}