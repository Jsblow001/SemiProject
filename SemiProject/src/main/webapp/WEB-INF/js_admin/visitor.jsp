<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../header2.jsp" />

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<div class="col-lg-10">
    <div class="admin-main-content shadow-sm p-4">
        <h3 class="mb-4 font-weight-bold">방문자 관리 시스템</h3>

        <ul class="nav nav-tabs mb-4" id="visitorTab" role="tablist">
            <li class="nav-item">
                <a class="nav-link active font-weight-bold" id="total-tab" data-toggle="tab" href="#total" role="tab">전체 통계</a>
            </li>
            <li class="nav-item">
                <a class="nav-link font-weight-bold" id="member-tab" data-toggle="tab" href="#member" role="tab">회원 통계</a>
            </li>
            <li class="nav-item">
                <a class="nav-link font-weight-bold" id="guest-tab" data-toggle="tab" href="#guest" role="tab">비회원 통계</a>
            </li>
        </ul>

        <div class="tab-content" id="visitorTabContent">
            
            <%-- 전체 통계 --%>
            <div class="tab-pane fade show active" id="total" role="tabpanel">
                <div class="row mb-4">
                    <div class="col-md-4">
                        <div class="card p-4 border-0 shadow-sm text-center bg-light h-100">
                            <p class="text-muted mb-2 font-weight-bold">오늘 전체 방문</p>
                            <h2 class="font-weight-bold text-dark mb-2">${not empty todayTotal ? todayTotal : 0}명</h2>
                            <c:set var="tDiff" value="${todayTotal - yesterdayTotal}" />
                            <c:choose>
                                <c:when test="${not empty yesterdayTotal && yesterdayTotal > 0}">
                                    <c:set var="tPercent" value="${(tDiff / yesterdayTotal) * 100}" />
                                    <span class="${tDiff >= 0 ? 'text-danger' : 'text-primary'} font-weight-bold">
                                        ${tDiff >= 0 ? '▲' : '▼'} <fmt:formatNumber value="${tPercent < 0 ? -tPercent : tPercent}" pattern="0.1"/>%
                                        <small class="text-muted ml-1">(전일 대비)</small>
                                    </span>
                                </c:when>
                                <c:otherwise><span class="text-muted small">데이터 비교 불가</span></c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card p-4 border-0 shadow-sm text-center bg-light h-100">
                            <p class="text-muted mb-2 font-weight-bold">어제 전체 방문</p>
                            <h2 class="font-weight-bold text-success mb-0">${not empty yesterdayTotal ? yesterdayTotal : 0}명</h2>
                            <p class="text-muted small mt-2">24시간 누적 데이터</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card p-4 border-0 shadow-sm text-center h-100" style="background-color: #f0fdf4; border: 1px solid #dcfce7;">
                            <p class="text-success mb-2 font-weight-bold">
                                <span class="spinner-grow spinner-grow-sm mr-1" role="status"></span>
                                실시간 접속자
                            </p>
                            <h2 class="font-weight-bold text-success mb-0">${not empty currentLoginUser ? currentLoginUser : 0}명</h2>
                            <p class="text-muted small mt-2">현재 활동 중인 세션</p>
                        </div>
                    </div>
                </div>
                <div class="card border-0 shadow-sm p-4 mb-4">
                    <h5 class="font-weight-bold mb-3">전체 방문 추이 (최근 7일)</h5>
                    <div style="height: 300px;"><canvas id="totalChart"></canvas></div>
                </div>
            </div>

            <%-- 회원 통계 --%>
            <div class="tab-pane fade" id="member" role="tabpanel">
                <div class="row mb-4">
                    <div class="col-md-4">
                        <div class="card p-3 border-0 shadow-sm text-center h-100" style="background-color: #e3f2fd;">
                            <p class="text-muted mb-1 font-weight-bold">오늘 회원 방문</p>
                            <h3 class="font-weight-bold text-primary">${not empty todayMember ? todayMember : 0}명</h3>
                            <small class="text-muted">실시간 회원 유입</small>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card p-3 border-0 shadow-sm text-center h-100" style="background-color: #e3f2fd;">
                            <p class="text-muted mb-1 font-weight-bold">어제 회원 방문</p>
                            <h3 class="font-weight-bold text-success">${not empty yesterdayMember ? yesterdayMember : 0}명</h3>
                            <small class="text-muted">24시간 누적</small>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card p-3 border-0 shadow-sm text-center h-100" style="background-color: #e3f2fd;">
                            <p class="text-muted mb-1 font-weight-bold">신규 가입(오늘)</p>
                            <h3 class="font-weight-bold text-warning">${not empty todayNewMember ? todayNewMember : 0}명</h3>
                            <small class="text-muted">일일 가입자 수</small>
                        </div>
                    </div>
                </div>
                <div class="card border-0 shadow-sm p-4 mb-4">
                    <h5 class="font-weight-bold mb-3 text-primary">회원 활동 추이 (최근 7일)</h5>
                    <div style="height: 300px;"><canvas id="memberChart"></canvas></div>
                </div>
            </div>

            <%-- 비회원 통계 --%>
            <div class="tab-pane fade" id="guest" role="tabpanel">
                <div class="row mb-4">
                    <div class="col-md-4">
                        <div class="card p-3 border-0 shadow-sm text-center h-100" style="background-color: #fce4ec;">
                            <p class="text-muted mb-1 font-weight-bold">오늘 비회원</p>
                            <h3 class="font-weight-bold text-danger">${not empty todayGuest ? todayGuest : 0}명</h3>
                            <small class="text-muted">실시간 유입량</small>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card p-3 border-0 shadow-sm text-center h-100" style="background-color: #fce4ec;">
                            <p class="text-muted mb-1 font-weight-bold">어제 비회원</p>
                            <h3 class="font-weight-bold text-success">${not empty yesterdayGuest ? yesterdayGuest : 0}명</h3>
                            <small class="text-muted">24시간 누적</small>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="card p-3 border-0 shadow-sm text-center h-100" style="background-color: #fce4ec;">
                            <p class="text-muted mb-1 font-weight-bold">평균 이탈률</p>
                            <h3 class="font-weight-bold text-dark">${bounceRate}%</h3>
                            <div class="progress mt-2" style="height: 6px; background-color: rgba(0,0,0,0.05);">
                                <div class="progress-bar bg-danger" role="progressbar" style="width: 74.2%" aria-valuenow="74.2" aria-valuemin="0" aria-valuemax="100"></div>
                            </div>
                            <small class="text-muted d-block mt-1">단일 페이지 방문 비율</small>
                        </div>
                    </div>
                </div>
                <div class="card border-0 shadow-sm p-4 mb-4">
                    <h5 class="font-weight-bold mb-3 text-danger">비회원 유입 추이 (최근 7일)</h5>
                    <div style="height: 300px;"><canvas id="guestChart"></canvas></div>
                </div>
            </div>

        </div>
    </div>
