package jh.reserve.admin.controller;

import java.util.HashMap;
import java.util.Map;

import org.json.simple.JSONObject;

import hk.member.domain.MemberDTO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import sp.common.controller.AbstractController;
import jh.reserve.model.ReservationDAO;
import jh.reserve.model.ReservationDAO_imple;

public class AdminSendSmsController extends AbstractController {


    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

    	ReservationDAO dao = new ReservationDAO_imple();
    	
        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");

        // ✅ 관리자만
        if (loginuser == null || !"admin".equals(loginuser.getUserid())) {
            response.setStatus(401);
            return;
        }

        String reservationId = request.getParameter("reservationId");
        String storeId       = request.getParameter("storeId");
        String toPhone       = request.getParameter("toPhone");
        String smsType       = request.getParameter("smsType");
        String content       = request.getParameter("content");

        if(smsType == null || smsType.isBlank()) smsType = "ADMIN";

        JSONObject json = new JSONObject();

        // 필수값 체크
        if (reservationId == null || storeId == null || toPhone == null || content == null ||
            reservationId.isBlank() || storeId.isBlank() || toPhone.isBlank() || content.isBlank()) {

            json.put("ok", false);
            json.put("message", "필수값 누락(reservationId, storeId, toPhone, content)");
            request.setAttribute("json", json.toString());
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/hk_admin/jsonview.jsp");
            return;
        }

        String resultJson;

        try {
            
        	final String apiKey = "NCSKSXJ1S7X4BSFB";
        	final String apiSecret = "G6ZSVCJAAXIARC4EGOJM4D2HVKWKJKMG";
        	final String fromPhone = "01095994076";

            SmsSender sender = new SmsSender(apiKey, apiSecret, fromPhone);
            resultJson = sender.sendNow(toPhone, content);

        } catch (Exception e) {
            json.put("ok", false);
            json.put("message", "문자 전송 실패: " + e.getMessage());
            request.setAttribute("json", json.toString());
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/hk_admin/jsonview.jsp");
            return;
        }

        // 로그 저장
        boolean logged = false;
        String logFailMessage = null;
        try {
            Map<String, String> logMap = new HashMap<>();
            logMap.put("reservationId", reservationId);
            logMap.put("storeId", storeId);
            logMap.put("toPhone", toPhone);
            logMap.put("smsType", smsType);
            logMap.put("content", content);
            logMap.put("resultJson", resultJson);

            int n = dao.insertSmsLog(logMap);
            logged = (n == 1);

            json.put("ok", true);
            json.put("logged", (n == 1));
            json.put("resultJson", resultJson);

        } catch (Exception e) {
            // 전송은 됐는데 로그만 실패할 수도 있음
        	logged = false;
            logFailMessage = e.getMessage();
        }

        // ✅ “성공시 알림 메시지” 생성
        json.put("ok", true);
        json.put("logged", logged);
        json.put("toPhone", toPhone);
        json.put("smsType", smsType);

        if (logged) {
            json.put("message", "문자 전송 완료 (" + toPhone + ") / 로그 저장 완료");
        } else {
            json.put("message", "문자 전송 완료 (" + toPhone + ") / 로그 저장 실패"
                    + (logFailMessage != null ? (": " + logFailMessage) : ""));
        }

        // 필요하면 디버그용으로 결과 JSON도 내려줌
        // json.put("resultJson", resultJson);

        request.setAttribute("json", json.toString());
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/hk_admin/jsonview.jsp");
    }
}
