package js.admin.revenue.model;

import java.util.List;
import java.util.Map;

public interface RevenueDAO {

    // 주간 수익 조회 (최근 7일)
    List<Map<String, Object>> getWeeklyRevenue();

    // 월간 수익 조회 (이번 달 주차별)
    List<Map<String, Object>> getMonthlyRevenue();
    
    // 가장 많이 팔린 상품명 가져오기
    String getBestSellerName();
    
    // 주간 인기 상품 TOP 5 (최근 7일 기준)
    List<Map<String, String>> getTop5ProductsWeekly();
    
    // 월간 인기 상품 TOP 5 (이번 달 기준)
    List<Map<String, String>> getTop5ProductsMonthly();
    
}
