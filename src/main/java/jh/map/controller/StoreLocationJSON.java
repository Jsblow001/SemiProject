package jh.map.controller;

import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jh.product.model.*;
import sp.common.controller.AbstractController;

public class StoreLocationJSON extends AbstractController {
	
	private ProductDAO pdao;
	
	public StoreLocationJSON() {
		pdao = new ProductDAO_imple();
	}
	
	@Override
	public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		// tbl_map(위,경도) 테이블에 있는 정보를 가져오기(select)
		List<Map<String, String>> storeMapList = pdao.selectStoreMap();
		
		JSONArray jsonArr = new JSONArray(); // [] 배열객체생성
		
		if(storeMapList.size() > 0) {
		     for(Map<String, String> storeMap : storeMapList) {
		        JSONObject jsonObj = new JSONObject(); // {}
		        
		        String storeurl = storeMap.get("STOREURL");
		        String storename = storeMap.get("STORENAME");
		        String storeimg = storeMap.get("STOREIMG");
		        String storeaddress = storeMap.get("STOREADDRESS");
		        double lat = Double.parseDouble(storeMap.get("LAT"));
		        double lng = Double.parseDouble(storeMap.get("LNG"));
		        int zIndex = Integer.parseInt(storeMap.get("ZINDEX"));
		        
		        String tel = storeMap.get("TEL");
                String hours = storeMap.get("HOURS");
                String reserveUrl = storeMap.get("RESERVEURL");
		        
		        jsonObj.put("storeurl", storeurl);
		        jsonObj.put("storename", storename);
		        jsonObj.put("storeimg", storeimg);
		        jsonObj.put("storeaddress", storeaddress);
		        jsonObj.put("lat", lat);
		        jsonObj.put("lng", lng);
		        jsonObj.put("zIndex", zIndex);
		        
		        jsonObj.put("tel", tel);
                jsonObj.put("hours", hours);
                jsonObj.put("reserveUrl", reserveUrl);
		        
		        jsonArr.put(jsonObj); // [{},{},{},{},{}]
		     }// end of for---------------------
		}
		
		String json = jsonArr.toString();
	    request.setAttribute("json", json);
	      
   // 	super.setRedirect(false);
	    super.setViewPage("/WEB-INF/ih_jsonview.jsp");
		
		
	}

}
