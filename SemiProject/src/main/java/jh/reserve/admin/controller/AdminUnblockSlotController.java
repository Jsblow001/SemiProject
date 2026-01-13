package jh.reserve.admin.controller;

import java.util.HashMap;
import java.util.Map;

import org.json.simple.JSONObject;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import sp.common.controller.AbstractController;
import jh.reserve.model.ReservationDAO;
import jh.reserve.model.ReservationDAO_imple;

public class AdminUnblockSlotController extends AbstractController {


    @SuppressWarnings("unchecked")
    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

    	ReservationDAO dao = new ReservationDAO_imple();
    	
        JSONObject json = new JSONObject();

        if(!"POST".equalsIgnoreCase(request.getMethod())) {
            json.put("ok", false);
            json.put("message", "POST only");
            request.setAttribute("json", json.toString());
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/hk_admin/jsonview.jsp");
            return;
        }

        String blockId = request.getParameter("blockId");
        if(blockId == null || blockId.isBlank()) {
            json.put("ok", false);
            json.put("message", "필수값 누락(blockId)");
            request.setAttribute("json", json.toString());
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/hk_admin/jsonview.jsp");
            return;
        }

        Map<String, String> paraMap = new HashMap<>();
        paraMap.put("blockId", blockId);

        int n = dao.deleteBlockSlot(paraMap);

        json.put("ok", n == 1);
        if(n != 1) json.put("message", "삭제 대상이 없습니다.");

        request.setAttribute("json", json.toString());
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/hk_admin/jsonview.jsp");
    }
}
