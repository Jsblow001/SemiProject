package hk.admin.controller;

import sp.common.controller.AbstractController;
import hk.member.domain.MemberDTO;
import hk.member.model.MemberDAO;
import hk.member.model.MemberDAO_imple;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class AdminMemberMainController extends AbstractController {

    private MemberDAO mdao = new MemberDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        /* ==================================================
         * 1. 관리자 로그인 / 권한 체크
         * ================================================== */
        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");

        if (loginuser == null || !"admin".equals(loginuser.getUserid())) {
            request.setAttribute("message", "관리자만 접근할 수 있습니다.");
            request.setAttribute("loc", request.getContextPath() + "/index.sp");

            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        
        /* ==================================================
         * 2. 회원 요약 데이터 조회
         * ================================================== */
        //int totalCount  = mdao.getTotalMemberCount();    // 전체 회원 수
        //int activeCount = mdao.getTotalMemberCount();    // 정상 회원
        //int deleteCount = mdao.getTotalMemberCount();    // 탈퇴 회원
        //int idleCount   = mdao.getTotalMemberCount();    // 휴면 회원

        
        /* ==================================================
         * 2-1. 오늘 회원가입 수 조회
         * ================================================== */
        int todayRegisterCount = mdao.getTodayRegisterCount();
        
        
        /* ==================================================
         * 3. JSP로 전달
         * ================================================== */
        //request.setAttribute("totalCount", totalCount);
        //request.setAttribute("activeCount", activeCount);
        //request.setAttribute("deleteCount", deleteCount);
        //request.setAttribute("idleCount", idleCount);
        request.setAttribute("todayRegisterCount", todayRegisterCount);
        
        
        /* ==================================================
         * 4. 회원관리 대시보드 JSP 이동
         * ================================================== */
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/hk_admin/memberMain.jsp");
    }
}
