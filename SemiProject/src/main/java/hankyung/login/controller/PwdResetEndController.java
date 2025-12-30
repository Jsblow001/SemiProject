package hankyung.login.controller;

import sp.common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import hankyung.member.model.MemberDAO;
import hankyung.member.model.MemberDAO_imple;

public class PwdResetEndController extends AbstractController {

    private MemberDAO mdao = new MemberDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        // POST 방식만 허용
        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/login.sp");
            return;
        }

        HttpSession session = request.getSession();

        // 인증된 사용자 확인
        String userid = (String) session.getAttribute("pwdResetUser");

        if (userid == null) {
            request.setAttribute("message", "비정상적인 접근입니다.");
            request.setAttribute("loc", request.getContextPath() + "/login.sp");

            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // 새 비밀번호 (❗ 암호화 X)
        String passwd = request.getParameter("passwd");

        // DAO에게 그대로 전달
        boolean isUpdated = mdao.updatePassword(userid, passwd);

        if (isUpdated) {
            session.removeAttribute("pwdResetUser");
            session.removeAttribute("certification_code");

            request.setAttribute("message", "비밀번호가 정상적으로 변경되었습니다.");
            request.setAttribute("loc", request.getContextPath() + "/login.sp");
        }
        else {
            request.setAttribute("message", "비밀번호 변경에 실패했습니다.");
            request.setAttribute("loc", request.getContextPath() + "/pwdFind.sp");
        }

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/msg.jsp");
    }
}
