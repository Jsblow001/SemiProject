<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../header2.jsp" />

<style>
  /* ================================
   ADMIN CLAIM – REFINED UI
================================ */
:root {
    --carin-black: #1a1a1a;
    --carin-gray: #8c8c8c;
    --carin-light-gray: #f7f7f7;
    --carin-border: #e6e6e6;
    --carin-point: #bcaaa4;
    --success: #4caf50;
    --danger: #e53935;
}

/* 전체 래퍼 */
.carin-admin-wrap {
    max-width: 1400px;
    margin: 0 auto;
    padding: 60px 24px 120px;
    background: #fff;
    font-family: 'Pretendard', sans-serif;
}

/* 타이틀 */
.page-title {
    font-size: 20px;
    font-weight: 600;
    letter-spacing: 0.12em;
    text-align: center;
    margin-bottom: 60px;
}

/* ================================
   SUMMARY CARD
================================ */
.summary-section {
    display: flex;
    gap: 24px;
    justify-content: center;
    margin-bottom: 70px;
}

.summary-item {
    background: var(--carin-light-gray);
    border-radius: 12px;
    padding: 32px 24px;
    min-width: 220px;
    text-align: center;
}

.summary-item .label {
    font-size: 11px;
    letter-spacing: 0.12em;
    color: var(--carin-gray);
    margin-bottom: 12px;
}

.summary-item .count {
    font-size: 26px;
    font-weight: 600;
    color: var(--carin-black);
}

/* ================================
   TABLE
================================ */
.return-table {
    width: 100%;
    border-collapse: separate;
    border-spacing: 0 14px;
    font-size: 13px;
}

.return-table thead th {
    font-size: 12px;
    color: var(--carin-gray);
    font-weight: 500;
    padding: 10px;
    text-align: center;
}

.return-table tbody tr {
    background: #fff;
    border-radius: 12px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.04);
    transition: transform .15s ease, box-shadow .15s ease;
}

.return-table tbody tr:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 18px rgba(0,0,0,0.08);
}

.return-table td {
    padding: 18px 14px;
    text-align: center;
    vertical-align: middle;
}

.return-table td:first-child {
    border-radius: 12px 0 0 12px;
}

.return-table td:last-child {
    border-radius: 0 12px 12px 0;
}

/* ================================
   BADGE
================================ */
.badge {
    display: inline-block;
    padding: 6px 12px;
    font-size: 11px;
    border-radius: 999px;
    font-weight: 500;
    letter-spacing: 0.04em;
}

