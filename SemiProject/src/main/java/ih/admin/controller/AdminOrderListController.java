package ih.admin.controller;

import java.util.List;

import hk.member.domain.MemberDTO;
import ih.product.domain.AdminOrderDTO;
import ih.product.model.AdminOrderDAO;
import ih.product.model.AdminOrderDAO_imple;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import sp.common.controller.AbstractController;


public class AdminOrderListController extends AbstractController {

 @Override
 public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

     HttpSession session = request.getSession();
     MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");

     if(loginuser == null || !"admin".equals(loginuser.getUserid())) {
    	 String message = "관리자만 접근 가능합니다.";
         String loc = "javascript:history.back()";

         request.setAttribute("message", message);
         request.setAttribute("loc", loc);

         super.setRedirect(false);
         super.setViewPage("/WEB-INF/msg.jsp");
         return;
     }

     AdminOrderDAO odao = new AdminOrderDAO_imple();
     List<AdminOrderDTO> orderList = odao.selectAllOrder(); 

     // === 대시보드용 카운트 계산 로직 ===
     int newOrderCount = 0;    // 결제완료(1)
     int shippingCount = 0;    // 배송중(2)
     int completeCount = 0;    // 배송완료(3)
     int totalOrderCount = 0;  // 전체 주문수

     if(orderList != null) {
         totalOrderCount = orderList.size();
         for(AdminOrderDTO dto : orderList) {
             int status = dto.getDeliverystatus();
             
             if(status == 1) newOrderCount++;
             else if(status == 2) shippingCount++;
             else if(status == 3) completeCount++;
         }
     }

     // JSP로 데이터 전달
     request.setAttribute("orderList", orderList);
     request.setAttribute("newOrderCount", newOrderCount);
     request.setAttribute("shippingCount", shippingCount);
     request.setAttribute("completeCount", completeCount);
     request.setAttribute("totalOrderCount", totalOrderCount);
     
     super.setRedirect(false);
     super.setViewPage("/WEB-INF/ih_admin/adminOrderList.jsp");
 }
}