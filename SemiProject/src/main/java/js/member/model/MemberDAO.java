package js.member.model;

import java.sql.SQLException;
import java.util.Map;

import hk.member.domain.MemberDTO;

public interface MemberDAO {

	// 회원 업데이트
	public int updateMember(MemberDTO member) throws SQLException;

	// 포인트 업데이트
	public int updateMemberPoint(Map<String, Object> paraMap) throws SQLException;
	
}