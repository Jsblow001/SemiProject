<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../header2.jsp" />

<style>
    /* CARIN 브랜드 아이덴티티 스타일 */
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

    /* 상단 요약 섹션 (필요시 컨트롤러에서 카운트 전달) */
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

    /* 검색 및 정보 영역 */
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

    /* 테이블 디자인 */
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

    /* 상태 뱃지 및 버튼 */
    .badge {
        font-size: 10px;
        padding: 4px 10px;
        letter-spacing: 0.05em;
        border: 1px solid var(--carin-border);
        color: #888;
        display: inline-block;
        text-transform: uppercase;
    }
    /* 요청유형별 색상 구분 */
    .badge.cancel { border-color: #f44336; color: #f44336; }
    .badge.return { border-color: var(--carin-point); color: var(--carin-point); }
    .badge.exchange { border-color: var(--carin-black); color: var(--carin-black); }

    .btn-group { display: flex; flex-direction: column; gap: 6px; align-items: center; }
    
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
    
    .btn-approve { background-color: var(--carin-point); border: 1px solid var(--carin-point); color: #fff; }
    .btn-approve:hover { background-color: #a6958e; border-color: #a6958e; }
    
    .btn-reject { border-color: #ddd; color: #999; }
    .btn-reject:hover { background-color: #f5f5f5; color: #666; }
</style>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script>
    function processClaim(odrdetailno, action) {
        let actionKor = (action === 'APPROVE') ? '승인' : '반려';
        if(!confirm("해당 요청을 " + actionKor + " 처리하시겠습니까?")) return;

        // 기존 방식 유지 (location.href) 
        // 만약 AJAX 방식으로 바꾸고 싶다면 위 예시의 $.ajax 코드를 참고하세요.
        location.href = "${pageContext.request.contextPath}/admin/claimProcess.sp" +
                        "?odrdetailno=" + odrdetailno +
                        "&action=" + action;
    }
</script>

<div class="carin-admin-wrap">
    <h2 class="page-title">취소 / 반품 / 교환 요청 관리</h2>

    <%-- 요약 섹션: 컨트롤러에서 값을 넘겨주지 않는다면 이 섹션은 삭제하셔도 됩니다 --%>
    <div class="summary-section">
        <div class="summary-item">
            <span class="label">전체 요청</span>
            <span class="count">${not empty claimList ? claimList.size() : 0}</span>
        </div>
        <div class="summary-item">
            <span class="label">처리 대기</span>
            <span class="count" style="color: var(--carin-point);">${pendingCount}</span>
        </div>
    </div>

    <div class="search-area">
        <div class="total-info">
            전체 <strong>${not empty claimList ? claimList.size() : 0}</strong> 건의 요청이 있습니다.
        </div>
    </div>

    <table class="return-table">
        <thead>
            <tr>
                <th style="width: 140px;">주문번호</th>
                <th>상품명</th>
                <th style="width: 80px;">수량</th>
                <th style="width: 120px;">요청유형</th>
                <th>사유</th>
                <th style="width: 120px;">상태</th>
                <th style="width: 160px;">매니지먼트</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${not empty claimList}">
                    <c:forEach var="c" items="${claimList}">
                        <tr>
                            <td style="font-weight: 500; letter-spacing: 0.5px;">${c.odrCode}</td>
                            <td style="text-align: left; padding-left: 20px;">
                                <span style="font-weight: 500; color: var(--carin-black);">${c.productName}</span>
                            </td>
                            <td>${c.odrQty}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${c.claimType == '취소'}"><span class="badge cancel">취소요청</span></c:when>
                                    <c:when test="${c.claimType == '반품'}"><span class="badge return">반품요청</span></c:when>
                                    <c:otherwise><span class="badge exchange">${c.claimType}</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td style="color: #757575; font-size: 12px;">${c.claimReason}</td>
                            <td>
                                <span class="badge">${c.claimStatus}</span>
                            </td>
                            <td>
                                <div class="btn-group">
                                    <button type="button" class="btn-admin btn-approve" 
                                            onclick="processClaim('${c.odrDetailNo}','APPROVE')">요청승인</button>
                                    <button type="button" class="btn-admin btn-reject" 
                                            onclick="processClaim('${c.odrDetailNo}','REJECT')">요청반려</button>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="7" style="padding: 150px 0; color: #bbb;">처리할 클레임 내역이 존재하지 않습니다.</td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</div>

<jsp:include page="../footer2.jsp" />