<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../header2.jsp" />

<style>
    /* ================================
       CARIN 브랜드 아이덴티티 스타일
       ================================ */
    :root {
        --carin-black: #1a1a1a;
        --carin-gray: #757575;
        --carin-light-gray: #f2f2f2;
        --carin-border: #e0e0e0;
        --carin-point: #bcaaa4; /* 토프 브라운 */
    }

    .carin-admin-wrap {
        max-width: 1400px;
        margin: 0 auto;
        padding: 60px 20px;
        font-family: 'Pretendard', sans-serif;
        background-color: #fff;
    }

    .page-title {
        font-size: 22px;
        font-weight: 600;
        letter-spacing: 0.15em;
        text-transform: uppercase;
        margin-bottom: 50px;
        color: var(--carin-black);
        text-align: center;
    }

    /* ================================
       상단 요약 섹션
       ================================ */
    .summary-section {
        display: flex;
        justify-content: center;
        margin-bottom: 80px;
    }

    .summary-item {
        flex: 1;
        max-width: 250px;
        padding: 40px 20px;
        border: 1px solid var(--carin-border);
        margin-left: -1px;
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

    /* ================================
       테이블 디자인
       ================================ */
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

    /* ================================
       상태 뱃지 & 버튼
       ================================ */
    .badge {
        font-size: 10px;
        padding: 4px 10px;
        letter-spacing: 0.05em;
        border: 1px solid var(--carin-border);
        color: #888;
        display: inline-block;
        text-transform: uppercase;
    }

    .badge.cancel { border-color: #f44336; color: #f44336; }
    .badge.return { border-color: var(--carin-point); color: var(--carin-point); }
    .badge.exchange { border-color: var(--carin-black); color: var(--carin-black); }

    .btn-group {
        display: flex;
        flex-direction: column;
        gap: 6px;
        align-items: center;
    }

    .btn-admin {
        background: none;
        border: 1px solid var(--carin-black);
        color: var(--carin-black);
        padding: 7px 15px;
        font-size: 11px;
        cursor: pointer;
        transition: 0.3s;
        width: 100px;
    }

    .btn-admin:hover { background: var(--carin-black); color: #fff; }

    .btn-approve {
        background-color: var(--carin-point);
        border: 1px solid var(--carin-point);
        color: #fff;
    }

    .btn-reject {
        border-color: #ddd;
        color: #999;
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
