package js.member.controller;

import org.json.JSONObject;
import sp.common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import hk.member.domain.AddressDTO;
import hk.member.domain.MemberDTO;
import hk.member.model.MemberDAO;
import hk.member.model.MemberDAO_imple;

public class AddAddressController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        // 1. 로그인 유저 확인
        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");
        
        JSONObject jsonObj = new JSONObject();
        
        if(loginuser == null) {
            jsonObj.put("success", false);
        } else {
            // 2. JSP에서 보낸 파라미터 받기
            String postcode = request.getParameter("postcode");
            String address = request.getParameter("address");
            String detailaddress = request.getParameter("detailaddress");
            String extraaddress = request.getParameter("extraaddress");

            // 3. DTO에 담기
            AddressDTO adto = new AddressDTO();
            adto.setFkMemberId(loginuser.getUserid());
            adto.setPostcode(postcode);
            adto.setAddress(address);
            adto.setDetailaddress(detailaddress);
            adto.setExtraaddress(extraaddress);

            // 4. DB 저장
            MemberDAO mdao = new MemberDAO_imple();
            int n = mdao.addAddress(adto);
            
            if(n == 1) {
                // 저장 성공 시, 방금 생성된 시퀀스 번호(addr_id)를 가져옴 
                // (이 번호가 있어야 JSP에서 새로고침 없이 바로 '삭제' 버튼을 쓸 수 있음)
                int newAddrId = mdao.getLatestAddrId(loginuser.getUserid());
                
                jsonObj.put("success", true);
                jsonObj.put("new_addr_id", newAddrId);
            } else {
                jsonObj.put("success", false);
            }
        }

        // 5. JSON 결과 출력
        String json = jsonObj.toString();
        request.setAttribute("json", json);
        super.setViewPage("/WEB-INF/ih_jsonview.jsp");
    }
}