package ih.product.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
        
        // 카테고리 정보 가져오기
        String categoryP = request.getParameter("category");
        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");
        
        String categoryId = "1"; 
        String categoryName = "SUNGLASSES"; 
        String userid = (loginuser != null) ? loginuser.getUserid() : null;
        
        if(categoryP != null && !categoryP.trim().isEmpty()) {
            switch (categoryP.toLowerCase()) {
                case "sunglasses": case "1":
                    categoryId = "1"; categoryName = "SUNGLASSES"; break;
                case "eyeglasses": case "2":
                    categoryId = "2"; categoryName = "EYEGLASSES"; break;
                case "accessory": case "3":
                    categoryId = "3"; categoryName = "ACCESSORY"; break;
                case "collaboration": case "4":
                    categoryId = "4"; categoryName = "COLLABORATION"; break;
                default:
                    categoryId = "1"; categoryName = "SUNGLASSES"; break;
            }
        }

        // --- 페이징 처리 시작 --- //
        String str_currentShowPageNo = request.getParameter("currentShowPageNo");
        if(str_currentShowPageNo == null) {
            str_currentShowPageNo = "1"; // 초기 페이지는 1
        }

        int currentShowPageNo = 1;
        try {
            currentShowPageNo = Integer.parseInt(str_currentShowPageNo);
        } catch(NumberFormatException e) {
            currentShowPageNo = 1;
        }

        int sizePerPage = 8; // 한 페이지당 8개 출력
        int startRno = ((currentShowPageNo - 1) * sizePerPage) + 1;
        int endRno = startRno + sizePerPage - 1;

        // DAO 연결
        ProductDAO pdao = new ProductDAO_imple();
        
        // 검색 조건 Map에 담기
        Map<String, String> paraMap = new HashMap<>();
        paraMap.put("categoryId", categoryId);
        paraMap.put("userid", userid);
        paraMap.put("startRno", String.valueOf(startRno));
        paraMap.put("endRno", String.valueOf(endRno));

        // 페이징된 상품 목록 가져오기
        List<ProductDTO> productList = pdao.selectProductByCategoryPaging(paraMap);
        
        // 해당 카테고리의 총 상품 개수 가져오기 (페이지바 생성용)
        int totalCount = pdao.getTotalCountByCategory(categoryId);
        
        //  페이지바 생성
        String pageBar = pdao.getPageBar(currentShowPageNo, sizePerPage, totalCount, categoryId);
        
        // --- 페이징 처리 끝 --- //


        request.setAttribute("productList", productList);
        request.setAttribute("category", categoryName);
        request.setAttribute("currentCategory", categoryId);
        request.setAttribute("pageBar", pageBar); // 페이지바 추가

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/ih_product/product.jsp"); 
    }
}