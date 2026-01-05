package hk.member.controller;

import sp.common.controller.AbstractController;
import hk.member.domain.MemberDTO;
import hk.member.model.MemberDAO;
import hk.member.model.MemberDAO_imple;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class MemberWithdrawController extends AbstractController {

    private MemberDAO mdao = new MemberDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        /* ===============================
         * 1. 로그인 여부 체크
         * =============================== */
        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");

        if (loginuser == null) {
            request.setAttribute("message", "로그인이 필요합니다.");
            request.setAttribute("loc", request.getContextPath() + "/login.sp");

            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        /* ===============================
         * 2. 탈퇴 처리
         * =============================== */
        String userid = loginuser.getUserid();
        int n = mdao.withdrawMember(userid);

        /* ===============================
         * 3. 결과 처리
         * =============================== */
        if (n == 1) {
            session.invalidate(); // 로그아웃
            request.setAttribute("message", "회원 탈퇴가 완료되었습니다.");
            request.setAttribute("loc", request.getContextPath() + "/index.sp");
        }
        else {
            request.setAttribute("message", "회원 탈퇴에 실패했습니다.");
            request.setAttribute("loc", "javascript:history.back()");
        }

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/msg.jsp");
    }
}
