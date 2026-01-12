<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String ctxPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>CARIN | ADMIN LOGIN</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- Google Font -->
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">

<!-- Bootstrap -->
<link rel="stylesheet" href="<%=ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css">

<style>
body{font-family:'Poppins',sans-serif!important;background:#f3f3f3!important}

/* 카드 */
.login-wrap{max-width:420px!important;margin:120px auto!important;padding:45px 40px!important;background:#fff!important;border-top:6px solid #5d4037!important}

/* 타이틀 */
.login-title{text-align:center!important;font-size:24px!important;font-weight:600!important;letter-spacing:3px!important;color:#3e2723!important}
.login-subtitle{text-align:center!important;font-size:.8rem!important;color:#999!important;margin:6px 0 35px!important;letter-spacing:2px!important}

/* 입력창 */
.form-control{height:48px!important;border-radius:0!important;border:1px solid #ddd!important;font-size:.95rem!important}
.form-control:focus{border-color:#5d4037!important;box-shadow:none!important}

/* 관리자 버튼 */
.btn-login{background:#3e2723!important;color:#fff!important;border-radius:0!important;height:48px!important;font-weight:500!important;letter-spacing:1px!important}
.btn-login:hover{background:#2e1d18!important;color:#fff!important}

/* 하단 버튼 */
.btn-outline-secondary{height:48px!important;border-radius:0!important;font-size:.9rem!important;font-weight:500!important;background:#fff!important;border:1px solid #bdbdbd!important;color:#5d4037!important}
.btn-outline-secondary:hover{background:#5d4037!important;border-color:#5d4037!important;color:#fff!important}
</style>

</head>

<body>

<!--  고정 헤더 -->
<jsp:include page="../header.jsp" />

<div class="login-wrap">
    <div class="login-title">CARIN ADMIN</div>
    <div class="login-subtitle">SYSTEM MANAGEMENT</div>

    <!-- 관리자 로그인 -->
    <form method="post" action="<%= ctxPath %>/login.sp">
    
    <!-- 추가 (관리자 로그인 실패시 관리자 로그인 페이지로 이동 위함) -->
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
        회원 로그인으로 돌아가기
    </button>
</div>

<!--  고정 푸터 -->
<jsp:include page="../footer.jsp" />

</body>
</html>
