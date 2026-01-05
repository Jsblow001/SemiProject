package jh.qna.controller;

import sp.common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import hk.member.domain.MemberDTO;
import jh.qna.domain.QnaDTO;
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

        String qnaId = request.getParameter("qnaid");

        if(qnaId == null || qnaId.trim().isEmpty()) {
            request.setAttribute("message", "글번호가 없습니다.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");

        // 1건 조회 (수정폼에 기존 제목/내용 채우려고)
        QnaDTO qdto = qdao.selectOneQna(Integer.parseInt(qnaId));
        if(qdto == null) {
            request.setAttribute("message", "존재하지 않는 글입니다.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // 작성자 본인 or admin만 수정 허용
        boolean isAdmin = "admin".equals(loginuser.getUserid());
        if(!isAdmin && !loginuser.getUserid().equals(qdto.getFkMemberId())) { 
            request.setAttribute("message", "본인 글만 수정할 수 있습니다.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }
        
        request.setAttribute("qnaId", qnaId);  
        request.setAttribute("qdto", qdto);

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/jh_qna/qna_edit.jsp");
    }
}
