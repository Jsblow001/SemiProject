package js.admin.revenue;

import java.util.List;
import java.util.Map;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import sp.common.controller.AbstractController;
import hk.member.domain.MemberDTO;

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
        
        // 수익 관리 전용 뷰 페이지로 이동
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/js_admin/revenue.jsp");
    }
}