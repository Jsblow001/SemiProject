package js.admin.visitor;

import hk.member.domain.MemberDTO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import sp.common.controller.AbstractController;
import js.admin.visitor.model.VisitorDAO;
import js.admin.visitor.model.VisitorDAO_imple;

public class VisitorCheckController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
    	
        HttpSession session = request.getSession();
        String ip = request.getRemoteAddr();
        VisitorDAO vdao = new VisitorDAO_imple();

        // [추가] 세션에서 로그인한 회원 정보 가져오기
        // 로그인 시 세션에 저장한 이름이 "loginuser"라고 가정합니다.
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");
        String memberId = null;
        if (loginuser != null) {
            memberId = loginuser.getUserid(); // 로그인한 사용자의 ID 추출
        }

        // 1. 방문 기록 로직
        if (session.getAttribute("isVisited") == null) {
            // [수정] IP와 함께 memberId를 넘겨줍니다.
            vdao.insertVisitor(ip, memberId); 
            session.setAttribute("isVisited", true);
        } else {
            vdao.updateLastAccess(ip); 
        }

        // 2. 현재 실시간 접속자 수 계산
        int liveUserCount = vdao.getLiveUserCount();

        // 3. AJAX 응답
        response.setContentType("text/plain");
        response.getWriter().print(liveUserCount);

        super.setViewPage(null); 
    }
}