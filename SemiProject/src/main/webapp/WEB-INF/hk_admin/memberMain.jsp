<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String ctxPath = request.getContextPath(); %>

<%-- 관리자 헤더 : 아직 미구현이라 주석 처리 --%>
<%-- <jsp:include page="" /> --%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>관리자 | 회원관리 대시보드</title>

<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #fff;
    }
    .wrap {
        width: 1000px;
        margin: 40px auto;
    }
    h2 {
        margin-bottom: 30px;
    }
    .card-area {
        display: flex;
        gap: 20px;
        margin-bottom: 40px;
    }
    .card {
        flex: 1;
        border: 1px solid #ddd;
        padding: 20px;
        text-align: center;
    }
    .card h3 {
        margin-bottom: 10px;
    }
    .card p {
        font-size: 26px;
        font-weight: bold;
    }
    .btn-area a {
        display: inline-block;
        margin-right: 15px;
        padding: 12px 20px;
        border: 1px solid #333;
        text-decoration: none;
        color: #333;
    }
</style>
</head>

<body>

<div class="wrap">

    <h2>회원관리 대시보드</h2>

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

</body>
</html>

<%-- 관리자 푸터 --%>
<%-- <jsp:include page="../adminFooter.jsp" /> --%>
