package hk.member.model;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import hk.member.domain.AddressDTO;
import hk.member.domain.MemberCountDTO;
import hk.member.domain.MemberDTO;

/*
 * [MemberDAO]
 * - 회원 관련 DB 작업을 정의한 인터페이스
 * - 현재 사용 중인 기능만 선언
 */
public interface MemberDAO {

    // 회원가입
    int registerMember(MemberDTO member, AddressDTO address) throws SQLException;
    
    // 회원가입 內 이메일 중복검사 
 	boolean isUseridExists(String userid) throws SQLException;

    // 로그인 처리
    MemberDTO login(Map<String, String> paraMap) throws SQLException;
 	
    // 아이디 찾기 (이름 + 이메일)
    String findUseridByNameEmail(String name, String email) throws SQLException;

    // 비밀번호 찾기용 사용자 존재 여부 확인
    boolean isUserExistsForPwd(String userid, String email) throws SQLException;

    // 비밀번호 찾기 후 비밀번호 업데이트
	boolean updatePassword(String userid, String encryptPasswd) throws SQLException;

	// 회원정보 수정
	int updateMember(MemberDTO member) throws SQLException;

	// 회원 탈퇴
	int withdrawMember(String userid) throws SQLException;
	
	
	// 관리자 페이지 內 메인 페이지 - 회원 요약 데이터 (전체 회원수) + 전체목록 조회 페이징 처리
	int getTotalMemberCount() throws SQLException;
	
	// 관리자 페이지 內 메인 페이지 - 회원 요약 데이터 (정상회원 수)
	int getActiveMemberCount() throws SQLException;
	
	// 관리자 페이지 內 메인 페이지 - 회원 요약 데이터 (정상회원 수)
	int getDeleteMemberCount() throws SQLException;
	
	// 관리자 페이지 內 회원 전체 목록 조회 (+ 페이징 처리)
	List<MemberDTO> selectAllMemberForAdmin(int startRno, int endRno) throws SQLException;
	
	// 관리자 페이지 內 회원 검색 조회
	List<MemberDTO> selectMemberBySearch(String searchType, String searchWord) throws SQLException;
	
	// 관리자 페이지 內 회원 상세 조회 (입력받은 userid 를 가지고 한명의 회원정보를 가져오기) 
	MemberDTO selectOneMember(String userid);
	
	// 관리자 페이지 內 오늘자 가입회원 수
	int getTodayRegisterCount() throws SQLException;

	// 관리자 페이지 內 최근 7일 가입자 수
	int getLast7DaysRegisterCount() throws SQLException;
	
	// 관리자 페이지 內 최근 7일 가입자 수(그래프)
	List<Map<String, Object>> getLast7DaysRegisterList() throws SQLException;;

	// 관리자 페이지 內 최근 가입 회원 TOP 5
	List<MemberDTO> getRecentMemberList(int topN) throws SQLException;;
	
	// 관리자 페이지 內 등급별 회원 수
	List<MemberCountDTO> getGradeCountList() throws SQLException;

	// 관리자 페이지 內 성별 회원 수
	List<MemberCountDTO> getGenderCountList() throws SQLException;

	// 관리자 페이지 內 회원 더미 50명 추가
	int createDummyMembers(int i) throws SQLException;

	// 휴면회원 해제하기
	int idleRelease(String userid) throws SQLException;

	// 관리자 페이지 내 휴면회원 수 
	int getIdleMemberCount() throws SQLException;

	// 관리자 페이지 휴면회원 조회
	List<MemberDTO> selectIdleMemberListForAdmin() throws SQLException;

	

	

	

	

	

	
}
