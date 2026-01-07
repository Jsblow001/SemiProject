package js.member.controller;

import sp.common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import hk.member.domain.MemberDTO;
import js.member.model.MemberDAO;
import js.member.model.MemberDAO_imple;
import sp.util.security.Sha256;

public class MemberEditEndController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        String method = request.getMethod();

        if ("POST".equalsIgnoreCase(method)) {
            
            HttpSession session = request.getSession();
            MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");

            if(loginuser == null) {
                request.setAttribute("message", "로그인 후 이용 가능합니다.");
                request.setAttribute("loc", request.getContextPath() + "/login.sp");
                request.getRequestDispatcher("/msg.jsp").forward(request, response);
                return;
            }

            // 1. 데이터 받아오기 
            String userid = request.getParameter("userid");
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String mobile = request.getParameter("mobile");
            String postcode = request.getParameter("postcode");
            String address = request.getParameter("address");
            String detailaddress = request.getParameter("detailaddress");
            String extraaddress = request.getParameter("extraaddress");
            String gender = request.getParameter("gender"); 
            String birthday = request.getParameter("birthday");
            String new_passwd = request.getParameter("new_passwd");

            // 2. 빈칸 처리 로직 (빈칸이면 기존 정보 유지)
            if (userid == null || userid.trim().isEmpty()) { userid = loginuser.getUserid(); }
            if (name == null || name.trim().isEmpty()) { name = loginuser.getName(); }
            if (email == null || email.trim().isEmpty()) { email = loginuser.getEmail(); }
            if (mobile == null || mobile.trim().isEmpty()) { mobile = loginuser.getMobile(); }
            if (postcode == null || postcode.trim().isEmpty()) { postcode = loginuser.getPostcode(); }
            if (address == null || address.trim().isEmpty()) { address = loginuser.getAddress(); }
            if (detailaddress == null || detailaddress.trim().isEmpty()) { detailaddress = loginuser.getDetailaddress(); }
            if (extraaddress == null || extraaddress.trim().isEmpty()) { extraaddress = loginuser.getExtraaddress(); }
            if (gender == null || gender.trim().isEmpty()) { gender = loginuser.getGender(); }
            if (birthday == null || birthday.trim().isEmpty()) { birthday = loginuser.getBirthday(); }

            // 3. DTO 객체 생성 및 데이터 담기
            MemberDTO member = new MemberDTO();
            member.setUserid(userid);
            member.setName(name);
            member.setEmail(email);
            member.setMobile(mobile);
            member.setPostcode(postcode);
            member.setAddress(address);
            member.setDetailaddress(detailaddress);
            member.setExtraaddress(extraaddress);
            member.setGender(gender);
            member.setBirthday(birthday);
            
            if (new_passwd != null && !new_passwd.trim().isEmpty()) {
                member.setPasswd(new_passwd); 
            } else {
                member.setPasswd(null); 
            }

            // 4. DAO 호출하여 DB 업데이트
            MemberDAO mdao = new MemberDAO_imple();
            int n = mdao.updateMember(member);

            if (n == 1) {
                // 5. 세션 갱신
                loginuser.setName(name);
                loginuser.setEmail(email);
                loginuser.setMobile(mobile);
                loginuser.setPostcode(postcode);
                loginuser.setAddress(address);
                loginuser.setDetailaddress(detailaddress);
                loginuser.setExtraaddress(extraaddress);
                loginuser.setGender(gender);
                loginuser.setBirthday(birthday);

                request.setAttribute("message", "회원정보 수정이 완료되었습니다.");
                request.setAttribute("loc", request.getContextPath() + "/mypage.sp");
            } else {
                request.setAttribute("message", "정보 수정에 실패했습니다.");
                request.setAttribute("loc", "javascript:history.back()");
            }

            request.getRequestDispatcher("/WEB-INF/msg.jsp").forward(request, response);
            
        } else {
            request.setAttribute("message", "비정상적인 접근입니다.");
            request.setAttribute("loc", request.getContextPath() + "/index.sp");
            request.getRequestDispatcher("/WEB-INF/msg.jsp").forward(request, response);
        }
    }
}