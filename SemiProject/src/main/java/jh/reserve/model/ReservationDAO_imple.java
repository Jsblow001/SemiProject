package jh.reserve.model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class ReservationDAO_imple implements ReservationDAO {

    private DataSource ds;
    private Connection conn;
    private PreparedStatement pstmt;
    private ResultSet rs;

    public ReservationDAO_imple() {
        try {
            Context initContext = new InitialContext();
            Context envContext  = (Context)initContext.lookup("java:/comp/env");
            ds = (DataSource)envContext.lookup("SemiProject");
        } catch (NamingException e) {
            e.printStackTrace();
        }
    }

    private void close() {
        try {
            if(rs != null)    {rs.close(); rs=null;}
            if(pstmt != null) {pstmt.close(); pstmt=null;}
            if(conn != null)  {conn.close(); conn=null;}
        } catch(Exception e) {
            e.printStackTrace();
        }
    }

    // 예약 불가한 구간 반환
    @Override
    public List<TimeRange> selectBusyRanges(Map<String, String> paraMap) throws Exception {

        List<TimeRange> list = new ArrayList<>();

        try {
            conn = ds.getConnection();
            int storeId = Integer.parseInt(paraMap.get("storeId"));
            Timestamp dayStart = Timestamp.valueOf(paraMap.get("dayStart"));
            Timestamp dayEnd   = Timestamp.valueOf(paraMap.get("dayEnd"));

            String sql =
                " SELECT start_at, end_at " +
                "   FROM tbl_reservation " +
                "  WHERE fk_store_id = ? " +
                "    AND status = 'CONFIRMED' " +
                "    AND start_at < ? " +
                "    AND end_at   > ? " +
                " UNION ALL " +
                " SELECT start_at, end_at " +
                "   FROM tbl_block_slot " +
                "  WHERE fk_store_id = ? " +
                "    AND start_at < ? " +
                "    AND end_at   > ? ";

            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, storeId);
            pstmt.setTimestamp(2, dayEnd);
            pstmt.setTimestamp(3, dayStart);

            pstmt.setInt(4, storeId);
            pstmt.setTimestamp(5, dayEnd);
            pstmt.setTimestamp(6, dayStart);

            rs = pstmt.executeQuery();
            while(rs.next()) {
                list.add(new TimeRange(rs.getTimestamp("start_at"), rs.getTimestamp("end_at")));
            }

        } finally {
            close();
        }

        return list;
    }

    // ---------- 2) overlap reservation ----------
    @Override
    public boolean existsOverlapReservation(Map<String, String> paraMap) throws Exception {

        boolean exists = false;

        try {
            conn = ds.getConnection();

            int storeId = Integer.parseInt(paraMap.get("storeId"));
            Timestamp newStart = Timestamp.valueOf(paraMap.get("startAt"));
            Timestamp newEnd   = Timestamp.valueOf(paraMap.get("endAt"));

            String sql =
                " SELECT 1 " +
                "   FROM tbl_reservation r " +
                "  WHERE r.fk_store_id = ? " +
                "    AND r.status = 'CONFIRMED' " +
                "    AND r.start_at < ? " +
                "    AND r.end_at   > ? " +
                "    AND ROWNUM = 1 ";

            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, storeId);
            pstmt.setTimestamp(2, newEnd);
            pstmt.setTimestamp(3, newStart);

            rs = pstmt.executeQuery();
            exists = rs.next();

        } finally {
            close();
        }

        return exists;
    }

    // ---------- 3) overlap block ----------
    @Override
    public boolean existsOverlapBlock(Map<String, String> paraMap) throws Exception {

        boolean exists = false;

        try {
            conn = ds.getConnection();

            int storeId = Integer.parseInt(paraMap.get("storeId"));
            Timestamp newStart = Timestamp.valueOf(paraMap.get("startAt"));
            Timestamp newEnd   = Timestamp.valueOf(paraMap.get("endAt"));

            String sql =
                " SELECT 1 " +
                "   FROM tbl_block_slot b " +
                "  WHERE b.fk_store_id = ? " +
                "    AND b.start_at < ? " +
                "    AND b.end_at   > ? " +
                "    AND ROWNUM = 1 ";

            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, storeId);
            pstmt.setTimestamp(2, newEnd);
            pstmt.setTimestamp(3, newStart);

            rs = pstmt.executeQuery();
            exists = rs.next();

        } finally {
            close();
        }

        return exists;
    }

    // ---------- 4) insert reservation (원자적: 겹침 없을 때만 insert) ----------
    @Override
    public int insertReservation(Map<String, String> paraMap) throws Exception {

        int n = 0;

        try {
            conn = ds.getConnection();

            String memberUserid = paraMap.get("memberUserid"); // null이면 비회원

            String sql =
                " INSERT INTO tbl_reservation " +
                " (fk_store_id, fk_member_userid, guest_name, guest_phone, reason_code, duration_min, start_at, end_at, message, status, created_at) " +
                " SELECT ?, ?, ?, ?, ?, ?, ?, ?, ?, 'CONFIRMED', SYSTIMESTAMP " +
                "   FROM dual " +
                "  WHERE NOT EXISTS ( " +
                "        SELECT 1 " +
                "          FROM tbl_reservation r " +
                "         WHERE r.fk_store_id = ? " +
                "           AND r.status = 'CONFIRMED' " +
                "           AND r.start_at < ? " +
                "           AND r.end_at   > ? " +
                "  ) " +
                "    AND NOT EXISTS ( " +
                "        SELECT 1 " +
                "          FROM tbl_block_slot b " +
                "         WHERE b.fk_store_id = ? " +
                "           AND b.start_at < ? " +
                "           AND b.end_at   > ? " +
                "  ) ";

            pstmt = conn.prepareStatement(sql);

            int idx = 1;

            // INSERT 값들
            pstmt.setInt(idx++, Integer.parseInt(paraMap.get("storeId")));      // fk_store_id
            pstmt.setString(idx++, (memberUserid == null || memberUserid.isBlank()) ? null : memberUserid); // fk_member_userid
            pstmt.setString(idx++, paraMap.get("guestName"));                   // guest_name
            pstmt.setString(idx++, paraMap.get("guestPhone"));                  // guest_phone
            pstmt.setString(idx++, paraMap.get("reason"));                      // reason_code
            pstmt.setInt(idx++, Integer.parseInt(paraMap.get("durationMin")));  // duration_min
            pstmt.setTimestamp(idx++, java.sql.Timestamp.valueOf(paraMap.get("startAt"))); // start_at
            pstmt.setTimestamp(idx++, java.sql.Timestamp.valueOf(paraMap.get("endAt")));   // end_at
            pstmt.setString(idx++, paraMap.get("message"));                     // message

            // NOT EXISTS(예약 겹침) 바인딩
            pstmt.setInt(idx++, Integer.parseInt(paraMap.get("storeId")));
            pstmt.setTimestamp(idx++, java.sql.Timestamp.valueOf(paraMap.get("endAt")));   // r.start_at < newEnd
            pstmt.setTimestamp(idx++, java.sql.Timestamp.valueOf(paraMap.get("startAt"))); // r.end_at   > newStart

            // NOT EXISTS(막기 겹침) 바인딩
            pstmt.setInt(idx++, Integer.parseInt(paraMap.get("storeId")));
            pstmt.setTimestamp(idx++, java.sql.Timestamp.valueOf(paraMap.get("endAt")));   // b.start_at < newEnd
            pstmt.setTimestamp(idx++, java.sql.Timestamp.valueOf(paraMap.get("startAt"))); // b.end_at   > newStart

            n = pstmt.executeUpdate(); // 1 성공 / 0 겹침

        } finally {
            close();
        }

        return n;
    }


    
    // 슬롯막기 넣기
    @Override
    public int insertBlockSlot(Map<String, String> paraMap) throws Exception {

        int n = 0;

        try {
            conn = ds.getConnection();

            int storeId = Integer.parseInt(paraMap.get("storeId"));
            Timestamp startAt = Timestamp.valueOf(paraMap.get("startAt"));
            Timestamp endAt   = Timestamp.valueOf(paraMap.get("endAt"));
            String memo = paraMap.get("memo");
            if(memo == null) memo = "";

            // ✅ 겹침이 없을 때만 INSERT 되게 한다.
            // - 예약(CONFIRMED)과 겹치면 막기 불가
            // - 다른 막기와 겹쳐도 불가
            String sql =
                " INSERT INTO tbl_block_slot " +
                " (fk_store_id, start_at, end_at, memo, created_at) " +
                " SELECT ?, ?, ?, ?, SYSTIMESTAMP " +
                "   FROM dual " +
                "  WHERE NOT EXISTS ( " +
                "        SELECT 1 FROM tbl_reservation r " +
                "         WHERE r.fk_store_id = ? AND r.status='CONFIRMED' " +
                "           AND r.start_at < ? AND r.end_at > ? " +
                "       ) " +
                "    AND NOT EXISTS ( " +
                "        SELECT 1 FROM tbl_block_slot b " +
                "         WHERE b.fk_store_id = ? " +
                "           AND b.start_at < ? AND b.end_at > ? " +
                "       ) ";

            pstmt = conn.prepareStatement(sql);

            // insert values
            pstmt.setInt(1, storeId);
            pstmt.setTimestamp(2, startAt);
            pstmt.setTimestamp(3, endAt);
            pstmt.setString(4, memo);

            // overlap check with reservation
            pstmt.setInt(5, storeId);
            pstmt.setTimestamp(6, endAt);
            pstmt.setTimestamp(7, startAt);

            // overlap check with block_slot
            pstmt.setInt(8, storeId);
            pstmt.setTimestamp(9, endAt);
            pstmt.setTimestamp(10, startAt);

            n = pstmt.executeUpdate(); // 1=성공 / 0=겹침으로 인해 insert 안 됨

        } finally {
            close();
        }

        return n;
    }
    
    
    // 슬롯막기 없애기
    @Override
    public int deleteBlockSlot(Map<String, String> paraMap) throws Exception {

        int n = 0;

        try {
            conn = ds.getConnection();

            long blockId = Long.parseLong(paraMap.get("blockId"));

            String sql = " DELETE FROM tbl_block_slot WHERE block_id = ? ";

            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, blockId);

            n = pstmt.executeUpdate();

        } finally {
            close();
        }

        return n; // 1=삭제됨 / 0=없음
    }
    
    // 슬롯막기 목록 조회
    @Override
    public List<Map<String, String>> selectBlockList(Map<String, String> paraMap) throws Exception {

        List<Map<String, String>> list = new java.util.ArrayList<>();

        try {
            conn = ds.getConnection();

            int storeId = Integer.parseInt(paraMap.get("storeId"));
            Timestamp dayStart = Timestamp.valueOf(paraMap.get("dayStart"));
            Timestamp dayEnd   = Timestamp.valueOf(paraMap.get("dayEnd"));

            String sql =
                " SELECT block_id, fk_store_id, start_at, end_at, memo, created_at " +
                "   FROM tbl_block_slot " +
                "  WHERE fk_store_id = ? " +
                "    AND start_at < ? " +
                "    AND end_at   > ? " +
                "  ORDER BY start_at ";

            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, storeId);
            pstmt.setTimestamp(2, dayEnd);
            pstmt.setTimestamp(3, dayStart);

            rs = pstmt.executeQuery();

            while(rs.next()) {
                Map<String, String> m = new java.util.HashMap<>();
                m.put("blockId", String.valueOf(rs.getLong("block_id")));
                m.put("storeId", String.valueOf(rs.getInt("fk_store_id")));
                m.put("startAt", String.valueOf(rs.getTimestamp("start_at")));
                m.put("endAt", String.valueOf(rs.getTimestamp("end_at")));
                m.put("memo", rs.getString("memo"));
                m.put("createdAt", String.valueOf(rs.getTimestamp("created_at")));
                list.add(m);
            }

        } finally {
            close();
        }

        return list;
    }
    
    
    
    // 관리자 화면에 뿌리는 하루치 이벤트 목록 싸그리
    @Override
    public List<Map<String, String>> selectScheduleBoard(Map<String, String> paraMap) throws Exception {

        List<Map<String, String>> list = new java.util.ArrayList<>();

        try {
            conn = ds.getConnection();

            int storeId = Integer.parseInt(paraMap.get("storeId"));
            Timestamp dayStart = Timestamp.valueOf(paraMap.get("dayStart"));
            Timestamp dayEnd   = Timestamp.valueOf(paraMap.get("dayEnd"));

            String sql =
            	    " SELECT 'RESERVATION' AS type, " +
            	    "        TO_CHAR(r.reservation_id) AS id, " +
            	    "        TO_CHAR(r.start_at, 'YYYY-MM-DD HH24:MI:SS') AS startAt, " +
            	    "        TO_CHAR(r.end_at,   'YYYY-MM-DD HH24:MI:SS') AS endAt, " +
            	    "        r.reason_code AS reason, " +
            	    "        r.status AS status, " +
            	    "        r.guest_name AS name, " +
            	    "        r.guest_phone AS phone, " +
            	    "        NVL(r.message,'') AS message, " +  
            	    "        NVL(r.message,'') AS memo " +       
            	    "   FROM tbl_reservation r " +
            	    "  WHERE r.fk_store_id = ? " +
            	    "    AND r.status = 'CONFIRMED' " +
            	    "    AND r.start_at < ? " +
            	    "    AND r.end_at   > ? " +
            	    " UNION ALL " +
            	    " SELECT 'BLOCK' AS type, " +
            	    "        TO_CHAR(b.block_id) AS id, " +
            	    "        TO_CHAR(b.start_at, 'YYYY-MM-DD HH24:MI:SS') AS startAt, " +
            	    "        TO_CHAR(b.end_at,   'YYYY-MM-DD HH24:MI:SS') AS endAt, " +
            	    "        '' AS reason, " +
            	    "        '' AS status, " +
            	    "        '' AS name, " +
            	    "        '' AS phone, " +
            	    "        NVL(b.memo,'') AS message, " +      
            	    "        NVL(b.memo,'') AS memo " +          
            	    "   FROM tbl_block_slot b " +
            	    "  WHERE b.fk_store_id = ? " +
            	    "    AND b.start_at < ? " +
            	    "    AND b.end_at   > ? " +
            	    " ORDER BY startAt ";


            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, storeId);
            pstmt.setTimestamp(2, dayEnd);
            pstmt.setTimestamp(3, dayStart);

            pstmt.setInt(4, storeId);
            pstmt.setTimestamp(5, dayEnd);
            pstmt.setTimestamp(6, dayStart);

            rs = pstmt.executeQuery();

            while(rs.next()) {
                Map<String, String> m = new java.util.HashMap<>();
                m.put("type", rs.getString("type"));     // RESERVATION / BLOCK
                m.put("id", rs.getString("id"));
                m.put("startAt", rs.getString("startAt"));
                m.put("endAt", rs.getString("endAt"));
                m.put("reason", rs.getString("reason"));
                m.put("status", rs.getString("status"));
                m.put("name", rs.getString("name"));
                m.put("phone", rs.getString("phone"));
                m.put("memo", rs.getString("memo"));
                m.put("message", rs.getString("message")); 
                list.add(m);
            }

        } finally {
            close();
        }

        return list;
    }

    
    
    
    // 문자 로그 저장	
    @Override
    public int insertSmsLog(Map<String, String> paraMap) throws Exception {

        int n = 0;

        try {
            conn = ds.getConnection();

            long reservationId = Long.parseLong(paraMap.get("reservationId"));
            int storeId = Integer.parseInt(paraMap.get("storeId"));

            String toPhone = paraMap.get("toPhone");
            String smsType = paraMap.get("smsType");       // REMINDER / ADMIN / etc
            String content = paraMap.get("content");
            String resultJson = paraMap.get("resultJson"); // coolsms 응답 json string

            String sql =
                " INSERT INTO tbl_sms_log " +
                " (fk_reservation_id, fk_store_id, to_phone, sms_type, sms_content, result_json, sent_at) " +
                " VALUES (?, ?, ?, ?, ?, ?, SYSTIMESTAMP) ";

            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, reservationId);
            pstmt.setInt(2, storeId);
            pstmt.setString(3, toPhone);
            pstmt.setString(4, smsType);
            pstmt.setString(5, content);
            pstmt.setString(6, resultJson);

            n = pstmt.executeUpdate();

        } finally {
            close();
        }

        return n;
    }
    
    // 회원예약취소기능
    @Override
    public int cancelReservationByMember(Map<String, String> paraMap) throws Exception {

        int n = 0;

        try {
            conn = ds.getConnection();

            long reservationId = Long.parseLong(paraMap.get("reservationId"));
            int memberId = Integer.parseInt(paraMap.get("memberId"));

            String sql =
                " UPDATE tbl_reservation " +
                "    SET status = 'CANCELLED', cancelled_at = SYSTIMESTAMP, updated_at = SYSTIMESTAMP " +
                "  WHERE reservation_id = ? " +
                "    AND fk_member_userid = ? " +
                "    AND status = 'CONFIRMED' ";

            pstmt = conn.prepareStatement(sql);
            pstmt.setLong(1, reservationId);
            pstmt.setInt(2, memberId);

            n = pstmt.executeUpdate();

        } finally {
            close();
        }

        return n; // 1=취소 성공 / 0=권한없음 또는 이미 취소/없음
    }


    // 내 예약목록 조회
    @Override
    public List<Map<String, String>> selectMyReservations(Map<String, String> paraMap) throws Exception {

        List<Map<String, String>> list = new java.util.ArrayList<>();

        try {
            conn = ds.getConnection();

            int memberId = Integer.parseInt(paraMap.get("memberId"));

            String sql =
                " SELECT r.reservation_id, r.fk_store_id, s.store_name, " +
                "        TO_CHAR(r.start_at, 'YYYY-MM-DD HH24:MI') AS start_at, " +
                "        TO_CHAR(r.end_at,   'HH24:MI') AS end_at, " +
                "        r.reason_code, r.duration_min, r.status, " +
                "        r.guest_name, r.guest_phone, NVL(r.message,'') AS message " +
                "   FROM tbl_reservation r " +
                "   JOIN tbl_store s ON s.store_id = r.fk_store_id " +
                "  WHERE r.fk_member_userid = ? " +
                "  ORDER BY r.start_at DESC ";

            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, memberId);

            rs = pstmt.executeQuery();

            while(rs.next()) {
                Map<String,String> m = new java.util.HashMap<>();
                m.put("reservationId", String.valueOf(rs.getLong("reservation_id")));
                m.put("storeId", String.valueOf(rs.getInt("fk_store_id")));
                m.put("storeName", rs.getString("store_name"));
                m.put("startAt", rs.getString("start_at")); // "YYYY-MM-DD HH:mm"
                m.put("endAt", rs.getString("end_at"));     // "HH:mm"
                m.put("reason", rs.getString("reason_code"));
                m.put("durationMin", String.valueOf(rs.getInt("duration_min")));
                m.put("status", rs.getString("status"));
                m.put("guestName", rs.getString("guest_name"));
                m.put("guestPhone", rs.getString("guest_phone"));
                m.put("message", rs.getString("message"));
                list.add(m);
            }

        } finally {
            close();
        }

        return list;
    }




}
