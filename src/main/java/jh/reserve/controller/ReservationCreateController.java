package jh.reserve.controller;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.HashMap;
import java.util.Map;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import sp.common.controller.AbstractController;

import hk.member.domain.MemberDTO;
import jh.reserve.model.ReservationDAO;
import jh.reserve.model.ReservationDAO_imple;
import jh.reserve.admin.controller.SmsSender;

public class ReservationCreateController extends AbstractController {

    private final ReservationDAO dao = new ReservationDAO_imple();

    @SuppressWarnings("unchecked")
    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        JSONObject json = new JSONObject();

        // 0) POST 요청만 허용
        if (!"POST".equalsIgnoreCase(request.getMethod())) {
            json.put("ok", false);
            json.put("message", "POST only");
            returnJson(request, json);
            return;
        }

        // 1) 파라미터 수집
        String storeIdStr = nv(request.getParameter("storeId"));
        String reason     = nv(request.getParameter("reason")).toUpperCase(); // VISION / FULLSERVICE / AS
        String dateStr    = nv(request.getParameter("date"));                 // yyyy-MM-dd
        String startTime  = nv(request.getParameter("startTime"));            // HH:mm
        String guestName  = nv(request.getParameter("guestName"));
        String guestPhone = normalizePhone(request.getParameter("guestPhone"));
        String message    = request.getParameter("message");
        if (message == null) message = "";

        // 2) 필수값 검증
        if (storeIdStr.isBlank() || dateStr.isBlank() || startTime.isBlank()
                || guestName.isBlank() || guestPhone.isBlank()) {

            json.put("ok", false);
            json.put("message", "필수값 누락(storeId,date,startTime,guestName,guestPhone)");
            returnJson(request, json);
            return;
        }

        // 3) reason 값 보정
        if (!("VISION".equals(reason) || "FULLSERVICE".equals(reason) || "AS".equals(reason))) {
            reason = "VISION";
        }

        // 4) 소요시간 결정(30분/60분)
        int durationMin = ("FULLSERVICE".equals(reason)) ? 60 : 30;

        // 5) storeId 파싱
        int storeId;
        try {
            storeId = Integer.parseInt(storeIdStr);
        } catch (Exception e) {
            json.put("ok", false);
            json.put("message", "storeId 형식 오류");
            returnJson(request, json);
            return;
        }

        // 6) 날짜/시간 파싱 + 30분 단위 + 영업시간(11~20) 검증
        LocalDate day;
        LocalTime st;
        try {
            day = LocalDate.parse(dateStr);
            st  = LocalTime.parse(startTime);
        } catch (Exception e) {
            json.put("ok", false);
            json.put("message", "date/startTime 형식 오류");
            returnJson(request, json);
            return;
        }

        // 30분 단위 체크
        int minute = st.getMinute();
        if (!(minute == 0 || minute == 30)) {
            json.put("ok", false);
            json.put("message", "시간은 30분 단위만 가능합니다(00/30).");
            returnJson(request, json);
            return;
        }

        LocalTime open  = LocalTime.of(11, 0);
        LocalTime close = LocalTime.of(20, 0);

        LocalDateTime startLdt = LocalDateTime.of(day, st);
        LocalDateTime endLdt   = startLdt.plusMinutes(durationMin);

        // 시작 >= 11:00, 종료 <= 20:00
        if (st.isBefore(open) || endLdt.toLocalTime().isAfter(close)) {
            json.put("ok", false);
            json.put("message", "영업시간(11:00~20:00) 밖 예약입니다.");
            returnJson(request, json);
            return;
        }

        // 7) DAO 입력값 구성
        // Timestamp.valueOf("yyyy-MM-dd HH:mm:ss") 형태
        String startAt = startLdt.toString().replace('T', ' ') + ":00";
        String endAt   = endLdt.toString().replace('T', ' ') + ":00";

        Map<String, String> paraMap = new HashMap<>();
        paraMap.put("storeId", String.valueOf(storeId));
        paraMap.put("guestName", guestName.trim());
        paraMap.put("guestPhone", guestPhone);
        paraMap.put("reason", reason);
        paraMap.put("durationMin", String.valueOf(durationMin));
        paraMap.put("startAt", startAt);
        paraMap.put("endAt", endAt);
        paraMap.put("message", message);

        // 로그인 사용자라면 userid 추가
        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");
        if (loginuser != null) {
            paraMap.put("userid", loginuser.getUserid());
        }

        // 8) 예약 INSERT (겹치거나 막힌 시간이면 실패)
        int n = dao.insertReservation(paraMap);

        if (n != 1) {
            json.put("ok", false);
            json.put("message", "이미 예약이 있거나 막힌 시간입니다.");
            returnJson(request, json);
            return;
        }

