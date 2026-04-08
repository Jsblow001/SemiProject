<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/header2.jsp" />

<style>
    .admin-container { min-height: 800px; padding: 50px 0; background-color: #fcfcfc; }
    
    /* 수익 분석 대시보드 커스텀 탭 스타일 */
    .nav-tabs { border-bottom: 2px solid #ebebeb; }
    .nav-tabs .nav-link { border: none !important; color: #888 !important; font-weight: 600; padding: 12px 25px; cursor: pointer; background: none !important; transition: all 0.2s; }
    .nav-tabs .nav-link.active { color: #007bff !important; border-bottom: 3px solid #007bff !important; }
    
    /* 상단 요약 카드 스타일 (수익 분석 페이지 계승) */
    .revenue-card { border: none; border-radius: 12px; background: #fff; box-shadow: 0 4px 12px rgba(0,0,0,0.05); margin-bottom: 20px; transition: transform 0.2s; }
    .revenue-card:hover { transform: translateY(-5px); }
    .revenue-label { font-size: 0.85rem; color: #777; margin-bottom: 8px; }
    .revenue-value { font-size: 1.6rem; font-weight: 700; color: #333; }
    
    /* 리스트 영역 스타일 */
    .content-area { background: #fff; border-radius: 12px; padding: 25px; border: 1px solid #eee; min-height: 400px; }
    .badge-upgrade { padding: 6px 12px; border-radius: 20px; font-weight: 600; font-size: 0.8rem; }
    
    /* 승급 버튼 애니메이션 */
    .btn-upgrade-action { border-radius: 20px; font-weight: 600; transition: all 0.2s; }
    .btn-upgrade-action:hover { transform: scale(1.05); box-shadow: 0 4px 8px rgba(40, 167, 69, 0.2); }
</style>

<div class="container-fluid admin-container px-xl-5">
    <div class="row px-xl-5">
        <div class="col-lg-10 mx-auto">
            
            <h4 class="font-weight-bold mb-4 text-dark">
                회원 승급 관리 <span id="displayTarget" class="text-muted" style="font-size: 1rem; font-weight: normal;">일반 → 실버</span>
            </h4>

            <ul class="nav nav-tabs mb-4">
                <li class="nav-item"><a class="nav-link active" data-grade="1" href="javascript:void(0);">일반 등급 관리</a></li>
                <li class="nav-item"><a class="nav-link" data-grade="2" href="javascript:void(0);">실버 등급 관리</a></li>
            </ul>

            <div class="row mb-4">
                <div class="col-md-4">
                    <div class="card revenue-card p-4 border-left border-primary">
                        <div class="revenue-label text-success font-weight-bold">해당 등급 총 인원</div>
                        <div id="totalMemberCount" class="revenue-value">0명</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card revenue-card p-4">
                        <div class="revenue-label text-primary font-weight-bold">승급 대기 인원</div>
                        <div id="waitCount" class="revenue-value text-primary">0명</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="card revenue-card p-4">
                        <div class="revenue-label text-info font-weight-bold">승급 기준 금액</div>
                        <div id="minAmount" class="revenue-value">₩0</div>
                    </div>
                </div>
            </div>

            <div class="content-area shadow-sm">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="font-weight-bold m-0" style="font-size: 1.1rem;">승급 대상자 명단</h5>
                    <small class="text-muted">* 실시간 결제 데이터가 반영된 목록입니다.</small>
                </div>
                <table class="table table-hover text-center align-middle">
                    <thead class="table-light">
                        <tr>
                            <th style="width: 15%;">아이디</th>
                            <th style="width: 15%;">성명</th>
                            <th style="width: 25%;">누적 구매액</th>
                            <th style="width: 20%;">목표 등급</th>
                            <th style="width: 25%;">작업</th>
                        </tr>
                    </thead>
                    <tbody id="candidateBody">
                        </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script>
    const formatter = new Intl.NumberFormat('ko-KR');

    $(document).ready(function() {
        // 초기 로딩: 일반 등급(1)
        loadPromotionData('1');

        // 탭 전환 이벤트
        $('.nav-link').on('click', function() {
            $('.nav-link').removeClass('active');
            $(this).addClass('active');

            const grade = $(this).data('grade');
            const label = (grade == '1') ? '일반 → 실버' : '실버 → 골드';
            $('#displayTarget').text(label);

            loadPromotionData(grade);
        });
    });

    /**
     * 서버로부터 승급 관련 통계 및 대상자 리스트를 가져오는 함수
     */
    function loadPromotionData(grade) {
        $.ajax({
            url: '${pageContext.request.contextPath}/admin/memberGradeListData.sp', 
            type: 'GET',
            data: { "grade": grade },
            dataType: 'json',
            success: function(json) {
                /* 서버 응답 데이터(json) 구조 예시:
                   {
                     "totalCount": 150,        // 해당 등급 전체 인원
                     "candidates": [...],      // 승급 대상자 리스트
                     "threshold": 500000       // 기준 금액
                   }
                */

                // 1. 상단 카드 업데이트
                $('#totalMemberCount').text(formatter.format(json.totalCount) + "명");
                $('#waitCount').text(formatter.format(json.candidates.length) + "명");
                $('#minAmount').text('₩' + formatter.format(json.threshold));

                // 2. 테이블 바디 생성
                let html = "";
                const candidates = json.candidates;

                if (candidates.length === 0) {
                    html = "<tr><td colspan='5' class='py-5 text-muted'>조건을 충족하는 승급 대상자가 없습니다.</td></tr>";
                } else {
                    candidates.forEach(item => {
                        const nextGradeName = (grade == '1' ? 'SILVER' : 'GOLD');
                        const badgeClass = (grade == '1' ? 'border-primary text-primary' : 'border-warning text-warning');
                        
                        html += `<tr>
                                    <td class="font-weight-bold">\${item.member_id}</td>
                                    <td>\${item.name}</td>
                                    <td class="text-dark font-weight-bold">₩\${formatter.format(item.total_amount)}</td>
                                    <td><span class="badge badge-upgrade bg-light border \${badgeClass}">\${nextGradeName}</span></td>
                                    <td>
                                        <button class="btn btn-primary btn-sm btn-upgrade-action px-3" 
                                                onclick="executeUpgrade('\${item.member_id}', '\${parseInt(grade)+1}')">
                                            승급 확정
                                        </button>
                                    </td>
                                 </tr>`;
                    });
                }
                $('#candidateBody').hide().html(html).fadeIn(300); // 부드러운 전환 효과
            },
            error: function(e) {
                console.error("데이터 로드 실패", e);
            }
        });
    }

    /**
     * 승급 처리 실행
     */
    function executeUpgrade(mId, nextGrade) {
        if(confirm(mId + " 회원을 승급 처리하시겠습니까?")) {
            $.ajax({
                url: '${pageContext.request.contextPath}/admin/upgradeMemberGradeList.sp',
                type: 'POST',
                data: { "memberId": mId, "newGrade": nextGrade },
                success: function(res) {
                    alert("승급 처리가 완료되었습니다.");
                    // 현재 선택된 탭 정보 유지하며 리스트 새로고침
                    const currentGrade = $('.nav-link.active').data('grade');
                    loadPromotionData(currentGrade);
                },
                error: function() {
                    alert("처리 중 오류가 발생했습니다.");
                }
            });
        }
    }
</script>

<jsp:include page="/WEB-INF/footer2.jsp" />