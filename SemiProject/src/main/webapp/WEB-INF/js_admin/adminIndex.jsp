<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<% String ctxPath = request.getContextPath(); %>

<jsp:include page="../header2.jsp" />

<style>
    .admin-container { min-height: 800px; padding: 40px 0; background-color: #f8f9fa; }
    .dashboard-card { border: none; box-shadow: 0 4px 12px rgba(0,0,0,0.03); border-radius: 8px; background: #fff; transition: transform 0.2s; }
    .dashboard-card:hover { transform: translateY(-5px); }
    .text-wood { color: #5D4037 !important; }
    .status-badge { width: 45px; height: 45px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; }
    .table-v-center td { vertical-align: middle !important; }
    .chart-container { position: relative; height: 350px; width: 100%; }
    
    /* 예약 현황 전용 스타일 */
    .reservation-list { max-height: 280px; overflow-y: auto; padding-right: 5px; }
    .reservation-item { padding: 12px 0; border-bottom: 1px solid #eee; display: flex; align-items: center; }
    .reservation-item:last-child { border-bottom: none; }
    .res-time { font-weight: bold; color: #5D4037; width: 60px; flex-shrink: 0; }
    .res-content { flex-grow: 1; margin-left: 10px; }
    
    /* 스크롤바 커스텀 */
    .reservation-list::-webkit-scrollbar { width: 4px; }
    .reservation-list::-webkit-scrollbar-thumb { background-color: #e0e0e0; border-radius: 4px; }
</style>

<div class="container-fluid admin-container px-xl-5">
    <div class="row px-xl-5">
        <div class="col-lg-12">
            <div class="d-flex justify-content-between align-items-end mb-4">
                <h3 class="font-weight-bold m-0 text-dark">운영 현황 요약</h3>
                <span class="text-muted small">마지막 업데이트: <span id="updateTimestamp"><fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyy-MM-dd HH:mm"/></span></span>
            </div>

            <%-- 1. 상단 주요 지표 요약 --%>
            <div class="row">
                <div class="col-md-4 mb-4">
                    <div class="card dashboard-card p-4" style="border-left: 5px solid #5D4037 !important;">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <p class="text-muted mb-1 font-weight-bold">Total Members</p>
                                <h2 class="font-weight-bold">${(totalCount != null) ? totalCount : 0} 명</h2>
                            </div>
                            <div class="status-badge bg-light text-wood"><i class="fas fa-users"></i></div>
                        </div>
                        <a href="<%= ctxPath %>/admin/memberList.sp" class="small text-wood font-weight-bold mt-2 d-block text-decoration-none">상세 명단 보기 ></a>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <div class="card dashboard-card p-4" style="border-left: 5px solid #BCAA8F !important;">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <p class="text-muted mb-1 font-weight-bold">New Orders</p>
                                <h2 class="font-weight-bold">${(newOrderCount != null) ? newOrderCount : 0} 건</h2>
                            </div>
                            <div class="status-badge bg-light" style="color:#BCAA8F;"><i class="fas fa-shopping-bag"></i></div>
                        </div>
                        <a href="<%= ctxPath%>/admin/adminOrderList.sp" class="small text-wood font-weight-bold mt-2 d-block text-decoration-none">주문 내역 관리 ></a>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <div class="card dashboard-card p-4" style="border-left: 5px solid #D7CCC8 !important;">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <p class="text-muted mb-1 font-weight-bold">Today's QnA</p>
                                <h2 class="font-weight-bold">${(newQnACount != null) ? newQnACount : 0} 건</h2>
                            </div>
                            <div class="status-badge bg-light" style="color:#D7CCC8;"><i class="fas fa-comment-dots"></i></div>
                        </div>
                        <a href="<%= ctxPath%>/noCommentQnaList.sp" class="small text-wood font-weight-bold mt-2 d-block text-decoration-none">미답변 문의 확인 ></a>
                    </div>
                </div>
            </div>

            <div class="row">
                <%-- 2. 최근 7일 매출 현황 그래프 --%>
                <div class="col-lg-8 mb-4">
                    <div class="card dashboard-card p-4 h-100">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h5 class="font-weight-bold m-0">최근 7일 매출 현황</h5>
                            <a href="<%= ctxPath %>/revenue.sp" class="btn btn-sm btn-outline-secondary border-0 text-muted">상세 분석 보기 ></a>
                        </div>
                        <div class="chart-container">
                            <canvas id="revenueChart"></canvas>
                        </div>
                    </div>
                </div>

                <%-- 3. 오늘의 예약 현황 (매장 선택 연동) --%>
                <div class="col-lg-4 mb-4">
                    <div class="card dashboard-card p-4 h-100">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h5 class="font-weight-bold m-0">오늘의 예약 현황</h5>
                            <select id="dashStoreId" class="form-control form-control-sm" style="width: auto; min-width: 100px;">
                                <option value="1">SISEON 도산점</option>
                                <option value="2">SISEON 압구정점</option>
                                <option value="3">SISEON 홍대점</option>
                            </select>
                        </div>
                        
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <span class="small text-muted font-weight-bold" id="storeNameTag">SISEON 도산점 실시간</span>
                            <span class="badge badge-dark" id="dashResCount">0건</span>
                        </div>

                        <div class="reservation-list" id="dashResList">
                            <div class="text-center py-5 text-muted small">데이터를 불러오는 중...</div>
                        </div>

                        <div class="mt-auto">
                            <button class="btn btn-block btn-outline-dark font-weight-bold py-2 mt-3" 
                                    onclick="location.href='<%= ctxPath %>/admin/schedule.sp'">
                                예약 스케줄 상세 관리
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            
			<%-- 4. 반품/취소 요청 현황 (미처리 건만 표시) --%>
			<div class="row">
			    <div class="col-12">
			        <div class="card dashboard-card p-4 border-0">
			            <div class="d-flex justify-content-between align-items-center mb-4">
			                <h5 class="font-weight-bold m-0 text-danger">
			                    <i class="fas fa-exclamation-circle mr-2"></i>미처리 클레임 현황
			                </h5>
			                <a href="<%= ctxPath%>/admin/claimList.sp" class="btn btn-sm btn-light font-weight-bold px-3">전체보기</a>
			            </div>
			            <div class="table-responsive">
			                <table class="table table-hover table-v-center border-bottom mb-0 text-center">
			                    <thead class="bg-light text-muted small font-weight-bold">
			                        <tr>
			                            <th style="width: 15%;">주문번호</th>
			                            <th class="text-left" style="width: 40%;">상품명</th>
			                            <th style="width: 15%;">요청유형</th>
			                            <th style="width: 20%;">사유</th>
			                            <th style="width: 10%;">상태</th>
			                        </tr>
			                    </thead>
			                    <tbody>
			                        <c:set var="pendingCount" value="0" />
			                        <c:choose>
			                            <c:when test="${not empty returnRequestList}">
			                                <c:forEach var="c" items="${returnRequestList}">
			                                    <%-- 처리 완료(APPROVED, REJECTED)가 아닌 '신청(REQUEST)' 상태만 출력 --%>
			                                    <c:if test="${c.claimStatus eq 'REQUEST' and pendingCount lt 5}">
			                                        <c:set var="pendingCount" value="${pendingCount + 1}" />
			                                        <tr onclick="location.href='<%= ctxPath %>/admin/claimList.sp'" style="cursor:pointer;">
			                                            <%-- 1. 주문번호 --%>
			                                            <td class="font-weight-bold text-dark">${c.odrCode}</td>
			                                            
			                                            <%-- 2. 상품명 --%>
			                                            <td class="text-left">
			                                                <div class="small text-truncate" style="max-width:400px;">
			                                                    ${c.productName}
			                                                </div>
			                                            </td>
			                                            
			                                            <%-- 3. 요청유형 --%>
			                                            <td>
			                                                <span class="badge ${c.claimType eq 'CANCEL' ? 'badge-danger' : 'badge-warning'} p-2 px-3" style="font-size: 11px;">
			                                                    ${c.claimType eq 'CANCEL' ? '취소' : '반품'}
			                                                </span>
			                                            </td>
			                                            
			                                            <%-- 4. 사유 --%>
			                                            <td class="text-muted small text-truncate">
			                                                <div style="max-width:200px; margin: 0 auto;">${c.claimReason}</div>
			                                            </td>
			                                            
			                                            <%-- 5. 상태 (미처리 건이므로 '대기'로 표시) --%>
			                                            <td>
			                                                <span class="badge badge-secondary p-2">접수대기</span>
			                                            </td>
			                                        </tr>
			                                    </c:if>
			                                </c:forEach>
			                                
			                                <%-- 만약 리스트는 있지만 필터링 결과 처리할 건이 하나도 없을 때 --%>
			                                <c:if test="${pendingCount eq 0}">
			                                    <tr><td colspan="5" class="text-center py-5 text-muted font-weight-bold">새로 들어온 요청이 없습니다.</td></tr>
			                                </c:if>
			                            </c:when>
			                            <c:otherwise>
			                                <tr><td colspan="5" class="text-center py-5 text-muted font-weight-bold">접수된 클레임 요청이 없습니다.</td></tr>
			                            </c:otherwise>
			                        </c:choose>
			                    </tbody>
			                </table>
			            </div>
			        </div>
			    </div>
			</div>

<jsp:include page="../footer2.jsp" />

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    let revenueChart = null;
    const formatter = new Intl.NumberFormat('ko-KR');

    $(document).ready(function() {
        // 1. 매출 데이터 로드
        loadDashboardRevenue();

        // 2. 초기 매장 예약 데이터 로드
        const initialStoreId = $("#dashStoreId").val();
        fetchTodayReservations(initialStoreId);

        // 3. 매장 셀렉트박스 변경 이벤트
        $("#dashStoreId").on("change", function() {
            const storeId = $(this).val();
            const storeName = $("#dashStoreId option:selected").text();
            $("#storeNameTag").text(storeName + " 실시간");
            fetchTodayReservations(storeId);
        });
    });

    // [AJAX] 오늘의 예약 데이터 호출
    // [AJAX] 오늘의 예약 데이터 호출 (현재 시간 이후만 표시)
function fetchTodayReservations(storeId) {
    const $list = $("#dashResList");
    const now = new Date(); // 현재 시간 객체
    const todayStr = now.toISOString().split('T')[0];

    $.ajax({
        url: "<%= ctxPath %>/admin/scheduleBoard.sp",
        type: "GET",
        data: { storeId: storeId, date: todayStr },
        dataType: "json",
        success: function(json) {
            $list.empty();
            let count = 0;

            if(json.ok && json.events && json.events.length > 0) {
                // 시간순 정렬
                json.events.sort((a, b) => a.startAt.localeCompare(b.startAt));

                json.events.forEach(function(ev) {
                    if(ev.type !== "BLOCK") { 
                        
                        // --- [시간 비교 로직 추가] ---
                        // ev.startAt 형식 예: "2026-01-14 14:30:00"
                        const eventTime = new Date(ev.startAt.replace(/-/g, "/")); // 크로스브라우징을 위해 -를 /로 교체
                        
                        // 현재 시간보다 이벤트 시작 시간이 큰(미래인) 경우만 화면에 그림
                        if (eventTime > now) {
                            count++;
                            const startTime = ev.startAt.substring(11, 16);
                            const html = `
                                <div class="reservation-item">
                                    <span class="res-time">\${startTime}</span>
                                    <div class="res-content">
                                        <div class="small font-weight-bold">\${ev.name} 고객님</div>
                                        <div class="text-muted" style="font-size: 11px;">\${ev.phone} / \${ev.people || 1}명</div>
                                    </div>
                                    <span class="badge badge-light text-muted" style="font-size: 10px;">확정</span>
                                </div>`;
                            $list.append(html);
                        }
                    }
                });
            }

            $("#dashResCount").text(count + "건");
            if(count === 0) {
                $list.append('<div class="text-center py-5 text-muted small">남은 예약 내역이 없습니다.</div>');
            }
        },
        error: function() {
            $list.html('<div class="text-center py-5 text-danger small">데이터 호출 실패</div>');
        }
    });
}

    // [AJAX] 매출 현황 로드
    function loadDashboardRevenue() {
        $.ajax({
            url: '${pageContext.request.contextPath}/admin/revenueData.sp',
            type: 'GET',
            dataType: 'json',
            success: function(response) {
                const weeklyLabels = response.weekly.map(item => item.label);
                const weeklyData = response.weekly.map(item => item.value);
                renderRevenueChart(weeklyLabels, weeklyData);
            }
        });
    }

    function renderRevenueChart(labels, data) {
        const ctx = document.getElementById('revenueChart').getContext('2d');
        if(revenueChart !== null) revenueChart.destroy();
        revenueChart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: labels,
                datasets: [{
                    label: '일별 매출액',
                    data: data,
                    backgroundColor: 'rgba(93, 64, 55, 0.8)',
                    borderColor: '#5D4037',
                    borderWidth: 1,
                    borderRadius: 5,
                    barThickness: 30
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: { beginAtZero: true, ticks: { callback: function(value) { return '₩' + formatter.format(value); } } }
                },
                plugins: { legend: { display: false } }
            }
        });
    }

    function handleReturn(odrcode) {
        if(confirm("해당 건의 처리를 승인하시겠습니까?")) {
            // 처리 로직...
            alert("승인되었습니다.");
        }
    }
</script>