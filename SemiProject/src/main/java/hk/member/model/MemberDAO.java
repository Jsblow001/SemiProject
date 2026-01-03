package hk.member.model;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import hk.member.domain.MemberDTO;

/*
 * [MemberDAO]
 * - 회원 관련 DB 작업을 정의한 인터페이스
 * - 현재 사용 중인 기능만 선언
 */
public interface MemberDAO {

    // 회원가입
    int registerMember(MemberDTO member) throws SQLException;
    
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

	//관리자 페이지 內 메인 페이지 -  회원 요약 데이터 (오늘 회원가입 수)
	int getTodayRegisterCount() throws SQLException;
	
	// 관리자 페이지 內 메인 페이지 - 회원 요약 데이터
	// int getTotalMemberCount() throws SQLException;
	
	// 관리자 페이지 內 회원 전체 목록 조회
	List<MemberDTO> selectAllMemberForAdmin() throws SQLException;

	// 관리자 페이지 內 회원 검색 조회
	List<MemberDTO> selectMemberBySearch(String searchType, String searchWord);


	
}
