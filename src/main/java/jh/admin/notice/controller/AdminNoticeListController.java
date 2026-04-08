package jh.admin.notice.controller;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import hk.member.domain.MemberDTO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import sp.common.controller.AbstractController;
import jh.notice.domain.NoticeDTO;
import jh.notice.model.NoticeDAO;
import jh.notice.model.NoticeDAO_imple;

public class AdminNoticeListController extends AbstractController {

    private NoticeDAO ndao = new NoticeDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

    	HttpSession session = request.getSession();

    	// ===== 테스트 모드 =====
    	boolean testMode = false; // 테스트 끝나면 false
    	MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");

    	// ✅ 테스트모드면 "임시 로그인"을 세션에 저장하지 말고 로컬 변수로만 사용
    	if (testMode && loginuser == null) {
    	    loginuser = new MemberDTO();
    	    loginuser.setUserid("admin");
    	    loginuser.setName("관리자(테스트)"); // 선택: 화면 안 비게
    	}

    	// 1) 관리자 체크 (testMode=false이면 반드시 관리자만 통과)
    	if (!testMode && (loginuser == null || !"admin".equals(loginuser.getUserid()))) {
    	    request.setAttribute("message", "관리자만 접근 가능");
    	    request.setAttribute("loc", "javascript:history.back()");
    	    super.setRedirect(false);
    	    super.setViewPage("/WEB-INF/msg.jsp");
    	    return;
    	}

    	// ✅ 여기서부터는 loginuser가 admin인 상태(실제 or 테스트)


        String searchType = request.getParameter("searchType");
        String searchWord = request.getParameter("searchWord");
        String currentShowPageNo = request.getParameter("currentShowPageNo");
        String sizePerPage = request.getParameter("sizePerPage");

        if(searchType == null) searchType = "";
        if(searchWord == null) searchWord = "";
        if(currentShowPageNo == null || currentShowPageNo.isBlank()) currentShowPageNo = "1";
        if(sizePerPage == null || sizePerPage.isBlank()) sizePerPage = "10";

        Map<String, String> paraMap = new HashMap<>();
        paraMap.put("searchType", searchType);
        paraMap.put("searchWord", searchWord);
        paraMap.put("currentShowPageNo", currentShowPageNo);
        paraMap.put("sizePerPage", sizePerPage);

        List<NoticeDTO> fixedList = List.of();
        if("1".equals(currentShowPageNo)) {
            fixedList = ndao.selectFixedList(paraMap); // ✅ 검색조건 동일 적용
        }

        List<NoticeDTO> noticeList = ndao.selectNoticePaging(paraMap);
        int totalPage = ndao.getTotalPage(paraMap);

        String encSearchWord = URLEncoder.encode(searchWord, StandardCharsets.UTF_8);
        String queryString = "searchType=" + searchType + "&searchWord=" + encSearchWord + "&sizePerPage=" + sizePerPage;

        String pageBar = makePageBar(
                request.getContextPath() + "/adminNoticeList.sp",
                currentShowPageNo,
                totalPage,
                queryString
        );
        
        // 전체 공지글 개수 조회
        int totalNoticeCount = ndao.getTotalNoticeCount(paraMap);

        request.setAttribute("totalNoticeCount", totalNoticeCount);


        request.setAttribute("fixedList", fixedList);
        request.setAttribute("noticeList", noticeList);
        request.setAttribute("totalPage", totalPage);
        request.setAttribute("currentShowPageNo", currentShowPageNo);
        request.setAttribute("searchType", searchType);
        request.setAttribute("searchWord", searchWord);
        request.setAttribute("sizePerPage", sizePerPage);
        request.setAttribute("queryString", queryString);
        request.setAttribute("pageBar", pageBar);

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/jh_admin/notice/admin_notice_list.jsp");
    }

    private String makePageBar(String baseUrl, String currentShowPageNo, int totalPage, String queryString) {

        if(totalPage == 0) return "";

        int blockSize = 10;
        int loop = 1;

        int currentPage = Integer.parseInt(currentShowPageNo);
        int pageNo = ((currentPage - 1) / blockSize) * blockSize + 1;

        StringBuilder sb = new StringBuilder();
        sb.append("<ul class='pagination justify-content-center'>");

        // [이전]
        if(pageNo != 1) {
            sb.append("<li class='page-item'>")
              .append("<a class='page-link' href='").append(baseUrl).append("?").append(queryString)
              .append("&currentShowPageNo=").append(pageNo-1).append("'>")
              .append("&laquo;</a></li>");
        }

        while(!(loop > blockSize || pageNo > totalPage)) {

            if(pageNo == currentPage) {
                sb.append("<li class='page-item active'>")
                  .append("<a class='page-link' href='#'>").append(pageNo).append("</a></li>");
            }
            else {
                sb.append("<li class='page-item'>")
                  .append("<a class='page-link' href='").append(baseUrl).append("?").append(queryString)
                  .append("&currentShowPageNo=").append(pageNo).append("'>")
                  .append(pageNo).append("</a></li>");
            }

            loop++;
            pageNo++;
        }

        // [다음]
        if(pageNo <= totalPage) {
            sb.append("<li class='page-item'>")
              .append("<a class='page-link' href='").append(baseUrl).append("?").append(queryString)
              .append("&currentShowPageNo=").append(pageNo).append("'>")
              .append("&raquo;</a></li>");
        }

        sb.append("</ul>");

        return sb.toString();
    }
}
