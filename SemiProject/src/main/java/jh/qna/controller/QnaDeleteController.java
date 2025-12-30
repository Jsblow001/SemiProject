package jh.qna.controller;

import java.io.File;
import java.sql.Connection;
import java.util.List;

import sp.common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jh.qna.domain.QnaFileDTO;
import jh.qna.model.QnaDAO_imple;

public class QnaDeleteController extends AbstractController {

    private QnaDAO_imple qdao = new QnaDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        long qnaId = Long.parseLong(request.getParameter("qnaId"));

        String uploadDir = request.getServletContext().getRealPath("/img/qna");

        Connection conn = null;

        try {
            conn = qdao.getConnection();
            conn.setAutoCommit(false);

            // 1) 첨부 목록 조회
            List<QnaFileDTO> files = qdao.selectFilesByQnaId(conn, qnaId);

            // 2) 디스크 파일 삭제
            for(QnaFileDTO f : files) {
                File target = new File(uploadDir, f.getSaveFilename());
                if(target.exists()) target.delete();
            }

            // 3) DB 첨부 삭제
            qdao.deleteFilesByQnaId(conn, qnaId);

            // 4) DB 글 삭제
            int n = qdao.deleteQna(conn, qnaId);
            if(n != 1) throw new Exception("QnA 글 삭제 실패");

            conn.commit();

            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/qnaList.up");

        } catch(Exception e) {
            if(conn != null) conn.rollback();
            throw e;
        } finally {
            if(conn != null) conn.close();
        }
    }
}
