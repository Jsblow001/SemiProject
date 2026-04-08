package hk.login.controller;

import java.util.Random;

import sp.common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import hk.mail.controller.GoogleMail;
import hk.member.model.MemberDAO;
import hk.member.model.MemberDAO_imple;

public class PwdFindController extends AbstractController {

    private MemberDAO mdao = new MemberDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        String method = request.getMethod();

        /* ===============================
         * GET : 비밀번호 찾기 페이지
         * =============================== */
        if ("GET".equalsIgnoreCase(method)) {

            super.setRedirect(false);
            super.setViewPage("/WEB-INF/hk_login/pwdFind.jsp");
            return;
        }

        /* ===============================
         * POST : 비밀번호 찾기 처리
         * =============================== */
        else {

            String userid = request.getParameter("userid");
            String email  = request.getParameter("email");

            boolean isExist = mdao.isUserExistsForPwd(userid, email);
            boolean sendMailSuccess = false;

            if (isExist) {

                // ===== 인증코드 생성 =====
                Random rnd = new Random();
                String certification_code = "";

                // 영문 소문자 5자리
                for (int i = 0; i < 5; i++) {
                    char randChar = (char) (rnd.nextInt('z' - 'a' + 1) + 'a');
                    certification_code += randChar;
                }

                // 숫자 7자리
                for (int i = 0; i < 7; i++) {
                    int randNum = rnd.nextInt(10);
                    certification_code += randNum;
                }

                // ===== 메일 발송 =====
                try {
                    GoogleMail mail = new GoogleMail();
                    mail.send_certification_code(email, certification_code);
                    sendMailSuccess = true;

                    // ===== 세션 저장 =====
                    HttpSession session = request.getSession();
                    session.setAttribute("certification_code", certification_code);

                } catch (Exception e) {
                    e.printStackTrace();
                    sendMailSuccess = false;
                }
            }

            // ===== JSP로 전달 =====
            request.setAttribute("userid", userid);
            request.setAttribute("email", email);
            request.setAttribute("isExist", isExist);
            request.setAttribute("sendMailSuccess", sendMailSuccess);

            super.setRedirect(false);
            super.setViewPage("/WEB-INF/hk_login/pwdFind.jsp");
        }
    }
}
