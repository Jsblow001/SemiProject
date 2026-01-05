package ih.product.controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import sp.common.controller.AbstractController;

import java.io.IOException;
import java.sql.SQLException;

import org.json.JSONObject;

import hk.member.domain.MemberDTO;
import ih.product.model.ProductDAO;
import ih.product.model.ProductDAO_imple;


@WebServlet("/WishProcessController")
public class WishProcessController extends AbstractController {
	private static final long serialVersionUID = 1L;
   
	public void execute(HttpServletRequest request, HttpServletResponse response) throws IOException {
		
		
		// 로그인 여부 확인
		HttpSession session = request.getSession();
		MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");
		
		JSONObject jsonObj = new JSONObject();
		
		if(loginuser == null) {
			// 로그인이 안 된 경우
			jsonObj.put("result", "login_required");
			jsonObj.put("loc", request.getContextPath() + "/login.sp");
		}
		else {
			// 로그인이 된 경우
			
			String product_id = request.getParameter("product_id");
			String userid = loginuser.getUserid();
			
			ProductDAO pdao = new ProductDAO_imple();
			
			// DB
			int result;
			try {
				result = pdao.processWish(userid, product_id);

				if(result == 1) {
	                jsonObj.put("result", "added");
	                jsonObj.put("message", "찜 목록에 추가되었습니다.");
	            } else if(result == -1) {
	                jsonObj.put("result", "removed");
	                jsonObj.put("message", "찜 목록에서 제거되었습니다.");
	            } else {
	                jsonObj.put("result", "error");
	                jsonObj.put("message", "DB 오류가 발생했습니다.");
	            }
				
			} catch (SQLException e) {
				e.printStackTrace();
			}
			
		}
		
		response.setContentType("application/json; charset=UTF-8");
        response.getWriter().print(jsonObj.toString());
		
	}

}
