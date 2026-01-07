package js.qna.controller;

import java.util.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import hk.member.domain.MemberDTO;
import js.qna.model.*; // DAO 패키지 임포트
import jh.qna.domain.QnaDTO; // DTO 패키지 임포트
import sp.common.controller.AbstractController;

public class MyQnaListController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        // 1. 로그인 유무 확인
        if(!super.checkLogin(request)) {
            request.setAttribute("message", "로그인 후 이용 가능합니다.");
            request.setAttribute("loc", request.getContextPath() + "/login.sp"); // 로그인 페이지 경로 확인
            
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

        int currentShowPageNo = Integer.parseInt(cp);
        int sizePerPage = 10; 

        // 4. DAO를 통한 데이터 조회 (주석 해제 및 변수 연결)
        MyQnaListDAO qdao = new MyQnaListDAO_imple(); 
        
        Map<String, String> paraMap = new HashMap<>();
        paraMap.put("userid", userid);
        paraMap.put("currentShowPageNo", cp);
        paraMap.put("sizePerPage", String.valueOf(sizePerPage));

        // DB에서 데이터 가져오기
        int totalQnaCount = qdao.getMyTotalQnaCount(userid); 
        List<QnaDTO> qnaList = qdao.selectMyQnaList(paraMap);

        // 5. 페이징 바 생성 (기존 공통 메소드가 있다면 사용하세요)
        // String pageBar = ... ; 

        // 6. JSP로 보낼 결과 전달 (주석 해제)
        request.setAttribute("currentShowPageNo", currentShowPageNo);
        request.setAttribute("sizePerPage", sizePerPage);
        request.setAttribute("totalQnaCount", totalQnaCount);
        request.setAttribute("qnaList", qnaList);
        // request.setAttribute("pageBar", pageBar); 

        super.setRedirect(false);
        super.setViewPage("/WEB-INF/js_member/myQnaList.jsp");
    }
}