package ih.mail.controller;

import java.util.Properties;

import javax.mail.*;
import javax.mail.internet.*;


public class GoogleMail {
	public void sendmail(String recipient, String name, String orderCode, String pName) throws Exception {
	      
		// System.out.println("@@@ [DEBUG] 받는사람: " + recipient);
	    // System.out.println("@@@ [DEBUG] 주문번호: " + orderCode);
	    // System.out.println("@@@ [DEBUG] 상품명: " + pName);
	    // System.out.println("@@@ [DEBUG] 고객명: " + name);
	       
	       // 1. 정보를 담기 위한 객체
	       Properties prop = new Properties(); 
	       
	       
	       // 2. SMTP(Simple Mail Transfer Protocoal) 서버의 계정 설정
	       //    Google Gmail 과 연결할 경우 Gmail 의 email 주소를 지정 
	       prop.put("mail.smtp.user", "inhye3318@gmail.com"); 
	             
	      
	       // 3. SMTP 서버 정보 설정
	       //    Google Gmail 인 경우  smtp.gmail.com
	       prop.put("mail.smtp.host", "smtp.gmail.com");
	            
	       
	       prop.put("mail.smtp.port", "465");
	       prop.put("mail.smtp.starttls.enable", "true");
	       prop.put("mail.smtp.auth", "true");
	       prop.put("mail.smtp.debug", "true");
	       prop.put("mail.smtp.socketFactory.port", "465");
	       prop.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
	       prop.put("mail.smtp.socketFactory.fallback", "false");
	       
	       prop.put("mail.smtp.ssl.enable", "true");
	       prop.put("mail.smtp.ssl.trust", "smtp.gmail.com");
	       prop.put("mail.smtp.ssl.protocols", "TLSv1.2"); // MAC 에서도 이메일 보내기 가능하도록 한것임. 또한 만약에 SMTP 서버를 google 대신 naver 를 사용하려면 이것을 해주어야 함.
	         
	       /*  
	        	혹시나 465 포트에 연결할 수 없다는 에러메시지가 나오면 아래의 3개를 넣어주면 해결된다.
	       		prop.put("mail.smtp.starttls.enable", "true");
	        	prop.put("mail.smtp.starttls.required", "true");
	        	prop.put("mail.smtp.ssl.protocols", "TLSv1.2");
	        */ 
	       
	       Authenticator smtpAuth = new MySMTPAuthenticator();
	       Session ses = Session.getInstance(prop, smtpAuth);
	          
	       // 메일을 전송할 때 상세한 상황을 콘솔에 출력한다.
	       ses.setDebug(true);
	               
	       // 메일의 내용을 담기 위한 객체생성
	       MimeMessage msg = new MimeMessage(ses);

	       // 제목 설정
	       msg.setSubject("[주문완료] 고객님의 주문이 성공적으로 접수되었습니다.");
	           
	       // 보내는 사람의 메일주소
	       String sender = "inhye3318@gmail.com";
	       Address fromAddr = new InternetAddress(sender);
	       msg.setFrom(fromAddr);
	               
	       // 받는 사람의 메일주소
	       Address toAddr = new InternetAddress(recipient);
	       msg.addRecipient(Message.RecipientType.TO, toAddr);
	               
	       // 메일 내용 설정
	        msg.setFrom(new InternetAddress("inhye3318@gmail.com", "SISEON"));
	        msg.addRecipient(Message.RecipientType.TO, new InternetAddress(recipient));
	        msg.setSubject("[주문완료] 고객님의 주문이 성공적으로 접수되었습니다.");
	        
	        String content = 
	        	    "<div style='max-width: 600px; margin: 20px auto; font-family: \"Apple SD Gothic Neo\", \"Malgun Gothic\", sans-serif; border: 1px solid #eee; border-radius: 10px; overflow: hidden;'>" +
	        	    "    " +
	        	    "    <div style='background-color: #333; color: #fff; padding: 30px; text-align: center;'>" +
	        	    "        <h1 style='margin: 0; font-size: 24px; letter-spacing: 2px;'>SISEON</h1>" +
	        	    "        <p style='margin: 10px 0 0; opacity: 0.8;'>Order Confirmation</p>" +
	        	    "    </div>" +
	        	    "    " +
	        	    "    " +
	        	    "    <div style='padding: 40px 30px; line-height: 1.6; color: #444;'>" +
	        	    "        <h2 style='color: #222; margin-top: 0;'>" + name + " 고객님, 주문해 주셔서 감사합니다.</h2>" +
	        	    "        <p>안녕하세요, <strong>SISEON</strong>입니다.<br>" +
	        	    "        고객님께서 주문하신 상품이 정상적으로 접수되었습니다.</p>" +
	        	    "        " +
	        	    "        <p style='background-color: #f9f9f9; padding: 20px; border-radius: 8px; border-left: 4px solid #333;'>" +
	        	    "            <span style='color: #888; display: inline-block; width: 80px;'>주문번호</span> <strong style='color: #222;'>" + orderCode + "</strong><br>" +
	        	    "            <span style='color: #888; display: inline-block; width: 80px;'>상품명</span> <strong style='color: #222;'>" + pName + "</strong>" +
	        	    "        </p>" +
	        	    "        " +
	        	    "        <p style='margin: 30px 0; color: #555;'>" +
	        	    "            고객님이 주문하신 상품을 <strong>가장 안전하고 신속하게</strong> 확인하여 배송해 드릴 것을 약속드립니다.<br>" +
	        	    "            배송이 시작되면 다시 한번 안내 메일을 보내드리겠습니다." +
	        	    "        </p>" +
	        	    "        " +
	        	    "        <div style='text-align: center; margin-top: 40px;'>" +
	        	    "            <a href='http://localhost:9090/SemiProject/index.sp' style='background-color: #333; color: #fff; padding: 15px 35px; text-decoration: none; border-radius: 5px; font-weight: bold;'>쇼핑몰 바로가기</a>" +
	        	    "        </div>" +
	        	    "    </div>" +
	        	    "    " +
	        	    "    " +
	        	    "    <div style='background-color: #f4f4f4; padding: 20px 30px; font-size: 12px; color: #999; border-top: 1px solid #eee;'>" +
	        	    "        <p style='margin: 0;'>본 메일은 발신 전용입니다. 문의사항은 고객센터를 이용해 주세요.</p>" +
	        	    "        <p style='margin: 5px 0 0;'>© SISEON. All rights reserved.</p>" +
	        	    "    </div>" +
	        	    "</div>";
	        
	        msg.setContent(content, "text/html;charset=UTF-8"); 
	        
	       // 메일 발송하기
	       Transport.send(msg);      
	      
	   }// end of public void sendmail_OrderFinish(String recipient, String orderCode, String productName)----------

}
