package jh.qna.controller;

import java.util.List;
import java.util.Map;

import sp.common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jh.qna.model.QnaDAO;
import jh.qna.model.QnaDAO_imple;

public class QnaListController extends AbstractController {

    private QnaDAO qdao = new QnaDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        // 검색 파라미터(있으면 사용, 없으면 전체)
        String searchType = request.getParameter("searchType");
        String keyword = request.getParameter("keyword");

        // 목록 조회
        List<Map<String,Object>> qnaList = qdao.selectQnaList(searchType, keyword);
        request.setAttribute("qnaList", qnaList);

        // 페이지네이션은 다음 단계에서 붙이고, 일단 더미로 고정해도 됨
        request.setAttribute("currentPage", 1);
        request.setAttribute("totalPages", 1);

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/jh_views/qna_page.jsp"); 
    }
}
