package ih.admin.controller;

import org.json.JSONObject;

import ih.product.model.AdminOrderDAO;
import ih.product.model.AdminOrderDAO_imple;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import sp.common.controller.AbstractController;

public class AdminUpdateInvoiceController extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String odrdetailno = request.getParameter("odrdetailno");
        String invoice_no = request.getParameter("invoice_no");
        String method = request.getMethod(); // GET 또는 POST

        JSONObject jsonObj = new JSONObject();

        if("POST".equalsIgnoreCase(method)) {
            AdminOrderDAO adao = new AdminOrderDAO_imple();
            
            // DAO에서 DB 업데이트 실행
            int n = adao.updateInvoice(odrdetailno, invoice_no);

            if(n == 1) {
                jsonObj.put("result", 1); // 성공
            } else {
                jsonObj.put("result", 0); // 실패
            }
        } else {
            jsonObj.put("result", -1); 
        }

        String json = jsonObj.toString();
        request.setAttribute("json", json);
        
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/ih_jsonview.jsp");
		
	}

}
