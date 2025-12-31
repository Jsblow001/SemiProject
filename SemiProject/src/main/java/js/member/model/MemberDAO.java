package js.member.model;

import java.sql.SQLException;
import hk.member.domain.MemberDTO;

public interface MemberDAO {

	// 회원 업데이트
	public int updateMember(MemberDTO member) throws SQLException;
	
}