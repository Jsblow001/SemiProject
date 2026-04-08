package ih.product.controller;

import java.util.HashMap;
import java.util.Map;

import hk.member.domain.MemberDTO;
import ih.product.model.ProductDAO;
import ih.product.model.ProductDAO_imple;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import sp.common.controller.AbstractController;

public class AddressRegisterController extends AbstractController {

    ProductDAO pdao = new ProductDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        // 로그인 여부 확인
        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");

        if (loginuser == null) {

            request.setAttribute("message", "로그인이 필요합니다.");
            request.setAttribute("loc", "javascript:window.close()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        String method = request.getMethod(); // "GET" 또는 "POST"

        if ("GET".equalsIgnoreCase(method)) {
            // 주소 등록 폼 보여주기
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/ih_product/addressRegister.jsp");
            
        } else {
            // 주소 DB에 저장하기 (POST)
            String postcode = request.getParameter("postcode");
            String address = request.getParameter("address");
            String detailaddress = request.getParameter("detailaddress");
            String extraaddress = request.getParameter("extraaddress");
            
            Map<String, String> paraMap = new HashMap<>();
            paraMap.put("userid", loginuser.getUserid());
            paraMap.put("postcode", postcode);
            paraMap.put("address", address);
            paraMap.put("detailaddress", detailaddress);
            paraMap.put("extraaddress", extraaddress);

            // DB에 주소 인서트
            int n = pdao.registerAddress(paraMap); 

            if (n == 1) {
                // 성공 시 부모창(orderForm)을 새로고침하고 팝업을 닫음
                request.setAttribute("message", "배송지가 등록되었습니다.");
                request.setAttribute("loc", "javascript:window.opener.refreshAddress(); window.close();");
            } else {
                request.setAttribute("message", "배송지 등록에 실패했습니다.");
                request.setAttribute("loc", "javascript:history.back();");
            }

            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
        }
    }
}