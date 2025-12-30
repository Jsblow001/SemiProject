package hk.member.controller;

import hk.member.domain.MemberDTO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import sp.common.controller.AbstractController;

public class MemberEditController extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		// 내정보를 수정 하기 위한 전제조건은 먼저 로그인을 해야 하는 것이다.
		if(super.checkLogin(request)) {
			// 로그인 했으면
			String userid = request.getParameter("userid");
			
			HttpSession session = request.getSession();
			MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");
			
			if(loginuser.getUserid().equals(userid)) {
				// 로그인한 사용자가 자신의 정보를 수정하는 경우
				super.setRedirect(false);
				super.setViewPage("/WEB-INF/hk_member/memberEdit.jsp");
			
			}
			else {
				// 로그인한 사용자가 다른 사용자의 정보를 수정하려고 시도하는 경우
				String message = "다른 사용자의 정보 변경은 불가합니다.";
				String loc = "javascript:history.back()";
				
				request.setAttribute("message", message);
				request.setAttribute("loc", loc);
				
				super.setRedirect(false);
				super.setViewPage("/WEB-INF/msg.jsp");
			}
		}
		else {
			// 로그인 안했으면
			String message = "회원정보를 수정하기 위해서는 먼저 로그인하셔야 합니다.";
			String loc = "javascript:history.back()";
			
			request.setAttribute("message", message);
			request.setAttribute("loc", loc);
			
			super.setRedirect(false);
			super.setViewPage("/WEB-INF/msg.jsp");
		}
		
	}

}
