<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문 상세내역</title>

<style>
.detail-container {
    max-width:900px;
    margin:120px auto;
    font-size:14px;
}
.detail-table {
    width:100%;
    border-top:2px solid #3b2f2a;
}
.detail-table th, .detail-table td {
    padding:15px;
    border-bottom:1px solid #eee;
    text-align:center;
}
.detail-table th {
    background:#fafafa;
}
.badge {
    display:inline-block;
    padding:4px 10px;
    font-size:12px;
    border-radius:12px;
}
.badge.wait { background:#eee; color:#555; }
.badge.approve { background:#f1e4d8; color:#8e6e53; }
.badge.complete { background:#e3e3e3; color:#333; }
.badge.reject { background:#f8d7da; color:#c0392b; }

.btn-box {
    margin-top:40px;
    text-align:center;
}
.admin-btn {
    display:inline-block;
    padding:10px 22px;
    background:#3e3a39;
    color:#fff;
    border-radius:3px;
    text-decoration:none;
}
.admin-btn.light {
    background:#e6e4e1;
    color:#3e3a39 !important;
}
</style>
</head>

<body>

<jsp:include page="../header.jsp"/>

<div class="detail-container">

<h3 style="font-size:18px;font-weight:600;margin-bottom:20px;">
    주문 상세내역 <span style="font-size:13px;color:#999;">(주문번호:${odrCode})</span>
</h3>

<table class="detail-table">
<thead>
<tr>
    <th>No</th>
    <th>이미지</th>
    <th>상품명</th>
    <th>수량</th>
    <th>단가</th>
    <th>합계</th>
    <th>배송상태</th>

</tr>
</thead>

<tbody>
<c:set var="totalPrice" value="0"/>

<c:forEach var="d" items="${detailList}" varStatus="status">
<c:set var="itemTotal" value="${d.odrPrice * d.odrQty}"/>
<c:set var="totalPrice" value="${totalPrice + itemTotal}"/>

<tr>
    <td>${status.count}</td>

    <td>
        <img src="${pageContext.request.contextPath}/img/${d.productImage}"
             style="width:70px;height:70px;object-fit:cover;border-radius:6px;">
    </td>

    <td>${d.productName}</td>
    <td>${d.odrQty}</td>

    <td>
        <fmt:formatNumber value="${d.odrPrice}" pattern="#,###"/>원
    </td>

    <td>
        <strong><fmt:formatNumber value="${itemTotal}" pattern="#,###"/>원</strong>
    </td>

    <!-- 배송 상태 -->
    <td>
        <c:choose>
            <c:when test="${d.deliveryStatus == 4}">
                <span style="color:#c0392b;">배송취소</span>
            </c:when>
            <c:otherwise>
                ${d.deliveryStatusName}
            </c:otherwise>
        </c:choose>
    </td>
</tr>
</c:forEach>

<c:if test="${empty detailList}">
<tr>
    <td colspan="7" style="padding:40px;color:#999;">
        주문 상세 정보가 없습니다.
    </td>
</tr>
</c:if>
</tbody>
</table>

<!-- 금액 영역 -->
<div style="margin-top:30px;text-align:right;">
    <div>상품금액 :
        <strong><fmt:formatNumber value="${totalPrice}" pattern="#,###"/>원</strong>
    </div>

    <c:set var="deliveryFee" value="0"/>
    <c:if test="${totalPrice > 0 && totalPrice < 50000}">
        <c:set var="deliveryFee" value="3000"/>
    </c:if>

    <div>배송비 :
        <strong><fmt:formatNumber value="${deliveryFee}" pattern="#,###"/>원</strong>
    </div>

    <hr style="margin:15px 0;">

    <div style="font-size:18px;">
        총 결제금액 :
        <strong style="color:#c0392b;">
            <fmt:formatNumber value="${totalPrice + deliveryFee}" pattern="#,###"/>원
        </strong>
    </div>
</div>

<div class="btn-box">
    <a href="javascript:history.back()" class="admin-btn light">주문목록으로</a>
</div>

</div>

<jsp:include page="../footer.jsp"/>

</body>
</html>
