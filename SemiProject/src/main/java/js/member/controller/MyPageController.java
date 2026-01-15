package js.member.controller;

import sp.common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jh.review.domain.ReviewDTO;
import jh.review.model.ReviewDAO;
import jh.review.model.ReviewDAO_imple;

import java.time.LocalDate;
import java.util.List;

import hk.member.domain.MemberDTO;
import hk.order.domain.OrderDTO;
import hk.order.model.OrderDAO;
import hk.order.model.OrderDAO_imple;
import js.admin.memberGradeList.model.GradeListDAO;
import js.admin.memberGradeList.model.GradeListDAO_imple;

public class MyPageController extends AbstractController {

    private OrderDAO odao = new OrderDAO_imple();
    private GradeListDAO gdao = new GradeListDAO_imple(); // 승급 관련 DAO 추가

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        /* 1. 로그인 여부 검사 */
        if (!super.checkLogin(request)) {
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/hk_login/loginSelect.jsp");
            return;
        }

        /* 2. 로그인 사용자 정보 */
        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");
        String userid = loginuser.getUserid();

        /* ========================================================
           3. 승급 진행 데이터 계산 (관리자 페이지 기준 연동)
        ======================================================== */
        // 사용자의 실시간 누적 구매액 조회 (관리자 페이지와 동일한 쿼리 사용)
        int totalAmount = gdao.getMemberTotalAmount(userid); 
        
        String gradeCode = loginuser.getGrade_code(); // "1"(일반), "2"(실버), "3"(골드)
        int threshold = 0;
        String nextGradeName = "";

        if ("1".equals(gradeCode)) {
            threshold = 500000;    // 일반 -> 실버 기준
            nextGradeName = "SILVER";
        } else if ("2".equals(gradeCode)) {
            threshold = 2000000;   // 실버 -> 골드 기준
            nextGradeName = "GOLD";
        }

        int neededAmount = threshold - totalAmount;
        if (neededAmount < 0) neededAmount = 0;

        int percent = 0;
        if (threshold > 0) {
            percent = (int) ((double) totalAmount / threshold * 100);
            if (percent > 100) percent = 100;
        }

        // JSP에서 사용할 변수 설정
        request.setAttribute("nextGradeName", nextGradeName);
        request.setAttribute("neededAmount", neededAmount);
        request.setAttribute("percent", percent);
        /* ======================================================== */

        /* 4. 최근 30일 주문 조회 */
        LocalDate today = LocalDate.now();
        String startDate = today.minusDays(30).toString();
        String endDate = today.toString();

        int startRow = 1;
        int endRow = 5;
        
        List<OrderDTO> recentOrderList = odao.selectMyOrderList(userid, null, startDate, endDate, startRow, endRow);
        
        /* ===============================
         4-1. 최근 5개 리뷰 조회, request 영역에 저장
	     =============================== */
	     ReviewDAO rdao = new ReviewDAO_imple();
	
	     List<ReviewDTO> recentReviewList = rdao.selectMyRecentReviews(userid, 5);
	     request.setAttribute("recentReviewList", recentReviewList);

        /* 5. request 영역에 저장 */
        request.setAttribute("recentOrderList", recentOrderList);

        /* 6. 마이페이지 이동 */
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/js_member/mypage.jsp");
    }
}