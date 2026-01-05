package hk.member.controller;

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

        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");

        /* ===============================
           1. 로그인 체크
        =============================== */
        if (loginuser == null) {
            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/login.sp");
            return;
        }

        /* ===============================
           2. 사용자 아이디
        =============================== */
        String userid = loginuser.getUserid();

        /* ===============================
           3. (선제적) 조회 조건 처리
              - 상태
              - 기간
        =============================== */
        String status = request.getParameter("status");      // 결제완료, 배송중 등
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");

        /* ===============================
           4. 주문 목록 조회
        =============================== */
        List<OrderDTO> orderList = 
                odao.selectMyOrderList(userid);

        /* ===============================
           5. request 영역에 저장
        =============================== */
        request.setAttribute("orderList", orderList);
        request.setAttribute("status", status);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);

        /* ===============================
           6. 뷰 페이지 이동
        =============================== */
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/hk_member/orderlist.jsp");
    }
}