</div>

<script>
// 그래프 생성 공통 함수
function createAreaChart(canvasId, label, labels, data, color) {
    const canvas = document.getElementById(canvasId);
    if(!canvas) return;
    
    const ctx = canvas.getContext('2d');
    const colorMap = {
        '#5D4037': 'rgba(93, 64, 55, 0.1)',
        '#007bff': 'rgba(0, 123, 255, 0.1)',
        '#dc3545': 'rgba(220, 53, 69, 0.1)'
    };

    return new Chart(ctx, {
        type: 'line',
        data: {
            labels: labels,
            datasets: [{
                label: label,
                data: data,
                borderColor: color,
                backgroundColor: colorMap[color] || 'rgba(0,0,0,0.05)',
                borderWidth: 3,
                fill: true,
                tension: 0.4,
                pointRadius: 4,
                pointBackgroundColor: color
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: { legend: { display: false } },
            scales: {
                y: { beginAtZero: true, grid: { color: '#f1f1f1' } },
                x: { grid: { display: false } }
            }
        }
    });
}

document.addEventListener('DOMContentLoaded', function() {
    // 1. JSTL 루프를 사용하여 자바스크립트 배열 생성 (가장 안전한 방법)
    const labels = [
        <c:forEach var="label" items="${chartLabels}" varStatus="status">
            ${label}${!status.last ? ',' : ''}
        </c:forEach>
    ];
    
    const totalData = [
        <c:forEach var="val" items="${weeklyTotal}" varStatus="status">
            ${val}${!status.last ? ',' : ''}
        </c:forEach>
    ];
    
    const memberData = [
        <c:forEach var="val" items="${weeklyMember}" varStatus="status">
            ${val}${!status.last ? ',' : ''}
        </c:forEach>
    ];
    
    const guestData = [
        <c:forEach var="val" items="${weeklyGuest}" varStatus="status">
            ${val}${!status.last ? ',' : ''}
        </c:forEach>
    ];

    // 데이터가 비었을 경우를 위한 백업 데이터
    const finalLabels = labels.length > 0 ? labels : ['01/01','01/02','01/03','01/04','01/05','01/06','오늘'];
    const finalTotal = totalData.length > 0 ? totalData : [0,0,0,0,0,0,0];
    const finalMember = memberData.length > 0 ? memberData : [0,0,0,0,0,0,0];
    const finalGuest = guestData.length > 0 ? guestData : [0,0,0,0,0,0,0];

    // 2. 차트 생성
    createAreaChart('totalChart', '전체', finalLabels, finalTotal, '#5D4037');
    createAreaChart('memberChart', '회원', finalLabels, finalMember, '#007bff');
    createAreaChart('guestChart', '비회원', finalLabels, finalGuest, '#dc3545');

 	// 3. 실시간 접속자 수 주기적 업데이트
    setInterval(function() {
        fetch('${pageContext.request.contextPath}/visitorCheck.sp')
            .then(response => response.text())
            .then(count => {
                const liveCountEl = document.querySelector('.card[style*="background-color: #f0fdf4"] h2');
                if(liveCountEl) {
                    liveCountEl.innerText = count + "명";
                }
            })
            .catch(err => console.error("AJAX 에러:", err));
    }, 30000);
});

// 탭 전환 대응
$('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
    Chart.instances.forEach(chart => chart.resize());
});
</script>

<style>
    .nav-tabs { border-bottom: 2px solid #eee; }
    .nav-tabs .nav-link { color: #888; border: none; padding: 15px 30px; transition: 0.3s; }
    .nav-tabs .nav-link.active { color: #5D4037; border-bottom: 3px solid #5D4037; background: none; }
    .card { border-radius: 15px; }
    .spinner-grow { width: 0.8rem; height: 0.8rem; }
    .progress { border-radius: 10px; }
</style>

<jsp:include page="../footer2.jsp" />