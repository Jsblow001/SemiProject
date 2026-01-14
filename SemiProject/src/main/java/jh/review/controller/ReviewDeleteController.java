package jh.review.controller;

import java.io.File;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;

import hk.member.domain.MemberDTO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import sp.common.controller.AbstractController;
import jh.review.domain.ReviewDTO;
import jh.review.model.ReviewDAO;
import jh.review.model.ReviewDAO_imple;

public class ReviewDeleteController extends AbstractController {

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
            request.setAttribute("loc", request.getContextPath() + "/login.sp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        String reviewIdStr = request.getParameter("reviewId");
        if(reviewIdStr == null || reviewIdStr.isBlank()) {
            request.setAttribute("message", "리뷰 번호가 없습니다.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        long reviewId = Long.parseLong(reviewIdStr);

        // 3) 원글 조회 + 권한 확인
        ReviewDTO origin = rdao.selectReviewOne(reviewId); // 이미 있는 메서드면 그걸로 교체
        if(origin == null) {
            request.setAttribute("message", "존재하지 않는 리뷰입니다.");
            request.setAttribute("loc", request.getContextPath() + "/reviews.sp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        String loginId = loginuser.getUserid();
        boolean isAdmin  = "admin".equalsIgnoreCase(loginId);
        boolean isWriter = loginId.equals(origin.getFk_member_id());

        if(!isAdmin && !isWriter) {
            request.setAttribute("message", "삭제 권한이 없습니다.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // 4) 업로드 폴더
        String uploadDir = request.getServletContext().getRealPath("/img/review");
        String devImgDir = "C:\\git\\SemiProject\\SemiProject\\src\\main\\webapp\\img\\review"; // 너 환경(있으면)

        Connection conn = null;
        List<String> filenames = new ArrayList<>();

        try {
            conn = rdao.getConnection();
            conn.setAutoCommit(false);

            // (1) 디스크 삭제를 위해 파일명 먼저 확보
            filenames = rdao.selectReviewImageFilenames(conn, reviewId);

            // (2) 관리자 댓글 일괄 삭제
            rdao.deleteReviewComments(conn, reviewId);

            // (3) 이미지 레코드 삭제
            rdao.deleteReviewImages(conn, reviewId);

            // (4) 리뷰 삭제
            int n = rdao.deleteReview(conn, reviewId);
            if(n != 1) {
                conn.rollback();
                request.setAttribute("message", "리뷰 삭제 실패");
                request.setAttribute("loc", "javascript:history.back()");
                super.setRedirect(false);
                super.setViewPage("/WEB-INF/msg.jsp");
                return;
            }

            conn.commit();

            // (5) 커밋 후 디스크 파일 삭제
            for(String fn : filenames) {
                if(fn == null || fn.isBlank()) continue;
                new File(uploadDir, fn).delete();
                new File(devImgDir, fn).delete();
            }

            request.setAttribute("message", "리뷰가 삭제되었습니다.");
            request.setAttribute("loc", request.getContextPath() + "/reviews.sp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");

        } catch(Exception e) {
            if(conn != null) try { conn.rollback(); } catch(Exception ignore) {}
            e.printStackTrace();
            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/error.sp");
        } finally {
            if(conn != null) try { conn.setAutoCommit(true); conn.close(); } catch(Exception ignore) {}
        }
    }
}
