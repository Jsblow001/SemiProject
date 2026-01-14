package js.admin.visitor;

import hk.member.domain.MemberDTO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import sp.common.controller.AbstractController;
import js.admin.visitor.model.VisitorDAO;
import js.admin.visitor.model.VisitorDAO_imple;
import org.json.JSONObject; // JSON 라이브러리 추가 필요

public class VisitorCheckController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        HttpSession session = request.getSession();
        String ip = request.getRemoteAddr();
        VisitorDAO vdao = new VisitorDAO_imple();

        // 1. 방문 기록 로직 (기존 유지)
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");
        String memberId = (loginuser != null) ? loginuser.getUserid() : null;

        if (session.getAttribute("isVisited") == null) {
            vdao.insertVisitor(ip, memberId); 
            session.setAttribute("isVisited", true);
        } else {
            vdao.updateLastAccess(ip); 
        }

        // 2. [체크!] 탭 전환용 AJAX 요청인지 확인
        String mode = request.getParameter("mode"); // "total", "member", "guest"

        if (mode != null && !mode.isEmpty()) {
            // --- [수정] 탭 클릭 시 JSON 응답 ---
            JSONObject json = new JSONObject();
            
            // 공통 데이터
            json.put("liveUserCount", vdao.getLiveUserCount());
            json.put("weeklyData", vdao.getWeeklyStats(mode));
            
            // 모드별 상세 수치
            if ("total".equals(mode)) {
                json.put("today", vdao.getVisitorCount("total", "today"));
                json.put("yesterday", vdao.getVisitorCount("total", "yesterday"));
            } else if ("member".equals(mode)) {
                json.put("today", vdao.getVisitorCount("member", "today"));
                json.put("yesterday", vdao.getVisitorCount("member", "yesterday"));
                json.put("newMember", vdao.getTodayNewMember());
            } else if ("guest".equals(mode)) {
                // 뺄셈(tTotal - tMember) 대신 DAO의 메서드를 직접 호출
                json.put("today", vdao.getVisitorCount("guest", "today")); 
                json.put("yesterday", vdao.getVisitorCount("guest", "yesterday"));
                json.put("bounceRate", String.format("%.1f", vdao.getBounceRate()));
            }

            response.setContentType("application/json; charset=UTF-8");
            response.getWriter().print(json.toString());
            
        } else {
            // --- [기존] 30초 주기 실시간 숫자만 응답 ---
            int liveUserCount = vdao.getLiveUserCount();
            response.setContentType("text/plain");
            response.getWriter().print(liveUserCount);
        }

        super.setRedirect(false);
        super.setViewPage(null); 
    }
}