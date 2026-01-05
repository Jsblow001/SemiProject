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
        
        List<Map<String, Object>> weekly = rdao.getWeeklyRevenue();
        List<Map<String, Object>> monthly = rdao.getMonthlyRevenue();

        // 1. [추가] 인기 상품명 가져오기
        String bestSeller = rdao.getBestSellerName();

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
        
        // 2. [추가] JSON 데이터에 포함
        dataMap.put("bestSeller", bestSeller);

        String json = new Gson().toJson(dataMap);
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.print(json);
        out.flush();

        super.setRedirect(false);
        super.setViewPage(null);
    }
}