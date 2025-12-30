package hk.login.controller;

import java.util.HashMap;
import java.util.Map;

import sp.common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import hk.member.domain.MemberDTO;
import hk.member.model.MemberDAO;
import hk.member.model.MemberDAO_imple;

public class LoginController extends AbstractController {

	private MemberDAO mdao = new MemberDAO_imple();

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

		String method = request.getMethod();

		/*
		 * ===============================
		 * GET : 로그인 페이지 보여주기
		 * ===============================
		 */
		if ("GET".equalsIgnoreCase(method)) {

			String mode = request.getParameter("mode");

			// 관리자 로그인 화면
			if ("admin".equals(mode)) {
				super.setRedirect(false);
				super.setViewPage("/WEB-INF/hk_login/adminLogin.jsp");
			}
			// 일반 로그인 화면
			else {
				super.setRedirect(false);
				super.setViewPage("/WEB-INF/hk_login/login.jsp");
			}
			return;
		}

		/*
		 * ===============================
		 * POST : 로그인 처리
		 * ===============================
		 */
		else {

			String userid = request.getParameter("userid");   // name="userid"
			String passwd = request.getParameter("passwd");   // pwd → passwd 변경

			// Map 방식으로 DAO에 전달
			Map<String, String> paraMap = new HashMap<>();
			paraMap.put("userid", userid);
			paraMap.put("passwd", passwd);                    // 변경

			MemberDTO loginuser = mdao.login(paraMap);

			if (loginuser == null) {
				request.setAttribute("message", "아이디 또는 비밀번호가 틀렸습니다.");
				request.setAttribute("loc", request.getContextPath() + "/login.sp");

				super.setRedirect(false);
				super.setViewPage("/WEB-INF/msg.jsp");
			}
			else {

				if (loginuser.getStatus() == 0) {
					request.setAttribute("message", "탈퇴한 회원입니다.");
					request.setAttribute("loc", request.getContextPath() + "/login.sp");

					super.setRedirect(false);
					super.setViewPage("/WEB-INF/msg.jsp");
					return;
				}

				if (loginuser.getIdle() == 1) {
					request.setAttribute("message", "휴면 상태의 계정입니다.");
					request.setAttribute("loc", request.getContextPath() + "/login.sp");

					super.setRedirect(false);
					super.setViewPage("/WEB-INF/msg.jsp");
					return;
				}

				// 로그인 성공
				HttpSession session = request.getSession();
				session.setAttribute("loginuser", loginuser);

				// ===============================
				// 관리자 / 일반회원 분기
				// ===============================
				if ("admin".equals(loginuser.getUserid())) {
					// 관리자 로그인
					super.setRedirect(true);
					super.setViewPage(request.getContextPath() + "/admin.sp");
				}
				else {
					// 일반 회원 로그인
					super.setRedirect(true);
					super.setViewPage(request.getContextPath() + "/mypage.sp");
				}
			}
		}
	}
}
