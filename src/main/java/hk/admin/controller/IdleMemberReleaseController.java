package hk.admin.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import sp.common.controller.AbstractController;

import hk.member.model.MemberDAO;
import hk.member.model.MemberDAO_imple;

public class IdleMemberReleaseController extends AbstractController {

    private MemberDAO mdao = new MemberDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        // POST만 처리하도록 막아두기 (안전)
        if(!"POST".equalsIgnoreCase(request.getMethod())) {
            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/admin/idleMember.sp");
            return;
        }

        // 체크박스 name="userid"
        String[] useridArr = request.getParameterValues("userid");

        if(useridArr == null || useridArr.length == 0) {
            request.setAttribute("message", "휴면 해제할 회원을 선택하세요.");
            request.setAttribute("loc", request.getContextPath() + "/admin/idleMember.sp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // 일괄 휴면 해제 처리
        int releaseCnt = mdao.idleReleaseMany(useridArr);

        request.setAttribute("message", "총 " + releaseCnt + "명의 휴면을 해제했습니다.");
        request.setAttribute("loc", request.getContextPath() + "/admin/idleMember.sp");

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/msg.jsp");
    }
}
