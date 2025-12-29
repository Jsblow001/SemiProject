package ih.admin.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import sp.common.controller.AbstractController;
// import member.domain.MemberDTO; // 나중에 MemberDTO 만드시면 주석 해제하세요.

public class ProductRegisterController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        /* // 나중에 MemberDTO와 로그인 기능이 완성되면 아래 주석을 풀어 관리자 전용으로 만드세요.
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

        // 지금은 관리자 체크 없이 바로 등록 페이지(JSP)를 보여줍니다.
        super.setRedirect(false); // forward 방식
        super.setViewPage("/WEB-INF/ih_admin/productRegister.jsp");
    }
}