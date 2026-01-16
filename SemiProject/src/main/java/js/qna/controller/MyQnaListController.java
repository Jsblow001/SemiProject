package js.qna.controller;

import java.util.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import hk.member.domain.MemberDTO;
import js.qna.model.*; 
import jh.qna.domain.QnaDTO; 
import sp.common.controller.AbstractController;

public class MyQnaListController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        // 1. 로그인 유무 확인
        if(!super.checkLogin(request)) {
            request.setAttribute("message", "로그인 후 이용 가능합니다.");
            request.setAttribute("loc", request.getContextPath() + "/login.sp");
            
            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        // 2. 로그인한 유저 정보 가져오기
        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");
        String userid = loginuser.getUserid();
        
        // 3. 페이징 처리를 위한 파라미터 받기
        String cp = request.getParameter("currentShowPageNo");
        if(cp == null) cp = "1";

        int currentShowPageNo = 1;
        try {
            currentShowPageNo = Integer.parseInt(cp);
        } catch(NumberFormatException e) {
            currentShowPageNo = 1;
        }
        
        int sizePerPage = 10; 

        // 4. DAO를 통한 데이터 조회
        MyQnaListDAO qdao = new MyQnaListDAO_imple(); 
        
        Map<String, String> paraMap = new HashMap<>();
        paraMap.put("userid", userid);
        paraMap.put("currentShowPageNo", String.valueOf(currentShowPageNo));
        paraMap.put("sizePerPage", String.valueOf(sizePerPage));

        // DB에서 데이터 가져오기 (총 개수 및 페이징 목록)
        int totalQnaCount = qdao.getMyTotalQnaCount(userid); 
        List<QnaDTO> qnaList = qdao.selectMyQnaList(paraMap);

        // ==========================================
        // 5. 페이지바 생성 (QnaListController 방식 적용)
        // ==========================================
        String pageBar = "";
        int blockSize = 10; // 하단에 보여줄 페이지 번호 개수
        int loop = 1;       // 번호 출력 반복 횟수
        
        // pageNo 공식: 현재 페이지 번호를 이용해 해당 블럭의 첫 번째 페이지 번호를 구함
        int pageNo = ((currentShowPageNo - 1) / blockSize) * blockSize + 1;

        // 전체 페이지 수 계산
        int totalPage = (int) Math.ceil((double)totalQnaCount / sizePerPage);
        if(totalPage == 0) totalPage = 1;

        // [맨처음]
        pageBar += "<li><a href='" + request.getContextPath() + "/customer/myQnaList.sp?currentShowPageNo=1'>[맨처음]</a></li>";

        // [이전]
        if (pageNo != 1) {
            pageBar += "<li><a href='" + request.getContextPath() + "/customer/myQnaList.sp?currentShowPageNo=" + (pageNo - 1) + "'>[이전]</a></li>";
        }

        while (!(loop > blockSize || pageNo > totalPage)) {
            if (pageNo == currentShowPageNo) {
                // 현재 내가 보고 있는 페이지는 링크가 없음
                pageBar += "<li class='active'><a href='/customer/myQnaList.sp'>" + pageNo + "</a></li>";
            } else {
                pageBar += "<li><a href='" + request.getContextPath() + "/customer/myQnaList.sp?currentShowPageNo=" + pageNo + "'>" + pageNo + "</a></li>";
            }
            loop++;
            pageNo++;
        }

        // [다음]
        if (pageNo <= totalPage) {
            pageBar += "<li><a href='" + request.getContextPath() + "/customer/myQnaList.sp?currentShowPageNo=" + pageNo + "'>[다음]</a></li>";
        }

        // [마지막]
        pageBar += "<li><a href='" + request.getContextPath() + "/customer/myQnaList.sp?currentShowPageNo=" + totalPage + "'>[마지막]</a></li>";

        int vno = totalQnaCount - (currentShowPageNo - 1) * sizePerPage;
        
        // 6. JSP로 결과 전달
        request.setAttribute("qnaList", qnaList);
        request.setAttribute("pageBar", pageBar);
        request.setAttribute("vno", vno);
        request.setAttribute("currentShowPageNo", currentShowPageNo);

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/js_member/myQnaList.jsp");
    }
}