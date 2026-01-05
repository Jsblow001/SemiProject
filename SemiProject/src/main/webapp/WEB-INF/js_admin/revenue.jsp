<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/header2.jsp" />

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>
    .admin-container { min-height: 800px; padding: 50px 0; background-color: #fcfcfc; }
    .nav-tabs { border-bottom: 2px solid #ebebeb; }
    .nav-tabs .nav-link { border: none; color: #888; font-weight: 600; padding: 12px 25px; cursor: pointer; }
    .nav-tabs .nav-link.active { color: #007bff !important; background: none; border-bottom: 3px solid #007bff !important; }
    
    /* 상단 요약 카드 스타일 */
    .revenue-card { border: none; border-radius: 12px; background: #fff; box-shadow: 0 4px 12px rgba(0,0,0,0.05); margin-bottom: 20px; transition: transform 0.2s; }
    .revenue-card:hover { transform: translateY(-5px); }
    .revenue-label { font-size: 0.85rem; color: #777; margin-bottom: 8px; }
    .revenue-value { font-size: 1.6rem; font-weight: 700; color: #333; }
    
    /* 섹션 타이틀 스타일 */
    .section-title { margin-bottom: 30px !important; border: none !important; text-decoration: none !important; display: inline-block !important; }
    .section-title::after, .section-title::before { display: none !important; }
    
    /* 차트 영역 스타일 */
    .chart-area { position: relative; height: 380px !important; width: 100% !important; background: #fff; border-radius: 12px; padding: 20px; border: 1px solid #eee; overflow: hidden; }
</style>

<div class="container-fluid admin-container px-xl-5">
    <div class="row px-xl-5">
        <div class="col-lg-10 mx-auto">
            <h4 class="font-weight-bold section-title text-dark">
                수익 분석 <span id="displayDate" class="text-muted" style="font-size: 1rem; font-weight: normal;">주간 분석</span>
            </h4>

            <ul class="nav nav-tabs mb-4">
                <li class="nav-item"><a class="nav-link active" href="#weekly">주간 분석</a></li>
                <li class="nav-item"><a class="nav-link" href="#monthly">월간 분석</a></li>
            </ul>

            <div class="row mb-4">
                <div class="col-md-4">
                    <div class="card revenue-card p-4">
                        <div class="revenue-label text-info font-weight-bold">총 수익</div>
                        <div id="totalRevenue" class="revenue-value">₩0</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card revenue-card p-4">
                        <div id="subLabel" class="revenue-label">주간 평균 결제액</div>
                        <div id="subValue" class="revenue-value">₩0</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card revenue-card p-4">
                        <div class="revenue-label text-success font-weight-bold">인기 상품 (Best)</div>
                        <div id="bestSellerName" class="revenue-value" style="font-size: 1.2rem; color: #28a745;">
                            데이터 로딩 중...
                        </div>
                    </div>
                </div>
            </div>

            <div class="chart-area mb-5">
                <canvas id="mainRevenueChart"></canvas>
            </div>
        </div>
    </div>
</div>

<script>
    let currentChart = null;
    let dbChartData = { weekly: {}, monthly: {}, stats: {} }; // 서버 데이터를 담을 전역 객체
    const formatter = new Intl.NumberFormat('ko-KR'); // 화폐 단위 포맷터

    $(document).ready(function() {
        // 1. 초기 데이터 로드 (AJAX 호출)
        loadRevenueData();

        // 2. 탭 클릭 이벤트 설정
        $('.nav-link').on('click', function(e) {
            e.preventDefault();
            $('.nav-link').removeClass('active');
            $(this).addClass('active');

            const mode = $(this).attr('href').replace('#', '');
            $('#displayDate').text($(this).text());
            
            // 탭 변경 시 차트와 통계 수치 동시 업데이트
            renderChart(mode); 
            updateStats(mode);
        });
    });

    /**
     * 서버(RevenueDataController)로부터 JSON 데이터를 가져오는 함수
     */
    function loadRevenueData() {
        $.ajax({
            url: '${pageContext.request.contextPath}/admin/revenueData.sp', 
            type: 'GET',
            dataType: 'json',
            success: function(response) {
                console.log("서버 데이터 응답:", response);

                // 인기 상품 이름 실시간 반영
                $('#bestSellerName').text(response.bestSeller);

                // 차트 데이터 구성 (주간)
                dbChartData.weekly = {
                    type: 'line',
                    labels: response.weekly.map(item => item.label),
                    data: response.weekly.map(item => item.value),
                    borderColor: '#007bff',
                    backgroundColor: 'rgba(0, 123, 255, 0.1)',
                    fill: true,
                    labelName: '일일 수익'
                };

                // 차트 데이터 구성 (월간)
                dbChartData.monthly = {
                    type: 'bar',
                    labels: response.monthly.map(item => item.label),
                    data: response.monthly.map(item => item.value),
                    borderColor: '#6f42c1',
                    backgroundColor: '#6f42c1',
                    fill: false,
                    labelName: '주간 수익'
                };

                // 상단 카드용 통계 수치 저장
                dbChartData.stats.weekly = {
                    total: response.totalWeekly,
                    subValue: response.avgWeekly,
                    subLabel: '주간 평균 결제액',
                    unit: '₩'
                };
                dbChartData.stats.monthly = {
                    total: response.totalMonthly,
                    subValue: response.monthlyCount,
                    subLabel: '월간 결제 주차',
                    unit: ' 주차'
                };

                // 최초 실행 시 주간 데이터 표시
                renderChart('weekly');
                updateStats('weekly');
            },
            error: function(request, status, error) {
                console.error("데이터 로드 실패: " + error);
            }
        });
    }

    /**
     * Chart.js를 사용하여 그래프를 그리는 함수
     */
    function renderChart(mode) {
        const ctx = document.getElementById('mainRevenueChart').getContext('2d');
        const config = dbChartData[mode];

        if (!config || !config.labels) return;

        // 기존 차트가 존재하면 파괴하고 새로 생성 (잔상 방지)
        if (currentChart !== null) {
            currentChart.destroy();
        }

        currentChart = new Chart(ctx, {
            type: config.type,
            data: {
                labels: config.labels,
                datasets: [{
                    label: config.labelName,
                    data: config.data,
                    borderColor: config.borderColor,
                    backgroundColor: config.backgroundColor,
                    fill: config.fill,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: { 
                    y: { 
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) { return '₩' + value.toLocaleString(); }
                        }
                    } 
                },
                plugins: {
                    tooltip: {
                        callbacks: {
                            label: function(context) { return '수익: ₩' + context.raw.toLocaleString(); }
                        }
                    }
                }
            }
        });
    }

    /**
     * 상단 카드의 수치 정보를 업데이트하는 함수
     */
    function updateStats(mode) {
        const stats = dbChartData.stats[mode];
        if (!stats) return;

        // 총 수익 텍스트 업데이트
        $('#totalRevenue').text('₩' + formatter.format(stats.total));
        
        // 두 번째 카드 라벨 및 수치 업데이트
        $('#subLabel').text(stats.subLabel);
        if (stats.unit === '₩') {
            $('#subValue').text('₩' + formatter.format(stats.subValue));
        } else {
            $('#subValue').text(stats.subValue + stats.unit);
        }
    }
</script>

<jsp:include page="/WEB-INF/footer2.jsp" />