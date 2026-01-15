package jh.review.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import hk.member.domain.MemberDTO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

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
        String midSort = request.getParameter("midSort");

        if(midSort == null || midSort.isBlank()) midSort = "reviewCount";
        request.setAttribute("midSort", midSort);

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

        // ===== 로그인 유저 (wish 표시용) =====
        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");
        String userid = (loginuser != null) ? loginuser.getUserid() : null;

        // ===== 리스트/페이징 =====
        int totalCount = rdao.getTotalReviewCount(paraMap);
        int totalPage = (int) Math.ceil((double) totalCount / Integer.parseInt(sizePerPage));

        int nCurrentPage = Integer.parseInt(currentShowPageNo);
        if (nCurrentPage < 1) nCurrentPage = 1;
        if (totalPage > 0 && nCurrentPage > totalPage) nCurrentPage = totalPage;

        paraMap.put("currentShowPageNo", String.valueOf(nCurrentPage));

        List<ReviewDTO> allReviews = rdao.selectReviewListPaging(paraMap);

        // ===== midrank =====
        int limit = 4;

        request.setAttribute("allReviews", allReviews);
        request.setAttribute("totalReviews", totalCount);
        request.setAttribute("sort", sort);
        request.setAttribute("searchWord", searchWord);
        request.setAttribute("currentShowPageNo", nCurrentPage);
        request.setAttribute("totalPage", totalPage);

        request.setAttribute("mid_reviewCount", rdao.selectMidRankProducts("reviewCount", limit, userid));
        request.setAttribute("mid_recentSales", rdao.selectMidRankProducts("recentSales", limit, userid)); // ✅ 최근 30일 판매량
        request.setAttribute("mid_avgRating",  rdao.selectMidRankProducts("avgRating",  limit, userid));
        request.setAttribute("mid_newProduct", rdao.selectMidRankProducts("newProduct", limit, userid));

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/jh_views/reviews.jsp");
    }
}
