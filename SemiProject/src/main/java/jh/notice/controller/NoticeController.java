package jh.notice.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import common.controller.AbstractController;

public class NoticeController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        super.setViewPage("/WEB-INF/views/notice_page.jsp");
        super.setRedirect(false);
    }
}
