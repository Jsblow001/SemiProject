<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../header2.jsp" />

<style>
    /* 카린 브랜드 가이드라인 스타일링 */
    :root {
        --carin-black: #1a1a1a;
        --carin-gray: #757575;
        --carin-light-gray: #f2f2f2;
        --carin-border: #e0e0e0;
        --carin-point: #bcaaa4; /* 은은한 토프 브라운 */
    }

    .carin-admin-wrap {
        max-width: 1400px;
        margin: 0 auto;
        padding: 60px 20px;
        font-family: 'Pretendard', sans-serif;
        background-color: #fff;
    }

    /* 페이지 타이틀 (자간 넓게) */
    .page-title {
        font-size: 22px;
        font-weight: 600;
        letter-spacing: 0.15em;
        text-transform: uppercase;
        margin-bottom: 50px;
        color: var(--carin-black);
        text-align: center;
    }

    /* 대시보드 요약 (직선 위주 디자인) */
    .summary-section {
        display: flex;
        justify-content: center;
        gap: 0; /* 선을 겹치게 하기 위해 0 설정 */
        margin-bottom: 80px;
    }

    .summary-item {
        flex: 1;
        max-width: 250px;
        padding: 40px 20px;
        border: 1px solid var(--carin-border);
        margin-left: -1px; /* 테두리 중첩 제거 */
        text-align: center;
    }

    .summary-item .label {
        display: block;
        font-size: 11px;
        color: var(--carin-gray);
        letter-spacing: 0.1em;
        margin-bottom: 15px;
    }

    .summary-item .count {
        font-size: 24px;
        font-weight: 500;
        color: var(--carin-black);
    }

    /* 검색 영역 (미니멀 서치) */
    .search-area {
        display: flex;
        justify-content: space-between;
        align-items: flex-end;
        padding-bottom: 15px;
        border-bottom: 2px solid var(--carin-black);
        margin-bottom: 30px;
    }

    .total-info { font-size: 12px; color: var(--carin-gray); }
    .total-info strong { color: var(--carin-black); font-weight: 600; }

    /* 테이블 스타일링 */
    .return-table {
        width: 100%;
        border-collapse: collapse;
        font-size: 13px;
    }

    .return-table th {
        padding: 20px 10px;
        font-weight: 600;
        color: #444;
        border-bottom: 1px solid var(--carin-border);
        text-align: center;
    }

    .return-table td {
        padding: 25px 10px;
        border-bottom: 1px solid #f9f9f9;
        color: #333;
        text-align: center;
        vertical-align: middle;
    }

    /* 상품 정보 (좌측 정렬 및 이미지 여백) */
    .product-cell { text-align: left !important; display: flex; align-items: center; gap: 15px; }
    .product-thumb { width: 60px; height: 75px; background: #f5f5f5; object-fit: cover; }
    .product-name { font-weight: 500; margin-bottom: 5px; display: block; }
    .product-opt { font-size: 11px; color: #999; }

    /* 상태 뱃지 (미니멀) */
    .badge {
        font-size: 10px;
        padding: 4px 10px;
        letter-spacing: 0.05em;
        border: 1px solid var(--carin-border);
        color: #888;
    }
    .badge.active {
        background-color: var(--carin-black);
        color: #fff;
        border-color: var(--carin-black);
    }

    /* 버튼 스타일 */
    .btn-detail {
        background: none;
        border: 1px solid var(--carin-black);
        color: var(--carin-black);
        padding: 8px 20px;
        font-size: 11px;
        cursor: pointer;
        transition: 0.3s;
        text-transform: uppercase;
    }

    .btn-detail:hover {
        background: var(--carin-black);
        color: #fff;
    }

</style>

<div class="carin-admin-wrap">
    <h2 class="page-title">반품 및 교환 관리</h2>

    <div class="summary-section">
        <div class="summary-item">
            <span class="label">반품 요청</span>
            <span class="count">${returnRequestCount}</span>
        </div>
        <div class="summary-item">
            <span class="label">수거 진행</span>
            <span class="count">${pickupCount}</span>
        </div>
        <div class="summary-item">
            <span class="label">검수 완료</span>
            <span class="count">${inspectionCount}</span>
        </div>
        <div class="summary-item">
            <span class="label">처리 대기</span>
            <span class="count" style="color: var(--carin-point);">${pendingCount}</span>
        </div>
    </div>

    <div class="search-area">
        <div class="total-info">
            전체 <strong>${totalCount}</strong>건의 내역이 있습니다.
        </div>
        <div class="filter-options">
            <%-- 검색 필터 등이 들어갈 자리 --%>
        </div>
    </div>

    <table class="return-table">
        <thead>
            <tr>
                <th style="width: 110px;">신청일</th>
                <th style="width: 140px;">주문번호</th>
                <th>상품 정보</th>
                <th style="width: 120px;">고객명</th>
                <th style="width: 120px;">처리 상태</th>
                <th style="width: 150px;">관리</th>
            </tr>
        </thead>
        <tbody>
            <c:if test="${not empty returnList}">
                <c:forEach var="item" items="${returnList}">
                    <tr>
                        <td class="text-secondary">
                            <fmt:formatDate value="${item.regDate}" pattern="yyyy.MM.dd"/>
                        </td>
                        <td style="font-weight: 500;">${item.orderId}</td>
                        <td class="product-cell">
                            <img src="${item.pimg}" alt="상품이미지" class="product-thumb">
                            <div>
                                <span class="product-name">${item.pname}</span>
                                <span class="product-opt">옵션: ${item.optionName}</span>
                            </div>
                        </td>
                        <td>${item.userName}</td>
                        <td>
                            <c:choose>
                                <c:when test="${item.status == '요청'}">
                                    <span class="badge active">반품요청</span>
                                </c:when>
                                <c:when test="${item.status == '검수중'}">
                                    <span class="badge">검수진행</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge">처리완료</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <button class="btn-detail" onclick="location.href='returnDetail.sp?id=${item.returnId}'">상세보기</button>
                        </td>
                    </tr>
                </c:forEach>
            </c:if>
            <c:if test="${empty returnList}">
                <tr>
                    <td colspan="6" style="padding: 120px 0; color: #ccc; letter-spacing: -0.5px;">
                        조회된 반품 내역이 없습니다.
                    </td>
                </tr>
            </c:if>
        </tbody>
    </table>
</div>

<jsp:include page="../footer2.jsp" />