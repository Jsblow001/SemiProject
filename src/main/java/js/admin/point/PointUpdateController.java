package js.admin.point;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONObject;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import sp.common.controller.AbstractController;
import js.member.model.MemberDAO;
import js.member.model.MemberDAO_imple;

public class PointUpdateController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        // POST 방식일 때만 처리하도록 제한 (보안)
        String method = request.getMethod();
        
        if(!"POST".equalsIgnoreCase(method)) {
            // GET 방식으로 접근 시 에러 처리
            return;
        }

        // 1. 전달받은 파라미터 읽기
        String userid = request.getParameter("userid");
        String addPointStr = request.getParameter("addPoint");
        
        int n = 0;
        try {
            int addPoint = Integer.parseInt(addPointStr);

            // 2. DB 업데이트를 위한 Map 생성
            Map<String, Object> paraMap = new HashMap<>();
            paraMap.put("userid", userid);
            paraMap.put("addPoint", addPoint);

            // 3. DAO 호출하여 포인트 업데이트
            MemberDAO mdao = new MemberDAO_imple();
            n = mdao.updateMemberPoint(paraMap); 
            
        } catch (NumberFormatException e) {
            n = 0; // 숫자 변환 실패 시 실패 처리
        }

        // 4. 결과를 JSON으로 생성하여 뷰(msg.jsp 등)로 전달
        JSONObject jsonObj = new JSONObject();
        jsonObj.put("n", n); // 성공하면 1, 실패하면 0

        String json = jsonObj.toString();
        request.setAttribute("json", json);

        // 5. JSON 출력을 전용으로 하는 페이지로 포워드
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/ih_jsonview.jsp"); 
    }
}