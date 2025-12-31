package hk.admin.controller;

import sp.common.controller.AbstractController;
import hk.member.domain.MemberDTO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AdminController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	
        // ===============================
        // 관리자 로그인 여부 체크
        // ===============================
        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");

        // 로그인 안 했으면 접근 불가
        if (loginuser == null) {
        	System.out.println("메롱");
            request.setAttribute("message", "관리자 로그인이 필요합니다.");
            request.setAttribute("loc", request.getContextPath() + "/login.sp?mode=admin");

            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // 관리자 계정이 아니면 접근 불가
        if (!"admin".equals(loginuser.getUserid())) {
            request.setAttribute("message", "관리자만 접근할 수 있는 페이지입니다.");
            request.setAttribute("loc", request.getContextPath() + "/index.sp");

            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // ===============================
        // 관리자 메인 페이지 보여주기 (껍데기)
        // ===============================
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/js_admin/adminIndex.jsp");
    }
}
