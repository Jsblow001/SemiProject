package jh.introduction.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import sp.common.controller.AbstractController;

public class IntroController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        super.setViewPage("/WEB-INF/jh.views/introduction.jsp");
        super.setRedirect(false);
    }
}
