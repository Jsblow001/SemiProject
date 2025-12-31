package hk.member.controller;

import java.sql.SQLException;

import sp.common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import hk.member.domain.MemberDTO;
import hk.member.model.MemberDAO;
import hk.member.model.MemberDAO_imple;

public class MemberEditEndController extends AbstractController {

    private MemberDAO mdao = new MemberDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        // POST 방식만 허용
        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/index.sp");
            return;
        }

        // === 1. 파라미터 받기 ===
        String userid = request.getParameter("userid");
        String name   = request.getParameter("name");
        String passwd = request.getParameter("passwd");
        String email  = request.getParameter("email");
        String hp1    = request.getParameter("hp1");
        String hp2    = request.getParameter("hp2");
        String hp3    = request.getParameter("hp3");

        String mobile = hp1 + hp2 + hp3;

        // === 2. DTO에 담기 ===
        MemberDTO member = new MemberDTO();
        member.setUserid(userid);
        member.setName(name);
        member.setPasswd(passwd);
        member.setEmail(email);
        member.setMobile(mobile);

        try {
            // === 3. DB 수정 ===
            int n = mdao.updateMember(member);

            if (n == 1) {

                // === 4. session loginuser 갱신 (중요!!) ===
                HttpSession session = request.getSession();
                MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");

                loginuser.setName(name);
                loginuser.setPasswd(passwd);
                loginuser.setEmail(email);
                loginuser.setMobile(mobile);               

                // === 5. 메시지 처리 ===
                request.setAttribute("message", "회원정보가 수정되었습니다.");
                request.setAttribute("loc", request.getContextPath() + "/mypage.sp");

                super.setRedirect(false);
                super.setViewPage("/WEB-INF/msg.jsp");
            }
        }
        catch (SQLException e) {
            e.printStackTrace();
            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/error.sp");
        }
    }
}
