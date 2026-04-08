package jh.qna.controller;

import java.io.File;
import java.sql.Connection;
import java.util.List;

import hk.member.domain.MemberDTO;
import sp.common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jh.qna.domain.QnaDTO;
import jh.qna.domain.QnaFileDTO;
import jh.qna.model.QnaDAO_imple;

public class QnaDeleteController extends AbstractController {

    private QnaDAO_imple qdao = new QnaDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        // 1) POST만 허용
        if(!"POST".equalsIgnoreCase(request.getMethod())) {
            request.setAttribute("message", "비정상 접근입니다.");
            request.setAttribute("loc", request.getContextPath() + "/qnaList.sp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // 2) 로그인 체크
        MemberDTO loginuser = (MemberDTO) request.getSession().getAttribute("loginuser");
        if(loginuser == null) {
            request.setAttribute("message", "로그인 후 이용 가능합니다.");
            request.setAttribute("loc", request.getContextPath() + "/qnaList.sp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // 3) 글번호
        int qnaId;
        try {
            qnaId = Integer.parseInt(request.getParameter("qnaId"));
        } catch (NumberFormatException e) {
            request.setAttribute("message", "잘못된 접근입니다.");
            request.setAttribute("loc", request.getContextPath() + "/qnaList.sp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // 4) 작성자/관리자 권한 체크(필수)
        QnaDTO qdto = qdao.selectOneQna(qnaId);
        if(qdto == null) {
            request.setAttribute("message", "존재하지 않는 글입니다.");
            request.setAttribute("loc", request.getContextPath() + "/qnaList.sp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        String loginId = loginuser.getUserid();
        boolean isAdmin = "admin".equals(loginId);
        boolean isWriter = loginId.equals(qdto.getFkMemberId());

        if(!isAdmin && !isWriter) {
            request.setAttribute("message", "삭제 권한이 없습니다.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // 5) 첨부 포함 삭제 트랜잭션
        String uploadDir = request.getServletContext().getRealPath("/img/qna");
        Connection conn = null;

        try {
            conn = qdao.getConnection();
            conn.setAutoCommit(false);

            List<QnaFileDTO> files = qdao.selectFilesByQnaId(conn, qnaId);

            for(QnaFileDTO f : files) {
                File target = new File(uploadDir, f.getSaveFilename());
                if(target.exists()) target.delete();
            }

            qdao.deleteFilesByQnaId(conn, qnaId);

            int n = qdao.deleteQna(conn, qnaId);
            if(n != 1) throw new Exception("QnA 글 삭제 실패");

            conn.commit();

            request.setAttribute("message", "글 삭제 완료");
            request.setAttribute("loc", request.getContextPath() + "/qnaList.sp"); // popup_close면 사실상 사용 안 함
            request.setAttribute("popup_close", true);
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");

        } catch(Exception e) {
            if(conn != null) conn.rollback();
            throw e;
        } finally {
            if(conn != null) conn.close();
        }
    }
}
