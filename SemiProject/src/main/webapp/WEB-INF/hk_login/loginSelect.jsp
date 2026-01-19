<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String ctxPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>Login | SISEON</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- Google Font -->
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">

<!-- Font Awesome -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">

<!-- Bootstrap -->
<link href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" rel="stylesheet">

<style>
:root{
  --bg:#fbfaf8;
  --card:#ffffff;
  --text:#2f2b2a;
  --muted:#7a6f6b;
  --border:#e7e1dd;
  --brand:#5d4037;
  --brand-dark:#4a322b;
}

/* 전체 배경 */
body{
  background:var(--bg)!important;
  font-family:'Poppins', sans-serif!important;
  color:var(--text);
}

/* 가운데 정렬 */
.login-page{
  min-height:calc(100vh - 140px);
  display:flex;
  align-items:center;
  justify-content:center;
  padding:60px 16px;
}

/* 카드 */
.login-card{
  width:100%;
  max-width:440px;
  background:var(--card);
  border:1px solid var(--border);
  border-radius:18px;
  padding:42px 38px;
  box-shadow:0 14px 40px rgba(0,0,0,.06);
}

/* 상단 타이틀 */
.brand{
  text-align:center;
  margin-bottom:26px;
}
.brand .logo{
  font-size:26px;
  letter-spacing:6px;
  font-weight:600;
  color:var(--brand);
}
.brand .desc{
  margin-top:10px;
  font-size:13px;
  color:var(--muted);
}

/* 버튼 공통 */
.btn-block{
  height:52px;
  border-radius:12px!important;
  font-weight:600;
  font-size:15px;
  
   display:flex!important;
  align-items:center!important;
  justify-content:center!important;
}

/* 일반 로그인 버튼 */
.btn-member{
  background:var(--brand)!important;
  border:1px solid var(--brand)!important;
  color:#fff!important;
}
.btn-member:hover{
  background:var(--brand-dark)!important;
  border-color:var(--brand-dark)!important;
}

/* 관리자 로그인 버튼 */
.btn-admin{
  background:#fff!important;
  border:1px solid var(--border)!important;
  color:var(--brand)!important;
}
.btn-admin:hover{
  background:#f6f1ee!important;
}

/* 구분선 */
.or{
  display:flex;
  align-items:center;
  gap:12px;
  margin:22px 0;
  color:#9a8f8b;
  font-size:12px;
}
.or:before,.or:after{
  content:"";
  flex:1;
  height:1px;
  background:#e7e1dd;
}

/* 소셜 버튼 */
.btn-social{
  display:flex!important;
  align-items:center;
  justify-content:center;
  gap:10px;
  border-radius:12px!important;
  font-weight:700;
}

/* 네이버 */
.btn-naver{
  background:#03C75A!important;
  border:1px solid #03C75A!important;
  color:#fff!important;
}
.btn-naver:hover{
  background:#02b152!important;
  border-color:#02b152!important;
}

/* 카카오 */
.btn-kakao{
  background:#FEE500!important;
  border:1px solid #FEE500!important;
  color:#191919!important;
}
.btn-kakao:hover{
  background:#f5dc00!important;
  border-color:#f5dc00!important;
}

/* 회원가입 버튼 */
.btn-register{
  background:#f1ebe5!important;
  border:1px solid #d2c4ba!important;
  color:var(--brand)!important;
}
.btn-register:hover{
  background:#e6dbd2!important;
  border-color:var(--brand)!important;
  color:var(--brand-dark)!important;
}

/* footer 여백 제거 */
footer,.footer,#footer{margin-top:0!important;padding-top:0!important}
</style>
</head>

<body>

<!-- 고정 헤더 -->
<jsp:include page="../header.jsp" />

<div class="login-page">
  <div class="login-card">

    <div class="brand">
      <div class="logo">SISEON</div>
      <div class="desc">로그인 후 더 많은 서비스를 이용할 수 있어요</div>
    </div>

    <a href="<%= ctxPath %>/login.sp" class="btn btn-member btn-block">
      개인회원 로그인
    </a>

    <a href="<%= ctxPath %>/login.sp?mode=admin" class="btn btn-admin btn-block mt-2">
      관리자 로그인
    </a>

    <div class="or">또는</div>

    <button type="button" class="btn btn-social btn-naver btn-block"
            onclick="location.href='<%=ctxPath%>/naverLoginStart.sp'">
      <i class="fas fa-leaf"></i> 네이버로 로그인
    </button>

    <button type="button" class="btn btn-social btn-kakao btn-block mt-2"
            onclick="location.href='<%=ctxPath%>/kakaoLoginStart.sp'">
      <i class="fas fa-comment"></i> 카카오로 로그인
    </button>

    <div class="or">계정이 없으신가요?</div>

    <button type="button" class="btn btn-register btn-block"
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
