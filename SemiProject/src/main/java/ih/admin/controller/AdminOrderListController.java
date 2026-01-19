package ih.admin.controller;

import java.util.*;
import hk.member.domain.MemberDTO;
import ih.product.domain.AdminOrderDTO;
import ih.product.model.*;
import jakarta.servlet.http.*;
import sp.common.controller.AbstractController;

public class AdminOrderListController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");

        // 관리자 권한 체크
        if(loginuser == null || !"admin".equals(loginuser.getUserid())) {
            request.setAttribute("message", "관리자만 접근 가능합니다.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        AdminOrderDAO odao = new AdminOrderDAO_imple();

        String currentShowPageNo = request.getParameter("currentShowPageNo");
        if(currentShowPageNo == null) currentShowPageNo = "1";
        int sizePerPage = 10;

        Map<String, String> paraMap = new HashMap<>();
        paraMap.put("currentShowPageNo", currentShowPageNo);
        paraMap.put("sizePerPage", String.valueOf(sizePerPage));

        List<AdminOrderDTO> orderList = odao.selectPagingOrderList(paraMap);
        List<AdminOrderDTO> allOrderList = odao.selectAllOrder(); // 대시보드 카운트용
        
        // --- 최근 7일 차트 데이터 가져오기 로직 ---
        List<Map<String, String>> trendList = odao.getOrderTrend();
        
        List<String> labelList = new ArrayList<>();
        List<String> dataList = new ArrayList<>();

        if(trendList != null) {
            for(Map<String, String> map : trendList) {
                labelList.add("'" + map.get("odrdate") + "'"); // 차트 JS용 날짜 (따옴표 포함)
                dataList.add(map.get("cnt"));                  // 차트 JS용 주문건수
            }
        }
        // ------------------------------------------

        // 대시보드 카운트 계산
        int newOrderCount = 0, shippingCount = 0, completeCount = 0, totalOrderCount = 0;
        if(allOrderList != null) {
            totalOrderCount = allOrderList.size();
            for(AdminOrderDTO dto : allOrderList) {
                int status = dto.getDeliverystatus();
                if(status == 1) newOrderCount++;
                else if(status == 2) shippingCount++;
                else if(status == 3) completeCount++;
            }
        }

        // 페이지바 생성
        int totalPage = (int) Math.ceil((double)totalOrderCount / sizePerPage);
        int blockSize = 5;
        int pageNo = (((Integer.parseInt(currentShowPageNo) - 1) / blockSize) * blockSize) + 1;
        
        StringBuilder pageBar = new StringBuilder();
        if(pageNo != 1) {
            pageBar.append("<li><a href='adminOrderList.sp?currentShowPageNo=").append(pageNo-1).append("'>[이전]</a></li>");
        }
        
        int loop = 1;
        while(!(loop > blockSize || pageNo > totalPage)) {
            if(pageNo == Integer.parseInt(currentShowPageNo)) {
                pageBar.append("<li class='active'><a>").append(pageNo).append("</a></li>");
            } else {
                pageBar.append("<li><a href='adminOrderList.sp?currentShowPageNo=").append(pageNo).append("'>").append(pageNo).append("</a></li>");
            }
            loop++;
            pageNo++;
        }
        
        if(pageNo <= totalPage) {
            pageBar.append("<li><a href='adminOrderList.sp?currentShowPageNo=").append(pageNo).append("'>[다음]</a></li>");
        }

        // jsp로 전달
        request.setAttribute("orderList", orderList);
        request.setAttribute("newOrderCount", newOrderCount);
        request.setAttribute("shippingCount", shippingCount);
        request.setAttribute("completeCount", completeCount);
        request.setAttribute("totalOrderCount", totalOrderCount);
        request.setAttribute("pageBar", pageBar.toString());
        request.setAttribute("chartLabels", String.join(",", labelList));
        request.setAttribute("chartData", String.join(",", dataList));

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/ih_admin/adminOrderList.jsp");
    }
}