package hk.admin.controller;

import sp.common.controller.AbstractController;
import hk.member.domain.MemberDTO;
import hk.member.model.MemberDAO;
import hk.member.model.MemberDAO_imple;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.util.List;

public class AdminMemberListController extends AbstractController {

    private MemberDAO mdao = new MemberDAO_imple();

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        /* ===============================
         * 1. 관리자 로그인 / 권한 체크
         * =============================== */
        HttpSession session = request.getSession();
        MemberDTO loginuser = (MemberDTO) session.getAttribute("loginuser");

        if (loginuser == null || !"admin".equals(loginuser.getUserid())) {
            request.setAttribute("message", "관리자만 접근할 수 있습니다.");
            request.setAttribute("loc", request.getContextPath() + "/index.sp");

            super.setRedirect(false);
            super.setViewPage("/WEB-INF/msg.jsp");
            return;
        }

        /* ===============================
         * 2. 조회 파라미터 받기 (추가)
         * =============================== */
        String searchType = request.getParameter("searchType");
        String searchWord = request.getParameter("searchWord");

        /* ===============================
         * 3. 회원 목록 조회
         *    - 검색어가 있으면 검색
         *    - 없으면 전체 목록
         * =============================== */
        List<MemberDTO> memberList;

        if (searchType != null
            && searchWord != null
            && !"".equals(searchWord.trim())) {

            memberList = mdao.selectMemberBySearch(searchType, searchWord.trim());
        }
        else {
            memberList = mdao.selectAllMemberForAdmin();
            // admin 제외는 DAO에서 처리 추천
        }

        /* ===============================
         * 4. JSP로 전달
         * =============================== */
        request.setAttribute("memberList", memberList);

        /* ===============================
         * 5. 회원관리 JSP 이동
         * =============================== */
        super.setRedirect(false);
        super.setViewPage("/WEB-INF/hk_admin/memberList.jsp");
    }
}
