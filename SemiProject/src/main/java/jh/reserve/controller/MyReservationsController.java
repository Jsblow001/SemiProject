package jh.reserve.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import sp.common.controller.AbstractController;
import jh.reserve.model.ReservationDAO;
import jh.reserve.model.ReservationDAO_imple;
import hk.member.domain.MemberDTO;

public class MyReservationsController extends AbstractController {

    private ReservationDAO dao = new ReservationDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");

        if(loginuser == null) {
            request.setAttribute("message", "로그인 후 이용 가능합니다.");
            request.setAttribute("loc", request.getContextPath() + "/loginSelect.sp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        Map<String,String> paraMap = new HashMap<>();
        paraMap.put("userid", loginuser.getUserid());

        List<Map<String,String>> list = dao.selectMyReservations(paraMap);

        request.setAttribute("list", list);
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/jh_reserve/my_reservations.jsp");
    }
}
