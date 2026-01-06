package jh.qna.controller;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import hk.member.domain.MemberDTO;
import sp.common.controller.AbstractController;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jh.qna.domain.QnaDTO;
import jh.qna.model.QnaDAO;
import jh.qna.model.QnaDAO_imple;

public class QnaListController extends AbstractController {

    private QnaDAO qdao = new QnaDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        HttpSession session = request.getSession();

        // ===== 테스트 모드(원하면 유지) =====
        // 로그인 세션이 없으면 admin으로 강제 세팅
        boolean testMode = false;
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");

        if (testMode && loginuser == null) {
            loginuser = new MemberDTO();
            loginuser.setUserid("admin");
            session.setAttribute("loginuser", loginuser);
        }

        // JSP에서 로그인 정보 쓰는 용도
        String loginId = (loginuser != null ? loginuser.getUserid() : null);
        boolean isAdmin = (loginId != null && "admin".equalsIgnoreCase(loginId));

        request.setAttribute("loginId", loginId);
        request.setAttribute("isAdmin", isAdmin);

        // ==========================
        // 1) 파라미터 받기
        // ==========================
        String searchType = request.getParameter("searchType");
        String searchWord = request.getParameter("keyword"); // ✅ JSP name="keyword"
        String sizePerPage = request.getParameter("sizePerPage");
        String currentShowPageNo = request.getParameter("currentShowPageNo");

        if(searchType == null) searchType = "";
        if(searchWord == null) searchWord = "";
        if(sizePerPage == null || (!"10".equals(sizePerPage) && !"5".equals(sizePerPage) && !"3".equals(sizePerPage))) {
            sizePerPage = "10";
        }
        if(currentShowPageNo == null) currentShowPageNo = "1";

        // ✅ searchType 화이트리스트(DAO switch와 동일)
        if(!"writer".equals(searchType) && !"subject".equals(searchType) && !"content".equals(searchType) && !"subject_content".equals(searchType)) {
            searchType = "";
        }

        Map<String,String> paraMap = new HashMap<>();
        paraMap.put("searchType", searchType);
        paraMap.put("searchWord", searchWord);  // ✅ DAO용 키
        paraMap.put("sizePerPage", sizePerPage);
        paraMap.put("currentShowPageNo", currentShowPageNo);


        // ==========================
        // 4) totalPage / currentShowPageNo 보정
        // ==========================
        int totalPage = qdao.getTotalQnaPage(paraMap);
        if (totalPage < 1) totalPage = 1;

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

        // ==========================
        // 5) pageBar 만들기 (MemberList 방식)
        // ==========================
        String pageBar = "";

        int blockSize = 10;
        int loop = 1;
        int pageNo = ((Integer.parseInt(currentShowPageNo) - 1) / blockSize) * blockSize + 1;

        String encodedWord = URLEncoder.encode(searchWord, StandardCharsets.UTF_8);

        // ✅ [맨처음]
        pageBar += "<li><a href='"
                + request.getContextPath()
                + "/qnaList.sp?searchType=" + searchType
                + "&keyword=" + encodedWord
                + "&sizePerPage=" + sizePerPage
                + "&currentShowPageNo=1'>[맨처음]</a></li>";

        // ✅ [이전]
        if (pageNo != 1) {
            pageBar += "<li><a href='"
                    + request.getContextPath()
                    + "/qnaList.sp?searchType=" + searchType
                    + "&keyword=" + encodedWord
                    + "&sizePerPage=" + sizePerPage
                    + "&currentShowPageNo=" + (pageNo - 1) + "'>[이전]</a></li>";
        }

        while (!(loop > blockSize || pageNo > totalPage)) {

            if (pageNo == Integer.parseInt(currentShowPageNo)) {
                pageBar += "<li class='active'><a href='#'>" + pageNo + "</a></li>";
            } else {
                pageBar += "<li><a href='"
                        + request.getContextPath()
                        + "/qnaList.sp?searchType=" + searchType
                        + "&keyword=" + encodedWord
                        + "&sizePerPage=" + sizePerPage
                        + "&currentShowPageNo=" + pageNo + "'>" + pageNo + "</a></li>";
            }

            loop++;
            pageNo++;
        }

        // ✅ [다음]
        if (pageNo <= totalPage) {
            pageBar += "<li><a href='"
                    + request.getContextPath()
                    + "/qnaList.sp?searchType=" + searchType
                    + "&keyword=" + encodedWord
                    + "&sizePerPage=" + sizePerPage
                    + "&currentShowPageNo=" + pageNo + "'>[다음]</a></li>";
        }

        // ✅ [마지막]
        pageBar += "<li><a href='"
                + request.getContextPath()
                + "/qnaList.sp?searchType=" + searchType
                + "&keyword=" + encodedWord
                + "&sizePerPage=" + sizePerPage
                + "&currentShowPageNo=" + totalPage + "'>[마지막]</a></li>";

        // ==========================
        // 6) 목록/총개수 조회
        // ==========================
        List<QnaDTO> qnaList = qdao.selectQnaPaging(paraMap);
        int totalQnaCount = qdao.getTotalQnaCount(paraMap);

        // ==========================
        // 7) JSP가 쓰는 requestScope 값 세팅
        // ==========================
        request.setAttribute("qnaList", qnaList);
        request.setAttribute("pageBar", pageBar);

        request.setAttribute("searchType", searchType);
        request.setAttribute("keyword", searchWord); // ✅ JSP가 value="${param.keyword}"로 쓰니까 keyword로도 맞춰줌

        request.setAttribute("sizePerPage", sizePerPage);
        request.setAttribute("currentShowPageNo", currentShowPageNo);

        request.setAttribute("totalQnaCount", totalQnaCount);

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/jh_views/qna_page.jsp");
    }
}