.badge.cancel { background: #fdecea; color: var(--danger); }
.badge.return { background: #f3edea; color: var(--carin-point); }
.badge.exchange { background: #ececec; color: #333; }

.badge.request { background: #f5f5f5; color: #777; }
.badge.wait { background: #f3edea; color: var(--carin-point); }
.badge.done { background: #edf7ed; color: var(--success); }
.badge.reject { background: #f5f5f5; color: #999; }


/* ================================
   ADMIN MANAGEMENT BUTTON – BROWN (FINAL)
================================ */

:root {
    --admin-brown: #5d4037;
    --admin-brown-hover: #4e342e;
}

/* 버튼 그룹 */
.btn-group {
    display: flex;
    flex-direction: column;
    gap: 6px;
}

/* 공통 버튼 */
.btn-admin {
    font-size: 11px;
    padding: 8px 0;
    border-radius: 4px;
    border: 1px solid #d6d6d6;
    background: #fff;
    color: #333;
    cursor: pointer;
    transition: background .15s ease, color .15s ease;
}

/* 승인 / 처리완료 */
.btn-approve {
    background: var(--admin-brown);
    border-color: var(--admin-brown);
    color: #fff;
}

.btn-approve:hover {
    background: var(--admin-brown-hover);
    border-color: var(--admin-brown-hover);
}

/* 반려 */
.btn-reject {
    background: #fff;
    color: #777;
    border-color: #ddd;
}

.btn-reject:hover {
    background: #f2f2f2;
    color: #444;
}

/* 비활성 */
.btn-admin:disabled {
    background: #f5f5f5;
    color: #aaa;
    border-color: #e0e0e0;
    cursor: not-allowed;
}

</style>

<script>
    // [CHANGED] 처리완료(환불/배송취소/재고반영) 전용
    function completeClaim(odrdetailno) {
        if(!confirm("해당 요청을 처리완료 하시겠습니까?\n(결제취소/배송취소/재고반영 진행)")) return;

        location.href =
            "${pageContext.request.contextPath}/admin/claimComplete.sp" +
            "?odrdetailno=" + odrdetailno;
    }

</script>

<div class="carin-admin-wrap">

    <h2 class="page-title">취소 / 반품 / 교환 요청 관리</h2>

    <!-- ================================
         상단 요약 영역
         ================================ -->
    <div class="summary-section">
        <div class="summary-item">
            <span class="label">전체 요청</span>
            <span class="count">${not empty claimList ? claimList.size() : 0}</span>
        </div>
        <div class="summary-item">
            <span class="label">처리 대기</span>
            <span class="count" style="color: var(--carin-point);">
                ${pendingCount}
            </span>
        </div>
    </div>

    <!-- ================================
         클레임 목록 테이블
         ================================ -->
    <table class="return-table">
        <thead>
            <tr>
                <th>주문번호</th>
                <th>상품명</th>
                <th>수량</th>
                <th>요청유형</th>
                <th>사유</th>
                <th>상태</th>
                <th>매니지먼트</th>
            </tr>
        </thead>

        <tbody>
        <c:forEach var="c" items="${claimList}">
            <tr>
                <td>${c.odrCode}</td>

                <td style="text-align:left;padding-left:20px;">
                    ${c.productName}
                </td>

                <td>${c.odrQty}</td>

                <td>
                    <c:choose>
                        <c:when test="${c.claimType == '취소'}">
                            <span class="badge cancel">취소요청</span>
                        </c:when>
                        <c:when test="${c.claimType == '반품'}">
                            <span class="badge return">반품요청</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge exchange">${c.claimType}</span>
                        </c:otherwise>
                    </c:choose>
                </td>

                <td style="color:#757575;font-size:12px;">
                    ${c.claimReason}
                </td>

                <!--  [CHANGED] 상태 표시 분기 -->
                <td>
                    <c:choose>
                        <c:when test="${c.claimStatus == 'REQUEST'}">
                            <span class="badge">요청됨</span>
                        </c:when>
                        <c:when test="${c.claimStatus == 'APPROVED'}">
                            <span class="badge" style="color:var(--carin-point);border-color:var(--carin-point);">
                                처리대기
                            </span>
                        </c:when>
                        <c:when test="${c.claimStatus == 'COMPLETED'}">
                            <span class="badge" style="color:#222;border-color:#222;">
                                처리완료
                            </span>
                        </c:when>
                        <c:when test="${c.claimStatus == 'REJECTED'}">
                            <span class="badge" style="color:#999;border-color:#999;">
                                반려
                            </span>
                        </c:when>
                    </c:choose>
                </td>

                <!-- [CHANGED] 매니지먼트 버튼 분기 -->
                <td>
                    <div class="btn-group">
                       <c:choose>

					    <%-- 1️ 요청 상태 --%>
					    <c:when test="${c.claimStatus == 'REQUEST'}">
					        <button class="btn-admin btn-approve"
						        onclick="location.href='${pageContext.request.contextPath}/admin/claimApprove.sp?odrdetailno=${c.odrDetailNo}'">
						     승인
							</button>

					       <button class="btn-admin btn-reject"
						        onclick="location.href='${pageContext.request.contextPath}/admin/claimReject.sp?odrdetailno=${c.odrDetailNo}'">
						   반려
						   </button>

					    </c:when>
					
					    <%-- 2️ 승인됨 (처리대기) --%>
					    <c:when test="${c.claimStatus == 'APPROVED'}">
					        <button class="btn-admin btn-approve"
					                onclick="completeClaim('${c.odrDetailNo}')">
					            처리완료
					        </button>
					    </c:when>
					
					    <%-- 3️ 완료 / 반려 --%>
					    <c:otherwise>
					        <span>-</span>
					    </c:otherwise>
					
					</c:choose>

                    </div>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

<jsp:include page="../footer2.jsp" />
