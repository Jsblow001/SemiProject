package jh.review.controller;

import hk.member.domain.MemberDTO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import sp.common.controller.AbstractController;

import jh.review.model.ReviewDAO;
import jh.review.model.ReviewDAO_imple;

public class ReviewCommentWriteController extends AbstractController {

    private ReviewDAO rdao = new ReviewDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        // 1) POST만 허용
        if(!"POST".equalsIgnoreCase(request.getMethod())) {
            request.setAttribute("message", "비정상 접근입니다.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // 2) 로그인 체크
        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");
        if(loginuser == null) {
            request.setAttribute("message", "로그인이 필요합니다.");
            request.setAttribute("loc", request.getContextPath() + "/loginSelect.sp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // 3) 관리자만 가능
        String loginId = loginuser.getUserid();
        boolean isAdmin = "admin".equalsIgnoreCase(loginId);
        if(!isAdmin) {
            request.setAttribute("message", "관리자만 댓글을 작성할 수 있습니다.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // 4) 파라미터
        String reviewIdStr = request.getParameter("reviewId");
        String comment = request.getParameter("comment_content");
        String returnUrl = request.getParameter("returnUrl");

        if(returnUrl == null || returnUrl.isBlank()) {
            returnUrl = request.getContextPath() + "/reviews.sp";
        }

        if(reviewIdStr == null || reviewIdStr.isBlank() || comment == null || comment.trim().isBlank()) {
            request.setAttribute("message", "댓글 내용을 입력하세요.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        long reviewId = Long.parseLong(reviewIdStr);

        // 5) 댓글 저장(없으면 insert, 있으면 update)
        String adminId = loginuser.getUserid(); // 지금 admin 판별도 userid로 하고 있으니 그대로
        int n = rdao.upsertReviewComment(reviewId, adminId, comment.trim());


        if(n == 1) {
            request.setAttribute("message", "관리자 댓글이 저장되었습니다.");
            request.setAttribute("loc", returnUrl);
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
        }
        else {
            request.setAttribute("message", "댓글 저장 실패");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
        }
    }
}
