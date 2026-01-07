package js.admin.memberGradeList;

import java.util.List;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import hk.member.domain.MemberDTO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import js.admin.memberGradeList.model.GradeListDAO;
import js.admin.memberGradeList.model.GradeListDAO_imple;
import sp.common.controller.AbstractController;

public class MemberGradeListDataController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        // 1. JSP의 AJAX에서 보낸 등급 코드 ('1' 또는 '2')
        String grade = request.getParameter("grade");
        
        GradeListDAO gdao = new GradeListDAO_imple();
        
        // 2. 해당 등급 전체 인원수 조회 (DAO 메서드 호출)
        int totalCount = gdao.getTotalMemberCountByGrade(grade);
        
        // 3. 승급 기준 금액 설정 (등급 테이블 기준으로 판단)
        // 일반(1) -> 실버(2) 기준: 500,000원
        // 실버(2) -> 골드(3) 기준: 2,000,000원
        int threshold = ("1".equals(grade)) ? 500000 : 2000000;
        
        // 4. 실시간 승급 대상자 리스트 조회 (합산 쿼리 실행)
        List<MemberDTO> candidates = gdao.getPromotionCandidates(grade, threshold);
        
        // 5. JSON 데이터 구성
        JSONObject jsonObj = new JSONObject();
        jsonObj.put("totalCount", totalCount);
        jsonObj.put("threshold", threshold);
        
        JSONArray jsonArr = new JSONArray();
        if(candidates != null) {
            for(MemberDTO m : candidates) {
                JSONObject obj = new JSONObject();
                obj.put("member_id", m.getUserid());      // JSP item.member_id와 매칭
                obj.put("name", m.getName());              // JSP item.name과 매칭
                obj.put("total_amount", m.getTotal_amount()); // DTO에 추가한 필드
                jsonArr.add(obj);
            }
        }
        jsonObj.put("candidates", jsonArr);

        // 6. 결과 출력
        String json = jsonObj.toString();
        request.setAttribute("json", json);
        
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/ih_jsonview.jsp"); 
    }
}
