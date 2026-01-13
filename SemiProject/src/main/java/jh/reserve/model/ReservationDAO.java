package jh.reserve.model;

import java.sql.Timestamp;
import java.util.List;
import java.util.Map;

public interface ReservationDAO {

    public static class TimeRange {
        public Timestamp start;
        public Timestamp end;
        public TimeRange(Timestamp start, Timestamp end) {
            this.start = start;
            this.end = end;
        }
    }
    // 예약확정 + 막은 구간 조회
    List<TimeRange> selectBusyRanges(Map<String, String> paraMap) throws Exception;
    // storeId, dayStart, dayEnd (yyyy-MM-dd HH:mm:ss)

    // 예약확정과 겹치는지
    boolean existsOverlapReservation(Map<String, String> paraMap) throws Exception;
    // storeId, startAt, endAt

    // 막기와 겹치는지
    boolean existsOverlapBlock(Map<String, String> paraMap) throws Exception;
    // storeId, startAt, endAt

    // 예약진행
    int insertReservation(Map<String, String> paraMap) throws Exception;
    // 공통: storeId, guestName, guestPhone, reason, durationMin, startAt, endAt, message
    // 선택: memberId (있으면 회원, 없으면 비회원)
    // return: 1 성공 / 0 실패(겹침) / 예외는 진짜 DB오류
    
    // 슬롯막기 넣기
    int insertBlockSlot(Map<String, String> paraMap) throws Exception;
    
    // 슬롯막기 없애기
    int deleteBlockSlot(Map<String, String> paraMap) throws Exception;
    
    // 슬롯막기 목록 조회
    List<Map<String, String>> selectBlockList(Map<String, String> paraMap) throws Exception;

    // 관리자 화면에 뿌리는 하루치 이벤트 목록 싸그리
    List<Map<String, String>> selectScheduleBoard(Map<String, String> paraMap) throws Exception;

    // 문자 로그 저장
    int insertSmsLog(Map<String,String> paraMap) throws Exception;
    
    // 회원예약취소
    int cancelReservationByMember(Map<String,String> paraMap) throws Exception;


    // 내 예약목록 조회
    List<Map<String,String>> selectMyReservations(Map<String,String> paraMap) throws Exception;

}
