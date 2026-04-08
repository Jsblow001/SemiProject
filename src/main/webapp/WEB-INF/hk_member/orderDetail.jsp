<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>주문 상세내역</title>

<style>
body{
    font-family:'Pretendard','Poppins',sans-serif;
    background:#FBFAF8;
    color:#2f2b2a;
}

/* 전체 컨테이너 */
.detail-container{
    max-width:1000px;
    margin:140px auto 120px;
    padding:0 20px;
}

/* 상단 타이틀 */
.page-title{
    display:flex;
    justify-content:space-between;
    align-items:flex-end;
    margin-bottom:18px;
}
.page-title h3{
    font-size:22px;
    font-weight:700;
    margin:0;
}
.page-title .sub{
    font-size:13px;
    color:#999;
}

/* 카드 공통 */
.card{
    background:#fff;
    border:1px solid #eee;
    border-radius:14px;
    padding:18px 20px;
    box-shadow:0 6px 18px rgba(0,0,0,0.04);
    margin-bottom:18px;
}
.card-title{
    font-size:15px;
    font-weight:700;
    margin-bottom:14px;
    color:#3b2f2a;
}

/* 정보 테이블 (결제/배송지) */
.info-table{
    width:100%;
    border-collapse:collapse;
    font-size:13px;
}
.info-table td{
    padding:8px 0;
    vertical-align:top;
}
.info-table td.label{
    width:120px;
    color:#777;
}

/* 주문상품 테이블 */
.detail-table{
    width:100%;
    border-collapse:collapse;
    font-size:13px;
    overflow:hidden;
    border-radius:14px;
}
.detail-table thead th{
    background:#fafafa;
    color:#777;
    padding:14px 10px;
    text-align:center;
    border-bottom:1px solid #eee;
    white-space:nowrap;
}
.detail-table tbody td{
    padding:16px 10px;
    text-align:center;
    border-bottom:1px solid #f1f1f1;
    vertical-align:middle;
}
.detail-table tbody tr:last-child td{
    border-bottom:none;
}

/* 상품정보 */
.pd{
    display:flex;
    align-items:center;
    gap:12px;
    text-align:left;
}
.pd img{
    width:70px;
    height:70px;
    object-fit:cover;
    border-radius:10px;
    border:1px solid #eee;
}
.pd .name{
    font-weight:600;
    font-size:13px;
    color:#2f2b2a;
    line-height:1.4;
    max-width:320px;
    overflow:hidden;
    text-overflow:ellipsis;
    white-space:nowrap;
}

