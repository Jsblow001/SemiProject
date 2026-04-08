package js.member.controller;

import java.util.List; // 추가
import sp.common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import hk.member.domain.AddressDTO; // 추가
import hk.member.domain.MemberDTO;
import hk.member.model.MemberDAO;       // 추가
import hk.member.model.MemberDAO_imple; // 추가

public class MemberEditController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        // 1. 로그인 여부 확인
        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");

        if (loginuser == null) {
            request.setAttribute("message", "먼저 로그인을 하세요.");
            request.setAttribute("loc", request.getContextPath() + "/login.sp");
            // forward는 AbstractController의 setViewPage를 쓰는 것이 일관성 있습니다.
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // 2. 추가 배송지 목록 조회 (핵심 추가 파트)
        // 세션에는 기본 정보만 있으므로, 추가 주소록은 DB에서 새로 가져와야 합니다.
        MemberDAO mdao = new MemberDAO_imple();
        List<AddressDTO> addressList = mdao.selectAddressList(loginuser.getUserid());

        // 3. JSP로 데이터 전달
        request.setAttribute("addressList", addressList);

        // 4. 수정 페이지(JSP)로 이동
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/js_member/memberedit.jsp");
    }
}