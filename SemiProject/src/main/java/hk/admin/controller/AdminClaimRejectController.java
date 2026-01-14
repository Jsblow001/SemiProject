package hk.admin.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import sp.common.controller.AbstractController;
import hk.order.domain.OrderDetailDTO;
import hk.order.model.OrderDAO;
import hk.order.model.OrderDAO_imple;

public class AdminClaimRejectController extends AbstractController {

    private OrderDAO odao = new OrderDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        // ================================
        // 1️. GET 요청 → 반려 사유 입력 화면
        // ================================
        if ("GET".equalsIgnoreCase(request.getMethod())) {

            /*
             * odrdetailno는
             *  - 관리자 목록에서 반려 버튼 클릭 시 넘어옴
             *  - JSP에서 hidden 값으로 다시 사용
             */
        	int odrDetailNo = Integer.parseInt(request.getParameter("odrdetailno"));

        	OrderDetailDTO dto = odao.getClaimDetail(odrDetailNo);

        	request.setAttribute("claim", dto);


            super.setRedirect(false);
            super.setViewPage("/WEB-INF/hk_admin/claimRejectForm.jsp");
            return;
        }

        // ================================
        // 2️. POST 요청 → 실제 반려 처리
        // ================================

        int odrDetailNo = Integer.parseInt(request.getParameter("odrdetailno"));
        String rejectReason = request.getParameter("rejectReason");

        // (선택) 서버단 최소 검증
        if (rejectReason == null || rejectReason.trim().isEmpty()) {
            request.setAttribute("message", "반려 사유는 필수입니다.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // 3️. DB 반려 처리
        odao.rejectClaim(odrDetailNo, rejectReason);

        // 4️. 목록으로 이동
        super.setRedirect(true);
        super.setViewPage(request.getContextPath() + "/admin/claimList.sp");
    }
}
