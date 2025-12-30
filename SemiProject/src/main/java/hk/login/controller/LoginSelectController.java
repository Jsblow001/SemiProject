package hk.login.controller;

import sp.common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/*
 * [LoginSelectController]
 * - 개인회원 / 관리자 로그인 선택 페이지를 보여주는 컨트롤러
 * - GET 방식으로 접근
 */
public class LoginSelectController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        // 로그인 선택 화면으로 이동
        super.setRedirect(false); // forward
        super.setViewPage("/WEB-INF/hk_login/loginSelect.jsp");
    }
}