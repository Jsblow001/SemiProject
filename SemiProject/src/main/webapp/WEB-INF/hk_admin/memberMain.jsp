<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String ctxPath = request.getContextPath(); %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>관리자 | 회원관리 대시보드</title>

<style>
    body {
        font-family: 'Pretendard', Arial, sans-serif;
        background-color: #f7f6f3;
        color: #333;
    }

    .wrap {
        width: 1100px;
        margin: 60px auto;
    }

    h2 {
        font-family: 'Pretendard', Arial, sans-serif;
	    font-size: 23px !important;    
	    font-weight: 700;
	    letter-spacing: -0.3px;
	    color: #2f2b2a;
	    margin-bottom: 40px;
    }

    /* ===== 대시보드 전체 ===== */
    .dashboard {
        display: flex;
        gap: 30px;
        margin-bottom: 50px;
    }

    /* ===== 메인 카드 ===== */
    .card-area.main-cards {
        flex: 4;
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 20px;
    }

    .card {
        background-color: #fff;
        border-radius: 4px;
        padding: 25px 20px;
        text-align: center;
        box-shadow: 0 4px 12px rgba(0,0,0,0.06);
        transition: transform 0.15s ease;
    }

    .card:hover {
        transform: translateY(-4px);
    }

    .card h3 {
        font-size: 14px;
        color: #777;
        margin-bottom: 15px;
        font-weight: 500;
    }

    .card p {
        font-size: 30px;
        font-weight: 700;
        color: #3e3a39;
    }

    /* ===== 사이드 카드 ===== */
    .side-card {
        flex: 1;
        background-color: #fff;
        border-radius: 4px;
        padding: 30px 25px;
        text-align: center;
        box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        border-left: 5px solid #a1887f;
    }

    .side-card h3 {
        font-size: 15px;
        margin-bottom: 20px;
        color: #6d4c41;
        font-weight: 600;
    }

    .side-card p {
        font-size: 36px;
        font-weight: 800;
        color: #4e342e;
    }

    /* ===== 검색 영역 ===== */
    .search-area {
        background-color: #fff;
        padding: 30px;
        border-radius: 4px;
        margin-bottom: 40px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.05);
    }

    .search-area h3 {
        margin-bottom: 20px;
        font-size: 16px;
        font-weight: 600;
    }

    .search-area form {
        display: flex;
        gap: 10px;
    }

    .search-area select,
    .search-area input {
        padding: 10px 12px;
        border: 1px solid #ccc;
        border-radius: 3px;
        font-size: 14px;
    }

    .search-area input {
        flex: 1;
    }

    .search-area button {
        padding: 10px 18px;
        border: none;
        background-color: #6d4c41;
        color: #fff;
        font-weight: 600;
        cursor: pointer;
        border-radius: 3px;
    }

    .search-area button:hover {
        background-color: #5d4037;
    }

    /* ===== 하단 버튼 ===== */
    .btn-area a {
        display: inline-block;
        padding: 12px 24px;
        background-color: #3e3a39;
        color: #fff;
        text-decoration: none;
        font-size: 14px;
        font-weight: 600;
        border-radius: 3px;
    }

    .btn-area a:hover {
        background-color: #2f2b2a;
    }
</style>

</head>

<body>

<!--  고정 헤더 -->
<jsp:include page="../header.jsp" />

<div class="wrap">

    <h2 class="font-weight-bold mb-4 text-dark">회원관리 대시보드</h2>

    <%-- ===============================
         회원 요약 카드 영역
       =============================== --%>
    <div class="dashboard">

	    <%-- 왼쪽 : 주요 회원 요약 --%>
	    <div class="card-area main-cards">
	        <div class="card">
	            <h3>전체 회원</h3>
	            <p>${totalCount}</p>
	        </div>
	
	        <div class="card">
	            <h3>정상 회원</h3>
	            <p>${activeCount}</p>
	        </div>
	
	        <div class="card">
	            <h3>탈퇴 회원</h3>
	            <p>${deleteCount}</p>
	        </div>
	
	        <div class="card">
	            <h3>휴면 회원</h3>
	            <p>${idleCount}</p>
	        </div>	
	    </div>

	    <%-- 오른쪽 : 오늘 회원가입 수 --%>
	    <div class="side-card">
	        <h3>오늘 가입 회원</h3>
	        <p>${todayRegisterCount}</p>
	    </div>
	
	</div>

	<%-- ===============================
         회원 조회 영역 (조회는 메인에서)
       =============================== --%>
    <div class="search-area">
        <h3>회원 조회</h3>

        <form action="<%= ctxPath %>/admin/memberList.sp" method="get">
            <select name="searchType">
                <option value="userid">아이디</option>
                <option value="name">이름</option>
            </select>

            <input type="text" name="searchWord" placeholder="검색어 입력">

            <button type="submit">조회</button>
        </form>
    </div>
	

    <%-- ===============================
         하위 기능 이동 버튼
       =============================== --%>
    <div class="btn-area">
        <a href="<%=request.getContextPath()%>/admin/memberList.sp">
            회원 목록 보기
        </a>

        <%-- 확장 예정
        <a href="#">탈퇴 회원 관리</a>
        <a href="#">휴면 회원 관리</a>
        --%>
    </div>

</div>

<%-- 고정 푸터 --%>
<jsp:include page="../footer.jsp" />

</body>
</html>

