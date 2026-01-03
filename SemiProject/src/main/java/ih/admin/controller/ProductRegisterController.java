package ih.admin.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import sp.common.controller.AbstractController;
// import member.domain.MemberDTO; // 나중에 MemberDTO 만들면 주석해제하기

public class ProductRegisterController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
    	
    	// 관리자 모드 설정
        /* 
        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");

        if(loginuser == null || !"admin".equals(loginuser.getUserid())) {
            String message = "관리자만 접근 가능한 페이지입니다.";
            String loc = request.getContextPath() + "/index.sp";
            
            request.setAttribute("message", message);
            request.setAttribute("loc", loc);
            
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }
        */

        super.setRedirect(false); // forward 방식
        super.setViewPage("/WEB-INF/ih_admin/productRegister.jsp");
    }
}