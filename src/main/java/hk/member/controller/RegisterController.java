package hk.member.controller;

import sp.common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import hk.member.domain.MemberDTO;
import hk.member.domain.AddressDTO;     // ★ 추가
import hk.member.model.MemberDAO;
import hk.member.model.MemberDAO_imple;

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

            super.setRedirect(false);
            super.setViewPage("/WEB-INF/hk_member/register.jsp");
            return;
        }

        /* ==================================================
         * POST : 회원가입 처리
         * ================================================== */
        else {

            // JSP에서 넘어온 값 받기
            String userid        = request.getParameter("userid");
            String passwd        = request.getParameter("passwd");
            String name          = request.getParameter("name");
            String email         = request.getParameter("email");
            String mobile        = request.getParameter("mobile");
            String postcode      = request.getParameter("postcode");
            String address       = request.getParameter("address");
            String detailaddress = request.getParameter("detailaddress");
            String extraaddress  = request.getParameter("extraaddress");
            String birthday      = request.getParameter("birthday");
            String gender        = request.getParameter("gender");

            // ===============================
            // 1️⃣ MemberDTO 세팅
            // ===============================
            MemberDTO member = new MemberDTO();
            member.setUserid(userid);
            member.setPasswd(passwd);
            member.setName(name);
            member.setEmail(email);
            member.setMobile(mobile);
            member.setPostcode(postcode);
            member.setAddress(address);
            member.setDetailaddress(detailaddress);
            member.setExtraaddress(extraaddress);
            member.setBirthday(birthday);
            member.setGender(gender);

            // ===============================
            // 2️⃣ AddressDTO 세팅 (★ 추가)
            // ===============================
            AddressDTO addr = new AddressDTO();
            addr.setFkMemberId(userid);
            addr.setPostcode(postcode);
            addr.setAddress(address);
            addr.setDetailaddress(detailaddress);
            addr.setExtraaddress(extraaddress);
           

            // ===============================
            // 3️⃣ DAO 호출
            // ===============================
            int n = mdao.registerMember(member, addr);

            // ===============================
            // 4️⃣ 결과 처리
            // ===============================
            if (n == 1) {
                request.setAttribute("message", "회원가입이 완료되었습니다.");
                request.setAttribute("loc", request.getContextPath() + "/index.sp");
            }
            else {
                request.setAttribute("message", "회원가입에 실패했습니다.");
                request.setAttribute("loc", "javascript:history.back()");
            }

            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
        }
    }
}
