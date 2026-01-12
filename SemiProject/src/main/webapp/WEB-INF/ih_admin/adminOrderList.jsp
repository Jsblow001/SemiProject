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
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<style>
    body { font-family: 'Pretendard', Arial, sans-serif; background-color: #f7f6f3; color: #333; }
    .container-custom { width: 1300px; margin: 60px auto; background-color: #fff; padding: 40px; border-radius: 4px; box-shadow: 0 4px 12px rgba(0,0,0,0.06); }
    .admin-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
    .admin-header h3 { font-size: 18px; font-weight: 700; color: #2f2b2a; margin: 0; }
    table { width: 100%; border-collapse: collapse; font-size: 14px; table-layout: fixed; }
    thead th { background-color: #f2f1ee; font-weight: 600; color: #555; padding: 14px 5px; border-bottom: 2px solid #ddd; text-align: center; }
    
    /* 행 전체 클릭 스타일 */
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
        <h3>주문 상태 관리</h3>
        <button type="button" class="btn-list" onclick="location.href='<%= ctxPath %>/admin/memberMain.sp'">메인으로</button>
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
                        <%-- 행 전체 클릭 이벤트 적용 --%>
                        <tr onclick="goOrderDetail('${order.odrcode}')">
                            <td>${order.odrcode}</td>
                            <td>${order.name}<br><small>(${order.fk_userid})</small></td>
                            <td style="text-align: left; padding-left: 15px;">${order.pName}</td>
                            <td style="font-weight: 600;"><fmt:formatNumber value="${order.totalprice}" pattern="#,###"/>원</td>
                            <td><span class="pay-success">결제완료</span></td>
                            <td style="color: #888; font-size: 13px;">${order.odrdate}</td>
                            <%-- select 클릭 시 상세페이지 이동 방지 (event.stopPropagation) --%>
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

<script src="<%= ctxPath %>/js/ih_product/adminOrder.js"></script>
<jsp:include page="../footer2.jsp" />
</body>
</html>