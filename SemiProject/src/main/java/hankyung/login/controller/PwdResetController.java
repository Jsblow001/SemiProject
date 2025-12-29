package hankyung.login.controller;

import sp.common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class PwdResetController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession();

        // 인증 성공한 사용자만 접근 가능
        String pwdResetUser = (String) session.getAttribute("pwdResetUser");

        if (pwdResetUser == null) {
            request.setAttribute("message", "비정상적인 접근입니다.");
            request.setAttribute("loc", request.getContextPath() + "/login/login.sp");

            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/login/pwdReset.jsp");
    }
}
