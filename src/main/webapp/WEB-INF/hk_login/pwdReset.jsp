<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String ctxPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>SISEON | 비밀번호 재설정</title>

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<!-- Google Font -->
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">

<!-- Bootstrap -->
<link rel="stylesheet" href="<%=ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css">

<style>
body{font-family:'Poppins',sans-serif;background:#fbfaf8}

/* 카드 */
.reset-wrap{
    max-width:420px;
    margin:120px auto;
    padding:40px;
    background:#fff;
    border:1px solid #ddd;
    box-shadow:0 8px 20px rgba(0,0,0,.06)
}

/* 타이틀 */
.reset-title{text-align:center;font-size:24px;margin-bottom:30px;font-weight:500}

/* input */
.form-control{height:48px;border-radius:0}

/* 버튼 */
.btn-reset{
    height:48px;
    background:#4a322b;
    color:#fff;
    border-radius:0
}
.btn-reset:hover{background:#3e2723}
</style>

<script>
function validateReset() {
    const pwd = document.querySelector("#passwd").value.trim();
    const pwd2 = document.querySelector("#passwdConfirm").value.trim();

    if (pwd === "") {
        alert("새 비밀번호를 입력하세요.");
        return false;
    }

    if (pwd2 === "") {
        alert("비밀번호 확인을 입력하세요.");
        return false;
    }

    if (pwd !== pwd2) {
        alert("비밀번호가 일치하지 않습니다.");
        return false;
    }

    if (pwd.length < 8) {
        alert("비밀번호는 최소 8자리 이상이어야 합니다.");
        return false;
    }

    return true;
}
</script>
</head>

<body>

<jsp:include page="../header.jsp" />

<div class="reset-wrap">

    <div class="reset-title">비밀번호 재설정</div>

    <form method="post"
          action="<%=ctxPath%>/pwdResetEnd.sp"
          onsubmit="return validateReset();">

        <input type="password" id="passwd" name="passwd"
               class="form-control mb-3"
               placeholder="새 비밀번호">

        <input type="password" id="passwdConfirm"
               class="form-control mb-4"
               placeholder="새 비밀번호 확인">

        <button type="submit" class="btn btn-reset btn-block">
            비밀번호 변경
        </button>
    </form>

</div>

<jsp:include page="../footer.jsp" />

</body>
</html>
