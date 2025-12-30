<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String ctxPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>CARIN | LOGIN</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- Google Font -->
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">

<!-- Bootstrap -->
<link rel="stylesheet" href="<%=ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css">

<!-- jQuery -->
<script src="<%=ctxPath%>/js/jquery-3.7.1.min.js"></script>

<style>
body {
    font-family: 'Poppins', sans-serif !important;
    background-color: #FBFAF8 !important;
}

/* 로그인 박스 */
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
    font-size: 26px !important;
    font-weight: 500 !important;
    margin-bottom: 30px !important;
    letter-spacing: 2px !important;
}

/* input */
.form-control {
    height: 48px !important;
    border-radius: 0 !important;
}

/* 로그인 버튼 */
.btn-login {
    background-color: #5D4037 !important;
    color: #fff !important;
    border-radius: 0 !important;
    height: 48px !important;
    font-weight: 500 !important;
}

.btn-login:hover {
    background-color: #4a322b !important;
    color: #fff !important;
}

/* 아이디 저장 */
.save-id {
    font-size: 0.9rem !important;
}

/* 링크 영역 */
.login-links {
    text-align: center !important;
    font-size: 0.9rem !important;
    margin-top: 20px !important;
}

.login-links a {
    color: #555 !important;
    margin: 0 8px !important;
    text-decoration: none !important;
}

.login-links a:hover {
    color: #5D4037 !important;
}

/* ===============================
   회원가입 버튼 (강제 통일)
   =============================== */
.btn-outline-secondary {
    height: 48px !important;
    border-radius: 0 !important;
    font-weight: 500 !important;

    background-color: #ffffff !important;
    border: 1px solid #bdbdbd !important;
    color: #5D4037 !important;
}

.btn-outline-secondary:hover {
    background-color: #5D4037 !important;
    border-color: #5D4037 !important;
    color: #ffffff !important;
}
</style>



</head>

<body>

<!--  고정 헤더 -->
<jsp:include page="../header.jsp" />

<div class="login-wrap">
    <div class="login-title">CARIN</div>

    <form name="loginFrm" method="post" action="<%=ctxPath%>/login.sp">
        <div class="form-group">
            <input type="text" class="form-control" name="userid" id="userid" placeholder="아이디">
        </div>

        <div class="form-group">
            <input type="password" class="form-control" name="passwd" id="pwd" placeholder="비밀번호">
        </div>

        <div class="form-group d-flex align-items-center">
            <input type="checkbox" id="saveid" class="mr-2">
            <label for="saveid" class="mb-0 save-id">아이디 저장</label>
        </div>

        <button type="button" id="btnLogin" class="btn btn-login btn-block">
            LOGIN
        </button>
    </form>

    <div class="login-links">
        <a href="<%= ctxPath %>/idFind.sp">아이디 찾기</a> 
        <a href="<%= ctxPath %>/pwdFind.sp">비밀번호 찾기</a>
    </div>
    
    <hr>

	<!-- 회원가입 버튼 -->
	<button type="button" class="btn btn-outline-secondary btn-block mt-3" onclick="location.href='<%=ctxPath%>/register.sp'">
	    회원가입
	</button>
</div>

<!--  고정 푸터 -->
<jsp:include page="../footer.jsp" />


<!-- JS 분리 -->
<script src="<%=ctxPath%>/js/login.js"></script>

</body>
</html>