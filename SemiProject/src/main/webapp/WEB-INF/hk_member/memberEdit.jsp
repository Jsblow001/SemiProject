<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<jsp:include page="../header.jsp" />

<style>
body {
    font-family: 'Pretendard', sans-serif;
    background-color: #fff;
    color: #333;
}

/* 마이페이지와 동일한 래퍼 */
.mypage-wrap {
    max-width: 520px;
    margin: 80px auto;
}

/* 카드 박스 */
.user-box {
    background: #faf7f2;
    padding: 30px 25px;
    border-radius: 4px;
}

/* 타이틀 */
.page-title {
    text-align: center;
    font-size: 26px;
    margin-bottom: 40px;
    font-weight: 600;
}

/* 폼 그룹 */
.form-group {
    margin-bottom: 26px;
}

.form-group label {
    display: block;
    font-size: 13px;
    font-weight: 600;
    margin-bottom: 8px;
}

.form-desc {
    font-size: 12px;
    color: #777;
    margin-bottom: 6px;
}

/* input 기본 */
.form-input {
    width: 100%;
    border: none;
    border-bottom: 1px solid #ccc;
    background: transparent;
    padding: 8px 2px;
    font-size: 14px;
}

.form-input:focus {
    outline: none;
    border-bottom: 1px solid #000;
}

/* 전화번호 */
.input-row {
    display: flex;
    gap: 8px;
}

/* 버튼 */
.btn-area {
    display: flex;
    gap: 10px;
    margin-top: 40px;
}

.btn-main {
    flex: 1;
    background: #3a2f2a;
    color: #fff;
    border: none;
    height: 44px;
    font-size: 14px;
    cursor: pointer;
}

.btn-sub {
    flex: 1;
    background: #fff;
    color: #333;
    border: 1px solid #ccc;
    height: 44px;
    font-size: 14px;
    cursor: pointer;
}
</style>

<div class="mypage-wrap">

    <div class="page-title">회원정보 수정</div>

    <div class="user-box">

        <form name="editFrm" method="post"
              action="<%= request.getContextPath() %>/memberEditEnd.sp">

            <input type="hidden" name="userid"
                   value="${sessionScope.loginuser.userid}">

            <!-- 아이디 -->
            <div class="form-group">
                <label>아이디</label>
                <input type="text" class="form-input"
                       value="${sessionScope.loginuser.userid}" readonly>
            </div>

            <!-- 이름 -->
            <div class="form-group">
                <label>이름 *</label>
                <input type="text" name="name" class="form-input"
                       value="${sessionScope.loginuser.name}">
            </div>

            <!-- 비밀번호 -->
            <div class="form-group">
                <label>비밀번호 *</label>
                <div class="form-desc">
                    영문/숫자/특수문자 중 2가지 이상 조합 (8~16자)
                </div>
                <input type="password" name="passwd" class="form-input">
            </div>

            <!-- 이메일 -->
            <div class="form-group">
                <label>이메일 *</label>
                <input type="text" name="email" class="form-input"
                       value="${sessionScope.loginuser.email}">
            </div>

            <!-- 휴대전화 -->
            <div class="form-group">
                <label>휴대전화 *</label>
                <div class="input-row">
                    <input type="text" name="hp1" value="010"
                           class="form-input" readonly>
                    <input type="text" name="hp2"
                           class="form-input"
                           value="${fn:substring(sessionScope.loginuser.mobile,3,7)}">
                    <input type="text" name="hp3"
                           class="form-input"
                           value="${fn:substring(sessionScope.loginuser.mobile,7,11)}">
                </div>
            </div>

            <!-- 버튼 -->
            <div class="btn-area">
                <button type="submit" class="btn-main">회원정보수정</button>
                <button type="button" class="btn-sub"
                        onclick="history.back()">취소</button>
            </div>

        </form>
    </div>
</div>

<jsp:include page="../footer.jsp" />