        // ✅ 9) 예약 성공 응답 기본값
        json.put("ok", true);
        json.put("message", "예약이 확정되었습니다.");
        json.put("storeId", storeId);
        json.put("reason", reason);
        json.put("startAt", startAt);
        json.put("endAt", endAt);

        // ✅ 10) (해결책 A) 예약 성공 시 서버에서 예약확정 문자 자동 발송
        boolean smsSent = false;
        String smsResult = "";

        try {
            // 10-1) 매장 전화번호(tbl_map.TEL) 조회
            String store = "store" + storeId;
            String storeTel = dao.selectStoreTel(store);

            if (storeTel == null || storeTel.trim().isEmpty()) {
                storeTel = "02-0000-0000";
            }

            // 10-2) 문자 내용 생성
            String storeName  = storeNameById(storeId);
            String reasonText = reasonText(reason);

            String endHHMM = endLdt.toLocalTime().toString();
            if (endHHMM.length() >= 5) endHHMM = endHHMM.substring(0, 5);

            String smsMsg = buildConfirmSms(
                    guestName,
                    storeName,
                    dateStr,
                    startTime,
                    endHHMM,
                    reasonText,
                    durationMin,
                    storeTel
            );

            // ✅ (선택지 A) 하드코딩으로 Sender 생성
            SmsSender sender = buildSmsSender();

            // 10-4) 발송
            smsResult = sender.sendNow(guestPhone, smsMsg);

            // 10-5) 성공 판정
            smsSent = parseCoolSmsSuccess(smsResult);

        } catch (Exception e) {
            smsSent = false;
            smsResult = "EXCEPTION: " + e.getMessage();
            e.printStackTrace();
        }


        json.put("smsSent", smsSent);
        json.put("smsResult", smsResult); // 필요 없으면 제거 가능 (디버깅용)

        returnJson(request, json);
    }

    // ----------------------------
    // Helper
    // ----------------------------

    private void returnJson(HttpServletRequest request, JSONObject json) {
        request.setAttribute("json", json.toString());
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/hk_admin/jsonview.jsp");
    }

    private String nv(String s) {
        return (s == null) ? "" : s.trim();
    }

    private String normalizePhone(String s) {
        if (s == null) return "";
        return s.replaceAll("[^0-9]", "");
    }

    private String storeNameById(int storeId) {
        if (storeId == 1) return "SISEON 도산점";
        if (storeId == 2) return "SISEON 압구정점";
        if (storeId == 3) return "SISEON 홍대점";
        return "SISEON";
    }

    private String reasonText(String reason) {
        if ("FULLSERVICE".equals(reason)) return "안경맞춤";
        if ("AS".equals(reason)) return "A/S";
        return "시력검사";
    }

    private String buildConfirmSms(
            String guestName,
            String storeName,
            String date,
            String startHHMM,
            String endHHMM,
            String reasonText,
            int durationMin,
            String storeTel
    ) {
        StringBuilder sb = new StringBuilder();
        sb.append("[SISEON 방문예약 확정]\n");
        sb.append(guestName).append("님 예약이 확정되었습니다.\n");
        sb.append("매장: ").append(storeName).append("\n");
        sb.append("일시: ").append(date).append(" ").append(startHHMM).append("~").append(endHHMM).append("\n");
        sb.append("내용: ").append(reasonText).append(" (").append(durationMin).append("분)\n");
        sb.append("문의: ").append(storeTel);
        return sb.toString();
    }

    // 하드코딩
    private SmsSender buildSmsSender() {

        final String apiKey    = "NCSKSXJ1S7X4BSFB"; // ✅ 너 관리자 컨트롤러 값 그대로
        final String apiSecret = "G6ZSVCJAAXIARC4EGOJM4D2HVKWKJKMG";
        final String fromPhone = "01095994076"; // ✅ 등록된 발신번호

        return new SmsSender(apiKey, apiSecret, fromPhone);
    }


    /**
     * CoolSMS 응답(JSON 문자열)에서 success_count가 1 이상이면 성공으로 판단
     */
    private boolean parseCoolSmsSuccess(String jsonStr) {
        if (jsonStr == null || jsonStr.trim().isEmpty()) return false;

        try {
            JSONObject obj = (JSONObject) new JSONParser().parse(jsonStr);
            Object sc = obj.get("success_count");

            if (sc == null) return false;

            // success_count가 Long 또는 String 형태로 올 수 있음
            long cnt;
            if (sc instanceof Number) {
                cnt = ((Number) sc).longValue();
            } else {
                cnt = Long.parseLong(sc.toString());
            }

            return cnt >= 1;

        } catch (Exception e) {
            return false;
        }
    }
}
