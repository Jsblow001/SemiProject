package ih.admin.controller;

import java.util.List;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import sp.common.controller.AbstractController;
import ih.product.domain.AdminOrderDTO;
import ih.product.model.AdminOrderDAO;
import ih.product.model.AdminOrderDAO_imple;
import hk.member.domain.*;;

public class AdminOrderDetailController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
       
        // 관리자 권한 확인
        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");

        if(loginuser == null || !"admin".equals(loginuser.getUserid())) {
            String message = "관리자 전용 페이지입니다.";
            String loc = "javascript:history.back()";
            
            request.setAttribute("message", message);
            request.setAttribute("loc", loc);
            
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        String odrcode = request.getParameter("odrcode");

        if(odrcode == null || odrcode.trim().isEmpty()) {
            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/admin/adminOrderList.sp");
            return;
        }

        AdminOrderDAO odao = new AdminOrderDAO_imple();

        // 주문 1건에 대한 메인 정보 조회 (회원명, 주소, 총액 등)
        AdminOrderDTO orderInfo = odao.selectOneOrder(odrcode);

        // 해당 주문의 상세 상품 목록 조회 (상품명, 수량, 단가 등)
        List<AdminOrderDTO> detailList = odao.selectOrderDetailList(odrcode);

        request.setAttribute("orderInfo", orderInfo);
        request.setAttribute("detailList", detailList);

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/ih_admin/adminOrderDetail.jsp"); 
    }
}