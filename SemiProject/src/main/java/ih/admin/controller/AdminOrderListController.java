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
		// 관리자 로그인 여부 확인
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

        // DB에서 주문 목록 가져오기
        AdminOrderDAO odao = new AdminOrderDAO_imple();
        List<AdminOrderDTO> orderList = odao.selectAllOrder(); 

        request.setAttribute("orderList", orderList);
        
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/ih_admin/adminOrderList.jsp");
		
	}

}
