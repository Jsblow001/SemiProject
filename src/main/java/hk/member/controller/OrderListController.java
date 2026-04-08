package hk.member.controller;

import java.time.LocalDate;
import java.util.List;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import sp.common.controller.AbstractController;

import hk.member.domain.MemberDTO;
import hk.order.domain.OrderDTO;
import hk.order.model.OrderDAO;
import hk.order.model.OrderDAO_imple;

public class OrderListController extends AbstractController {

    private OrderDAO odao = new OrderDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        /* ===============================
           1. 로그인 체크
        =============================== */
        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");

        if (loginuser == null) {
        	
        	request.setAttribute("message", "로그인 후 이용 가능합니다!");
        	request.setAttribute("loc", request.getContextPath() + "/index.sp");
        	
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        String userid = loginuser.getUserid();

        /* ===============================
           2. 파라미터 받기
        =============================== */
        // 필터
        String status    = request.getParameter("status");     // 결제상태
        String startDate = request.getParameter("startDate");  // yyyy-MM-dd
        String endDate   = request.getParameter("endDate");    // yyyy-MM-dd
        String range     = request.getParameter("range");      // today, 7d, 1m, 3m, 6m
        
        // 페이징 처리
        String pageStr = request.getParameter("page");
        int page = 1;        // 기본 1페이지
        int size = 10;       // 한 페이지 10개

        if(pageStr != null) {
            try {
                page = Integer.parseInt(pageStr);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        /* ===============================
           3. 빠른 기간(range) 처리
        =============================== */
        LocalDate today = LocalDate.now();

        if (range != null && !"".equals(range)) {

            switch (range) {
                case "today":
                    startDate = today.toString();
                    endDate   = today.toString();
                    break;

                case "7d":
                    startDate = today.minusDays(7).toString();
                    endDate   = today.toString();
                    break;

                case "1m":
                    startDate = today.minusMonths(1).toString();
                    endDate   = today.toString();
                    break;

                case "3m":
                    startDate = today.minusMonths(3).toString();
                    endDate   = today.toString();
                    break;

                case "6m":
                    startDate = today.minusMonths(6).toString();
                    endDate   = today.toString();
                    break;
            }
        }

        /* ===============================
        4. 페이징 계산
     	=============================== */
        int startRow = (page - 1) * size + 1;
        int endRow   = page * size;
        
        /* ===============================
        5. 총 건수
     	=============================== */
        int totalCount =
            odao.getOrderTotalCount(userid, status, startDate, endDate);

        int totalPage = (int)Math.ceil((double)totalCount / size);
        
        /* ===============================
           6. 주문 목록 조회
        =============================== */
        List<OrderDTO> orderList =
            odao.selectMyOrderList(userid, status, startDate, endDate, startRow, endRow);

        /* ===============================
           7. request 영역에 저장 (값 유지용)
        =============================== */
        request.setAttribute("orderList", orderList);
        request.setAttribute("status", status);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        request.setAttribute("range", range);
        
        // 페이징 처리
        request.setAttribute("page", page);
        request.setAttribute("totalPage", totalPage);
        request.setAttribute("totalCount", totalCount);

        /* ===============================
           6. JSP 이동
        =============================== */
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/hk_member/orderlist.jsp");
    }
}
