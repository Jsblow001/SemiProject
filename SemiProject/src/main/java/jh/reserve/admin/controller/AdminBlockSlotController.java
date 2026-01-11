package jh.reserve.admin.controller;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.HashMap;
import java.util.Map;

import org.json.simple.JSONObject;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import sp.common.controller.AbstractController;
import jh.reserve.model.ReservationDAO;
import jh.reserve.model.ReservationDAO_imple;

public class AdminBlockSlotController extends AbstractController {

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

        String storeId = request.getParameter("storeId");
        String date = request.getParameter("date");           // yyyy-MM-dd
        String startTime = request.getParameter("startTime"); // HH:mm
        String durationMin = request.getParameter("durationMin"); // 30 or 60
        String memo = request.getParameter("memo");

        if(storeId == null || date == null || startTime == null || durationMin == null ||
           storeId.isBlank() || date.isBlank() || startTime.isBlank() || durationMin.isBlank()) {

            json.put("ok", false);
            json.put("message", "필수값 누락(storeId,date,startTime,durationMin)");
            request.setAttribute("json", json.toString());
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/hk_admin/jsonview.jsp");
            return;
        }

        int dur = Integer.parseInt(durationMin);

        // 영업시간 11~20 체크(막기도 동일 규칙)
        LocalDate d = LocalDate.parse(date);
        LocalTime st = LocalTime.parse(startTime);
        LocalDateTime startLdt = LocalDateTime.of(d, st);
        LocalDateTime endLdt = startLdt.plusMinutes(dur);

        if(st.isBefore(LocalTime.of(11,0)) || endLdt.toLocalTime().isAfter(LocalTime.of(20,0))) {
            json.put("ok", false);
            json.put("message", "영업시간 밖 막기입니다.");
            request.setAttribute("json", json.toString());
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/hk_admin/jsonview.jsp");
            return;
        }

        // Timestamp.valueOf용 문자열 포맷
        String startAt = startLdt.toString().replace('T',' ') + ":00";
        String endAt   = endLdt.toString().replace('T',' ') + ":00";

        Map<String, String> paraMap = new HashMap<>();
        paraMap.put("storeId", storeId);
        paraMap.put("startAt", startAt);
        paraMap.put("endAt", endAt);
        paraMap.put("memo", memo == null ? "" : memo);

        int n = dao.insertBlockSlot(paraMap);

        if(n == 1) {
            json.put("ok", true);
        } else {
            json.put("ok", false);
            json.put("message", "이미 예약이 있거나 다른 막기와 겹칩니다.");
        }

        request.setAttribute("json", json.toString());
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/hk_admin/jsonview.jsp");
    }
}
