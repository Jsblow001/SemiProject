package hk.admin.controller;

import sp.common.controller.AbstractController;

import java.util.List;

import hk.member.domain.MemberDTO;
import hk.member.model.MemberDAO;
import hk.member.model.MemberDAO_imple;
import ih.product.domain.AdminOrderDTO;
import ih.product.model.AdminOrderDAO;
import ih.product.model.AdminOrderDAO_imple;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import js.qna.model.MyQnaListDAO;
import js.qna.model.MyQnaListDAO_imple;

public class AdminController extends AbstractController {

   MemberDAO mdao = new MemberDAO_imple();
   MyQnaListDAO mydao = new MyQnaListDAO_imple();
   AdminOrderDAO odao = new AdminOrderDAO_imple();
   
    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
       
        // ===============================
        // 관리자 로그인 여부 체크
        // ===============================
        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");

        // 로그인 안 했으면 접근 불가
        if (loginuser == null) {
     
            request.setAttribute("message", "관리자 로그인이 필요합니다.");
            request.setAttribute("loc", request.getContextPath() + "/login.sp?mode=admin");

            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // 관리자 계정이 아니면 접근 불가
        if (!"admin".equals(loginuser.getUserid())) {
            request.setAttribute("message", "관리자만 접근할 수 있는 페이지입니다.");
            request.setAttribute("loc", request.getContextPath() + "/index.sp");

            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // 1. DB에서 값을 가져와 자바 변수에 할당
        int totalCount  = mdao.getTotalMemberCount();
        int newQnACount = mydao.noCommentCnt();

        List<AdminOrderDTO> orderList = odao.selectAllOrder();
        
        int newOrderCount = 0;
        int totalOrderCount = 0;
        
        if(orderList != null) {
            totalOrderCount = orderList.size();
            for(AdminOrderDTO dto : orderList) {
                int status = dto.getDeliverystatus();
                
                if(status == 1) newOrderCount++;
            }
        }
              
        // 2. JSP에서 사용할 이름으로 request 영역에 저장
        request.setAttribute("totalCount", totalCount); 
        request.setAttribute("newQnACount", newQnACount);
        request.setAttribute("newOrderCount", newOrderCount);
        
        // ===============================
        // 관리자 메인 페이지 보여주기 (껍데기)
        // ===============================
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/js_admin/adminIndex.jsp");
    }
}
