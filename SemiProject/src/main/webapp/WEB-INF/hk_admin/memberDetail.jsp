<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String ctxPath = request.getContextPath(); %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>관리자 | 회원 상세</title>

<style>
    body {
        font-family: 'Pretendard', Arial, sans-serif;
        background-color: #f7f6f3;
        color: #333;
    }

    .container {
        width: 900px;
        margin: 60px auto;
        background-color: #fff;
        padding: 40px;
        border-radius: 4px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.06);
    }

    h3 {
        font-size: 18px;
        font-weight: 700;
        margin-bottom: 30px;
        color: #2f2b2a;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        font-size: 14px;
    }

    th {
        width: 160px;
        background: #f2f1ee;
        text-align: left;
        padding: 14px;
        border-bottom: 1px solid #ddd;
        color: #555;
    }

    td {
        padding: 14px;
        border-bottom: 1px solid #eee;
    }

    .btn-box {
        margin-top: 40px;
        text-align: center;
    }

    .btn {
        display: inline-block;
        padding: 10px 18px;
        font-size: 14px;
        border-radius: 4px;
        text-decoration: none;
        margin: 0 5px;
    }

    .btn-list {
        background: #3e3a39;
        color: #fff;
    }

    .btn-list:hover {
        background: #2f2b2a;
    }
</style>

</head>

<body>

<!-- 고정 헤더 -->
<jsp:include page="../header2.jsp" />

<div class="container">

    <h3>회원 상세 정보</h3>

    <table>
        <tr>
            <th>아이디</th>
            <td>${member.userid}</td>
        </tr>
        <tr>
            <th>이름</th>
            <td>${member.name}</td>
        </tr>
        <tr>
            <th>성별</th>
            <td>
                <c:choose>
                    <c:when test="${member.gender == '1'}">남</c:when>
                    <c:when test="${member.gender == '2'}">여</c:when>
                    <c:otherwise>미입력</c:otherwise>
                </c:choose>
            </td>
        </tr>
        <tr>
            <th>이메일</th>
            <td>${member.email}</td>
        </tr>
        <tr>
            <th>가입일</th>
            <td>${member.registerday}</td>
        </tr>
        <tr>
            <th>상태</th>
            <td>
                <c:choose>
                    <c:when test="${member.status == 1}">정상</c:when>
                    <c:otherwise>탈퇴</c:otherwise>
                </c:choose>
            </td>
        </tr>
    </table>

    <div class="btn-box">
        <a href="<%=ctxPath%>/admin/memberList.sp" class="btn btn-list">
            목록으로
        </a>
    </div>

</div>

<!-- 고정 푸터 -->
<jsp:include page="../footer2.jsp" />

</body>
</html>
