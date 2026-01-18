package jh.admin.review.controller;

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

public class AdminReviewManageController extends AbstractController {

    private ReviewDAO rdao = new ReviewDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        // ✅ 관리자 체크
        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");

        boolean isAdmin = (loginuser != null && "admin".equalsIgnoreCase(loginuser.getUserid()));
        if(!isAdmin) {
            request.setAttribute("message", "관리자만 접근 가능합니다.");
            request.setAttribute("loc", request.getContextPath() + "/index.sp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // ✅ view 선택: unanswered(미답변) / reported(신고)
        String view = request.getParameter("view");
        if(view == null || view.isBlank()) view = "unanswered";

        // ✅ 페이지 번호
        String currentShowPageNo = request.getParameter("currentShowPageNo");
        if(currentShowPageNo == null || currentShowPageNo.isBlank()) currentShowPageNo = "1";

        int nCurrentPage = Integer.parseInt(currentShowPageNo);
        if(nCurrentPage < 1) nCurrentPage = 1;

        int sizePerPage = 10; // 관리자 목록은 10개가 보기 좋음

        int totalCount = 0;
        int totalPage = 0;

        Map<String, String> paraMap = new HashMap<>();
        paraMap.put("currentShowPageNo", String.valueOf(nCurrentPage));
        paraMap.put("sizePerPage", String.valueOf(sizePerPage));

        // ✅ 목록 조회
        if("reported".equals(view)) {

            totalCount = rdao.getTotalReportedReviewCount();
            totalPage = (int)Math.ceil((double)totalCount / sizePerPage);

            if(totalPage > 0 && nCurrentPage > totalPage) nCurrentPage = totalPage;
            paraMap.put("currentShowPageNo", String.valueOf(nCurrentPage));

            List<Map<String,String>> reportedList = rdao.selectReportedReviewPaging(paraMap);
            request.setAttribute("reportedList", reportedList);

        } else {

            totalCount = rdao.getTotalUnansweredReviewCount();
            totalPage = (int)Math.ceil((double)totalCount / sizePerPage);

            if(totalPage > 0 && nCurrentPage > totalPage) nCurrentPage = totalPage;
            paraMap.put("currentShowPageNo", String.valueOf(nCurrentPage));

            List<ReviewDTO> unansweredList = rdao.selectUnansweredReviewPaging(paraMap);
            request.setAttribute("unansweredList", unansweredList);
        }

        // ✅ 10블록 페이지네이션
        int blockSize = 10;
        int startPage = ((nCurrentPage - 1) / blockSize) * blockSize + 1;
        int endPage = startPage + blockSize - 1;
        if(endPage > totalPage) endPage = totalPage;

        request.setAttribute("view", view);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("totalPage", totalPage);
        request.setAttribute("currentShowPageNo", nCurrentPage);
        request.setAttribute("startPage", startPage);
        request.setAttribute("endPage", endPage);

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/jh_admin/review/adminReviewManage.jsp");
    }
}
