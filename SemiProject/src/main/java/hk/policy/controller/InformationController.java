package hk.policy.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import sp.common.controller.AbstractController;

public class InformationController extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		// 약관 페이지는 데이터 조회/DAO 없음. 그냥 JSP로 포워딩만 한다.
		super.setViewPage("/WEB-INF/hk_policy/information.jsp");
		
	}

}
