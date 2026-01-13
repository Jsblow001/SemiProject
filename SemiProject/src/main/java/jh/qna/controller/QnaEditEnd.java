package jh.qna.controller;

import java.io.File;
import java.nio.file.Paths;
import java.sql.Connection;
import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

import hk.member.domain.MemberDTO;
import sp.common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import jh.qna.domain.QnaDTO;
import jh.qna.domain.QnaFileDTO;
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
        String qnaid   = request.getParameter("qnaId");
        String subject = request.getParameter("subject");
        String content = request.getParameter("content");
        int isSecret   = (request.getParameter("isSecret") != null ? 1 : 0);

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
        boolean isAdmin  = "admin".equals(loginId);
        boolean isWriter = loginId.equals(origin.getFkMemberId());

        if(!isAdmin && !isWriter) {
            request.setAttribute("message", "수정 권한이 없습니다.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // ===== 업로드 경로 =====
        String uploadDir = request.getServletContext().getRealPath("/images/qna");
        String devImgDir = "C:\\dev\\SemiProject\\src\\main\\webapp\\images\\qna"; // 너 환경에 맞게

        new File(uploadDir).mkdirs();
        new File(devImgDir).mkdirs();

        Connection conn = null;

        try {
            conn = qdao.getConnection();
            conn.setAutoCommit(false);

            long qnaIdLong = Long.parseLong(qnaid);

            // 5) 글 UPDATE
            QnaDTO dto = new QnaDTO();
            dto.setQnaId(qnaIdLong);
            dto.setSubject(subject);
            dto.setContent(content);
            dto.setIsSecret(isSecret);

            int n = qdao.updateQna(conn, dto);
            if(n != 1) {
                conn.rollback();
                request.setAttribute("message", "글 수정 실패");
                request.setAttribute("loc", "javascript:history.back()");
                super.setRedirect(false);
                super.setViewPage("/WEB-INF/msg.jsp");
                return;
            }

            // (A) 삭제 요청된 첨부 처리 + 삭제대상 Set(교체 업로드 충돌 방지)
            Set<Long> delSet = new HashSet<>();
            String[] delFileIds = request.getParameterValues("delFileId"); // checkbox name

            if(delFileIds != null) {
                for(String fidStr : delFileIds) {
                    long qnaFileId = Long.parseLong(fidStr);
                    delSet.add(qnaFileId);

                    // 디스크 삭제 위해 기존 파일명 조회
                    QnaFileDTO old = qdao.selectOneQnaFile(conn, qnaFileId);

                    // DB 삭제(이미 있는 deleteQnaFile 활용)
                    qdao.deleteQnaFile(conn, qnaFileId);

                    // 디스크 파일 삭제(권장)
                    if(old != null && old.getSaveFilename() != null) {
                        new File(uploadDir, old.getSaveFilename()).delete();
                        new File(devImgDir, old.getSaveFilename()).delete();
                    }
                }
            }

         // (B) 첨부 업로드 처리 (새첨부 추가만)
            for(Part part : request.getParts()) {

                if(!"files".equals(part.getName())) continue;
                if(part.getSize() == 0) continue;

                String orgName = Paths.get(part.getSubmittedFileName()).getFileName().toString();

                String ext = "";
                int dot = orgName.lastIndexOf('.');
                if(dot > -1) ext = orgName.substring(dot);

                String saveName = UUID.randomUUID().toString().replace("-", "") + ext;

                part.write(uploadDir + File.separator + saveName);

                java.nio.file.Path from = java.nio.file.Paths.get(uploadDir, saveName);
                java.nio.file.Path to   = java.nio.file.Paths.get(devImgDir, saveName);
                java.nio.file.Files.copy(from, to, java.nio.file.StandardCopyOption.REPLACE_EXISTING);

                QnaFileDTO f = new QnaFileDTO();
                f.setFkQnaId(qnaIdLong);
                f.setOrgFilename(orgName);
                f.setSaveFilename(saveName);
                f.setFileSize(part.getSize());
                f.setContentType(part.getContentType());

                qdao.insertQnaFile(conn, f);
            }


            conn.commit();

            request.setAttribute("message", "글 수정 완료");
            request.setAttribute("loc", request.getContextPath() + "/qnaView.sp?no=" + qnaid);

            request.setAttribute("popup_close", true);
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
        }
        catch(Exception e) {
            if(conn != null) try { conn.rollback(); } catch(Exception ignore) {}
            e.printStackTrace();
            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/error.sp");
        }
        finally {
            if(conn != null) try { conn.setAutoCommit(true); conn.close(); } catch(Exception ignore) {}
        }
    }
}
