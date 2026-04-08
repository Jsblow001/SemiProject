package hk.admin.controller;

import java.util.List;

import hk.member.domain.MemberDTO;
import hk.member.model.MemberDAO;
import hk.member.model.MemberDAO_imple;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import sp.common.controller.AbstractController;

public class IdleMemberController extends AbstractController {

	 private MemberDAO mdao = new MemberDAO_imple();
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		 // 1) 휴면회원 목록 조회
        List<MemberDTO> idleMemberList = mdao.selectIdleMemberListForAdmin();

        // 2) 휴면회원 수
        int idleCount = idleMemberList.size();
		
        // 3) JSP로 넘기기
        request.setAttribute("idleMemberList", idleMemberList);
        request.setAttribute("idleCount", idleCount);
		
        super.setRedirect(false);
	    super.setViewPage("/WEB-INF/hk_admin/idlememberList.jsp");
	}

}
