<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String ctxPath = request.getContextPath(); %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>관리자 | 회원관리 대시보드</title>

<style>
/* ===== 공통 ===== */
body{font-family:'Pretendard',Arial,sans-serif;background:#f7f6f3;color:#333;}
.wrap{width:1100px;margin:60px auto;}
h2{font-size:23px!important;font-weight:700;letter-spacing:-0.3px;color:#2f2b2a;margin-bottom:40px;}

/* ===== 대시보드 상단 ===== */
.dashboard{display:flex;gap:20px;margin-bottom:50px;}
.dashboard-sub h2{font-size:15px;font-weight:600;color:#2f2b2a;margin-bottom:15px;}
.card-area.main-cards{flex:3;display:grid;grid-template-columns:repeat(3,1fr);gap:20px;}
.card{background:#fff;border-radius:4px;padding:25px 20px;text-align:center;box-shadow:0 4px 12px rgba(0,0,0,0.06);transition:.15s;}
.card:hover{transform:translateY(-4px);}
.card h3{font-size:14px;color:#777;margin-bottom:15px;font-weight:500;}
.card p{font-size:30px;font-weight:700;color:#3e3a39;}
.side-card{flex:1.2;background:#fff;border-radius:4px;padding:30px 25px;text-align:center;box-shadow:0 4px 12px rgba(0,0,0,0.08);border-left:5px solid #a1887f;}
.side-card h3{font-size:15px;margin-bottom:20px;color:#6d4c41;font-weight:600;}
.side-card p{font-size:36px;font-weight:800;color:#4e342e;}

/* ===== 검색 ===== */
.search-area{background:#fff;padding:30px;border-radius:4px;margin-bottom:40px;box-shadow:0 4px 12px rgba(0,0,0,0.05);}
.search-area h3{margin-bottom:20px;font-size:16px;font-weight:600;}
.search-area form{display:flex;gap:10px;}
.search-area select,.search-area input{padding:10px 12px;border:1px solid #ccc;border-radius:3px;font-size:14px;}
.search-area input{flex:1;}
.search-area button{padding:10px 18px;border:none;background:#6d4c41;color:#fff;font-weight:600;cursor:pointer;border-radius:3px;}
.search-area button:hover{background:#5d4037;}

/* ===== 하단 버튼 ===== */
.btn-area a{display:inline-block;padding:12px 24px;background:#3e3a39;color:#fff;text-decoration:none;font-size:14px;font-weight:600;border-radius:3px;}
.btn-area a:hover{background:#2f2b2a;}

/* ===============================
   확장 지표 영역
   =============================== */
.dashboard-sub{margin-top:50px;}   
.dashboard-sub h4{font-size:15px;font-weight:600;color:#2f2b2a;margin-bottom:15px;}
.sub-cards{display:flex;gap:20px;margin-bottom:30px;}
.card.small{padding:20px;margin-bottom:40px;}
.sub-lists{display:flex;gap:30px;margin-bottom:30px;}
.list-box{flex:1;background:#fff;padding:20px;border-radius:4px;box-shadow:0 4px 12px rgba(0,0,0,0.05);}
.recent-members{background:#fff;padding:20px;border-radius:4px;box-shadow:0 4px 12px rgba(0,0,0,0.05);}

/* ===== 최근 가입 회원 TOP ===== */
.recent-members {
    background:#fff;
    padding:25px;
    border-radius:4px;
    box-shadow:0 4px 12px rgba(0,0,0,0.05);
}

.recent-members h4 {
    font-size:15px;
    font-weight:700;
    margin-bottom:18px;
}

.recent-members p {
    display:flex;
    justify-content:space-between;
    align-items:center;
    padding:12px 14px;
    margin:0 0 8px;
    background:#faf7f2;
    border-radius:3px;
    font-size:14px;
    font-weight:500;
    color:#3e3a39;
    transition:0.15s;
}

.recent-members p:last-child {
    margin-bottom:0;
}

.recent-members p:hover {
    background:#f1ebe6;
    transform:translateX(3px);
}

/* 아이디 강조 */
.recent-members p::before {
    content:"👤";
    margin-right:8px;
}

/* 날짜 스타일 */
.recent-members p span {
    font-size:12px;
    color:#8d6e63;
}

/* ===== 등급별 회원수/ 성별 회원수 스타일 ===== */
/* 왼쪽 라벨 */
.stat-list{
    list-style:none;
    padding:0;
    margin:0;
}

/* 숫자 뱃지 */
.stat-list li{
    display:flex;
    justify-content:space-between;
    align-items:center;
    padding:10px 12px;
    border-bottom:1px solid #eee;
    font-size:14px;
}

/* ===== 성별 색상 ===== */
.stat-list li.male .label::before{
    content:'';
    display:inline-block;
    width:8px;
    height:8px;
    background:#4a90e2;
    border-radius:50%;
    margin-right:8px;
}

.stat-list li.female .label::before{
    content:'';
    display:inline-block;
    width:8px;
    height:8px;
    background:#e91e63;
    border-radius:50%;
    margin-right:8px;
}


</style>

</head>

<body>

<!-- 고정 헤더 -->
<jsp:include page="../header2.jsp" />

<div class="wrap">
<%-- <div><pre>${last7daysList}</pre></div>   확인용 추후 삭제--%>
<h2 class="font-weight-bold mb-4 text-dark">회원관리 대시보드</h2>

<%-- ===============================
     회원 요약 카드 영역
   =============================== --%>
<div class="dashboard">

    <%-- 왼쪽 : 동일 크기 카드 3개 --%>
    <div class="card-area main-cards">
        <div class="card">
            <h3>전체 회원</h3>
            <p>${empty totalCount ? 0 : totalCount}</p>
        </div>
        <div class="card">
            <h3>정상 회원</h3>
            <p>${empty activeCount ? 0 : activeCount}</p>
        </div>
        <div class="card">
            <h3>탈퇴 회원</h3>
            <p>${empty deleteCount ? 0 : deleteCount}</p>
        </div>
    </div>

    <%-- 오른쪽 : 오늘 가입 회원 --%>
    <div class="side-card">
        <h3>오늘 가입 회원</h3>
        <p>${empty todayRegisterCount ? 0 : todayRegisterCount}</p>
    </div>

</div>

<%-- ===============================
     회원 조회 영역
   =============================== --%>
<div class="search-area">
    <h3>회원 조회</h3>
    <form action="<%=ctxPath%>/admin/memberList.sp" method="get">
        <select name="searchType">
            <option value="userid">아이디</option>
            <option value="name">이름</option>
        </select>
        <input type="text" name="searchWord" placeholder="검색어 입력">
        <button type="submit">조회</button>
    </form>
</div>

<%-- ===============================
     하위 기능 이동
   =============================== --%>
<div class="btn-area">
    <a href="<%=ctxPath%>/admin/memberList.sp">회원 목록 보기</a>
</div>

<%-- ===============================
     확장 지표 영역 (추후 사용)
     - 최근 7일 가입자 수
     - 탈퇴율
     - 등급별 회원 수
     - 성별 회원 수
     - 최근 가입 회원 TOP N
   =============================== --%>
<div class="dashboard-sub">

    <div class="sub-cards">
        <div class="card small">
            <h3 class="font-weight-bold mb-4 text-dark">최근 7일 가입</h3>
            <p>${last7daysCount}</p>
        </div>
        <div class="card small">
            <h3 class="font-weight-bold mb-4 text-dark">탈퇴율</h3>
            <p>${withdrawRate}%</p>
        </div>
    </div>
    
    <div class="card small">
	    <h3>최근 7일 가입 추이</h3>
	    <canvas id="registerChart" height="120"></canvas>
	</div>

    <div class="sub-lists">

    <div class="list-box">
        <h4>등급별 회원 수</h4>
        <ul class="stat-list">
            <c:forEach var="g" items="${gradeCountList}">
                <li>
                    <span class="label">${g.key}</span>
                    <span class="count">${g.cnt}명</span>
                </li>
            </c:forEach>
        </ul>
    </div>

    <div class="list-box">
        <h4>성별 회원 수</h4>
        <ul class="stat-list">
            <c:forEach var="g" items="${genderCountList}">
                <li class="${g.key == '남자' ? 'male' : (g.key == '여자' ? 'female' : 'unknown')}">
                    <span class="label">${g.key}</span>
                    <span class="count">${g.cnt}명</span>
                </li>
            </c:forEach>
        </ul>
    </div>

</div>


    <div class="recent-members">
        <h4>최근 가입 회원 top 5</h4>       
        <c:forEach var="m" items="${recentMemberList}">
            <p>${m.userid} / ${m.registerday}</p>
        </c:forEach>      
    </div>

</div>

</div>

<jsp:include page="../footer2.jsp" />

<%-- 그래프 구현 위해 추가 --%>
<!-- 차트 생성 -->
<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<script>

const chartData = [
<c:forEach var="row" items="${last7daysList}" varStatus="s">
    { date: '${row.date}', count: ${row.count} }${!s.last ? ',' : ''}
</c:forEach>
];

const labels = chartData.map(d => d.date);
const values = chartData.map(d => d.count);

const ctx = document.getElementById('registerChart').getContext('2d');

new Chart(ctx, {
    type: 'line',
    data: {
        labels: labels,
        datasets: [{
            data: values,
            borderColor: '#6d4c41',
            backgroundColor: 'rgba(109,76,65,0.15)',
            fill: true,
            tension: 0.3
        }]
    },
    options: {
        responsive: true,
        plugins: { legend: { display: false } },
        scales: { y: { beginAtZero: true } }
    }
});
</script>


</body>
</html>


