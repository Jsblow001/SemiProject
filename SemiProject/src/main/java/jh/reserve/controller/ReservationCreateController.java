package jh.reserve.controller;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
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

public class ReservationCreateController extends AbstractController {

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

        // ===== 1) 파라미터 받기 =====
        String storeIdStr  = nv(request.getParameter("storeId"));
        String reason      = nv(request.getParameter("reason")).toUpperCase(); // VISION/FITTING/AS
        String dateStr     = nv(request.getParameter("date"));                // yyyy-MM-dd
        String startTime   = nv(request.getParameter("startTime"));           // HH:mm
        String guestName   = nv(request.getParameter("guestName"));
        String guestPhone  = normalizePhone(request.getParameter("guestPhone"));
        String message     = request.getParameter("message");
        if(message == null) message = "";

        // ===== 2) 필수값 체크 =====
        if(storeIdStr.isBlank() || dateStr.isBlank() || startTime.isBlank()
           || guestName.isBlank() || guestPhone.isBlank()) {
            json.put("ok", false);
            json.put("message", "필수값 누락(storeId,date,startTime,guestName,guestPhone)");
            request.setAttribute("json", json.toString());
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/hk_admin/jsonview.jsp");
            return;
        }

        if(!("VISION".equals(reason) || "FITTING".equals(reason) || "AS".equals(reason))) {
            reason = "VISION";
        }

        // ===== 3) duration 결정 =====
        int durationMin = ("FITTING".equals(reason)) ? 60 : 30; // AS=30, VISION=30, FITTING=60

        // ===== 4) 시간 계산 + 영업시간 검증(11~20) + 30분 단위 검증 =====
        int storeId;
        try {
            storeId = Integer.parseInt(storeIdStr);
        } catch(Exception e) {
            json.put("ok", false);
            json.put("message", "storeId 형식 오류");
            request.setAttribute("json", json.toString());
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/hk_admin/jsonview.jsp");
            return;
        }

        LocalDate day;
        LocalTime st;
        try {
            day = LocalDate.parse(dateStr);
            st = LocalTime.parse(startTime); // HH:mm
        } catch(Exception e) {
            json.put("ok", false);
            json.put("message", "date/startTime 형식 오류");
            request.setAttribute("json", json.toString());
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/hk_admin/jsonview.jsp");
            return;
        }

        // 30분 단위 체크
        int minute = st.getMinute();
        if(!(minute == 0 || minute == 30)) {
            json.put("ok", false);
            json.put("message", "시간은 30분 단위만 가능합니다(00/30).");
            request.setAttribute("json", json.toString());
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/hk_admin/jsonview.jsp");
            return;
        }

        LocalTime open  = LocalTime.of(11, 0);
        LocalTime close = LocalTime.of(20, 0);

        LocalDateTime startLdt = LocalDateTime.of(day, st);
        LocalDateTime endLdt   = startLdt.plusMinutes(durationMin);

        // 영업시간 범위: 시작은 11:00 이상, 종료는 20:00 이하
        if(st.isBefore(open) || endLdt.toLocalTime().isAfter(close)) {
            json.put("ok", false);
            json.put("message", "영업시간(11:00~20:00) 밖 예약입니다.");
            request.setAttribute("json", json.toString());
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/hk_admin/jsonview.jsp");
            return;
        }

        // ===== 5) paraMap 구성(DAO 규약) =====
        // Timestamp.valueOf용: "yyyy-MM-dd HH:mm:ss"
        String startAt = startLdt.toString().replace('T',' ') + ":00";
        String endAt   = endLdt.toString().replace('T',' ') + ":00";

        Map<String,String> paraMap = new HashMap<>();
        paraMap.put("storeId", String.valueOf(storeId));
        paraMap.put("guestName", guestName.trim());
        paraMap.put("guestPhone", guestPhone);
        paraMap.put("reason", reason);
        paraMap.put("durationMin", String.valueOf(durationMin));
        paraMap.put("startAt", startAt);
        paraMap.put("endAt", endAt);
        paraMap.put("message", message);

        // 회원이면 memberId 추가(비회원이면 아예 안 넣음)
        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");
        if(loginuser != null) {
        	paraMap.put("memberUserid", loginuser.getUserid());
        }

        // ===== 6) INSERT(조건부) =====
        // 1 = 성공 / 0 = 겹침(이미 예약 or 막기)
        int n = dao.insertReservation(paraMap);

        if(n == 1) {
            json.put("ok", true);
            json.put("message", "예약이 확정되었습니다.");
            json.put("storeId", storeId);
            json.put("reason", reason);
            json.put("startAt", startAt);
            json.put("endAt", endAt);
        } else {
            json.put("ok", false);
            json.put("message", "이미 예약이 있거나 막힌 시간입니다.");
        }

        request.setAttribute("json", json.toString());
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/hk_admin/jsonview.jsp");
    }

    private String nv(String s) {
        return (s == null) ? "" : s.trim();
    }

    private String normalizePhone(String s) {
        if(s == null) return "";
        return s.replaceAll("[^0-9]", "");
    }
}
