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

            // ⚠️ mobile이 암호문일 수 있으니, 여기서 복호화된 값을 넣는 게 베스트
            // 지금 당장은 “세션에 평문이 들어온다”가 확실하지 않으면 비우는 게 안전
            request.setAttribute("prefillMobile", loginuser.getMobile()); 
        }

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/jh_reserve/reservation.jsp");
    }
}
