package hk.login.controller;

import sp.common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class VerifyCertificationController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        if(!"POST".equalsIgnoreCase(request.getMethod())) {
            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/pwdFind.sp");
            return;
        }

        String inputCode = request.getParameter("userCertificationCode");
        String userid    = request.getParameter("userid");

        HttpSession session = request.getSession();
        String sessionCode = (String) session.getAttribute("certification_code");

        if(sessionCode != null && sessionCode.equals(inputCode)) {

            // 비밀번호 재설정 권한 부여
            session.setAttribute("pwdResetUser", userid);

            // 인증코드 제거
            session.removeAttribute("certification_code");

            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/pwdReset.sp");
        }
        else {
            request.setAttribute("message", "인증코드가 올바르지 않습니다.");
            request.setAttribute("loc", request.getContextPath() + "/pwdFind.sp");

            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
        }
    }
}
