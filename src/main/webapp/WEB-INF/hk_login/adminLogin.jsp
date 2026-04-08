<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String ctxPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>SISEON | ADMIN LOGIN</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- Google Font -->
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

<!-- Bootstrap -->
<link rel="stylesheet" href="<%=ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css">

<style>
body{font-family:'Poppins',sans-serif!important;background:#f3f3f3!important}

/* 관리자 카드 : 명도 + 레이어감 */
.login-wrap{
    max-width:420px!important;
    margin:120px auto!important;
    padding:45px 40px!important;
    background:linear-gradient(180deg,#ffffff 0%,#fbfaf8 100%)!important;
    border:1px solid #e0d6cf!important;
    border-top:5px solid #3e2723!important;
    box-shadow:
        0 10px 30px rgba(0,0,0,.08),
        0 2px 0 rgba(255,255,255,.8) inset!important
}

/* 타이틀 */
.login-title{text-align:center!important;font-size:24px!important;font-weight:700!important;letter-spacing:1.5px!important;color:#3e2723!important}
.login-subtitle{text-align:center!important;font-size:.8rem!important;color:#8d6e63!important;margin:6px 0 35px!important;letter-spacing:1.5px!important;text-transform:uppercase!important}

/* 입력창 */
.form-control{height:48px!important;border-radius:0!important;border:1px solid #ddd!important;font-size:.95rem!important}
.form-control:focus{border-color:#3e2723!important;box-shadow:none!important}

/* 관리자 로그인 버튼 */
.btn-login{
    background:#3e2723!important;
    color:#fff!important;
    border-radius:0!important;
    height:48px!important;
    font-weight:600!important;
    letter-spacing:1px!important
}
.btn-login:hover{background:#2e1d18!important;color:#fff!important}

/* 회원 로그인 이동 버튼 : 베이지 브라운 */
.btn-outline-secondary{
    height:46px!important;
    border-radius:0!important;
    font-size:.85rem!important;
    font-weight:500!important;
    background:#f1ebe5!important;
    border:1px solid #d2c4ba!important;
    color:#5d4037!important;
    transition:all .2s ease!important
}
.btn-outline-secondary:hover{
    background:#e6dbd2!important;
    border-color:#5d4037!important;
    color:#3e2723!important
}
</style>

</head>

<body>

<!-- 고정 헤더 -->
<jsp:include page="../header.jsp" />

<div class="login-wrap">
    <div class="login-title">SISEON ADMIN</div>
    <div class="login-subtitle">SYSTEM MANAGEMENT</div>

    <!-- 관리자 로그인 -->
    <form method="post" action="<%= ctxPath %>/login.sp">
        <input type="hidden" name="mode" value="admin"> 

        <div class="form-group">
            <input type="text"
                   class="form-control"
                   name="userid"
                   placeholder="관리자 아이디">
        </div>

        <div class="form-group">
            <input type="password"
                   class="form-control"
                   name="passwd"
                   placeholder="비밀번호">
        </div>

        <button type="submit" class="btn btn-login btn-block">
            ADMIN LOGIN
        </button>
    </form>

    <hr>

    <!-- 회원 로그인 이동 -->
    <button type="button"
            class="btn btn-outline-secondary btn-block"
            onclick="location.href='<%= ctxPath %>/login.sp'">
        일반 회원 로그인으로 이동
    </button>
</div>

<!-- 고정 푸터 -->
<jsp:include page="../footer.jsp" />

</body>
</html>
