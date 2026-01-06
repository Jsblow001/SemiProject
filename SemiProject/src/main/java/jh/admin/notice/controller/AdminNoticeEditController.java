package jh.admin.notice.controller;

import hk.member.domain.MemberDTO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import sp.common.controller.AbstractController;

import jh.notice.domain.NoticeDTO;
import jh.notice.model.NoticeDAO;
import jh.notice.model.NoticeDAO_imple;

public class AdminNoticeEditController extends AbstractController {

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

        String noticeIdStr = request.getParameter("noticeId");
        if(noticeIdStr == null || noticeIdStr.isBlank()) {
            request.setAttribute("message", "잘못된 접근입니다.");
            request.setAttribute("loc", request.getContextPath() + "/adminNoticeList.sp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        int noticeId = 0;
        try {
            noticeId = Integer.parseInt(noticeIdStr);
        } catch(NumberFormatException e) {
            request.setAttribute("message", "공지번호가 올바르지 않습니다.");
            request.setAttribute("loc", request.getContextPath() + "/adminNoticeList.sp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        if("GET".equalsIgnoreCase(request.getMethod())) {

            NoticeDTO noticeDto = ndao.selectOne(noticeId);
            if(noticeDto == null) {
                request.setAttribute("message", "존재하지 않는 공지입니다.");
                request.setAttribute("loc", request.getContextPath() + "/adminNoticeList.sp");
                super.setRedirect(false);
                super.setViewPage("/WEB-INF/msg.jsp");
                return;
            }

            request.setAttribute("noticeDto", noticeDto);

            super.setRedirect(false);
            super.setViewPage("/WEB-INF/jh_admin/notice/admin_notice_edit.jsp");
            return;
        }

        // POST (수정)
        String subject = request.getParameter("subject");
        String content = request.getParameter("content");
        String isFixedStr = request.getParameter("isFixed");

        if(subject == null) subject = "";
        if(content == null) content = "";
        subject = subject.trim();
        content = content.trim();

        int isFixed = (isFixedStr != null && "1".equals(isFixedStr)) ? 1 : 0;

        NoticeDTO noticeDto = new NoticeDTO();
        noticeDto.setNoticeId(noticeId);
        noticeDto.setSubject(subject);
        noticeDto.setContent(content);
        noticeDto.setIsFixed(isFixed);

        int n = ndao.updateNotice(noticeDto);

        if(n == 1) {
            super.setRedirect(true);
            super.setViewPage(request.getContextPath() + "/noticeView.sp?noticeId=" + noticeId);
        } else {
            request.setAttribute("message", "공지 수정 실패");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
        }
    }
}
