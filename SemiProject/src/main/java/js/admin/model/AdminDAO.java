package js.admin.model;

import java.util.List;
import java.util.Map;

public interface AdminDAO {

    // A. 상단 요약 정보 (총 수익, 결제 건수 등) 조회
	Map<String, String> getRevenueSummary();

	 // B. 차트용 일별 수익 데이터 조회 (최근 28일)
	List<Map<String, String>> getDailyRevenueChart();

	// C. 최근 수익 거래 내역 (하단 테이블용) 조회
	List<Map<String, String>> getRecentRevenueOrders();

}
