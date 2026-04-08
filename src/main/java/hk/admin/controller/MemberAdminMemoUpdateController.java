package hk.admin.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import sp.common.controller.AbstractController;

import hk.member.model.MemberDAO;
import hk.member.model.MemberDAO_imple;

public class MemberAdminMemoUpdateController extends AbstractController {

    private MemberDAO mdao = new MemberDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        if(!"POST".equalsIgnoreCase(request.getMethod())) {
            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/admin/memberList.sp");
            return;
        }

        String userid = request.getParameter("userid");
        String adminMemo = request.getParameter("adminMemo");

        if(userid == null || userid.trim().isEmpty()) {
            request.setAttribute("message", "잘못된 접근입니다.");
            request.setAttribute("loc", request.getContextPath() + "/admin/memberList.sp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        if(adminMemo == null) adminMemo = "";
        adminMemo = adminMemo.trim();

        // 200자 제한 (서버에서도 컷)
        if(adminMemo.length() > 200) {
            adminMemo = adminMemo.substring(0, 200);
        }

        int n = mdao.updateAdminMemo(userid, adminMemo);

        if(n == 1) {
            request.setAttribute("message", "관리자 메모가 저장되었습니다.");
        } else {
            request.setAttribute("message", "메모 저장에 실패했습니다.");
        }

        request.setAttribute("loc", request.getContextPath() + "/admin/memberDetail.sp?userid=" + userid);

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/msg.jsp");
    }
}