/* 배송상태 뱃지 */
.badge{
    display:inline-block;
    padding:6px 10px;
    font-size:12px;
    border-radius:999px;
    font-weight:600;
}
.badge.ready{ background:#f1e4d8; color:#8e6e53; }      /* 배송준비중 */
.badge.ship{ background:#e8f0ff; color:#2d5bd1; }       /* 배송중 */
.badge.done{ background:#e6f7ec; color:#1e8e3e; }       /* 배송완료 */
.badge.cancel{ background:#f8d7da; color:#c0392b; }     /* 취소 */

/* 금액 영역 */
.price-box{
    display:flex;
    justify-content:flex-end;
}
.price-inner{
    width:360px;
    font-size:13px;
}
.price-row{
    display:flex;
    justify-content:space-between;
    padding:8px 0;
    color:#555;
}
.price-row strong{
    color:#2f2b2a;
}
.price-total{
    border-top:1px solid #eee;
    margin-top:8px;
    padding-top:14px;
    display:flex;
    justify-content:space-between;
    font-size:16px;
    font-weight:800;
}
.price-total .total{
    color:#c0392b;
}

/* 버튼 */
.btn-box{
    margin-top:26px;
    text-align:center;
}
.btn-back{
    display:inline-block;
    padding:12px 26px;
    border-radius:999px;
    border:1px solid #e3e0dc;
    background:#fff;
    color:#3b2f2a;
    text-decoration:none;
    font-size:13px;
    font-weight:600;
    transition:all .2s ease;
}
.btn-back:hover{
    background:#3b2f2a;
    color:#fff;
    border-color:#3b2f2a;
}
</style>
</head>

<body>

<jsp:include page="../header.jsp"/>

<div class="detail-container">

    <!-- 타이틀 -->
    <div class="page-title">
        <h3>주문 상세내역</h3>
        <div class="sub">주문번호: ${odrCode}</div>
    </div>

    <!-- 주문/결제 정보 -->
    <div class="card">
        <div class="card-title">주문/결제 정보</div>
        <table class="info-table">
            <tr>
                <td class="label">주문번호</td>
                <td><strong>${orderInfo.odrCode}</strong></td>
            </tr>
            <tr>
                <td class="label">주문일자</td>
                <td><fmt:formatDate value="${orderInfo.odrDate}" pattern="yyyy-MM-dd"/></td>
            </tr>
            <tr>
                <td class="label">결제상태</td>
                <td><strong>${orderInfo.paymentStatusName}</strong></td>
            </tr>
            <tr>
                <td class="label">주문금액</td>
                <td><strong><fmt:formatNumber value="${orderInfo.odrTotalPrice}" pattern="#,###"/>원</strong></td>
            </tr>
        </table>
    </div>

    <!-- 배송지 정보 -->
    <div class="card">
        <div class="card-title">배송지 정보</div>
        <table class="info-table">
            <tr>
                <td class="label">수령자</td>
                <td><c:out value="${sessionScope.loginuser.name}"/></td>
            </tr>
            <tr>
                <td class="label">연락처</td>
                <td><c:out value="${sessionScope.loginuser.mobile}"/></td>
            </tr>
            <tr>
                <td class="label">배송주소</td>
                <td style="line-height:1.6;">
                    (<c:out value="${sessionScope.loginuser.postcode}"/>)<br>
                    <c:out value="${sessionScope.loginuser.address}"/><br>
                    <c:out value="${sessionScope.loginuser.detailaddress}"/>
                    <c:if test="${not empty sessionScope.loginuser.extraaddress}">
                        <br><c:out value="${sessionScope.loginuser.extraaddress}"/>
                    </c:if>
                </td>
            </tr>
        </table>
        <div style="margin-top:10px;font-size:12px;color:#999;">
            ※ 배송지는 회원정보 기준으로 표시됩니다.
        </div>
    </div>

    <!-- 주문 상품 목록 -->
    <div class="card" style="padding:0;">
        <div style="padding:18px 20px 0;">
            <div class="card-title" style="margin-bottom:10px;">주문 상품</div>
        </div>

        <table class="detail-table">
            <thead>
                <tr>
                    <th style="width:60px;">No</th>
                    <th>상품정보</th>
                    <th style="width:90px;">수량</th>
                    <th style="width:120px;">단가</th>
                    <th style="width:120px;">합계</th>
                    <th style="width:120px;">배송상태</th>
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
                            <div class="pd">
                                <img src="${pageContext.request.contextPath}/img/${d.productImage}">
                                <div class="name" title="${d.productName}">
                                    ${d.productName}
                                </div>
                            </div>
                        </td>

                        <td>${d.odrQty}</td>

                        <td>
                            <fmt:formatNumber value="${d.odrPrice}" pattern="#,###"/>원
                        </td>

                        <td>
                            <strong><fmt:formatNumber value="${itemTotal}" pattern="#,###"/>원</strong>
                        </td>

                        <td>
                            <c:choose>
                                <c:when test="${d.deliveryStatus == 1}">
                                    <span class="badge ready">배송준비중</span>
                                </c:when>
                                <c:when test="${d.deliveryStatus == 2}">
                                    <span class="badge ship">배송중</span>
                                </c:when>
                                <c:when test="${d.deliveryStatus == 3}">
                                    <span class="badge done">배송완료</span>
                                </c:when>
                                <c:when test="${d.deliveryStatus == 4}">
                                    <span class="badge cancel">배송취소</span>
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
                        <td colspan="6" style="padding:40px;color:#999;">
                            주문 상세 정보가 없습니다.
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>

        <!-- 금액영역 -->
        <div style="padding:18px 20px 20px;">
            <div class="price-box">
                <div class="price-inner">

                    <c:set var="deliveryFee" value="0"/>
                    <c:if test="${totalPrice > 0 && totalPrice < 50000}">
                        <c:set var="deliveryFee" value="3000"/>
                    </c:if>

                    <div class="price-row">
                        <span>상품금액</span>
                        <strong><fmt:formatNumber value="${totalPrice}" pattern="#,###"/>원</strong>
                    </div>

                    <div class="price-row">
                        <span>배송비</span>
                        <strong><fmt:formatNumber value="${deliveryFee}" pattern="#,###"/>원</strong>
                    </div>

                    <div class="price-total">
                        <span>총 결제금액</span>
                        <span class="total"><fmt:formatNumber value="${totalPrice + deliveryFee}" pattern="#,###"/>원</span>
                    </div>

                </div>
            </div>
        </div>
    </div>

    <!-- 버튼 -->
    <div class="btn-box">
        <a href="javascript:history.back()" class="btn-back">주문목록으로</a>
    </div>

</div>

<jsp:include page="../footer.jsp"/>

</body>
</html>
