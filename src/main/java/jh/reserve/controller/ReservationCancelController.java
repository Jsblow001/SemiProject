package jh.reserve.controller;

import java.util.HashMap;
import java.util.Map;

import org.json.simple.JSONObject;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import sp.common.controller.AbstractController;
import jh.reserve.model.ReservationDAO;
import jh.reserve.model.ReservationDAO_imple;
import hk.member.domain.MemberDTO;

public class ReservationCancelController extends AbstractController {

    private ReservationDAO dao = new ReservationDAO_imple();

    @SuppressWarnings("unchecked")
    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        JSONObject json = new JSONObject();

        if(!"POST".equalsIgnoreCase(request.getMethod())) {
            json.put("ok", false);
            json.put("message", "POST only");
            request.setAttribute("json", json.toString());
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/hk_admin/jsonview.jsp");
            return;
        }

        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");

        if(loginuser == null) {
            json.put("ok", false);
            json.put("message", "회원만 예약 취소가 가능합니다.");
            request.setAttribute("json", json.toString());
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/hk_admin/jsonview.jsp");
            return;
        }

        String reservationId = request.getParameter("reservationId");
        if(reservationId == null || reservationId.isBlank()) {
            json.put("ok", false);
            json.put("message", "reservationId 누락");
            request.setAttribute("json", json.toString());
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/hk_admin/jsonview.jsp");
            return;
        }

        Map<String,String> paraMap = new HashMap<>();
        paraMap.put("reservationId", reservationId);

        paraMap.put("userid", loginuser.getUserid());

        int n = dao.cancelReservationByMember(paraMap);

        if(n == 1) {
            json.put("ok", true);
        } else {
            json.put("ok", false);
            json.put("message", "취소할 수 없습니다(본인예약 아님/이미 취소/존재X).");
        }

        request.setAttribute("json", json.toString());
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/hk_admin/jsonview.jsp");
    }
}
