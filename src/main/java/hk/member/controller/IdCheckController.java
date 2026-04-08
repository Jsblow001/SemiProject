package hk.member.controller;

import java.io.PrintWriter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.json.JSONObject;
import sp.common.controller.AbstractController;
import hk.member.model.MemberDAO;
import hk.member.model.MemberDAO_imple;

public class IdCheckController extends AbstractController {

    private MemberDAO mdao = new MemberDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        String userid = request.getParameter("userid");

        boolean isExists = mdao.isUseridExists(userid);

        JSONObject jsonObj = new JSONObject();
        jsonObj.put("isExists", isExists);

        response.setContentType("application/json; charset=UTF-8");

        PrintWriter out = response.getWriter();
        out.print(jsonObj.toString());
        out.flush();
    }
}
