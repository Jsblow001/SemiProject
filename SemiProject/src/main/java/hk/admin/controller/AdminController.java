package hk.admin.controller;

import sp.common.controller.AbstractController;
import hk.member.domain.MemberDTO;
import hk.member.model.MemberDAO;
import hk.member.model.MemberDAO_imple;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AdminController extends AbstractController {

   MemberDAO mdao = new MemberDAO_imple();
   
    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
       
        // ===============================
        // 관리자 로그인 여부 체크
        // ===============================
        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");

        // 로그인 안 했으면 접근 불가
        if (loginuser == null) {
     
            request.setAttribute("message", "관리자 로그인이 필요합니다.");
            request.setAttribute("loc", request.getContextPath() + "/login.sp?mode=admin");

            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // 관리자 계정이 아니면 접근 불가
        if (!"admin".equals(loginuser.getUserid())) {
            request.setAttribute("message", "관리자만 접근할 수 있는 페이지입니다.");
            request.setAttribute("loc", request.getContextPath() + "/index.sp");

            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // 1. DB에서 값을 가져와 자바 변수(totalCount)에 할당
        int totalCount  = mdao.getTotalMemberCount(); 

        // 2. JSP에서 사용할 이름("totalCount")으로 request 영역에 저장
        request.setAttribute("totalCount", totalCount); 
        
        // ===============================
        // 관리자 메인 페이지 보여주기 (껍데기)
        // ===============================
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/js_admin/adminIndex.jsp");
    }
}
