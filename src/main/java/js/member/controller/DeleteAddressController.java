package js.member.controller;

import org.json.JSONObject;
import sp.common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import hk.member.model.MemberDAO;
import hk.member.model.MemberDAO_imple;

public class DeleteAddressController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        
        // 1. 삭제할 주소의 PK값 받기
        String addrId = request.getParameter("addr_id");
        
        MemberDAO mdao = new MemberDAO_imple();
        int n = mdao.deleteAddress(addrId);
        
        JSONObject jsonObj = new JSONObject();
        jsonObj.put("success", (n == 1));

        // 2. JSON 결과 출력
        String json = jsonObj.toString();
        request.setAttribute("json", json);
        super.setViewPage("/WEB-INF/ih_jsonview.jsp");
    }
}