package jh.admin.qna.controller;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import sp.common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import hk.member.domain.MemberDTO;
import jh.qna.domain.QnaDTO;
import jh.qna.model.QnaDAO;
import jh.qna.model.QnaDAO_imple;

public class QnaList extends AbstractController {

    private QnaDAO qdao = new QnaDAO_imple();

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

        // 1) 관리자 체크
        if (loginuser == null || !"admin".equals(loginuser.getUserid())) {
            request.setAttribute("message", "관리자만 접근 가능");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // ✅✅ 여기 중요: 관리자 목록 컨트롤러 "자기 자신" URL로 통일
        String ctx = request.getContextPath();
        String listUrl = ctx + "/adminQnaList.sp"; 

        // 2) 파라미터 (드롭다운 방식 우선: searchType/searchWord)
        String searchType = request.getParameter("searchType");
        String searchWord = request.getParameter("searchWord");

        // (호환) 기존 JSP 방식 writer/keyword도 들어오면 자동 변환
        String writer = request.getParameter("writer");
        String keyword = request.getParameter("keyword");

        if ((searchType == null || searchWord == null) && (writer != null || keyword != null)) {
            if (writer == null) writer = "";
            if (keyword == null) keyword = "";
            writer = writer.trim();
            keyword = keyword.trim();

            if (!writer.isBlank()) {
                searchType = "writer";
                searchWord = writer;
            } else if (!keyword.isBlank()) {
                searchType = "subject_content";
                searchWord = keyword;
            } else {
                searchType = "";
                searchWord = "";
            }
        }

        if (searchType == null) searchType = "";
        if (searchWord == null) searchWord = "";
        searchType = searchType.trim();
        searchWord = searchWord.trim();

        // 3) 정규화(화이트리스트) - DAO 기준(writer/subject/content/subject_content)
        if (!"writer".equals(searchType) &&
            !"subject".equals(searchType) &&
            !"content".equals(searchType) &&
            !"subject_content".equals(searchType)) {
            searchType = "";
        }
        if (searchWord.isBlank()) {
            // 검색어 없으면 검색조건 제거(전체)
            searchType = "";
            searchWord = "";
        }

        String sizePerPage = request.getParameter("sizePerPage");
        String currentShowPageNo = request.getParameter("currentShowPageNo");

        if (sizePerPage == null || (!"10".equals(sizePerPage) && !"5".equals(sizePerPage) && !"3".equals(sizePerPage))) {
            sizePerPage = "10";
        }
        if (currentShowPageNo == null || currentShowPageNo.isBlank()) {
            currentShowPageNo = "1";
        }

        Map<String, String> paraMap = new HashMap<>();
        paraMap.put("searchType", searchType);
        paraMap.put("searchWord", searchWord);
        paraMap.put("sizePerPage", sizePerPage);
        paraMap.put("currentShowPageNo", currentShowPageNo);

        // 4) totalPage
        int totalPage = qdao.getTotalQnaPage(paraMap);
        if (totalPage == 0) totalPage = 1;

        // 5) currentShowPageNo 장난 방지
        try {
            int cPage = Integer.parseInt(currentShowPageNo);
            if (cPage > totalPage || cPage <= 0) {
                currentShowPageNo = "1";
                paraMap.put("currentShowPageNo", currentShowPageNo);
            }
        } catch (NumberFormatException e) {
            currentShowPageNo = "1";
            paraMap.put("currentShowPageNo", currentShowPageNo);
        }

        // 6) pageBar
        String pageBar = "";
        int blockSize = 10;
        int loop = 1;
        int pageNo = ((Integer.parseInt(currentShowPageNo) - 1) / blockSize) * blockSize + 1;

        String encType = URLEncoder.encode(searchType, StandardCharsets.UTF_8);
        String encWord = URLEncoder.encode(searchWord, StandardCharsets.UTF_8);

        // [맨처음]
        pageBar += "<li class='page-item'>"
                + "<a class='page-link' href='" + listUrl
                + "?searchType=" + encType
                + "&searchWord=" + encWord
                + "&sizePerPage=" + sizePerPage
                + "&currentShowPageNo=1'>[맨처음]</a></li>";

        // [이전]
        if (pageNo != 1) {
            pageBar += "<li class='page-item'>"
                    + "<a class='page-link' href='" + listUrl
                    + "?searchType=" + encType
                    + "&searchWord=" + encWord
                    + "&sizePerPage=" + sizePerPage
                    + "&currentShowPageNo=" + (pageNo - 1) + "'>[이전]</a></li>";
        }

        while (!(loop > blockSize || pageNo > totalPage)) {
            if (pageNo == Integer.parseInt(currentShowPageNo)) {
                pageBar += "<li class='page-item active'><a class='page-link' href='#'>" + pageNo + "</a></li>";
            } else {
                pageBar += "<li class='page-item'>"
                        + "<a class='page-link' href='" + listUrl
                        + "?searchType=" + encType
                        + "&searchWord=" + encWord
                        + "&sizePerPage=" + sizePerPage
                        + "&currentShowPageNo=" + pageNo + "'>" + pageNo + "</a></li>";
            }
            loop++;
            pageNo++;
        }

        // [다음]
        if (pageNo <= totalPage) {
            pageBar += "<li class='page-item'>"
                    + "<a class='page-link' href='" + listUrl
                    + "?searchType=" + encType
                    + "&searchWord=" + encWord
                    + "&sizePerPage=" + sizePerPage
                    + "&currentShowPageNo=" + pageNo + "'>[다음]</a></li>";
        }

        // [마지막]
        pageBar += "<li class='page-item'>"
                + "<a class='page-link' href='" + listUrl
                + "?searchType=" + encType
                + "&searchWord=" + encWord
                + "&sizePerPage=" + sizePerPage
                + "&currentShowPageNo=" + totalPage + "'>[마지막]</a></li>";

        // 7) 목록 + totalCount
        List<QnaDTO> qnaList = qdao.selectQnaPaging(paraMap);
        int totalQnaCount = qdao.getTotalQnaCount(paraMap);

        // 8) view로 전달 (검색값 유지용)
        request.setAttribute("qnaList", qnaList);
        request.setAttribute("searchType", searchType);
        request.setAttribute("searchWord", searchWord);
        request.setAttribute("sizePerPage", sizePerPage);
        request.setAttribute("currentShowPageNo", currentShowPageNo);
        request.setAttribute("pageBar", pageBar);
        request.setAttribute("totalQnaCount", totalQnaCount);

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/jh_admin/qna/qna_page_admin.jsp");
    }
}
