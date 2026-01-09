package jh.qna.controller;

import java.io.File;
import java.nio.file.Paths;
import java.sql.Connection;
import java.util.UUID;

import hk.member.domain.MemberDTO;
import sp.common.controller.AbstractController;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import jh.qna.domain.QnaDTO;
import jh.qna.domain.QnaFileDTO;
import jh.qna.model.QnaDAO_imple;

@MultipartConfig(
  maxFileSize = 10 * 1024 * 1024,
  maxRequestSize = 30 * 1024 * 1024
)
public class QnaWriteController extends AbstractController {

    private QnaDAO_imple qdao = new QnaDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

//      MemberDTO loginuser = (MemberDTO) request.getSession().getAttribute("loginuser");
//
//      if(loginuser == null) {
//          super.setRedirect(true);
//          super.setViewPage(request.getContextPath() + "/login.sp");
//          return;
//      }
//
//      String memberId = loginuser.getUserid();
      
		// ===== 테스트 모드: 로그인 없이도 작성되게(관리자 ID로 고정) =====
		String memberId = "admin";  // ⚠️ tbl_qna.FK_MEMBER_ID에 실제 존재하는 ID로 넣어야 함
		
		MemberDTO loginuser = (MemberDTO) request.getSession().getAttribute("loginuser");
		if(loginuser != null) {
		    // 로그인 되어있으면 실제 로그인 사용자를 우선 사용
		    memberId = loginuser.getUserid();
		}
      
        if("GET".equalsIgnoreCase(request.getMethod())) {
        	String myUrl = request.getParameter("myUrl");
            request.setAttribute("myUrl", myUrl);
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/jh_qna/qna_write.jsp");
            return;
        }

        



        String subject = request.getParameter("subject");
        String content = request.getParameter("content");
        int isSecret = (request.getParameter("isSecret") == null) ? 0 : 1;

        // 기본 검증
        if(subject == null || subject.trim().isEmpty() || content == null || content.trim().isEmpty()) {
            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/qnaWrite.sp");
            return;
        }
        

        // 업로드 폴더(실제 물리경로)
        String uploadDir = request.getServletContext().getRealPath("/img/qna");
        System.out.println("uploadDir = " + uploadDir);
        File dir = new File(uploadDir);
        if(!dir.exists()) dir.mkdirs();

        Connection conn = null;

        try {
            conn = qdao.getConnection();
            conn.setAutoCommit(false);

            // 1) 글 insert
            QnaDTO dto = new QnaDTO();
            dto.setFkMemberId(memberId);
            dto.setSubject(subject);
            dto.setContent(content);
            dto.setIsSecret(isSecret);

            long qnaId = qdao.insertQna(conn, dto);

            // 2) 첨부 처리 (첨부 없으면 그냥 스킵됨)
            for(Part part : request.getParts()) {

                if(!"files".equals(part.getName())) continue;
                if(part.getSize() == 0) continue;  // ✅ 파일 없으면 넘어감(중요)

                // 원본 파일명
                String orgName = Paths.get(part.getSubmittedFileName()).getFileName().toString();

                // 확장자만 추출
                String ext = "";
                int dot = orgName.lastIndexOf('.');
                if(dot > -1) ext = orgName.substring(dot);

                // 저장 파일명 (유니크)
                String saveName = UUID.randomUUID().toString().replace("-", "") + ext;

                // 디스크 저장
                part.write(uploadDir + File.separator + saveName);

                // DB 저장
                QnaFileDTO f = new QnaFileDTO();
                f.setFkQnaId(qnaId);
                f.setOrgFilename(orgName);
                f.setSaveFilename(saveName);
                f.setFileSize(part.getSize());
                f.setContentType(part.getContentType());

                qdao.insertQnaFile(conn, f);
            }

            conn.commit();

            // 등록 후 QnA 목록으로(너 프로젝트 목록 URL로 수정)
            String myUrl = request.getParameter("myUrl");
            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + myUrl);

        } catch(Exception e) {
            if(conn != null) conn.rollback();
            throw e;
        } finally {
            if(conn != null) conn.close();
        }
    }
}
