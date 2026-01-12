package js.qna.controller;

import java.util.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import hk.member.domain.MemberDTO;
import js.qna.model.*; 
import jh.qna.domain.QnaDTO; 
import sp.common.controller.AbstractController;

public class NoCommentQnaListController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        // 1. 관리자 권한 체크 (세션 확인)
        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");

        if (loginuser == null || !"admin".equals(loginuser.getUserid())) {
            request.setAttribute("message", "관리자만 접근 가능한 페이지입니다.");
            request.setAttribute("loc", "javascript:history.back()");
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // 2. 페이징 처리를 위한 파라미터 받기
        String cp = request.getParameter("currentShowPageNo");
        if(cp == null) cp = "1";

        int currentShowPageNo = 1;
        try {
            currentShowPageNo = Integer.parseInt(cp);
        } catch(NumberFormatException e) {
            currentShowPageNo = 1;
        }
        
        int sizePerPage = 10; // 한 페이지당 10개씩

        // 3. DAO 객체 생성 및 데이터 조회
        MyQnaListDAO qdao = new MyQnaListDAO_imple();
        
        // 미답변 개수 조회 (페이지바 계산용)
        int noCommentCnt = qdao.noCommentCnt(); 
        
        Map<String, String> paraMap = new HashMap<>();
        paraMap.put("currentShowPageNo", String.valueOf(currentShowPageNo));
        paraMap.put("sizePerPage", String.valueOf(sizePerPage));

        // DB에서 미답변 페이징 목록 가져오기
        // (주의: selectNoCommentList 메소드가 paraMap을 받도록 DAO 수정이 필요합니다)
        List<QnaDTO> qnaList = qdao.selectNoCommentList(paraMap);

        // 4. 페이지바 생성
        String pageBar = "";
        int blockSize = 10;
        int loop = 1;
        int pageNo = ((currentShowPageNo - 1) / blockSize) * blockSize + 1;
        int totalPage = (int) Math.ceil((double)noCommentCnt / sizePerPage);
        if(totalPage == 0) totalPage = 1;

        String url = request.getContextPath() + "/noCommentQnaList.sp";

        // [맨처음]
        pageBar += "<li><a href='" + url + "?currentShowPageNo=1'>[맨처음]</a></li>";

        // [이전]
        if (pageNo != 1) {
            pageBar += "<li><a href='" + url + "?currentShowPageNo=" + (pageNo - 1) + "'>[이전]</a></li>";
        }

        while (!(loop > blockSize || pageNo > totalPage)) {
            if (pageNo == currentShowPageNo) {
                pageBar += "<li class='active'><a>" + pageNo + "</a></li>";
            } else {
                pageBar += "<li><a href='" + url + "?currentShowPageNo=" + pageNo + "'>" + pageNo + "</a></li>";
            }
            loop++;
            pageNo++;
        }

        // [다음]
        if (pageNo <= totalPage) {
            pageBar += "<li><a href='" + url + "?currentShowPageNo=" + pageNo + "'>[다음]</a></li>";
        }

        // [마지막]
        pageBar += "<li><a href='" + url + "?currentShowPageNo=" + totalPage + "'>[마지막]</a></li>";

        // 가상번호(vno) 계산
        int vno = noCommentCnt - (currentShowPageNo - 1) * sizePerPage;
        
        // 5. 결과 전달
        request.setAttribute("qnaList", qnaList);
        request.setAttribute("pageBar", pageBar);
        request.setAttribute("noCommentCnt", noCommentCnt);
        request.setAttribute("vno", vno);
        request.setAttribute("currentShowPageNo", currentShowPageNo);

        // 6. 뷰 페이지 설정
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/js_admin/noCommentQnaList.jsp");
    }
}