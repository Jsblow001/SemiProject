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

    /* [추가] TOP 5 상품 테이블 스타일 */
    #top5ProductList tr td { vertical-align: middle; padding: 15px 10px; text-align: center; }
    .rank-badge { 
        display: inline-block; width: 24px; height: 24px; line-height: 24px; 
        border-radius: 50%; background: #eee; color: #555; font-size: 0.75rem; font-weight: bold; 
    }
    .rank-1 { background: #ffd700; color: #fff; } /* 금 */
    .rank-2 { background: #c0c0c0; color: #fff; } /* 은 */
    .rank-3 { background: #cd7f32; color: #fff; } /* 동 */
    .prod-name { font-weight: 600; color: #333; font-size: 0.95rem; }
    .prod-category { font-size: 0.75rem; color: #999; }
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

            <div class="best-products-section mt-5">
                <h5 class="font-weight-bold mb-4 text-dark">
                    <i class="fas fa-trophy text-warning mr-2"></i>인기 상품 TOP 5
                </h5>
                <div class="card border-0 shadow-sm" style="border-radius: 12px; overflow: hidden;">
                    <table class="table table-hover mb-0">
                        <thead class="bg-light">
                            <tr class="text-center" style="font-size: 0.85rem; color: #666;">
                                <th style="width: 80px;">순위</th>
                                <th colspan="2" class="text-left pl-4">상품 정보</th>
                                <th>판매 수량</th>
                                <th>총 판매액</th>
                            </tr>
                        </thead>
                        <tbody id="top5ProductList">
                            <tr>
                                <td colspan="5" class="text-center py-5 text-muted">데이터를 로드하고 있습니다...</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    let currentChart = null;
    // top5 데이터를 주간/월간으로 나누어 담도록 구조 변경
    let dbChartData = { 
        weekly: {}, 
        monthly: {}, 
        stats: {},
        top5: { weekly: [], monthly: [] }
    }; 
    const formatter = new Intl.NumberFormat('ko-KR');

    $(document).ready(function() {
        loadRevenueData();

        $('.nav-link').on('click', function(e) {
            e.preventDefault();
            $('.nav-link').removeClass('active');
            $(this).addClass('active');

            const mode = $(this).attr('href').replace('#', '');
            $('#displayDate').text($(this).text());
            
            // 탭 변경 시 차트, 통계, 상품목록 동시 업데이트
            renderChart(mode); 
            updateStats(mode);
            renderTop5(dbChartData.top5[mode]); 
        });
    });

    function loadRevenueData() {
        $.ajax({
            url: '${pageContext.request.contextPath}/admin/revenueData.sp', 
            type: 'GET',
            dataType: 'json',
            success: function(response) {
                console.log("서버 데이터 응답:", response);

                // 1. 인기 상품 데이터 저장 (Controller에서 전송된 키값 확인 필요)
                dbChartData.top5.weekly = response.top5Weekly || [];
                dbChartData.top5.monthly = response.top5Monthly || [];

                // 2. 상단 베스트셀러 텍스트
                $('#bestSellerName').text(response.bestSeller || "데이터 없음");

                // 3. 차트 데이터 구성
                dbChartData.weekly = {
                    type: 'line',
                    labels: response.weekly.map(item => item.label),
                    data: response.weekly.map(item => item.value),
                    borderColor: '#007bff', backgroundColor: 'rgba(0, 123, 255, 0.1)', fill: true, labelName: '일일 수익'
                };

                dbChartData.monthly = {
                    type: 'bar',
                    labels: response.monthly.map(item => item.label),
                    data: response.monthly.map(item => item.value),
                    borderColor: '#6f42c1', backgroundColor: '#6f42c1', fill: false, labelName: '주간 수익'
                };

                // 4. 통계 수치 저장
                dbChartData.stats.weekly = {
                    total: response.totalWeekly, subValue: response.avgWeekly, subLabel: '주간 평균 결제액', unit: '₩'
                };
                dbChartData.stats.monthly = {
                    total: response.totalMonthly, subValue: response.monthlyCount, subLabel: '월간 결제 주차', unit: ' 주차'
                };

                // 초기 실행 (주간)
                renderChart('weekly');
                updateStats('weekly');
                renderTop5(dbChartData.top5.weekly);
            },
            error: function(request, status, error) {
                console.error("데이터 로드 실패: " + error);
            }
        });
    }

    /**
     * [추가] 인기 상품 테이블 렌더링 함수
     */
     function renderTop5(dataList) {
    	    let html = "";
    	    if (dataList && dataList.length > 0) {
    	        dataList.forEach((item, index) => {
    	            const rankNum = index + 1;
    	            const rankClass = (rankNum <= 3) ? 'rank-' + rankNum : '';
    	            
    	            const pname = item.pname ? item.pname : '상품명 없음';
    	            const categoryName = item.categoryName ? item.categoryName : '카테고리';
    	            const totalCount = item.totalCount ? item.totalCount : 0;
    	            const totalPrice = item.totalPrice ? Number(item.totalPrice) : 0;

    	            // 백틱(`) 대신 따옴표(')와 + 를 사용합니다.
    	            html += '<tr>' +
    	                        '<td><span class="rank-badge ' + rankClass + '">' + rankNum + '</span></td>' +
    	                        '<td colspan="2" class="text-left pl-5">' +
    	                            '<div class="prod-name" style="font-weight:bold; color:#333;">' + pname + '</div>' +
    	                            '<div class="prod-category" style="font-size:0.85rem; color:#888;">' + categoryName + '</div>' +
    	                        '</td>' +
    	                        '<td class="font-weight-bold">' + totalCount + '개</td>' +
    	                        '<td class="text-primary font-weight-bold">' +
    	                            '₩' + formatter.format(totalPrice) +
    	                        '</td>' +
    	                    '</tr>';
    	        });
    	    } else {
    	        html = "<tr><td colspan='5' class='text-center py-5 text-muted'>해당 기간 판매 데이터가 없습니다.</td></tr>";
    	    }
    	    $('#top5ProductList').html(html);
    	}

    function renderChart(mode) {
        const ctx = document.getElementById('mainRevenueChart').getContext('2d');
        const config = dbChartData[mode];
        if (!config || !config.labels) return;

        if (currentChart !== null) currentChart.destroy();

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
                    y: { beginAtZero: true, ticks: { callback: function(value) { return '₩' + value.toLocaleString(); } } } 
                },
                plugins: {
                    tooltip: { callbacks: { label: function(context) { return '수익: ₩' + context.raw.toLocaleString(); } } }
                }
            }
        });
    }

    function updateStats(mode) {
        const stats = dbChartData.stats[mode];
        if (!stats) return;
        $('#totalRevenue').text('₩' + formatter.format(stats.total));
        $('#subLabel').text(stats.subLabel);
        if (stats.unit === '₩') {
            $('#subValue').text('₩' + formatter.format(stats.subValue));
        } else {
            $('#subValue').text(stats.subValue + stats.unit);
        }
    }
</script>

<jsp:include page="/WEB-INF/footer2.jsp" />