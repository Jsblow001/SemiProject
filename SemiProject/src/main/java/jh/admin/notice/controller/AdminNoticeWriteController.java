package jh.admin.notice.controller;

import hk.member.domain.MemberDTO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import sp.common.controller.AbstractController;

import jh.notice.domain.NoticeDTO;
import jh.notice.model.NoticeDAO;
import jh.notice.model.NoticeDAO_imple;

public class AdminNoticeWriteController extends AbstractController {

    private NoticeDAO ndao = new NoticeDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession();
        // ===== 테스트 모드 =====
        boolean testMode = false; // 테스트 끝나면 false
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");
        if (testMode && loginuser == null) {
            loginuser = new MemberDTO();
            loginuser.setUserid("admin");
            session.setAttribute("loginuser", loginuser);
        }

        if(loginuser == null || !"admin".equals(loginuser.getUserid())) {
            request.setAttribute("message", "관리자만 접근 가능합니다.");
            request.setAttribute("loc", request.getContextPath() + "/index.sp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        if("GET".equalsIgnoreCase(request.getMethod())) {
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/jh_admin/notice/admin_notice_write.jsp");
            return;
        }

        // POST
        String subject = request.getParameter("subject");
        String content = request.getParameter("content");
        String isFixedStr = request.getParameter("isFixed");

        if(subject == null) subject = "";
        if(content == null) content = "";
        subject = subject.trim();
        content = content.trim();

        int isFixed = (isFixedStr != null && "1".equals(isFixedStr)) ? 1 : 0;

        NoticeDTO noticeDto = new NoticeDTO();
        noticeDto.setAdminId(loginuser.getUserid()); // FK_ADMIN_ID
        noticeDto.setSubject(subject);
        noticeDto.setContent(content);
        noticeDto.setIsFixed(isFixed);

        int n = ndao.insertNotice(noticeDto);

        if(n == 1) {
            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/adminNoticeList.sp");
        } else {
            request.setAttribute("message", "공지 등록 실패");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
        }
    }
}
