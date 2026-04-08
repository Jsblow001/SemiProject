package jh.notice.controller;

import hk.member.domain.MemberDTO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import sp.common.controller.AbstractController;

import jh.notice.domain.NoticeDTO;
import jh.notice.model.NoticeDAO;
import jh.notice.model.NoticeDAO_imple;

public class NoticeViewController extends AbstractController {

    private NoticeDAO ndao = new NoticeDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        String noticeIdStr = request.getParameter("noticeId");

        if(noticeIdStr == null || noticeIdStr.isBlank()) {
            request.setAttribute("message", "잘못된 접근입니다.");
            request.setAttribute("loc", request.getContextPath() + "/noticeList.sp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        int noticeId = 0;
        try {
            noticeId = Integer.parseInt(noticeIdStr);
        } catch(NumberFormatException e) {
            request.setAttribute("message", "잘못된 공지번호입니다.");
            request.setAttribute("loc", request.getContextPath() + "/noticeList.sp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        NoticeDTO noticeDto = ndao.selectOne(noticeId);

        if(noticeDto == null) {
            request.setAttribute("message", "존재하지 않는 공지입니다.");
            request.setAttribute("loc", request.getContextPath() + "/noticeList.sp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // 관리자 여부(버튼 노출용)
        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");
        boolean isAdmin = (loginuser != null && "admin".equals(loginuser.getUserid()));

        request.setAttribute("noticeDto", noticeDto);
        request.setAttribute("isAdmin", isAdmin);

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/jh_notice/notice_view.jsp");
    }
}
