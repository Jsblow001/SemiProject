package jh.qna.controller;

import java.sql.SQLException;

import hk.member.domain.MemberDTO;
import sp.common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jh.qna.domain.QnaDTO;
import jh.qna.model.QnaDAO;
import jh.qna.model.QnaDAO_imple;

public class QnaEditEnd extends AbstractController {

    private QnaDAO qdao = new QnaDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        // 1) POST만 허용
        if(!"POST".equalsIgnoreCase(request.getMethod())) {
            request.setAttribute("message", "비정상 접근입니다.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // 2) 로그인 체크
        if(!super.checkLogin(request)) {
            request.setAttribute("message", "로그인 후 이용 가능합니다.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");

        // 3) 파라미터
        String qnaid = request.getParameter("qnaId");
        String subject = request.getParameter("subject");
        String content = request.getParameter("content");
        int isSecret = (request.getParameter("isSecret") != null ? 1 : 0);

        // 4) 원글 조회 + 권한 확인
        QnaDTO origin = qdao.selectOneQna(Integer.parseInt(qnaid));
        if(origin == null) {
            request.setAttribute("message", "존재하지 않는 글입니다.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        String loginId = loginuser.getUserid();
        boolean isAdmin = "admin".equals(loginId);
        boolean isWriter = loginId.equals(origin.getFkMemberId());

        if(!isAdmin && !isWriter) {
            request.setAttribute("message", "수정 권한이 없습니다.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // 5) UPDATE
        try {
            QnaDTO dto = new QnaDTO();
            dto.setQnaId(Long.parseLong(qnaid));      // 네 DTO setter명에 맞춰
            dto.setSubject(subject);
            dto.setContent(content);
            dto.setIsSecret(isSecret);

            int n = qdao.updateQna(dto); // 아래 DAO 추가 필요
            if(n == 1) {
                request.setAttribute("message", "글 수정 완료");
                request.setAttribute("loc", request.getContextPath() + "/qnaContentView.sp?qnaid=" + qnaid);
                request.setAttribute("popup_close", true);
                super.setRedirect(false);
                super.setViewPage("/WEB-INF/msg.jsp");
            }
        }
        catch(SQLException e) {
            e.printStackTrace();
            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/error.sp");
        }
    }
}
