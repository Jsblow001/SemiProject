package hk.admin.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import sp.common.controller.AbstractController;
import hk.member.domain.MemberDTO;
import hk.member.model.MemberDAO;
import hk.member.model.MemberDAO_imple;

public class AdminMemberDetailController extends AbstractController {

    private MemberDAO mdao = new MemberDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");

        // ===============================
        // 관리자 로그인 체크
        // ===============================
        if (loginuser == null || !"admin".equals(loginuser.getUserid())) {
            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/login.sp");
            return;
        }

        // ===============================
        // 파라미터
        // ===============================
        String userid = request.getParameter("userid");

        if (userid == null || userid.trim().isEmpty()) {
            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/admin/memberList.sp");
            return;
        }

        // ===============================
        // DAO
        // ===============================
        MemberDTO member = mdao.selectOneMember(userid);

        if (member == null) {
            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/admin/memberList.sp");
            return;
        }

        // ===============================
        // request 저장
        // ===============================
        request.setAttribute("member", member);

        // ===============================
        // JSP 이동
        // ===============================
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/hk_admin/memberDetail.jsp");
    }
}
