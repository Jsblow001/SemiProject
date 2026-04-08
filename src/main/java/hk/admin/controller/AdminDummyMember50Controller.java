package hk.admin.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import sp.common.controller.AbstractController;
import hk.member.domain.MemberDTO;
import hk.member.model.MemberDAO;
import hk.member.model.MemberDAO_imple;

public class AdminDummyMember50Controller extends AbstractController {

    private MemberDAO mdao = new MemberDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO)session.getAttribute("loginuser");

        if(loginuser == null || !"admin".equals(loginuser.getUserid())) {
            request.setAttribute("message", "관리자만 사용 가능합니다.");
            request.setAttribute("loc", request.getContextPath()+"/index.sp");
            setRedirect(false);
            setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        int cnt = mdao.createDummyMembers(50);

        request.setAttribute("message", cnt + "명의 더미 회원이 생성되었습니다.");
        request.setAttribute("loc", request.getContextPath()+"/admin/memberList.sp");
        setRedirect(false);
        setViewPage("/WEB-INF/msg.jsp");
    }
}
