package ih.admin.controller;

import org.json.JSONObject;
import ih.product.model.AdminOrderDAO;
import ih.product.model.AdminOrderDAO_imple;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import sp.common.controller.AbstractController;

public class AdminUpdateStatusController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        String method = request.getMethod();
        
        if(!"POST".equalsIgnoreCase(method)) {
            return;
        }

        String orderNo = request.getParameter("orderNo");
        String status = request.getParameter("status");

        AdminOrderDAO odao = new AdminOrderDAO_imple();
        int n = odao.updateOrderStatus(orderNo, status); // 성공하면 1, 실패하면 0 반환

        JSONObject jsonObj = new JSONObject();
        jsonObj.put("result", n);

        String json = jsonObj.toString();
        request.setAttribute("json", json);
        
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/ih_jsonview.jsp"); 
    }
}