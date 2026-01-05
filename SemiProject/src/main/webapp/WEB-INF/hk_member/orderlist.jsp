<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String ctxPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>CARIN | 주문내역</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%=ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css">

<style>
body {
    font-family: 'Poppins','Pretendard',sans-serif;
    background:#FBFAF8;
}

.order-container {
    margin: 150px auto 120px;
    max-width: 1100px;
}

/* ===== 상단 탭 ===== */
.order-tabs {
    font-size:14px;
    margin-bottom:30px;
}
.order-tabs a {
    margin-right:20px;
    color:#999;
    text-decoration:none;
}
.order-tabs a.active {
    color:#333;
    font-weight:600;
}

/* ===== 필터 영역 ===== */
.filter-box {
    display:flex;
    justify-content:space-between;
    align-items:center;
    font-size:13px;
    margin-bottom:15px;
}

.filter-left select {
    height:32px;
    font-size:13px;
}

.filter-right button,
.filter-right input {
    height:32px;
    font-size:12px;
}

.filter-right button {
    background:#3b2f2a;
    color:#fff;
    border:none;
    padding:0 12px;
}

/* ===== 안내 문구 ===== */
.notice {
    font-size:12px;
    color:#999;
    margin-bottom:15px;
}

/* ===== 테이블 ===== */
.order-table {
    width:100%;
    background:#fff;
    border-top:2px solid #3b2f2a;
    font-size:13px;
}
.order-table th {
    background:#fafafa;
    color:#777;
    text-align:center;
    padding:15px 5px;
}
.order-table td {
    text-align:center;
    padding:25px 5px;
    border-top:1px solid #eee;
}

.empty-msg {
    padding:80px 0;
    color:#999;
}

/* ===== 페이지네이션 ===== */
.pagination {
    justify-content:center;
    margin-top:40px;
}
</style>
</head>

<body>

<jsp:include page="../header.jsp"/>

<div class="order-container">

    <h3 style="font-size:22px;font-weight:600;margin-bottom:20px;">주문내역</h3>

    <!-- 탭 -->
    <div class="order-tabs">
        <a href="#" class="active">주문내역 (0)</a>
        <a href="#">취소/교환/반품 내역 (0)</a>
    </div>

    <!-- 필터 -->
    <div class="filter-box">
        <div class="filter-left">
            <select>
                <option>전체 주문처리상태</option>
                <option>결제완료</option>
                <option>배송중</option>
                <option>배송완료</option>
            </select>
        </div>

        <div class="filter-right">
            <button>오늘</button>
            <button>1주일</button>
            <button>1개월</button>
            <button>3개월</button>
            <button>6개월</button>
            <input type="date">
            <span>~</span>
            <input type="date">
            <button>조회</button>
        </div>
    </div>

    <!-- 안내 -->
    <div class="notice">
        · 최근 3개월간의 주문내역이 기본으로 조회됩니다.<br>
        · 주문번호를 클릭하시면 주문 상세내역을 확인할 수 있습니다.
    </div>

    <!-- 테이블 -->
    <table class="order-table">
        <thead>
            <tr>
                <th style="width:18%">주문일자<br>[주문번호]</th>
                <th>상품정보</th>
                <th style="width:8%">수량</th>
                <th style="width:15%">상품구매금액</th>
                <th style="width:12%">주문처리상태</th>
                <th style="width:12%">취소/교환/반품</th>
            </tr>
        </thead>
        <tbody>
			<c:choose>
			    <c:when test="${not empty requestScope.orderList}">
			        <c:forEach var="o" items="${requestScope.orderList}">
			            <tr>
			                <!-- 주문일자 / 주문번호 -->
			                <td>
			                    <fmt:formatDate value="${o.odrDate}" pattern="yyyy-MM-dd"/><br>
			                    <span style="color:#999;">[${o.odrCode}]</span>
			                </td>
			
			                <!-- 상품정보 -->
			                <td>
			                    ${o.productName}
			                </td>
			
			                <!-- 수량 -->
			                <td>
			                    ${o.totalQty}
			                </td>
			
			                <!-- 금액 -->
			                <td>
			                    <fmt:formatNumber value="${o.odrTotalPrice}" pattern="#,###"/>원
			                </td>
			
			                <!-- 주문상태 -->
			                <td>
			                    ${o.paymentStatusName}
			                </td>
			
			                <!-- 취소/교환/반품 -->
			                <td>
			                    <a href="#" style="font-size:12px;color:#999;">신청</a>
			                </td>
			            </tr>
			        </c:forEach>
			    </c:when>
			
			    <c:otherwise>
			        <tr>
			            <td colspan="6" class="empty-msg">
			                주문 내역이 없습니다.
			            </td>
			        </tr>
			    </c:otherwise>
			</c:choose>
		</tbody>

    </table>

    <!-- 페이지네이션 -->
    <ul class="pagination">
        <li class="page-item disabled"><a class="page-link" href="#">‹</a></li>
        <li class="page-item active"><a class="page-link" href="#">1</a></li>
        <li class="page-item disabled"><a class="page-link" href="#">›</a></li>
    </ul>

</div>

<jsp:include page="../footer.jsp"/>

</body>
</html>
