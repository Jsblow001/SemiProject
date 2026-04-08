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

    /* 대시보드 요약 섹션 */
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

    .product-cell { text-align: left !important; display: flex; align-items: center; gap: 15px; }
    .product-thumb { width: 60px; height: 75px; background: #f5f5f5; object-fit: cover; border: 1px solid #eee; }
    .product-name { font-weight: 500; margin-bottom: 5px; display: block; color: var(--carin-black); }
    .product-opt { font-size: 11px; color: #999; }

    /* 상태 뱃지 및 버튼 */
    .badge {
        font-size: 10px;
        padding: 4px 10px;
        letter-spacing: 0.05em;
        border: 1px solid var(--carin-border);
        color: #888;
        display: inline-block;
    }
    .badge.active { background-color: var(--carin-black); color: #fff; border-color: var(--carin-black); }
    .badge.processing { border-color: var(--carin-point); color: var(--carin-point); }

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
    
    .btn-next { background-color: var(--carin-point); border: 1px solid var(--carin-point); color: #fff; }
    .btn-next:hover { background-color: #a6958e; border-color: #a6958e; }
</style>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script>
    function updateReturnStatus(returnId, nextStatus) {
        let msg = "해당 건을 [" + nextStatus + "] 단계로 변경하시겠습니까?";
        if(nextStatus === '완료') {
            msg = "최종 환불 처리를 승인하시겠습니까?\n이 작업은 되돌릴 수 없으며 실제 결제가 취소됩니다.";
        }

        if(!confirm(msg)) return;

        $.ajax({
            url: "${pageContext.request.contextPath}/admin/updateReturnStatus.sp",
            type: "POST",
            data: {
                "returnId": returnId,
                "status": nextStatus
            },
            dataType: "JSON",
            success: function(json) {
                // 컨트롤러에서 처리 결과(n: 1)를 넘겨준다고 가정
                if(json.n === 1) {
                    alert("성공적으로 처리되었습니다.");
                    location.reload();
                } else {
                    alert("처리 중 오류가 발생했습니다. (데이터 미변경)");
                }
            },
            error: function() {
                alert("서버 통신 오류가 발생했습니다.");
            }
        });
    }
</script>

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
            전체 <strong>${totalCount}</strong> 건의 내역이 조회되었습니다.
        </div>
    </div>

    <table class="return-table">
        <thead>
            <tr>
                <th style="width: 110px;">신청일</th>
                <th style="width: 140px;">주문번호</th>
                <th>상품 정보</th>
                <th style="width: 120px;">고객명</th>
                <th style="width: 120px;">현재 상태</th>
                <th style="width: 160px;">매니지먼트</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${not empty returnList}">
                    <c:forEach var="item" items="${returnList}">
                        <tr>
                            <td style="color: #999;"><fmt:formatDate value="${item.regDate}" pattern="yyyy.MM.dd"/></td>
                            <td style="font-weight: 500; letter-spacing: 0.5px;">${item.orderId}</td>
                            <td class="product-cell">
                                <img src="${item.pimg}" alt="pimg" class="product-thumb">
                                <div>
                                    <span class="product-name">${item.pname}</span>
                                    <span class="product-opt">옵션: ${item.optionName}</span>
                                </div>
                            </td>
                            <td>${item.userName}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${item.status == '요청'}"><span class="badge active">반품요청</span></c:when>
                                    <c:when test="${item.status == '수거중'}"><span class="badge processing">수거진행</span></c:when>
                                    <c:when test="${item.status == '검수완료'}"><span class="badge">검수완료</span></c:when>
                                    <c:when test="${item.status == '처리대기'}"><span class="badge" style="color:var(--carin-point);">처리대기</span></c:when>
                                    <c:otherwise><span class="badge">완료</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="btn-group">
                                    <button type="button" class="btn-admin" onclick="location.href='returnDetail.sp?id=${item.returnId}'">상세보기</button>
                                    
                                    <%-- 현재 상태에 따른 다음 단계 액션 버튼 --%>
                                    <c:choose>
                                        <c:when test="${item.status == '요청'}">
                                            <button type="button" class="btn-admin btn-next" onclick="updateReturnStatus('${item.returnId}', '수거중')">수거시작</button>
                                        </c:when>
                                        <c:when test="${item.status == '수거중'}">
                                            <button type="button" class="btn-admin btn-next" onclick="updateReturnStatus('${item.returnId}', '검수완료')">검수완료</button>
                                        </c:when>
                                        <c:when test="${item.status == '검수완료'}">
                                            <button type="button" class="btn-admin btn-next" onclick="updateReturnStatus('${item.returnId}', '처리대기')">처리대기송신</button>
                                        </c:when>
                                        <c:when test="${item.status == '처리대기'}">
                                            <button type="button" class="btn-admin" style="background:#1a1a1a; color:#fff;" onclick="updateReturnStatus('${item.returnId}', '완료')">환불승인</button>
                                        </c:when>
                                    </c:choose>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="6" style="padding: 150px 0; color: #bbb;">내역이 존재하지 않습니다.</td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</div>

<jsp:include page="../footer2.jsp" />