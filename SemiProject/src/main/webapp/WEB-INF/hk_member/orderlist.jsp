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
<title>SISEON | 주문내역</title>
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

/* ===== 취소/교환/반품 버튼 ===== */
.btn-cancel{
    display:inline-block;
    padding:6px 14px;
    font-size:12px;
    font-weight:500;
    color:#3b2f2a;
    background:#f5f3ef;
    border:1px solid #e3e0dc;
    border-radius:16px;
    text-decoration:none;
    transition:all .2s ease;
}
.btn-cancel:hover{
    background:#3b2f2a;
    color:#fff;
    border-color:#3b2f2a;
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

/* ===== 주문상세 버튼 ===== */
.btn-order-detail {
    display:inline-block;
    padding:6px 14px;
    font-size:12px;
    font-weight:500;
    color:#3b2f2a;
    border:1px solid #e3e0dc;
    border-radius:20px;
    background:#fff;
    text-decoration:none;
    transition:all .2s ease;
}

.btn-order-detail:hover {
    background:#3b2f2a;
    color:#fff;
    border-color:#3b2f2a;
}

/* ===== 페이지네이션 ===== */
.pagination {
    justify-content:center;
    margin-top:40px;
}
.pagination .page-item .page-link {
    color: #3b2f2a;                 /* 기본 텍스트 */
    border: 1px solid #e3e0dc;      /* 연한 베이지 테두리 */
    background-color: #fff;
    margin: 0 3px;
    padding: 6px 12px;
    font-size: 13px;
    border-radius: 20px;
    transition: all 0.2s ease;
}

/* hover */
.pagination .page-item .page-link:hover {
    background-color: #f5f3ef;      /* 연베이지 */
    border-color: #3b2f2a;
    color: #3b2f2a;
}

/* 활성 페이지 */
.pagination .page-item.active .page-link {
    background-color: #3b2f2a;      /* 우드 브라운 */
    border-color: #3b2f2a;
    color: #fff;
    font-weight: 500;
}

/* 비활성(disabled) */
.pagination .page-item.disabled .page-link {
    color: #bbb;
    background-color: #fafafa;
    border-color: #eee;
    pointer-events: none;
}

/* 이전/다음 화살표도 동일 톤 */
.pagination .page-item:first-child .page-link,
.pagination .page-item:last-child .page-link {
    font-weight: 600;
}
</style>
</head>

<script type="text/javaScript">
	
	/* 취소 교환 반품 팝업창 */
	function openCancelPopup(odrCode, status){
	    window.open(
	        "<%=ctxPath%>/orderCancelPopup.sp?odrcode=" + odrCode + "&status=" + status,
	        "cancelPopup",
	        "width=500,height=600,scrollbars=yes"
	    );
	}
</script>

<body>

<jsp:include page="../header.jsp"/>

<div class="order-container">

    <h3 style="font-size:22px;font-weight:600;margin-bottom:20px;">주문내역</h3>

    <!-- 탭 -->
    <div class="order-tabs">
        <!-- 총 주문 건수로 표시 -->
        <a href="#" class="active">주문내역 (${totalCount})</a>
        <a href="<%=ctxPath%>/shop/orderList.sp?status=2" class="active">취소/교환/반품 내역 확인</a>
    </div>

    <!-- 필터 -->
    <div class="filter-box">
        <div class="filter-left">
            <form method="get" action="<%=ctxPath%>/shop/orderList.sp">
                <select name="status" onchange="this.form.submit()">
                    <option value="" ${empty status ? 'selected' : ''}>전체 주문처리상태</option>
                    <option value="1" ${status == '1' ? 'selected' : ''}>결제완료</option>
                    <option value="0" ${status == '0' ? 'selected' : ''}>결제대기</option>
                    <option value="2" ${status == '2' ? 'selected' : ''}>결제취소</option>
                </select>
            </form>
        </div>

        <div class="filter-right">
            <form method="get" action="<%=ctxPath%>/shop/orderList.sp"
                  style="display:flex;align-items:center;gap:6px;">

                <!-- 빠른 기간 버튼 -->
                <button type="submit" name="range" value="today">오늘</button>
                <button type="submit" name="range" value="7d">1주일</button>
                <button type="submit" name="range" value="1m">1개월</button>
                <button type="submit" name="range" value="3m">3개월</button>
                <button type="submit" name="range" value="6m">6개월</button>

                <!-- 직접 날짜 선택 -->
                <input type="date" name="startDate" value="${startDate}">
                <span>~</span>
                <input type="date" name="endDate" value="${endDate}">

                <button type="submit">조회</button>

                <!-- 상태값 유지 -->
                <input type="hidden" name="status" value="${status}">
            </form>
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
                <th style="width:5%">No</th>
                <th style="width:18%">주문일자<br>[주문번호]</th>
                <th>상품정보</th>
                <th style="width:8%">수량</th>
                <th style="width:15%">상품구매금액</th>
                <th style="width:12%">주문처리상태</th>
                <th style="width:12%">취소/교환/반품</th>
                <th style="width:15%">주문상세내역</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${not empty orderList}">
                    <c:forEach var="o" items="${orderList}" varStatus="st">
                        <tr>
                            <!-- 페이지 기준 번호 -->
                            <td>
                                ${(page - 1) * 10 + st.count}
                            </td>

                            <!-- 주문일자 / 주문번호 -->
                            <td>
                                <fmt:formatDate value="${o.odrDate}" pattern="yyyy-MM-dd"/><br>
                                <span style="color:#999;">[${o.odrCode}]</span>
                            </td>

                            <!-- 상품정보 -->
                            <td>${o.productName}</td>

                            <!-- 수량 -->
                            <td>${o.totalQty}</td>

                            <!-- 금액 -->
                            <td>
                                <fmt:formatNumber value="${o.odrTotalPrice}" pattern="#,###"/>원
                            </td>

                            <!-- 주문상태 -->
                            <td>${o.paymentStatusName}</td>

                            <!-- 취소/교환/반품 신청 (팝업창) -->
                            <td>
							    <a href="javascript:void(0);"
							       class="btn-cancel"
							       onclick="openCancelPopup('${o.odrCode}','${o.paymentStatusName}')">
							        신청
							    </a>
							</td>

                            <!-- 주문상세 -->
                            <td>
                                <a href="<%=ctxPath%>/orderDetail.sp?odrcode=${o.odrCode}"
                                   class="btn-order-detail">
                                    주문상세
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>

                <c:otherwise>
                    <tr>
                        <td colspan="8" class="empty-msg">
                            주문 내역이 없습니다.
                        </td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>

        <!-- 페이지네이션 -->
    <ul class="pagination">

        <!-- 이전 -->
        <li class="page-item ${page == 1 ? 'disabled' : ''}">
            <a class="page-link"
               href="<%=ctxPath%>/shop/orderList.sp?page=${page - 1}&status=${empty status ? '' : status}&startDate=${empty startDate ? '' : startDate}&endDate=${empty endDate ? '' : endDate}&range=${empty range ? '' : range}">
                ‹
            </a>
        </li>

        <!-- 페이지 번호 -->
        <c:forEach begin="1" end="${totalPage}" var="i">
            <li class="page-item ${page == i ? 'active' : ''}">
                <a class="page-link"
                   href="<%=ctxPath%>/shop/orderList.sp?page=${i}&status=${empty status ? '' : status}&startDate=${empty startDate ? '' : startDate}&endDate=${empty endDate ? '' : endDate}&range=${empty range ? '' : range}">
                    ${i}
                </a>
            </li>
        </c:forEach>

        <!-- 다음 -->
        <li class="page-item ${page == totalPage ? 'disabled' : ''}">
            <a class="page-link"
               href="<%=ctxPath%>/shop/orderList.sp?page=${page + 1}&status=${empty status ? '' : status}&startDate=${empty startDate ? '' : startDate}&endDate=${empty endDate ? '' : endDate}&range=${empty range ? '' : range}">
                ›
            </a>
        </li>

    </ul>

<!-- 테스트 -->

</div>

<jsp:include page="../footer.jsp"/>

</body>
</html>
