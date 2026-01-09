package jh.product.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import sp.common.controller.AbstractController;

public class ProductSearchResultController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        // q 파라미터는 JSP에서 param.q로 사용하니 그대로 포워딩
        super.setRedirect(false);

        // ✅ 너 JSP 실제 경로로 수정
        super.setViewPage("/WEB-INF/jh_productSearchResult.jsp");
    }
}
