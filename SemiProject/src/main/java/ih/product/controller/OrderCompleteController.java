package ih.product.controller;

import hk.member.domain.MemberDTO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import sp.common.controller.AbstractController;
import ih.mail.controller.GoogleMail;

public class OrderCompleteController extends AbstractController {
	
    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");

        // System.out.println("### OrderCompleteController 진입 ###");

        String odrcode = request.getParameter("odrcode");
        String pName = request.getParameter("pName");
        // String product_name = request.getParameter("product_name");
        // System.out.println("### 전달받은 pName: " + pName);
        // System.out.println("### 전달받은 product_name: " + product_name);
        
        if(pName == null || pName.isEmpty()) {
        	pName = "주문 상품";
        }
       
        if(loginuser != null && odrcode != null) {
            // System.out.println("조건 만족: 쓰레드 시작");
            
            final String email = loginuser.getEmail();
            final String name = loginuser.getName();
            final String orderCode = odrcode;
            final String finalPName = pName;
            
            Thread mailThread = new Thread(new Runnable() {
                @Override
                public void run() {
                    GoogleMail mail = new GoogleMail();
                    try {
                        System.out.println("### [쓰레드] 메일 발송 메소드 호출 직전 ###");
                        mail.sendmail(email, name, orderCode, finalPName); 
                        System.out.println("### [쓰레드] 메일 발송 성공 ###");
                    } catch (Exception e) {
                        System.out.println("### [쓰레드] 에러 발생!!! ###");
                        e.printStackTrace();
                    }
                }
            });
            mailThread.start();
        } else {
            // System.out.println("### 조건 불만족: odrcode 혹은 loginuser가 null입니다. ###");
        }

        request.setAttribute("message", "주문이 성공적으로 완료되었습니다!");
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/ih_product/orderComplete.jsp");
    }
}