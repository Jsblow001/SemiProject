package jh.review.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import common.controller.AbstractController;

public class ReviewsController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        // 나중에 DB 연결 시 여기서 데이터 세팅
        // request.setAttribute("reviewList", list);

        super.setViewPage("/WEB-INF/views/reviews.jsp");
        super.setRedirect(false); // forward
    }
}

