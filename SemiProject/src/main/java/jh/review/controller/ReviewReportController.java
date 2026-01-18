package jh.review.controller;

import org.json.simple.JSONObject;

import hk.member.domain.MemberDTO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import sp.common.controller.AbstractController;
import jh.review.model.ReviewDAO;
import jh.review.model.ReviewDAO_imple;

public class ReviewReportController extends AbstractController {

    private ReviewDAO rdao = new ReviewDAO_imple();

    @SuppressWarnings("unchecked")
    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        JSONObject json = new JSONObject();

        // ✅ POST만 허용
        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            json.put("ok", false);
            json.put("message", "비정상 접근입니다.");
            request.setAttribute("json", json.toString());
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/hk_admin/jsonview.jsp");
            return;
        }

        // ✅ 로그인 체크
        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");

        if (loginuser == null) {
            json.put("ok", false);
            json.put("message", "로그인 후 이용해주세요.");
            request.setAttribute("json", json.toString());
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/hk_admin/jsonview.jsp");
            return;
        }

        // ✅ 파라미터 받기
        String reviewIdStr = request.getParameter("reviewId");
        String reportContent = request.getParameter("reportContent");

        if (reportContent == null) reportContent = "";
        reportContent = reportContent.trim();

        // ✅ 유효성 체크
        long review_id = 0;
        try {
            review_id = Long.parseLong(reviewIdStr);
        } catch (Exception e) {
            json.put("ok", false);
            json.put("message", "잘못된 요청입니다.");
            request.setAttribute("json", json.toString());
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/hk_admin/jsonview.jsp");
            return;
        }

        if (reportContent.length() < 3) {
            json.put("ok", false);
            json.put("message", "신고 내용을 3자 이상 입력해주세요.");
            request.setAttribute("json", json.toString());
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/hk_admin/jsonview.jsp");
            return;
        }

        // ✅ DB insert
        String member_id = loginuser.getUserid(); // ⚠️ 너희 MemberDTO에 맞게 (getMember_id() 맞는지 확인)

        int n = 0;
        try {
            n = rdao.insertReviewReport(review_id, member_id, reportContent);
        } catch (Exception e) {
            e.printStackTrace();
        }

        if (n == 1) {
            json.put("ok", true);
        } else {
            json.put("ok", false);
            json.put("message", "신고 접수에 실패했습니다.");
        }

        request.setAttribute("json", json.toString());
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/hk_admin/jsonview.jsp");
    }
}
