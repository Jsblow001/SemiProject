package jh.qna.controller;

import java.io.PrintWriter;

import hk.member.domain.MemberDTO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jh.qna.model.QnaDAO;
import jh.qna.model.QnaDAO_imple;
import sp.common.controller.AbstractController;

public class QnaCommentWriteController extends AbstractController {

    private QnaDAO qdao = new QnaDAO_imple();
    
    

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

    	// ===== 테스트 모드 =====
    	boolean testMode = false; // 테스트 끝나면 false 로만 변경

    	HttpSession session = request.getSession();
    	MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");

    	// 테스트 모드 + 미로그인 상태면 admin으로 세션 로그인 처리
    	if (testMode && loginuser == null) {
    	    loginuser = new MemberDTO();
    	    loginuser.setUserid("admin"); // ⚠️ tbl_member(또는 회원테이블)에 실제 존재하는 userid여야 함
    	    session.setAttribute("loginuser", loginuser);
    	}

    	// 여기부터는 "항상" 동일한 로그인 체크 로직
    	if (loginuser == null) {
    	    sendAlertAndBack(response, "로그인이 필요합니다.");
    	    return;
    	}

    	String memberId = loginuser.getUserid();  // 이후 FK_MEMBER_ID 등에 사용


        int qnaId = Integer.parseInt(request.getParameter("qnaId"));
        String content = request.getParameter("content");
        if (content == null) content = "";
        content = content.trim();

        if (content.isEmpty()) {
            sendAlertAndBack(response, "댓글 내용을 입력하세요.");
            return;
        }

        String loginId = loginuser.getUserid(); // getter명 맞춰

        qdao.insertComment(qnaId, loginId, content);

        super.setRedirect(true);
        super.setViewPage(request.getContextPath() + "/qnaView.sp?no=" + qnaId);
    }

    private void sendAlertAndBack(HttpServletResponse response, String msg) throws Exception {
        response.setContentType("text/html; charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.println("<script>alert('" + msg.replace("'", "\\'") + "'); history.back();</script>");
        out.flush();
    }
}
