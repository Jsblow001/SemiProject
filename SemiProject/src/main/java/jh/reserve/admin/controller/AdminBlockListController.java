package jh.reserve.admin.controller;

import java.time.LocalDate;
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

public class AdminBlockListController extends AbstractController {

    private ReservationDAO dao = new ReservationDAO_imple();

    @SuppressWarnings("unchecked")
    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

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

        Map<String, String> paraMap = new HashMap<>();
        paraMap.put("storeId", storeId);
        paraMap.put("dayStart", dayStart);
        paraMap.put("dayEnd", dayEnd);

        List<Map<String, String>> list = dao.selectBlockList(paraMap);

        JSONArray arr = new JSONArray();
        for(Map<String, String> m : list) {
            JSONObject o = new JSONObject();
            o.putAll(m);
            arr.add(o);
        }

        json.put("ok", true);
        json.put("storeId", storeId);
        json.put("date", date);
        json.put("blocks", arr);

        request.setAttribute("json", json.toString());
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/hk_admin/jsonview.jsp");
    }
}
