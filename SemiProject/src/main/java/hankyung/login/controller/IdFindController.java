package hankyung.login.controller;

import sp.common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import hankyung.member.model.MemberDAO;
import hankyung.member.model.MemberDAO_imple;

/*
 * [IdFindController]
 * - GET  : 아이디 찾기 화면
 * - POST : 이름 + 이메일로 아이디 조회
 */
public class IdFindController extends AbstractController {

    private MemberDAO mdao = new MemberDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        // ===============================
        // GET : 화면만 보여주기
        // ===============================
        if ("GET".equalsIgnoreCase(request.getMethod())) {

            super.setRedirect(false);
            super.setViewPage("/WEB-INF/login/idFind.jsp");
            return;
        }

        // ===============================
        // POST : 아이디 찾기
        // ===============================
        String name  = request.getParameter("name");
        String email = request.getParameter("email");

        // DB 조회
        String userid = mdao.findUseridByNameEmail(name, email);

        // JSP로 결과 전달
        request.setAttribute("userid", userid);
        request.setAttribute("name", name);
        request.setAttribute("email", email);

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/login/idFind.jsp");
    }
}
