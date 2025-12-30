<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    String ctxPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>CARIN | PASSWORD FIND</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- Google Font -->
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">

<!-- Bootstrap -->
<link rel="stylesheet" href="<%=ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css">

<style>
body {
    font-family: 'Poppins', sans-serif !important;
    background-color: #FBFAF8 !important;
}

/* 박스 */
.login-wrap {
    max-width: 420px !important;
    margin: 120px auto !important;
    padding: 40px !important;
    background: #fff !important;
    border: 1px solid #eee !important;
}

/* 타이틀 */
.login-title {
    text-align: center !important;
    font-size: 24px !important;
    font-weight: 500 !important;
    margin-bottom: 30px !important;
    letter-spacing: 1.5px !important;
}

/* input */
.form-control {
    height: 48px !important;
    border-radius: 0 !important;
}

/* 메인 버튼 */
.btn-login {
    height: 48px !important;
    border-radius: 0 !important;
    font-weight: 500 !important;

    background-color: #5D4037 !important;
    color: #ffffff !important;
    border: none !important;
}

.btn-login:hover {
    background-color: #4a322b !important;
    color: #ffffff !important;
}

/* 인증코드 버튼은 살짝 구분 */
.btn-cert {
    background-color: #ffffff !important;
    border: 1px solid #bdbdbd !important;
    color: #5D4037 !important;
}

.btn-cert:hover {
    background-color: #5D4037 !important;
    color: #ffffff !important;
    border-color: #5D4037 !important;
}

/* 링크 영역 */
.link-area {
    text-align: center !important;
    font-size: 0.9rem !important;
    margin-top: 20px !important;
}

.link-area a {
    color: #555 !important;
    margin: 0 8px !important;
    text-decoration: none !important;
}

.link-area a:hover {
    color: #5D4037 !important;
}
</style>

<script>
function validateForm() {
    const userid = document.querySelector('[name="userid"]').value.trim();
    const email  = document.querySelector('[name="email"]').value.trim();

    if(userid === "") { alert("아이디를 입력하세요."); return false; }
    if(email === "") { alert("이메일을 입력하세요."); return false; }

    const reg = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
    if(!reg.test(email)) {
        alert("이메일 형식이 올바르지 않습니다.");
        return false;
    }
    return true;
}
</script>
</head>

<body>

<jsp:include page="../header.jsp" />

<div class="login-wrap">
    <div class="login-title">PASSWORD FIND</div>

    <!-- 1단계 -->
    <form method="post" action="<%=ctxPath%>/pwdFind.sp" onsubmit="return validateForm();">
        <input type="text" name="userid" class="form-control mb-3" placeholder="아이디" value="${userid}">
        <input type="text" name="email"  class="form-control mb-3" placeholder="이메일" value="${email}">
        <button class="btn btn-login btn-block">인증코드 발송</button>
    </form>

    <!-- 실패 -->
    <c:if test="${isExist == false}">
        <p class="text-danger text-center mt-3">
            일치하는 회원 정보가 없습니다.
        </p>
    </c:if>

    <!-- 인증코드 입력 -->
    <c:if test="${isExist == true}">
        <hr>
        <p class="text-center">이메일로 인증코드를 발송했습니다.</p>

        <form method="post" action="<%=ctxPath%>/verifyCertification.sp">
            <input type="hidden" name="userid" value="${userid}">
            <input type="text" name="userCertificationCode"
                   class="form-control mb-3" placeholder="인증코드 입력">
            <button class="btn btn-cert btn-block">인증하기</button>
        </form>
    </c:if>

    <div class="link-area">
        <a href="<%=ctxPath%>/login.sp">로그인</a> |
        <a href="<%=ctxPath%>/idFind.sp">아이디 찾기</a>
    </div>
</div>

<jsp:include page="../footer.jsp" />
</body>
</html>
