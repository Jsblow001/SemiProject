<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<% String ctxPath = request.getContextPath(); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 | 주문관리</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

<style>
    body { font-family: 'Pretendard', Arial, sans-serif; background-color: #f7f6f3; color: #333; }
    .container-custom { width: 1300px; margin: 60px auto; background-color: #fff; padding: 40px; border-radius: 4px; box-shadow: 0 4px 12px rgba(0,0,0,0.06); }
    
    .admin-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
    .admin-header h3 { font-size: 18px; font-weight: 700; color: #2f2b2a; margin: 0; }
    
    .dashboard-wrapper { display: flex; gap: 25px; margin-bottom: 40px; align-items: stretch; }
    
    .summary-grid { flex: 1; display: grid; grid-template-columns: 1fr 1fr; gap: 15px; }
    .dash-card { background: #fff; border: 1px solid #eee; padding: 20px; border-radius: 10px; display: flex; align-items: center; }
    .dash-icon { width: 45px; height: 45px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 18px; margin-right: 15px; }
    .dash-info .label { font-size: 13px; color: #888; display: block; margin-bottom: 2px; }
    .dash-info .value { font-size: 22px; font-weight: 700; color: #222; }
    .dash-info .unit { font-size: 14px; font-weight: normal; margin-left: 2px; color: #555; }

    .bg-new { background-color: #eef2ff; color: #4f46e5; }      /* 신규 배송 */
    .bg-shipping { background-color: #fff7ed; color: #ea580c; } /* 배송중 */
    .bg-done { background-color: #f0fdf4; color: #16a34a; }     /* 배송완료 */
    .bg-total { background-color: #f8fafc; color: #475569; }    /* 총 주문량 */

    .chart-container { flex: 1.5; background: #fff; border: 1px solid #eee; padding: 20px; border-radius: 10px; }
    .chart-header { font-size: 14px; font-weight: 700; margin-bottom: 15px; color: #555; }

    table { width: 100%; border-collapse: collapse; font-size: 14px; table-layout: fixed; }
    thead th { background-color: #f2f1ee; font-weight: 600; color: #555; padding: 14px 5px; border-bottom: 2px solid #ddd; text-align: center; }
    tbody tr { cursor: pointer; transition: background 0.2s; }
    tbody tr:hover { background-color: #f1f0ec; }
    tbody td { padding: 15px 5px; border-bottom: 1px solid #eee; color: #444; vertical-align: middle; text-align: center; word-break: break-all; }
    
    .pay-success { color: #28a745; font-weight: 700; font-size: 13px; }
    .status-select { width: 95%; padding: 6px 5px; border: 1px solid #ddd; border-radius: 3px; font-size: 13px; background-color: #fff; cursor: default; }
    .btn-list { padding: 10px 18px; background-color: #3e3a39; color: #fff !important; text-decoration: none; border-radius: 3px; font-size: 14px; font-weight: 600; border: none; cursor: pointer; }
</style>
</head>
<body>
<jsp:include page="../header2.jsp" />
<input type="hidden" id="ctxPath" value="<%= ctxPath %>" />

<div class="container-custom">
    <div class="admin-header">
        <h3>주문 및 배송 현황 관리</h3>
        <button type="button" class="btn-list" onclick="location.href='<%= ctxPath %>/admin/memberMain.sp'">메인으로</button>
    </div>

    <div class="dashboard-wrapper">
        <div class="summary-grid">
            <div class="dash-card">
                <div class="dash-icon bg-new"><i class="fa-solid fa-bell"></i></div>
                <div class="dash-info">
                    <span class="label">신규 배송건</span>
                    <span class="value">${newOrderCount != null ? newOrderCount : 0}<span class="unit">건</span></span>
                </div>
            </div>
            <div class="dash-card">
                <div class="dash-icon bg-shipping"><i class="fa-solid fa-truck"></i></div>
                <div class="dash-info">
                    <span class="label">배송중</span>
                    <span class="value">${shippingCount != null ? shippingCount : 0}<span class="unit">건</span></span>
                </div>
            </div>
            <div class="dash-card">
                <div class="dash-icon bg-done"><i class="fa-solid fa-check-double"></i></div>
                <div class="dash-info">
                    <span class="label">배송완료</span>
                    <span class="value">${completeCount != null ? completeCount : 0}<span class="unit">건</span></span>
                </div>
            </div>
            <div class="dash-card">
                <div class="dash-icon bg-total"><i class="fa-solid fa-chart-simple"></i></div>
                <div class="dash-info">
                    <span class="label">총 주문량(누적)</span>
                    <span class="value">${totalOrderCount != null ? totalOrderCount : 0}<span class="unit">건</span></span>
                </div>
            </div>
        </div>

        <div class="chart-container">
            <div class="chart-header">
                <i class="fa-solid fa-chart-line"></i> 최근 7일 주문량 추이
            </div>
            <canvas id="orderChart" height="100"></canvas>
        </div>
    </div>

    <table>
        <thead>
            <tr>
                <th style="width: 140px;">주문번호</th>
                <th style="width: 120px;">주문자(ID)</th>
                <th>상품명</th>
                <th style="width: 120px;">결제금액</th>
                <th style="width: 100px;">결제상태</th> 
                <th style="width: 170px;">주문일시</th>
                <th style="width: 150px;">배송상태</th> 
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${not empty orderList}">
                    <c:forEach var="order" items="${orderList}">
                        <tr onclick="goOrderDetail('${order.odrcode}')">
                            <td>${order.odrcode}</td>
                            <td>${order.name}<br><small>(${order.fk_userid})</small></td>
                            <td style="text-align: left; padding-left: 15px;">${order.pName}</td>
                            <td style="font-weight: 600;"><fmt:formatNumber value="${order.totalprice}" pattern="#,###"/>원</td>
                            <td><span class="pay-success">결제완료</span></td>
                            <td style="color: #888; font-size: 13px;">${order.odrdate}</td>
                            <td onclick="event.stopPropagation();">
                                <select class="status-select" data-order-no="${order.odrcode}">
								    <option value="1" ${order.deliverystatus == 1 ? 'selected' : ''}>결제완료</option>
								    <option value="2" ${order.deliverystatus == 2 ? 'selected' : ''}>배송중</option>
								    <option value="3" ${order.deliverystatus == 3 ? 'selected' : ''}>배송완료</option>
								    <option value="4" ${order.deliverystatus == 4 ? 'selected' : ''}>주문취소</option>
								</select>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="7" style="padding: 80px 0; color: #999;">진행된 주문 내역이 없습니다.</td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</div>

<script>
    $(document).ready(function() {

        const ctx = document.getElementById('orderChart').getContext('2d');
        
        // 데이터 예시 (서버에서 넘겨받은 데이터를 배열 형태로 넣으시면 됩니다)
        const labels = ['01/07', '01/08', '01/09', '01/10', '01/11', '01/12', '오늘'];
        const orderData = [5, 12, 8, 15, 20, 10, 18]; // 예시 수치

        new Chart(ctx, {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: '주문건수',
                    data: orderData,
                    borderColor: '#4f46e5',
                    backgroundColor: 'rgba(79, 70, 229, 0.05)',
                    borderWidth: 3,
                    fill: true,
                    tension: 0.4,
                    pointRadius: 3,
                    pointBackgroundColor: '#4f46e5'
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
                plugins: { legend: { display: false } },
                scales: {
                    y: { beginAtZero: true, grid: { color: '#f5f5f5' } },
                    x: { grid: { display: false } }
                }
            }
        });
    });
</script>

<script src="<%= ctxPath %>/js/ih_product/adminOrder.js"></script>
<jsp:include page="../footer2.jsp" />
</body>
</html>