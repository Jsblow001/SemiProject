<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>휴면 계정 안내</title>

<link rel="stylesheet" href="${pageContext.request.contextPath}/bootstrap-4.6.2-dist/css/bootstrap.min.css">

<style>
body{font-family:'Poppins',sans-serif!important;background:#fbfaf8!important}

.page-wrap{
    padding-top: 120px;
    padding-bottom: 160px;
}

.login-wrap{
    max-width:420px;
    margin: 30px auto;
    padding:40px;
    background:#fff;
    border:1px solid #ddd;
    box-shadow:0 8px 20px rgba(0,0,0,.06);
}

/* 타이틀 */
.login-title{text-align:center!important;font-size:26px!important;font-weight:500!important;margin-bottom:30px!important;letter-spacing:2px!important}

/* 입력 */
.form-control{height:48px!important;border-radius:0!important}

/* 로그인 */
.btn-login{height:48px!important;background:#4a322b!important;color:#fff!important;border-radius:0!important;font-weight:500!important}
.btn-login:hover{background:#3e2723!important}

/* 옵션 */
.save-id{font-size:.9rem!important}

/* 링크 */
.login-links{text-align:center!important;font-size:.9rem!important;margin-top:20px!important}
.login-links a{color:#555!important;margin:0 8px!important;text-decoration:none!important}
.login-links a:hover{color:#5d4037!important}

/* 버튼 */
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
<body style="background:#f5f5f5;">

<!--  고정 헤더 -->
<jsp:include page="../header.jsp" />

<div class="page-wrap">
    <div class="container" style="max-width:520px;">
        <div class="card shadow-sm">
            <div class="card-body p-4">

                <h4 class="mb-3">휴면 계정입니다</h4>

                <p class="text-muted">
                    1년 이상 로그인 이력이 없어 휴면 처리된 계정입니다.<br>
                    휴면 해제를 진행하면 다시 로그인할 수 있습니다.
                </p>

                <hr>

                <form method="post" action="${pageContext.request.contextPath}/admin/idleRelease.sp">
                    <input type="hidden" name="userid" value="${requestScope.userid}" />

                    <button type="submit" class="btn btn-dark btn-block">
                        휴면 해제하기
                    </button>
                </form>

                <div class="mt-3">
                    <a href="${pageContext.request.contextPath}/login.sp" class="btn btn-outline-secondary btn-block">
                        로그인 화면으로 돌아가기
                    </a>
                </div>

            </div>
        </div>
    </div>
</div>

<!--  고정 푸터 -->
<jsp:include page="../footer.jsp" />


</body>
</html>
