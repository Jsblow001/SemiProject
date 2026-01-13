package jh.reserve.controller;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import sp.common.controller.AbstractController;
import jh.reserve.model.ReservationDAO;
import jh.reserve.model.ReservationDAO_imple;
import jh.reserve.model.ReservationDAO.TimeRange;

public class ReservationSlotsController extends AbstractController {

    private ReservationDAO dao = new ReservationDAO_imple();

    @SuppressWarnings("unchecked")
    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        String storeId = request.getParameter("storeId");
        String dateStr = request.getParameter("date");   // yyyy-MM-dd
        String reason  = request.getParameter("reason"); // AS / FITTING / VISION

        JSONObject json = new JSONObject();

        if(storeId == null || storeId.isBlank() || dateStr == null || dateStr.isBlank()) {
            json.put("ok", false);
            json.put("message", "필수 파라미터 누락(storeId, date)");
            request.setAttribute("json", json.toString());
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/hk_admin/jsonview.jsp");
            return;
        }

        if(reason == null || reason.isBlank()) reason = "VISION";
        reason = reason.trim().toUpperCase();

        int durationMin = ("FITTING".equals(reason)) ? 60 : 30;

        // 영업시간
        LocalTime open = LocalTime.of(11, 0);
        LocalTime close = LocalTime.of(20, 0);

        LocalDate day = LocalDate.parse(dateStr);
        LocalDateTime dayStartLdt = day.atStartOfDay();
        LocalDateTime dayEndLdt   = day.plusDays(1).atStartOfDay();

        // DAO로 넘길 dayStart/dayEnd (Timestamp.valueOf 가능 형태)
        String dayStart = dayStartLdt.toString().replace('T',' ') + ":00";
        String dayEnd   = dayEndLdt.toString().replace('T',' ') + ":00";

        Map<String,String> paraMap = new HashMap<>();
        paraMap.put("storeId", storeId);
        paraMap.put("dayStart", dayStart);
        paraMap.put("dayEnd", dayEnd);

        // ✅ 예약 + 막기 구간을 한 번에 받아옴(UNION)
        List<TimeRange> busy = dao.selectBusyRanges(paraMap);

        // 30분 단위 후보 시작시간 만들기
        JSONArray availableStarts = new JSONArray();
        DateTimeFormatter hhmm = DateTimeFormatter.ofPattern("HH:mm");

        LocalDateTime cursor = LocalDateTime.of(day, open);

        while(true) {
            LocalDateTime candidateStart = cursor;
            LocalDateTime candidateEnd   = candidateStart.plusMinutes(durationMin);

            if(candidateEnd.toLocalTime().isAfter(close)) break;

            if(!overlapsAny(candidateStart, candidateEnd, busy)) {
                availableStarts.add(candidateStart.toLocalTime().format(hhmm));
            }

            cursor = cursor.plusMinutes(30);
            if(cursor.toLocalTime().isAfter(close)) break;
        }

        json.put("ok", true);
        json.put("storeId", storeId);
        json.put("date", dateStr);
        json.put("reason", reason);
        json.put("durationMin", durationMin);
        json.put("openTime", "11:00");
        json.put("closeTime", "20:00");
        json.put("availableStarts", availableStarts);

        request.setAttribute("json", json.toString());
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/hk_admin/jsonview.jsp");
    }

    private boolean overlapsAny(LocalDateTime start, LocalDateTime end, List<TimeRange> busy) {
        java.sql.Timestamp s = java.sql.Timestamp.valueOf(start);
        java.sql.Timestamp e = java.sql.Timestamp.valueOf(end);

        for(TimeRange r : busy) {
            // 겹침: r.start < e AND r.end > s
            if(r.start.before(e) && r.end.after(s)) return true;
        }
        return false;
    }
}
