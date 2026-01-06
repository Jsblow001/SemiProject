package js.admin.visitor.model;

import java.sql.*;
import java.util.*;
import javax.sql.DataSource;
import javax.naming.Context;
import javax.naming.InitialContext;

public class VisitorDAO_imple implements VisitorDAO {

    private DataSource ds;

    public VisitorDAO_imple() {
        try {
            Context initContext = new InitialContext();
            Context envContext = (Context) initContext.lookup("java:/comp/env");
            ds = (DataSource) envContext.lookup("SemiProject");
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
    }

    // 자원 반납을 위한 공통 메서드 (Try-with-resources를 사용하므로 명시적 호출은 줄어듭니다)
    private void close(Connection conn, PreparedStatement pstmt, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    // 1. 방문자 기록 저장
    @Override
    public void insertVisitor(String ip, String memberId) {
        String sql = " INSERT INTO visitor_log (v_idx, v_ip, v_date, last_access, member_id) " +
                     " VALUES (seq_visitor_log.NEXTVAL, ?, SYSDATE, SYSDATE, ?) ";
        try (Connection conn = ds.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, ip);
            pstmt.setString(2, memberId);
            pstmt.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    // 2. 접속 시간 갱신 (오늘 데이터만 대상)
    @Override
    public void updateLastAccess(String ip) {
        String sql = " UPDATE visitor_log SET last_access = SYSDATE " +
                     " WHERE v_ip = ? AND TO_CHAR(v_date, 'YYYY-MM-DD') = TO_CHAR(SYSDATE, 'YYYY-MM-DD') ";
        try (Connection conn = ds.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, ip);
            pstmt.executeUpdate();
        } catch (SQLException e) { e.printStackTrace(); }
    }

    // 3. 실시간 접속자 수 (최근 1분 기준)
    @Override
    public int getLiveUserCount() {
        int count = 0;
        String sql = " SELECT COUNT(DISTINCT v_ip) FROM visitor_log " +
                     " WHERE last_access >= SYSDATE - (1/24/60) ";
        try (Connection conn = ds.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) count = rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return count;
    }

 // 4. 오늘/어제 방문자 수 (중복 제거 버전)
    @Override
    public int getVisitorCount(String type, String day) {
        int count = 0;
        String targetDate = "today".equals(day) ? "SYSDATE" : "SYSDATE-1";
        
        // [수정 포인트] COUNT(*) 대신 COUNT(DISTINCT v_ip)를 사용합니다.
        StringBuilder sql = new StringBuilder(" SELECT COUNT(DISTINCT v_ip) FROM visitor_log ");
        sql.append(" WHERE TO_CHAR(v_date, 'YYYY-MM-DD') = TO_CHAR(").append(targetDate).append(", 'YYYY-MM-DD') ");
        
        if ("member".equals(type)) {
            sql.append(" AND member_id IS NOT NULL ");
        } else if ("guest".equals(type)) {
            sql.append(" AND member_id IS NULL ");
        }

        try (Connection conn = ds.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString());
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) count = rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return count;
    }

 // 5. 오늘 가입한 신규 회원 수 수정
    @Override
    public int getTodayNewMember() {
        int count = 0;
        // [수정 완료] register_date 대신 registerday 컬럼 사용
        String sql = " SELECT COUNT(*) FROM tbl_member " +
                     " WHERE TO_CHAR(registerday, 'YYYY-MM-DD') = TO_CHAR(SYSDATE, 'YYYY-MM-DD') ";
        
        try (Connection conn = ds.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            if (rs.next()) count = rs.getInt(1);
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
        return count;
    }

    // 6. 최근 7일 그래프 데이터
    @Override
    public List<Integer> getWeeklyStats(String type) {
        List<Integer> stats = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        
        sql.append(" SELECT b.dt, COUNT(a.v_idx) ")
           .append(" FROM visitor_log a, ")
           .append("      (SELECT TO_CHAR(SYSDATE - LEVEL + 1, 'YYYY-MM-DD') AS dt FROM DUAL CONNECT BY LEVEL <= 7) b ")
           .append(" WHERE b.dt = TO_CHAR(a.v_date(+), 'YYYY-MM-DD') ");
        
        if ("member".equals(type)) {
            sql.append(" AND a.member_id(+) IS NOT NULL ");
        } else if ("guest".equals(type)) {
            sql.append(" AND a.member_id(+) IS NULL ");
        }
        
        sql.append(" GROUP BY b.dt ORDER BY b.dt ASC ");

        try (Connection conn = ds.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql.toString());
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                stats.add(rs.getInt(2));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        
        // 데이터가 7개가 안 채워졌을 경우를 대비한 방어 로직 (보통 쿼리에서 해결되지만 안전장치)
        while(stats.size() < 7) {
            stats.add(0, 0); 
        }
        
        return stats;
    }

 // 7. 오늘 평균 이탈률 조회 (단일 페이지 방문 비율)
    @Override
    public double getBounceRate() {
        int totalVisitors = 0;   // 오늘 전체 방문자(중복 없는 IP 수)
        int bounceVisitors = 0;  // 오늘 단일 페이지 방문자(로그가 1개인 IP 수)
        
        // 1. 오늘 접속한 유니크 IP 총 개수
        String totalSql = " SELECT COUNT(DISTINCT v_ip) FROM visitor_log " +
                          " WHERE TO_CHAR(v_date, 'YYYY-MM-DD') = TO_CHAR(SYSDATE, 'YYYY-MM-DD') ";
                          
        // 2. 오늘 접속한 IP 중 기록(v_idx)이 딱 1개인 IP의 개수
        String bounceSql = " SELECT COUNT(*) FROM ( " +
                           "   SELECT v_ip FROM visitor_log " +
                           "   WHERE TO_CHAR(v_date, 'YYYY-MM-DD') = TO_CHAR(SYSDATE, 'YYYY-MM-DD') " +
                           "   GROUP BY v_ip HAVING COUNT(*) = 1 " +
                           " ) ";

        try (Connection conn = ds.getConnection()) {
            // 전체 방문자 수 조회
            try (PreparedStatement pstmt = conn.prepareStatement(totalSql);
                 ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) totalVisitors = rs.getInt(1);
            }
            
            // 이탈 방문자 수 조회
            try (PreparedStatement pstmt = conn.prepareStatement(bounceSql);
                 ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) bounceVisitors = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // 방문자가 0명일 경우 분모가 0이 되는 것을 방지
        if (totalVisitors == 0) return 0.0;
        
        // 이탈률 계산: (이탈자 / 전체방문자) * 100
        return ((double) bounceVisitors / totalVisitors) * 100;
    }
    
    
}