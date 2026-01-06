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
</style>
</head>

<body>

<jsp:include page="../header.jsp"/>

<div class="detail-container">

    <h3 style="font-size:18px;font-weight:600;color:#333;margin-bottom:20px;">
	    주문 상세내역 <span style="font-size:13px;color:#999;">(${odrCode})</span>
	</h3>

    <table class="detail-table">
        <thead>
            <tr>
                <th>상품명</th>
                <th>수량</th>
                <th>가격</th>
                <th>배송상태</th>
                <th>배송일</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="d" items="${detailList}">
                <tr>
                    <td>${d.productName}</td>
                    <td>${d.odrQty}</td>
                    <td>
                        <fmt:formatNumber value="${d.odrPrice}" pattern="#,###"/>원
                    </td>
                    <td>${d.deliveryStatusName}</td>
                    <td>${d.deliveryDate}</td>
                </tr>
            </c:forEach>

            <c:if test="${empty detailList}">
                <tr>
                    <td colspan="5" style="padding:40px;color:#999;">
                        주문 상세 정보가 없습니다.
                    </td>
                </tr>
            </c:if>
        </tbody>
    </table>

    <div style="margin-top:30px;">
        <a href="javascript:history.back()">← 주문목록으로</a>
    </div>

</div>

<jsp:include page="../footer.jsp"/>

</body>
</html>
