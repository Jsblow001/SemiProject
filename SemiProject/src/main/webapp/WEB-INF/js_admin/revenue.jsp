<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- 1. 제공된 헤더 포함 --%>
<jsp:include page="/WEB-INF/header.jsp" />

<style>
    .admin-container { min-height: 800px; padding: 50px 0; background-color: #fcfcfc; }
    
    /* 사이드바 스타일 (기존 유지) */
    .sidebar-menu { background-color: #fff; border: 1px solid #ddd; }
    .sidebar-menu .list-group-item { border: none; color: #333; font-size: 0.95rem; padding: 15px 20px; text-decoration: none; display: block; }
    .menu-parent { font-weight: 600; border-bottom: 1px solid #eee !important; }
    .menu-parent:hover { background-color: var(--light-bg) !important; color: var(--dark-wood) !important; }
    .sub-menu-list { background-color: #fcfcfc; border-bottom: 1px solid #eee; }
    .sub-menu-list a { display: block; padding: 10px 20px 10px 50px; color: #777; font-size: 0.9rem; text-decoration: none; }

    /* 유튜브 스타일 수익 대시보드 커스텀 */
    .revenue-card { border: none; border-radius: 8px; background: #fff; box-shadow: 0 2px 10px rgba(0,0,0,0.05); transition: 0.3s; }
    .revenue-card:hover { box-shadow: 0 5px 20px rgba(0,0,0,0.1); }
    .revenue-label { font-size: 0.9rem; color: #606060; font-weight: 500; }
    .revenue-value { font-size: 1.8rem; font-weight: 700; color: #0d0d0d; margin: 10px 0; }
    .revenue-change { font-size: 0.85rem; font-weight: 600; }
    .text-success-up { color: #00875a; } /* 수익 상승 초록색 */
    
    /* 차트 영역 */
    .chart-container { background: #fff; border-radius: 8px; padding: 25px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
    
    /* 테이블 스타일 */
    .table-custom thead th { border-top: none; background: #f9f9f9; color: #606060; font-size: 0.85rem; text-transform: uppercase; letter-spacing: 1px; }
    .section-title { margin-bottom: 40px !important; }
</style>

<div class="container-fluid admin-container px-xl-5">
    <div class="row px-xl-5">

        <div class="col-lg-9">
            <h4 class="font-weight-bold section-title text-dark">수익 분석 <span class="text-muted" style="font-size: 1rem; font-weight: normal;">(지난 28일)</span></h4>
            
            <div class="row mb-5">
                <div class="col-md-4 mb-3">
                    <div class="card revenue-card p-4 border-bottom border-info" style="border-bottom-width: 4px !important;">
                        <div class="revenue-label">추정 수익</div>
                        <div class="revenue-value">₩<fmt:formatNumber value="12540000" pattern="#,###" /></div>
                        <div class="revenue-change text-success-up">▲ 12% <span class="text-muted font-weight-normal">평소보다 높음</span></div>
                    </div>
                </div>
                <div class="col-md-4 mb-3">
                    <div class="card revenue-card p-4 border-bottom border-primary" style="border-bottom-width: 4px !important;">
                        <div class="revenue-label">결제 건수</div>
                        <div class="revenue-value">842 <span style="font-size: 1.2rem; font-weight: 500;">건</span></div>
                        <div class="revenue-change text-success-up">▲ 5% <span class="text-muted font-weight-normal">상승세 유지</span></div>
                    </div>
                </div>
                <div class="col-md-4 mb-3">
                    <div class="card revenue-card p-4 border-bottom border-success" style="border-bottom-width: 4px !important;">
                        <div class="revenue-label">주문당 평균 수익</div>
                        <div class="revenue-value">₩<fmt:formatNumber value="14800" pattern="#,###" /></div>
                        <div class="revenue-change text-muted font-weight-normal">지난달 대비 변동 없음</div>
                    </div>
                </div>
            </div>

            <div class="chart-container mb-5 text-center">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h6 class="font-weight-bold m-0">날짜별 수익 현황</h6>
                    <select class="form-control form-control-sm" style="width: 120px;">
                        <option>지난 7일</option>
                        <option selected>지난 28일</option>
                        <option>전체 기간</option>
                    </select>
                </div>
                <div style="height: 300px; background: #fbfbfb; display: flex; align-items: center; justify-content: center; border: 1px dashed #ddd;">
                    <p class="text-muted">사용자님, 여기에 Chart.js 라이브러리를 연결하면 <br><strong>유튜브와 같은 부드러운 선 그래프</strong>가 나타납니다.</p>
                </div>
            </div>

            <h6 class="font-weight-bold mb-3">최근 거래 내역</h6>
            <div class="card border-0 shadow-sm">
                <table class="table table-custom text-center mb-0">
                    <thead>
                        <tr>
                            <th>주문번호</th>
                            <th>상품명</th>
                            <th>날짜</th>
                            <th>결제 금액</th>
                            <th>상태</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>ORD-20231024-01</td>
                            <td class="text-left font-weight-bold">BREEZE C1 (안경)</td>
                            <td>2023.10.24</td>
                            <td>₩198,000</td>
                            <td><span class="badge badge-success">결제완료</span></td>
                        </tr>
                        <tr>
                            <td>ORD-20231024-02</td>
                            <td class="text-left font-weight-bold">OAKLEY SUNGLASSES</td>
                            <td>2023.10.23</td>
                            <td>₩245,000</td>
                            <td><span class="badge badge-success">결제완료</span></td>
                        </tr>
                    </tbody>
                </table>
                <div class="card-footer bg-white border-0 text-center py-3">
                    <a href="#" class="small font-weight-bold text-wood">모든 수익 내역 보기 ></a>
                </div>
            </div>

        </div>
    </div>
</div>

<%-- 2. 제공된 푸터 포함 --%>
<jsp:include page="/WEB-INF/footer.jsp" />