package jh.qna.controller;

import java.sql.Connection;
import java.util.List;

import sp.common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import hk.member.domain.MemberDTO;
import jh.qna.domain.QnaDTO;
import jh.qna.domain.QnaFileDTO;
import jh.qna.model.QnaDAO;
import jh.qna.model.QnaDAO_imple;

public class QnaEdit extends AbstractController {

    private QnaDAO qdao = new QnaDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        if(!super.checkLogin(request)) {
            request.setAttribute("message", "로그인 후 이용 가능합니다.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // ✅ 파라미터 통일: qnaid / qnaId / no 모두 허용
        String qnaIdStr = request.getParameter("qnaid");
        if(qnaIdStr == null || qnaIdStr.isBlank()) qnaIdStr = request.getParameter("qnaId");
        if(qnaIdStr == null || qnaIdStr.isBlank()) qnaIdStr = request.getParameter("no");

        if(qnaIdStr == null || qnaIdStr.trim().isEmpty()) {
            request.setAttribute("message", "글번호가 없습니다.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        int qnaId;
        try {
            qnaId = Integer.parseInt(qnaIdStr.trim());
        } catch(NumberFormatException e) {
            request.setAttribute("message", "글번호가 올바르지 않습니다.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");

        QnaDTO qdto = qdao.selectOneQna(qnaId);
        if(qdto == null) {
            request.setAttribute("message", "존재하지 않는 글입니다.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        if(!loginuser.getUserid().equals(qdto.getFkMemberId())) {
            request.setAttribute("message", "본인 글만 수정할 수 있습니다.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // ✅✅ 기존 첨부 목록 조회해서 JSP에 전달 (conn 있는 버전)
        Connection conn = null;
        try {
            conn = qdao.getConnection();
            List<QnaFileDTO> fileList = qdao.selectQnaFileList(conn, (long)qnaId);
            request.setAttribute("fileList", fileList);
        } finally {
            if(conn != null) try { conn.close(); } catch(Exception ignore) {}
        }

        request.setAttribute("qnaId", String.valueOf(qnaId));
        request.setAttribute("qdto", qdto);

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/jh_qna/qna_edit.jsp");
    }
}
