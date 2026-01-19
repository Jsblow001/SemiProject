package hk.login.controller;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import org.json.JSONObject;

import hk.member.domain.MemberDTO;
import hk.member.model.MemberDAO;
import hk.member.model.MemberDAO_imple;
import sp.common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class NaverCallbackController extends AbstractController {

    private MemberDAO mdao = new MemberDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession();

        String code  = request.getParameter("code");
        String state = request.getParameter("state");

        if(code == null) {
            request.setAttribute("message", "네이버 로그인 실패(code 없음)");
            request.setAttribute("loc", request.getContextPath() + "/login.sp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        String sessionState = (String) session.getAttribute("NAVER_STATE");

        if(sessionState == null || !sessionState.equals(state)) {
            request.setAttribute("message", "잘못된 접근입니다.(state 불일치)");
            request.setAttribute("loc", request.getContextPath() + "/login.sp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // 1) access_token 요청
        String clientId = "PYBFkSdMo4dphDcHvPnj";
        String clientSecret = "uuGK05h2A8";

        String tokenUrl = "https://nid.naver.com/oauth2.0/token"
                        + "?grant_type=authorization_code"
                        + "&client_id=" + clientId
                        + "&client_secret=" + clientSecret
                        + "&code=" + code
                        + "&state=" + state;

        String tokenResult = requestGET(tokenUrl);
        JSONObject tokenJson = new JSONObject(tokenResult);

        if(!tokenJson.has("access_token")) {
            request.setAttribute("message", "네이버 토큰 발급 실패: " + tokenResult);
            request.setAttribute("loc", request.getContextPath() + "/login.sp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        String accessToken = tokenJson.getString("access_token");

        // 2) 사용자 정보 요청
        String userInfoUrl = "https://openapi.naver.com/v1/nid/me";
        String userResult = requestGETWithToken(userInfoUrl, accessToken);

        JSONObject userJson = new JSONObject(userResult);

        if(!userJson.has("response")) {
            request.setAttribute("message", "네이버 사용자정보 조회 실패: " + userResult);
            request.setAttribute("loc", request.getContextPath() + "/login.sp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        JSONObject res = userJson.getJSONObject("response");

        String socialId = res.getString("id");

        // ★ 최소 변경 핵심: member_id에 prefix 박기
        String userid = "naver_" + socialId;

        String name = res.optString("name", "네이버회원");
        String email = res.optString("email", "");
        String mobile = res.optString("mobile", "");

        // 3) 우리 DB 회원 처리 (없으면 insert / 있으면 select)
        MemberDTO loginuser = mdao.loginSocial(userid, name, email, mobile);

        if(loginuser == null) {
            request.setAttribute("message", "네이버 로그인 처리 중 DB 오류가 발생했습니다.");
            request.setAttribute("loc", request.getContextPath() + "/login.sp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        session.setAttribute("loginuser", loginuser);

        super.setRedirect(true);
        super.setViewPage(request.getContextPath() + "/mypage.sp");
    }

    // ====== 유틸 메서드 ======
    private String requestGET(String apiURL) throws Exception {
        URL url = new URL(apiURL);
        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setRequestMethod("GET");

        BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "UTF-8"));
        StringBuilder sb = new StringBuilder();
        String line;
        while((line = br.readLine()) != null) sb.append(line);
        br.close();
        return sb.toString();
    }

    private String requestGETWithToken(String apiURL, String accessToken) throws Exception {
        URL url = new URL(apiURL);
        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setRequestMethod("GET");
        con.setRequestProperty("Authorization", "Bearer " + accessToken);

        BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream(), "UTF-8"));
        StringBuilder sb = new StringBuilder();
        String line;
        while((line = br.readLine()) != null) sb.append(line);
        br.close();
        return sb.toString();
    }
}
