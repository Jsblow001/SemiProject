package jh.reserve.admin.controller;

import java.util.HashMap;

import org.json.simple.JSONObject;
import net.nurigo.java_sdk.api.Message;

public class SmsSender {

    private final String apiKey;
    private final String apiSecret;
    private final String fromPhone;

    public SmsSender(String apiKey, String apiSecret, String fromPhone) {
        this.apiKey = apiKey;
        this.apiSecret = apiSecret;
        this.fromPhone = fromPhone;
    }

    @SuppressWarnings("unchecked")
    public String sendNow(String toPhone, String text) throws Exception {

        Message coolsms = new Message(apiKey, apiSecret);

        HashMap<String, String> paraMap = new HashMap<>();
        paraMap.put("to", toPhone);
        paraMap.put("from", fromPhone);
        paraMap.put("type", "LMS");
        // 45포인트씩 차감
        paraMap.put("text", text);
        paraMap.put("app_version", "JAVA SDK v2.2");

        JSONObject jsObj = (JSONObject) coolsms.send(paraMap);
        return jsObj.toString(); // {"group_id":...,"success_count":1,...}
    }
}

