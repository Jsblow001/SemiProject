package js.admin.visitor;

import hk.member.domain.MemberDTO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import sp.common.controller.AbstractController;
import js.admin.visitor.model.VisitorDAO;
import js.admin.visitor.model.VisitorDAO_imple;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class VisitorStatsController extends AbstractController {

    private VisitorDAO vdao = new VisitorDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        	
        // 1. 관리자 로그인 여부 체크
        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");

        if (loginuser == null || !"admin".equals(loginuser.getUserid())) {
            String message = (loginuser == null) ? "관리자 로그인이 필요합니다." : "관리자만 접근할 수 있는 페이지입니다.";
            String loc = (loginuser == null) ? request.getContextPath() + "/login.sp?mode=admin" : request.getContextPath() + "/index.sp";

            request.setAttribute("message", message);
            request.setAttribute("loc", loc);

            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // 2. 관리자 인증 통과 시 - 상단 카드용 숫자 데이터 조회
        int todayTotal = vdao.getVisitorCount("total", "today");
        int yesterdayTotal = vdao.getVisitorCount("total", "yesterday");
        int todayMember = vdao.getVisitorCount("member", "today");
        int yesterdayMember = vdao.getVisitorCount("member", "yesterday");
        int todayNewMember = vdao.getTodayNewMember();
        int currentLoginUser = vdao.getLiveUserCount(); 
        
        // [추가] 이탈률 데이터 조회
        double bounceRate = vdao.getBounceRate();
        
        // 3. 그래프용 데이터 조회 (최근 7일 통계)
        List<Integer> weeklyTotal = vdao.getWeeklyStats("total");
        List<Integer> weeklyMember = vdao.getWeeklyStats("member");
        List<Integer> weeklyGuest = vdao.getWeeklyStats("guest");

        // Null 체크 및 기본값 보장
        if(weeklyTotal == null || weeklyTotal.isEmpty()) 
            weeklyTotal = Stream.generate(() -> 0).limit(7).collect(Collectors.toList());
        if(weeklyMember == null || weeklyMember.isEmpty()) 
            weeklyMember = Stream.generate(() -> 0).limit(7).collect(Collectors.toList());
        if(weeklyGuest == null || weeklyGuest.isEmpty()) 
            weeklyGuest = Stream.generate(() -> 0).limit(7).collect(Collectors.toList());

        // 4. 날짜 라벨 생성
        List<String> chartLabels = new ArrayList<>();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM/dd");
        for (int i = 6; i >= 0; i--) {
            chartLabels.add("'" + LocalDate.now().minusDays(i).format(formatter) + "'");
        }

        // 5. JSP로 데이터 전달
        request.setAttribute("todayTotal", todayTotal);
        request.setAttribute("yesterdayTotal", yesterdayTotal);
        request.setAttribute("todayMember", todayMember);
        request.setAttribute("yesterdayMember", yesterdayMember);
        request.setAttribute("todayGuest", todayTotal - todayMember);
        request.setAttribute("yesterdayGuest", yesterdayTotal - yesterdayMember);
        request.setAttribute("todayNewMember", todayNewMember);
        request.setAttribute("currentLoginUser", currentLoginUser);
        
        // [추가] 이탈률 전달 (소수점 첫째 자리까지 포맷팅)
        request.setAttribute("bounceRate", String.format("%.1f", bounceRate));

        request.setAttribute("weeklyTotal", weeklyTotal);
        request.setAttribute("weeklyMember", weeklyMember);
        request.setAttribute("weeklyGuest", weeklyGuest);
        request.setAttribute("chartLabels", chartLabels);

        // 6. 뷰 페이지 설정
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/js_admin/visitor.jsp");
    }
}