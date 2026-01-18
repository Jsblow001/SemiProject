package jh.review.controller;

import java.io.PrintWriter;

import hk.member.domain.MemberDTO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import sp.common.controller.AbstractController;
import jh.review.domain.ReviewDTO;
import jh.review.model.ReviewDAO;
import jh.review.model.ReviewDAO_imple;

public class ReviewViewController extends AbstractController {

    private ReviewDAO rdao = new ReviewDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession();

        // ===== 1) 목록으로 돌아가기 URL 처리 (reviews.sp에서 들어온 경우만 저장) =====
        String refererHeader = request.getHeader("referer");
        boolean fromReviews = (refererHeader != null && refererHeader.contains("/reviews.sp"));

        if(fromReviews) {
            session.setAttribute("review_referer", refererHeader);
        }

        String saved = (String) session.getAttribute("review_referer");
        String defaultListUrl = request.getContextPath() + "/reviews.sp";
        String goListUrl = (saved != null && !saved.isBlank()) ? saved : defaultListUrl;

        request.setAttribute("referer", goListUrl);

        // ===== 2) 파라미터 =====
        String reviewIdStr = request.getParameter("reviewId");
        if(reviewIdStr == null || reviewIdStr.isBlank()) {
            sendAlertAndGo(response, "잘못된 접근입니다.", defaultListUrl);
            return;
        }

        long reviewId = Long.parseLong(reviewIdStr);

        // ===== 3) 상세 조회(사진 전체 포함) =====
        ReviewDTO review = rdao.selectReviewDetail(reviewId); // 아래 DAO 메서드 추가/사용
        if(review == null) {
            sendAlertAndGo(response, "존재하지 않는 리뷰입니다.", defaultListUrl);
            return;
        }

        // ===== 4) 권한(삭제 버튼 표시용) =====
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");

        String loginId = (loginuser != null ? loginuser.getUserid() : null);
        boolean isAdmin = (loginId != null && "admin".equalsIgnoreCase(loginId));
        boolean isOwner = (loginId != null && loginId.equals(review.getFk_member_id()));

        request.setAttribute("isAdmin", isAdmin);
        request.setAttribute("isOwner", isOwner);
        request.setAttribute("review", review);
        
        // ===== 5) 권한(관리자만 가능한 신고목록 보기) =====
        if(isAdmin) {
            request.setAttribute("reportList", rdao.selectReviewReports(review.getReview_id()));
        }
        request.setAttribute("isAdmin", isAdmin);

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/jh_review/review_view.jsp");
    }

    private void sendAlertAndGo(HttpServletResponse response, String msg, String goUrl) throws Exception {
        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.println("<script>");
        out.println("alert('" + msg.replace("'", "\\'") + "');");
        out.println("location.href='" + goUrl + "';");
        out.println("</script>");
        out.flush();
    }
}
