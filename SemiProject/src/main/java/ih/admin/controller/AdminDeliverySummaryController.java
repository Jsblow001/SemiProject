package ih.admin.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import ih.product.domain.AdminOrderDTO;
import ih.product.model.AdminOrderDAO;
import ih.product.model.AdminOrderDAO_imple;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import sp.common.controller.AbstractController;

public class AdminDeliverySummaryController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        AdminOrderDAO odao = new AdminOrderDAO_imple();
        
        String currentShowPageNo = request.getParameter("currentShowPageNo");
        if(currentShowPageNo == null) {
            currentShowPageNo = "1";
        }
        
        int sizePerPage = 10; // 한 페이지당 보여줄 게시물 수
        
        Map<String, String> paraMap = new HashMap<>();
        paraMap.put("currentShowPageNo", currentShowPageNo);
        paraMap.put("sizePerPage", String.valueOf(sizePerPage));

        List<AdminOrderDTO> orderList = odao.selectPagingOrderList(paraMap); 
        Map<String, Integer> summary = odao.getDeliveryStatusCount();
        
        int totalOrderCount = odao.getTotalOrderCount(); 
        
        //페이지바 만들기
        int totalPage = (int) Math.ceil((double)totalOrderCount / sizePerPage);
        int blockSize = 5;    
        int loop = 1;         
        int pageNo = (((Integer.parseInt(currentShowPageNo) - 1) / blockSize) * blockSize) + 1;
        
        StringBuilder pageBar = new StringBuilder();
        
        // [이전] 
        if(pageNo != 1) {
            pageBar.append("<li class='page-item'><a class='page-link' href='adminDeliverySummary.sp?currentShowPageNo=").append(pageNo-1).append("'>이전</a></li>");
        }
        
        // 페이지 번호 출력
        while(!(loop > blockSize || pageNo > totalPage)) {
            if(pageNo == Integer.parseInt(currentShowPageNo)) {
                pageBar.append("<li class='page-item active'><a class='page-link'>").append(pageNo).append("</a></li>");
            } else {
                pageBar.append("<li class='page-item'><a class='page-link' href='adminDeliverySummary.sp?currentShowPageNo=").append(pageNo).append("'>").append(pageNo).append("</a></li>");
            }
            loop++;
            pageNo++;
        }
        
        // [다음] 
        if(pageNo <= totalPage) {
            pageBar.append("<li class='page-item'><a class='page-link' href='adminDeliverySummary.sp?currentShowPageNo=").append(pageNo).append("'>다음</a></li>");
        }

        request.setAttribute("orderList", orderList);
        request.setAttribute("summary", summary);
        request.setAttribute("pageBar", pageBar.toString());
        
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/ih_admin/deliverySummary.jsp");
        
    }
}