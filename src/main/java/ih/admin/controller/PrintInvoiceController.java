package ih.admin.controller;

import java.util.List;

import ih.product.domain.AdminOrderDTO;
import ih.product.model.AdminOrderDAO;
import ih.product.model.AdminOrderDAO_imple;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import sp.common.controller.AbstractController;

public class PrintInvoiceController extends AbstractController {

	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String odrcode = request.getParameter("odrcode");

        if(odrcode != null) {
           
        	AdminOrderDAO odao = new AdminOrderDAO_imple();
            
            AdminOrderDTO orderInfo = odao.getOrderDetail(odrcode); 
            List<AdminOrderDTO> detailList = odao.getOrderDetailList(odrcode);

            request.setAttribute("orderInfo", orderInfo);
            request.setAttribute("detailList", detailList);

            super.setRedirect(false);
            super.setViewPage("/WEB-INF/ih_admin/printInvoice.jsp");
        } else {
            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/ih_admin/adminOrderList.sp");
        }
    
	}

}
