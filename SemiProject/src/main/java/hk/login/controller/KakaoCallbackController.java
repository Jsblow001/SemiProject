package hk.login.controller;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
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

public class KakaoCallbackController extends AbstractController {

    private MemberDAO mdao = new MemberDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        String code = request.getParameter("code");

        if(code == null) {
            request.setAttribute("message", "카카오 로그인 실패(code 없음)");
            request.setAttribute("loc", request.getContextPath() + "/login.sp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        String clientId = "b9bece0348ecbd39646aba63ecf1f7ea"; // 카카오REST_API_KEY
        String redirectURI = "http://localhost:9090/SemiProject/kakaoCallback.sp";

        // ==================================================
        // 1) access_token 발급 (POST)
        // ==================================================
        String tokenUrl = "https://kauth.kakao.com/oauth/token";

        String params = "grant_type=authorization_code"
                      + "&client_id=" + clientId
                      + "&redirect_uri=" + redirectURI
                      + "&code=" + code;

        String tokenResult = requestPOST(tokenUrl, params);

        JSONObject tokenJson = new JSONObject(tokenResult);

        if(!tokenJson.has("access_token")) {
            request.setAttribute("message", "카카오 토큰 발급 실패: " + tokenResult);
            request.setAttribute("loc", request.getContextPath() + "/login.sp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        String accessToken = tokenJson.getString("access_token");

        // ==================================================
        // 2) 사용자 정보 조회
        // ==================================================
        String userInfoUrl = "https://kapi.kakao.com/v2/user/me";
        String userResult = requestGETWithToken(userInfoUrl, accessToken);

        JSONObject userJson = new JSONObject(userResult);

        if(!userJson.has("id")) {
            request.setAttribute("message", "카카오 사용자정보 조회 실패: " + userResult);
            request.setAttribute("loc", request.getContextPath() + "/login.sp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        String kakaoId = String.valueOf(userJson.getLong("id"));

        // ★ 최소 변경 핵심: member_id에 prefix
        String userid = "kakao_" + kakaoId;

        String name = "카카오회원";
        String email = "";

        if(userJson.has("kakao_account")) {
            JSONObject kakaoAccount = userJson.getJSONObject("kakao_account");
            email = kakaoAccount.optString("email", "");

            if(kakaoAccount.has("profile")) {
                JSONObject profile = kakaoAccount.getJSONObject("profile");
                name = profile.optString("nickname", "카카오회원");
            }
        }

        // ==================================================
        // 3) DB 처리 (없으면 insert / 있으면 select)
        // ==================================================
        HttpSession session = request.getSession();

        MemberDTO loginuser = mdao.loginSocial(userid, name, email, "");

        if(loginuser == null) {
            request.setAttribute("message", "카카오 로그인 처리 중 DB 오류가 발생했습니다.");
            request.setAttribute("loc", request.getContextPath() + "/login.sp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        session.setAttribute("loginuser", loginuser);

        super.setRedirect(true);
        super.setViewPage(request.getContextPath() + "/mypage.sp");
    }

    // ==================================================
    // 유틸: POST 요청
    // ==================================================
    private String requestPOST(String apiURL, String params) throws Exception {

        URL url = new URL(apiURL);
        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setRequestMethod("POST");
        con.setDoOutput(true);
        con.setRequestProperty("Content-Type", "application/x-www-form-urlencoded;charset=utf-8");

        try(OutputStream os = con.getOutputStream()) {
            os.write(params.getBytes("UTF-8"));
        }

        int responseCode = con.getResponseCode();

        BufferedReader br = null;
        if(responseCode >= 200 && responseCode < 300) {
            br = new BufferedReader(new InputStreamReader(con.getInputStream(), "UTF-8"));
        } else {
            br = new BufferedReader(new InputStreamReader(con.getErrorStream(), "UTF-8"));
        }

        StringBuilder sb = new StringBuilder();
        String line;
        while((line = br.readLine()) != null) sb.append(line);
        br.close();

       // System.out.println("카카오 토큰 응답코드: " + responseCode);
        //System.out.println("카카오 토큰 응답바디: " + sb.toString());

        return sb.toString();
    }


    // ==================================================
    // 유틸: GET + Bearer Token
    // ==================================================
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
