package jh.reserve.admin.controller;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import hk.member.domain.MemberDTO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import sp.common.controller.AbstractController;
import jh.reserve.model.ReservationDAO;
import jh.reserve.model.ReservationDAO_imple;

public class AdminScheduleBoardController extends AbstractController {


    @SuppressWarnings("unchecked")
    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

    	ReservationDAO dao = new ReservationDAO_imple();
    	

    	// testmode!
    	boolean testMode = false;

    	HttpSession session = request.getSession();
    	MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");

    	// ✅ 테스트모드일 때만 "로컬 변수"로만 admin 부여 (세션에 넣지 말 것)
    	if (testMode && (loginuser == null || !"admin".equals(loginuser.getUserid()))) {
    	    loginuser = new MemberDTO();
    	    loginuser.setUserid("admin");
    	}

    	// ✅ 권한체크는 이렇게 (testMode=false일 때만 막기)
    	if (!testMode && (loginuser == null || !"admin".equals(loginuser.getUserid()))) {

    	    JSONObject json = new JSONObject();
    	    json.put("ok", false);
    	    json.put("message", "관리자만 접근 가능(로그인 필요)");

    	    // 방법 A: 401 유지 (프론트에서 fail 처리 필요)
    	    response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);

    	    request.setAttribute("json", json.toString());
    	    super.setRedirect(false);
    	    super.setViewPage("/WEB-INF/hk_admin/jsonview.jsp");
    	    return;
    	}

        
        String storeId = request.getParameter("storeId");
        String date = request.getParameter("date"); // yyyy-MM-dd

        JSONObject json = new JSONObject();

        if(storeId == null || date == null || storeId.isBlank() || date.isBlank()) {
            json.put("ok", false);
            json.put("message", "필수값 누락(storeId,date)");
            request.setAttribute("json", json.toString());
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/hk_admin/jsonview.jsp");
            return;
        }

        LocalDate d = LocalDate.parse(date);
        String dayStart = d.atStartOfDay().toString().replace('T',' ') + ":00";
        String dayEnd   = d.plusDays(1).atStartOfDay().toString().replace('T',' ') + ":00";

        Map<String,String> paraMap = new HashMap<>();
        paraMap.put("storeId", storeId);
        paraMap.put("dayStart", dayStart);
        paraMap.put("dayEnd", dayEnd);

        List<Map<String,String>> events = dao.selectScheduleBoard(paraMap);

        JSONArray arr = new JSONArray();
        for(Map<String,String> e : events) {
            JSONObject o = new JSONObject();
            o.putAll(e);
            arr.add(o);
        }

        json.put("ok", true);
        json.put("storeId", storeId);
        json.put("date", date);
        json.put("events", arr);

        request.setAttribute("json", json.toString());
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/hk_admin/jsonview.jsp");
    }
}
