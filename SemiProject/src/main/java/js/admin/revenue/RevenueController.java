package js.admin.revenue;

import java.util.List;
import java.util.Map;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import sp.common.controller.AbstractController;
import hk.member.domain.MemberDTO;
import js.admin.model.AdminDAO;
import js.admin.model.AdminDAO_imple;

public class RevenueController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        // 1. 관리자 로그인 여부 체크 (사용자 제공 스타일 반영)
        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");

        // 로그인 안 했거나 관리자 계정("admin")이 아니면 접근 차단
        if (loginuser == null || !"admin".equals(loginuser.getUserid())) {
            String message = (loginuser == null) ? "관리자 로그인이 필요합니다." : "관리자만 접근할 수 있는 페이지입니다.";
            String loc = (loginuser == null) ? request.getContextPath() + "/login.sp?mode=admin" : request.getContextPath() + "/index.sp";

            request.setAttribute("message", message);
            request.setAttribute("loc", loc);

            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // 2. 수익 데이터 조회를 위한 DAO 객체 생성
        AdminDAO adao = new AdminDAO_imple();

        // 3. 유튜브 스튜디오 대시보드에 필요한 데이터 가져오기
        
        // A. 상단 요약 정보 (총 수익, 결제 건수 등) 조회
        // 결과 예: {total_revenue: "12540000", order_count: "842", avg_revenue: "14800"}
        Map<String, String> summaryMap = adao.getRevenueSummary();
        
        // B. 차트용 일별 수익 데이터 조회 (최근 28일)
        // 리스트 형태: [{day: "2023-10-01", revenue: "450000"}, ...]
        List<Map<String, String>> revenueList = adao.getDailyRevenueChart();
        
        // C. 최근 수익 거래 내역 (하단 테이블용) 조회
        List<Map<String, String>> recentOrderList = adao.getRecentRevenueOrders();

        // 4. 조회한 데이터를 request 영역에 저장하여 JSP로 전달
        request.setAttribute("summaryMap", summaryMap);
        request.setAttribute("revenueList", revenueList);
        request.setAttribute("recentOrderList", recentOrderList);

        // 5. 수익 관리 전용 뷰 페이지로 이동
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/admin/revenue.jsp");
    }
}