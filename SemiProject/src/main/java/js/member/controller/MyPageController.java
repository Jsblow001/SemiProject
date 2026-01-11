package js.member.controller;

import sp.common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.time.LocalDate;
import java.util.List;

import hk.member.domain.MemberDTO;
import hk.order.domain.OrderDTO;
import hk.order.model.OrderDAO;
import hk.order.model.OrderDAO_imple;

public class MyPageController extends AbstractController {

    private OrderDAO odao = new OrderDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        /* ===============================
           1. 로그인 여부 검사
        =============================== */
        if (!super.checkLogin(request)) {
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/hk_login/loginSelect.jsp");
            return;
        }

        /* ===============================
           2. 로그인 사용자 정보
        =============================== */
        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");

        String userid = loginuser.getUserid();

        /* ===============================
        3. 최근 30일 주문 조회
	    =============================== */
	    LocalDate today = LocalDate.now();
	    String startDate = today.minusDays(30).toString();
	    String endDate   = today.toString();
	
	    int startRow = 1;
	     int endRow   = 5;
	    
	    List<OrderDTO> recentOrderList = odao.selectMyOrderList(userid, null, startDate, endDate, startRow, endRow);

        /* ===============================
           4. request 영역에 저장
        =============================== */
        request.setAttribute("recentOrderList", recentOrderList);

        /* ===============================
           5. 마이페이지 이동
        =============================== */
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/js_member/mypage.jsp");
    }
}
