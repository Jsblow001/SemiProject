package jh.reserve.controller;

import org.json.simple.JSONObject;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jh.reserve.model.ReservationDAO;
import jh.reserve.model.ReservationDAO_imple;
import sp.common.controller.AbstractController;

public class StoreTelController extends AbstractController {

    private ReservationDAO dao = new ReservationDAO_imple();

    @SuppressWarnings("unchecked")
    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        String storeId = "store"+request.getParameter("storeId");
        System.out.println("확인용 storeId : " + storeId);

        JSONObject json = new JSONObject();

        try {
            String tel = dao.selectStoreTel(storeId);

            json.put("ok", true);
            json.put("tel", tel == null ? "" : tel);

        } catch(Exception e) {
            json.put("ok", false);
            json.put("message", e.getMessage());
        }

        request.setAttribute("json", json.toString());
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/hk_admin/jsonview.jsp");
    }
}
