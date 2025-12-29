package hankyung.member.controller;

import sp.common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import hankyung.member.domain.MemberDTO;
import hankyung.member.model.MemberDAO;
import hankyung.member.model.MemberDAO_imple;

/*
 * [RegisterController]
 * - GET  : 회원가입 페이지 보여주기
 * - POST : 회원가입 처리 (DB insert)
 */
public class RegisterController extends AbstractController {

    // DAO 객체 생성
    private MemberDAO mdao = new MemberDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        String method = request.getMethod();

        /* ==================================================
         * GET : 회원가입 페이지 보여주기
         * ================================================== */
        if ("GET".equalsIgnoreCase(method)) {

            // forward 방식으로 회원가입 JSP 이동
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/member/register.jsp");
            return;
        }

        /* ==================================================
         * POST : 회원가입 처리
         * ================================================== */
        else {

            // JSP에서 넘어온 값 받기
            String userid        = request.getParameter("userid");
            String passwd        = request.getParameter("passwd"); // 변경
            String name          = request.getParameter("name");
            String email         = request.getParameter("email");
            String mobile        = request.getParameter("mobile");
            String postcode      = request.getParameter("postcode");
            String address       = request.getParameter("address");
            String detailaddress = request.getParameter("detailaddress");
            String extraaddress  = request.getParameter("extraaddress");
            String birthday      = request.getParameter("birthday");

            // DTO에 값 세팅
            MemberDTO member = new MemberDTO();
            member.setUserid(userid);
            member.setPasswd(passwd);       // 변경
            member.setName(name);
            member.setEmail(email);          // DAO에서 AES-256 암호화
            member.setMobile(mobile);
            member.setPostcode(postcode);
            member.setAddress(address);
            member.setDetailaddress(detailaddress);
            member.setExtraaddress(extraaddress);
            member.setBirthday(birthday);

            // DAO 호출 → DB insert
            int n = mdao.registerMember(member);
            // n == 1 : 성공
            // n == 0 : 실패

            // 결과 처리
            if (n == 1) {
                // 회원가입 성공
                request.setAttribute("message", "회원가입이 완료되었습니다.");
                request.setAttribute("loc", request.getContextPath() + "/index.sp");
            }
            else {
                // 회원가입 실패
                request.setAttribute("message", "회원가입에 실패했습니다.");
                request.setAttribute("loc", "javascript:history.back()");
            }

            // msg.jsp로 이동
            super.setRedirect(false);
            super.setViewPage("/msg.jsp");
        }
    }
}
