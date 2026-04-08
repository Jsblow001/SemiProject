package jh.notice.controller;

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

public class NoticeListController extends AbstractController {

    private NoticeDAO ndao = new NoticeDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

    	
    	// ✅ 관리자 여부 판단
        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");

        boolean isAdmin = false;
        if(loginuser != null) {
            // 프로젝트 정책에 맞게 변경 가능:
            // 예) loginuser.getRole().equals("ADMIN") 이런 식이면 더 좋음
            isAdmin = "admin".equalsIgnoreCase(loginuser.getUserid());
        }
        request.setAttribute("isAdmin", isAdmin);
    	
        String currentShowPageNo = request.getParameter("currentShowPageNo");
        if(currentShowPageNo == null || currentShowPageNo.isBlank()) {
            currentShowPageNo = "1";
        }

        String sizePerPage = "10"; // ✅ 일반회원은 10개 고정

        Map<String, String> paraMap = new HashMap<>();
        paraMap.put("currentShowPageNo", currentShowPageNo);
        paraMap.put("sizePerPage", sizePerPage);

        // ✅ 일반회원은 검색 자체가 없음(무조건 빈값)
        paraMap.put("searchType", "");
        paraMap.put("searchWord", "");

        // 1페이지에서만 고정글
        List<NoticeDTO> fixedList = List.of();
        if("1".equals(currentShowPageNo)) {
            fixedList = ndao.selectFixedList(paraMap);
        }

        List<NoticeDTO> noticeList = ndao.selectNoticePaging(paraMap);
        
        int totalPage = ndao.getTotalPage(paraMap);

        // 페이지바
        String pageBar = makePageBar(request.getContextPath() + "/noticeList.sp", currentShowPageNo, totalPage);

        // 전체 공지글 개수 조회
        int totalNoticeCount = ndao.getTotalNoticeCount(paraMap);

        request.setAttribute("totalNoticeCount", totalNoticeCount);
        
        request.setAttribute("sizePerPage", sizePerPage);
        request.setAttribute("fixedList", fixedList);
        request.setAttribute("noticeList", noticeList);
        request.setAttribute("totalPage", totalPage);
        request.setAttribute("currentShowPageNo", currentShowPageNo);
        request.setAttribute("pageBar", pageBar);

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/jh_views/notice_page.jsp");
    }

    private String makePageBar(String baseUrl, String currentShowPageNo, int totalPage) {

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
              .append("<a class='page-link' href='").append(baseUrl).append("?currentShowPageNo=").append(pageNo-1).append("'>")
              .append("&laquo;</a></li>");
        }

        while(!(loop > blockSize || pageNo > totalPage)) {

            if(pageNo == currentPage) {
                sb.append("<li class='page-item active'>")
                  .append("<a class='page-link' href='#'>").append(pageNo).append("</a></li>");
            }
            else {
                sb.append("<li class='page-item'>")
                  .append("<a class='page-link' href='").append(baseUrl).append("?currentShowPageNo=").append(pageNo).append("'>")
                  .append(pageNo).append("</a></li>");
            }

            loop++;
            pageNo++;
        }

        // [다음]
        if(pageNo <= totalPage) {
            sb.append("<li class='page-item'>")
              .append("<a class='page-link' href='").append(baseUrl).append("?currentShowPageNo=").append(pageNo).append("'>")
              .append("&raquo;</a></li>");
        }

        sb.append("</ul>");

        return sb.toString();
    }
}
