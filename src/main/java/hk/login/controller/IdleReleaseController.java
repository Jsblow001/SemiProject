package hk.login.controller;

import sp.common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import hk.member.model.MemberDAO;
import hk.member.model.MemberDAO_imple;

public class IdleReleaseController extends AbstractController {

    private MemberDAO mdao = new MemberDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        String method = request.getMethod();

        // 직접 URL로 GET 치는 경우 막기
        if(!"POST".equalsIgnoreCase(method)) {
            request.setAttribute("message", "비정상적인 접근입니다.");
            request.setAttribute("loc", request.getContextPath() + "/login.sp");
           
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        String userid = request.getParameter("userid");

        int n = mdao.idleRelease(userid); // idle=0 업데이트

        if(n == 1) {
            request.setAttribute("message", "휴면 해제가 완료되었습니다. 다시 로그인해주세요.");
            request.setAttribute("loc", request.getContextPath() + "/login.sp");
        }
        else {
            request.setAttribute("message", "휴면 해제에 실패했습니다.");
            request.setAttribute("loc", request.getContextPath() + "/login.sp");
        }

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/msg.jsp");
    }
}
