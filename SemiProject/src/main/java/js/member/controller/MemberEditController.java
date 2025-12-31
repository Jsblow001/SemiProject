package js.member.controller;

import sp.common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import hk.member.domain.MemberDTO;

public class MemberEditController extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
	    
	    // 1. 로그인 여부 확인
	    HttpSession session = request.getSession();
	    MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");

	    if (loginuser == null) {
	        // 로그인이 안 된 상태라면 접근 불가
	        request.setAttribute("message", "먼저 로그인을 하세요.");
	        request.setAttribute("loc", request.getContextPath() + "/login.sp");
	        request.getRequestDispatcher("/msg.jsp").forward(request, response);
	        return;
	    }

	    // 2. 로그인된 상태라면 수정 페이지(JSP)로 이동
	    // 세션에 이미 loginuser 정보가 있으므로 별도의 DB 조회 없이 바로 포워딩 가능합니다.
	    request.getRequestDispatcher("/WEB-INF/js_member/memberedit.jsp").forward(request, response);

	}

}
