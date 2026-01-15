package jh.review.controller;

import java.util.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import sp.common.controller.AbstractController;
import hk.member.domain.MemberDTO;
import jh.review.domain.ReviewDTO;
import jh.review.model.ReviewDAO;
import jh.review.model.ReviewDAO_imple;

public class MyReviewListController extends AbstractController {

    private ReviewDAO rdao = new ReviewDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");

        // ✅ 로그인 안했으면 로그인 선택 페이지로 이동
        if(loginuser == null) {
            request.setAttribute("message", "로그인이 필요합니다.");
            request.setAttribute("loc", request.getContextPath() + "/loginSelect.sp");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        String userid = loginuser.getUserid();  // fk_member_id가 userid 문자열로 쓰이는 구조 전제

        // 파라미터 받기
        String page = request.getParameter("page");
        if(page == null || page.isBlank()) page = "1";

        String sort = request.getParameter("sort");
        if(sort == null || sort.isBlank()) sort = "recent";  // recent | rating

        String searchWord = request.getParameter("searchWord");
        if(searchWord == null) searchWord = "";
        searchWord = searchWord.trim();

        int currentShowPageNo = 1;
        try {
            currentShowPageNo = Integer.parseInt(page);
        } catch(Exception e) {
            currentShowPageNo = 1;
        }
        if(currentShowPageNo < 1) currentShowPageNo = 1;

        int sizePerPage = 10;  // 주문내역처럼 10개

        // DAO 파라미터
        Map<String, String> paraMap = new HashMap<>();
        paraMap.put("userid", userid);
        paraMap.put("sort", sort);
        paraMap.put("searchWord", searchWord);
        paraMap.put("currentShowPageNo", String.valueOf(currentShowPageNo));
        paraMap.put("sizePerPage", String.valueOf(sizePerPage));

        // ✅ 총 개수
        int totalCount = rdao.getTotalMyReviewCount(paraMap);

        // ✅ 총 페이지수
        int totalPage = (int)Math.ceil((double)totalCount / sizePerPage);
        if(totalPage < 1) totalPage = 1;

        // 페이지 범위 보정
        if(currentShowPageNo > totalPage) currentShowPageNo = totalPage;
        paraMap.put("currentShowPageNo", String.valueOf(currentShowPageNo));

        // ✅ 페이징 목록
        List<ReviewDTO> myReviewList = rdao.selectMyReviewListPaging(paraMap);

        // JSP로 전달
        request.setAttribute("myReviewList", myReviewList);

        request.setAttribute("totalCount", totalCount);
        request.setAttribute("totalPage", totalPage);
        request.setAttribute("page", currentShowPageNo);

        request.setAttribute("sort", sort);
        request.setAttribute("searchWord", searchWord);

        // JSP 경로(너가 만든 myReviewList.jsp 위치에 맞추면 됨)
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/jh_review/myReviewList.jsp");
    }
}
