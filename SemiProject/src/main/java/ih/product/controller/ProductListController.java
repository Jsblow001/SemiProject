package ih.product.controller;

import java.util.List;

import hk.member.domain.MemberDTO;
import sp.common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import ih.product.domain.ProductDTO;
import ih.product.model.*;

public class ProductListController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        // 사용자가 클릭한 카테고리 정보 가져오기
        String categoryP = request.getParameter("category");
        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");
        
        // 카테고리 ID 변환 (문자 -> 숫자ID)
        // DB의 FK_CATEGORY_ID NUMBER 타입이므로 숫자로 매핑
        String categoryId = "1"; // 기본값 (sunglasses)
        String categoryName = "SUNGLASSES"; // 화면 출력용 이름
        String userid = (loginuser != null) ? loginuser.getUserid() : null;
        
        if(categoryP != null && !categoryP.trim().isEmpty()) {
            switch (categoryP.toLowerCase()) {
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

        // DAO를 통해 실제 DB 데이터 가져오기
        ProductDAO pdao = new ProductDAO_imple();
        
        // 실제 숫자로 변환된 categoryId를 넘기기
        List<ProductDTO> productList = pdao.selectProductByCategory(categoryId, userid);
        
        // JSP단에서 사용할 수 있도록 데이터를 request에 담기
        request.setAttribute("productList", productList);
        request.setAttribute("category", categoryName); // 화면 제목용 (예: SUNGLASSES)
        request.setAttribute("currentCategory", categoryId); // 혹시 모를 ID값 유지용

        // 뷰 페이지 설정 및 이동 (Forward)
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/ih_product/product.jsp"); 
        
    }
}