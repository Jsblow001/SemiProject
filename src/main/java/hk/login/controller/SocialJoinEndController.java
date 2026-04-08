package hk.login.controller;

import hk.member.domain.MemberDTO;
import hk.member.model.MemberDAO;
import hk.member.model.MemberDAO_imple;
import sp.common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class SocialJoinEndController extends AbstractController {

    private MemberDAO mdao = new MemberDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        // POST로만 받기(권장)
        String method = request.getMethod();
        if(!"POST".equalsIgnoreCase(method)) {
            request.setAttribute("message", "비정상적인 접근입니다.");
            request.setAttribute("loc", request.getContextPath() + "/login.sp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        String userid = request.getParameter("userid");

        // ★ 추가된 3개
        String name = request.getParameter("name");
        String gender = request.getParameter("gender");
        String birthday = request.getParameter("birthday");

        String postcode = request.getParameter("postcode");
        String address = request.getParameter("address");
        String detailaddress = request.getParameter("detailaddress");
        String extraaddress = request.getParameter("extraaddress");

        int n = mdao.updateSocialExtraInfo(userid, name, gender, birthday,
                                           postcode, address, detailaddress, extraaddress);

        if(n == 1) {
            MemberDTO loginuser = mdao.getMemberByUserid(userid);

            HttpSession session = request.getSession();
            session.setAttribute("loginuser", loginuser);

            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/mypage.sp");
        }
        else {
            request.setAttribute("message", "추가정보 저장 실패");
            request.setAttribute("loc", request.getContextPath() + "/login.sp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
        }
    }
}
