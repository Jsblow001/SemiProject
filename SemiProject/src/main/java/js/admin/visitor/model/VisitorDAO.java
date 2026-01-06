package js.admin.visitor.model;

import java.util.List;

public interface VisitorDAO {
    // 1. 새로운 방문자 기록 저장
	void insertVisitor(String ip, String memberId);

    // 2. 활동 중인 사용자의 마지막 접속 시간 갱신 (AJAX용)
    void updateLastAccess(String ip);

    // 3. 실시간 접속자 수 조회 (최근 1분 기준)
    int getLiveUserCount();

    // 4. 특정 조건의 방문자 수 카운트 (오늘/어제, 전체/회원/비회원)
    int getVisitorCount(String type, String day);

    // 5. 오늘 신규 가입자 수
    int getTodayNewMember();

    // 6. 최근 7일간 통계 데이터 (그래프용)
    List<Integer> getWeeklyStats(String type);
    
    // 7. 오늘 평균 이탈률 조회 (단일 페이지 방문 비율)
    double getBounceRate();
}
