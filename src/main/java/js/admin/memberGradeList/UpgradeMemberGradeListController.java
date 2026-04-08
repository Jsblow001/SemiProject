package js.admin.memberGradeList;

import org.json.simple.JSONObject;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import js.admin.memberGradeList.model.GradeListDAO;
import js.admin.memberGradeList.model.GradeListDAO_imple;
import sp.common.controller.AbstractController;

public class UpgradeMemberGradeListController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        // POST 방식으로 전송된 데이터 수신
        String memberId = request.getParameter("memberId");
        String newGrade = request.getParameter("newGrade");
        
        // DAO 객체 생성 및 등급 업데이트 실행
        GradeListDAO gdao = new GradeListDAO_imple();
        int result = gdao.updateMemberGrade(memberId, newGrade);
        
        // 처리 결과를 JSON으로 생성
        // JSP의 success: function(res) { ... } 부분으로 전달됨
        JSONObject jsonObj = new JSONObject();
        jsonObj.put("result", result); // 성공 시 1, 실패 시 0
        
        String json = jsonObj.toString();
        request.setAttribute("json", json);
        
        // JSON 응답 전용 뷰로 이동
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/ih_jsonview.jsp");
    }
}