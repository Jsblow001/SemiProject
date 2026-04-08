package jh.reserve.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import sp.common.controller.AbstractController;
import hk.member.domain.MemberDTO;

public class ReservationPageController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");

        if(loginuser != null) {
            request.setAttribute("prefillName", loginuser.getName());

            request.setAttribute("prefillMobile", loginuser.getMobile()); 
            
        }

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/jh_reserve/reservation.jsp");
    }
}
