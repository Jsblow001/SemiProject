package hankyung.member.controller;

import sp.common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/*
 * [MyPageController]
 * - 마이페이지 접근을 제어하는 컨트롤러
 * - 로그인 여부를 검사해서
 *   1) 로그인 안 했으면 → 로그인 선택 페이지로 이동
 *   2) 로그인 했으면 → 마이페이지로 이동
 */
public class MyPageController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        // === 로그인 여부 검사 ===
        // AbstractController 에 정의된 checkLogin() 메서드 사용
        // sessionScope.loginuser 가 존재하면 true
        if (!super.checkLogin(request)) {

            // 로그인 안 된 상태 → 로그인 선택 페이지로 forward
            super.setRedirect(false); // forward 방식
            super.setViewPage("/WEB-INF/login/loginSelect.jsp");
            return; // 메서드 종료
        }

        // 로그인 된 상태 → 마이페이지 이동
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/member/mypage.jsp");
    }
}