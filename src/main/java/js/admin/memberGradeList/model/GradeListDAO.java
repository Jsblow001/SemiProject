package js.admin.memberGradeList.model;

import java.sql.SQLException;
import java.util.List;

import hk.member.domain.MemberDTO;

public interface GradeListDAO {

	// 특정 등급의 전체 인원수 조회
	int getTotalMemberCountByGrade(String grade) throws SQLException;

	// 실시간 승급 대상자 및 누적 금액 조회
	List<MemberDTO> getPromotionCandidates(String grade, int threshold) throws SQLException;

	// 실제 등급 업데이트 처리
	int updateMemberGrade(String memberId, String newGrade) throws SQLException;

	// 
	int getMemberTotalAmount(String userid) throws SQLException;
	
}
