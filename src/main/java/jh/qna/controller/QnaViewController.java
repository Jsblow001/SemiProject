package jh.qna.controller;

import java.io.PrintWriter;
import java.sql.Connection;
import java.util.List;

import hk.member.domain.MemberDTO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import sp.common.controller.AbstractController;
import jh.qna.domain.QnaDTO;
import jh.qna.domain.QnaFileDTO;
import jh.qna.model.QnaDAO;
import jh.qna.model.QnaDAO_imple;

public class QnaViewController extends AbstractController {

    private QnaDAO qdao = new QnaDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession();

        // ===== 1) 로그인/테스트 모드 =====
        boolean testMode = false;
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");

        if (testMode && loginuser == null) {
            loginuser = new MemberDTO();
            loginuser.setUserid("admin");
            session.setAttribute("loginuser", loginuser);
        }

        if (loginuser == null) {
            return;
        }

        String loginId = loginuser.getUserid();
        boolean isAdmin = (loginId != null && "admin".equalsIgnoreCase(loginId));

        // ===== 2) 목록으로 돌아가기 URL 처리 (referer 보정) =====
        String refererHeader = request.getHeader("referer");

        boolean fromUserList  = (refererHeader != null && refererHeader.contains("/qnaList.sp"));
        boolean fromAdminList = (refererHeader != null && refererHeader.contains("/adminQnaList.sp"));
        boolean fromNoCommentList = (refererHeader != null && refererHeader.contains("/noCommentQnaList.sp"));
        boolean fromMyQnaList = (refererHeader != null && refererHeader.contains("/myQnaList.sp"));

        if (fromUserList || fromAdminList || fromNoCommentList || fromMyQnaList) {
            session.setAttribute("qna_referer", refererHeader);
        }

        String saved = (String) session.getAttribute("qna_referer");

        String defaultListUrl = isAdmin
                ? request.getContextPath() + "/adminQnaList.sp"
                : request.getContextPath() + "/qnaList.sp";

        String goListUrl = (saved != null && !saved.isBlank()) ? saved : defaultListUrl;
        request.setAttribute("referer", goListUrl);

        // ===== 3) 파라미터 통일 패치 (no / qnaid / qnaId 모두 허용) =====
        String idStr = request.getParameter("no");
        if (idStr == null || idStr.isBlank()) idStr = request.getParameter("qnaid");
        if (idStr == null || idStr.isBlank()) idStr = request.getParameter("qnaId");

        if (idStr == null || idStr.isBlank()) {
            sendAlertAndGo(response, "잘못된 접근입니다.", defaultListUrl);
            return;
        }

        int qnaId;
        try {
            qnaId = Integer.parseInt(idStr.trim());
        } catch (NumberFormatException e) {
            sendAlertAndGo(response, "잘못된 글번호입니다.", defaultListUrl);
            return;
        }

        // ===== 4) 상세 조회 =====
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

        // ===== 5) ✅ 첨부 목록 조회 (conn 있는 버전만 사용) =====
        Connection conn = null;
        try {
            conn = qdao.getConnection();
            List<QnaFileDTO> fileList = qdao.selectQnaFileList(conn, (long)qnaId);
            request.setAttribute("fileList", fileList);
        }
        finally {
            if(conn != null) try { conn.close(); } catch(Exception ignore) {}
        }

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
