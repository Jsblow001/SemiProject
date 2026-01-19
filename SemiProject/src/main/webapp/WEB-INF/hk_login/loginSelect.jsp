<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String ctxPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>Login Select | SISEON</title>

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- Google Font -->
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">

<!-- Font Awesome -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">

<!-- Bootstrap -->
<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" rel="stylesheet">

<style>
/* ===============================
   핵심: body 배경 통일
   =============================== */
body{background:#fbfaf8!important}

/* ===============================
   콘텐츠 영역
   =============================== */
.login-select-bg{padding-top:80px!important;padding-bottom:40px!important}

/* 로그인 카드 */
.login-select-wrapper{max-width:420px!important;margin:0 auto!important;background:#fff!important;padding:40px 35px!important;border-radius:14px!important;box-shadow:0 8px 28px rgba(0,0,0,.07)!important;text-align:center!important}
.login-title{font-size:1.8rem!important;font-weight:600!important;color:#5d4037!important;margin-bottom:10px!important}
.login-desc{font-size:.9rem!important;color:#777!important;margin-bottom:30px!important}

/* 버튼 */
.btn-login{width:100%!important;padding:12px!important;font-size:.95rem!important;border-radius:6px!important;margin-bottom:12px!important;font-weight:500!important}
.btn-member{background:#5d4037!important;color:#fff!important}
.btn-member:hover{background:#4a322b!important;color:#fff!important}
.btn-admin{background:#fff!important;border:1px solid #5d4037!important;color:#5d4037!important}
.btn-admin:hover{background:#5d4037!important;color:#fff!important}

/* 구분선 */
.divider{margin:25px 0!important;font-size:.85rem!important;color:#999!important;position:relative!important}
.divider::before,.divider::after{content:""!important;position:absolute!important;top:50%!important;width:40%!important;height:1px!important;background:#ddd!important}
.divider::before{left:0!important}
.divider::after{right:0!important}

/* footer 흰 여백 제거 */
footer,.footer,#footer{margin-top:0!important;padding-top:0!important}

/* ===============================
   회원가입 버튼
   =============================== */
.btn-outline-secondary{
    height:46px!important;
    border-radius:0!important;
    font-size:.95rem!important;
    font-weight:500!important;
    letter-spacing:-.2px!important;
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

<!-- 콘텐츠 -->
<div class="login-select-bg">
    <div class="login-select-wrapper">
        <div class="login-title">LOGIN</div>
        <div class="login-desc">SISEON에 오신 것을 환영합니다</div>

        <a href="<%= ctxPath %>/login.sp" class="btn btn-login btn-member">
            개인회원 로그인
        </a>

        <a href="<%= ctxPath %>/login.sp?mode=admin"
           class="btn btn-login btn-admin">
            관리자 로그인
        </a>
        
        <hr>

		<button type="button" class="btn btn-success btn-block mt-2"
		        onclick="location.href='<%=ctxPath%>/naverLoginStart.sp'">
		    네이버로 로그인
		</button>
		
		<button type="button" class="btn btn-warning btn-block mt-2"
		        onclick="location.href='<%=ctxPath%>/kakaoLoginStart.sp'">
		    카카오로 로그인
		</button>
        

        <div class="divider">또는</div>
        
        <!--  회원가입 버튼  -->
        <button type="button"
                class="btn btn-outline-secondary btn-block btn-register"
                onclick="location.href='<%= ctxPath %>/register.sp'">
            회원가입
        </button>
    </div>
</div>

<!-- 고정 푸터 -->
<jsp:include page="../footer.jsp" />

<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
</body>
</html>
