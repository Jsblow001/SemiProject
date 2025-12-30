package jh.qna.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import sp.common.controller.AbstractController;

public class QnaController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        super.setViewPage("/WEB-INF/jh_views/qna_page.jsp");
        super.setRedirect(false);
    }
}
