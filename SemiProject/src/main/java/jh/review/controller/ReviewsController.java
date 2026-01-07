package jh.review.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import sp.common.controller.AbstractController;
import jh.review.domain.ReviewDTO;
import jh.review.model.ReviewDAO;
import jh.review.model.ReviewDAO_imple;

public class ReviewsController extends AbstractController {

    private ReviewDAO rdao = new ReviewDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        if (!"GET".equalsIgnoreCase(request.getMethod())) {
            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/error.sp");
            return;
        }

        // ===== 파라미터 =====
        String sort = request.getParameter("sort");           // recent | rating
        String searchWord = request.getParameter("searchWord");
        String currentShowPageNo = request.getParameter("currentShowPageNo");

        if (sort == null || sort.isBlank()) sort = "recent";
        if (searchWord == null) searchWord = "";
        searchWord = searchWord.trim();

        if (currentShowPageNo == null || currentShowPageNo.isBlank()) currentShowPageNo = "1";

        // ===== 고정: 페이지당 5개 =====
        String sizePerPage = "5";

        Map<String, String> paraMap = new HashMap<>();
        paraMap.put("sort", sort);
        paraMap.put("searchWord", searchWord);
        paraMap.put("currentShowPageNo", currentShowPageNo);
        paraMap.put("sizePerPage", sizePerPage);

        // ===== 리스트/페이징 =====
        int totalCount = rdao.getTotalReviewCount(paraMap);
        int totalPage = (int) Math.ceil((double) totalCount / Integer.parseInt(sizePerPage));

        int nCurrentPage = Integer.parseInt(currentShowPageNo);
        if (nCurrentPage < 1) nCurrentPage = 1;
        if (totalPage > 0 && nCurrentPage > totalPage) nCurrentPage = totalPage;

        paraMap.put("currentShowPageNo", String.valueOf(nCurrentPage));

        List<ReviewDTO> allReviews = rdao.selectReviewListPaging(paraMap);

        // ===== JSP로 =====
        request.setAttribute("allReviews", allReviews);
        request.setAttribute("totalReviews", totalCount);
        request.setAttribute("sort", sort);
        request.setAttribute("searchWord", searchWord);
        request.setAttribute("currentShowPageNo", nCurrentPage);
        request.setAttribute("totalPage", totalPage);

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/jh_views/reviews.jsp");
    }
}
