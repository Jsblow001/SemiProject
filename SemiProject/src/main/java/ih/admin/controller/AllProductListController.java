package ih.admin.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import sp.common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import ih.product.domain.ProductDTO;
import ih.product.model.*;

public class AllProductListController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        String category = request.getParameter("category"); // 필터용
        String str_currentShowPageNo = request.getParameter("currentShowPageNo");

        if(str_currentShowPageNo == null || str_currentShowPageNo.trim().isEmpty()) {
            str_currentShowPageNo = "1";
        }

        int currentShowPageNo = 1;
        try {
            currentShowPageNo = Integer.parseInt(str_currentShowPageNo);
        } catch(NumberFormatException e) {
            currentShowPageNo = 1;
        }

        int sizePerPage = 10; 
        int startRno = ((currentShowPageNo - 1) * sizePerPage) + 1;
        int endRno = startRno + sizePerPage - 1;

        ProductDAO pdao = new ProductDAO_imple();
        
        // DAO에 전달할 데이터 Map에 담기
        Map<String, String> paraMap = new HashMap<>();
        paraMap.put("category", category); // "1", "2" 또는 null
        paraMap.put("startRno", String.valueOf(startRno));
        paraMap.put("endRno", String.valueOf(endRno));

        // 페이징이 적용된 관리자용 전체 상품 리스트 조회
        List<ProductDTO> productList = pdao.selectAllProductPaging(paraMap);
        
        // 페이지바를 만들기 위한 해당 카테고리의 총 상품 개수
        int totalCount = pdao.getTotalProductCount(category);

        // 관리자 전용 페이지바 생성 
        String pageBar = pdao.getAdminPageBar(currentShowPageNo, sizePerPage, totalCount, category);

        request.setAttribute("productList", productList);
        request.setAttribute("currentCategory", category); // 필터 버튼 active용
        request.setAttribute("pageBar", pageBar); // 페이지바 출력용
        
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/ih_admin/allproductList.jsp");
    }
}