package jh.qna.controller;

import java.io.PrintWriter;

import hk.member.domain.MemberDTO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import sp.common.controller.AbstractController;
import jh.qna.domain.QnaDTO;
import jh.qna.model.QnaDAO;
import jh.qna.model.QnaDAO_imple;

public class QnaViewController extends AbstractController {

    private QnaDAO qdao = new QnaDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        // 세션은 한 번만
        HttpSession session = request.getSession();

        // ===== 1) 로그인/테스트 모드 =====
        boolean testMode = false; // 테스트 끝나면 false

        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");

        if (testMode && loginuser == null) {
            loginuser = new MemberDTO();
            loginuser.setUserid("admin"); // ⚠️ 실제 존재하는 userid
            session.setAttribute("loginuser", loginuser);
        }

        if (loginuser == null) {
            return;
        }

        String loginId = loginuser.getUserid();
        boolean isAdmin = (loginId != null && "admin".equalsIgnoreCase(loginId));

        // ===== 2) 목록으로 돌아가기 URL 처리 (referer 보정) =====
        String refererHeader = request.getHeader("referer");

        // 네 프로젝트에서 "목록"에 해당하는 URL을 모두 인정 (일반/관리자)
        boolean fromUserList  = (refererHeader != null && refererHeader.contains("/qnaList.sp"));
        boolean fromAdminList = (refererHeader != null && refererHeader.contains("/adminQnaList.sp")); // ✅ 관리자 목록 URL

        // "목록에서 들어온 경우"만 세션에 저장
        if (fromUserList || fromAdminList) {
            session.setAttribute("qna_referer", refererHeader);
        }

        String saved = (String) session.getAttribute("qna_referer");

        // 저장된 게 없으면 로그인 상태에 맞는 기본 목록으로
        String defaultListUrl = isAdmin
                ? request.getContextPath() + "/adminQnaList.sp"
                : request.getContextPath() + "/qnaList.sp";

        String goListUrl = (saved != null && !saved.isBlank()) ? saved : defaultListUrl;

        // JSP에서 목록 버튼이 이 값을 씀
        request.setAttribute("referer", goListUrl);

        // ===== 3) 이하 기존 로직 =====
        String noStr = request.getParameter("no");
        if (noStr == null) {
            sendAlertAndGo(response, "잘못된 접근입니다.", defaultListUrl);
            return;
        }

        int qnaId = Integer.parseInt(noStr);

        QnaDTO qna = qdao.selectOneQna(qnaId);
        if (qna == null) {
            sendAlertAndGo(response, "존재하지 않는 글입니다.", defaultListUrl);
            return;
        }

        boolean isOwner = (loginId != null && loginId.equals(qna.getFkMemberId()));

        request.setAttribute("loginId", loginId);
        request.setAttribute("isAdmin", isAdmin);
        request.setAttribute("isOwner", isOwner);

        if (qna.getIsSecret() == 1 && !(isAdmin || isOwner)) {
            sendAlertAndGo(response, "비밀글입니다. 작성자 또는 관리자만 열람할 수 있습니다.", defaultListUrl);
            return;
        }

        request.setAttribute("qna", qna);
        request.setAttribute("commentList", qdao.selectCommentList(qnaId));

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/jh_qna/qna_content_view.jsp");
    }

    private void sendAlertAndGo(HttpServletResponse response, String msg, String goUrl) throws Exception {
        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.println("<script>");
        out.println("alert('" + msg.replace("'", "\\'") + "');");
        out.println("location.href='" + goUrl + "';");
        out.println("</script>");
        out.flush();
    }
}
