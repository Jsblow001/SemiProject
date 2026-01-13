package js.admin.revenue;

import java.io.PrintWriter;
import java.util.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import js.admin.revenue.model.RevenueDAO;
import js.admin.revenue.model.RevenueDAO_imple;
import sp.common.controller.AbstractController;
import com.google.gson.Gson;

public class RevenueDataController extends AbstractController {

    @Override
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {

        RevenueDAO rdao = new RevenueDAO_imple(); 
        
        // 1. 매출 그래프용 데이터 (기존)
        List<Map<String, Object>> weekly = rdao.getWeeklyRevenue();
        List<Map<String, Object>> monthly = rdao.getMonthlyRevenue();

        // 2. 인기 상품명 (단일 텍스트용 - 가장 많이 팔린 것 하나)
        String bestSeller = rdao.getBestSellerName();
        
        // -----------------------------------------------------------
        // [수정] 주간/월간 전용 TOP-5 상품 상세 리스트 각각 가져오기
        // -----------------------------------------------------------
        List<Map<String, String>> top5Weekly = rdao.getTop5ProductsWeekly(); 
        List<Map<String, String>> top5Monthly = rdao.getTop5ProductsMonthly(); 
        // -----------------------------------------------------------

        long totalWeekly = 0;
        long totalMonthly = 0;
        
        if (weekly != null) {
            for (Map<String, Object> m : weekly) {
                totalWeekly += Long.parseLong(m.get("value").toString());
            }
        }

        if (monthly != null) {
            for (Map<String, Object> m : monthly) {
                totalMonthly += Long.parseLong(m.get("value").toString());
            }
        }

        long avgWeekly = (weekly != null && !weekly.isEmpty()) ? totalWeekly / weekly.size() : 0;
        int monthlyCount = (monthly != null) ? monthly.size() : 0;

        Map<String, Object> dataMap = new HashMap<>();
        dataMap.put("weekly", weekly);
        dataMap.put("monthly", monthly);
        dataMap.put("totalWeekly", totalWeekly);
        dataMap.put("totalMonthly", totalMonthly);
        dataMap.put("avgWeekly", avgWeekly);
        dataMap.put("monthlyCount", monthlyCount);
        dataMap.put("bestSeller", bestSeller);
        
        // [수정] JSON 데이터에 주간/월간 전용 리스트를 각각 추가
        dataMap.put("top5Weekly", top5Weekly);
        dataMap.put("top5Monthly", top5Monthly);

        String json = new Gson().toJson(dataMap);
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.print(json);
        out.flush();

        super.setRedirect(false);
        super.setViewPage(null);
    }
}