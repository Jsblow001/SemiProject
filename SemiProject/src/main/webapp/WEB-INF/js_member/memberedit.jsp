<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    String ctxPath = request.getContextPath();
%>

<jsp:include page="../header.jsp" />

<link rel="stylesheet"
      href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.css" />
<link rel="stylesheet"
      href="<%=ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css">

<style>
    body { background-color:#fff; font-family:'Pretendard', sans-serif; color:#333; }
    .edit-container { max-width:550px; margin:120px auto; padding:20px; }
    .title { text-align:center; font-size:26px; font-weight:700; margin-bottom:50px; letter-spacing:5px; }
    .section-title { font-size:14px; font-weight:bold; margin:40px 0 20px; border-bottom:1px solid #000; padding-bottom:10px; }
    .form-label { font-size:13px; font-weight:600; margin-bottom:8px; display:block; }
    .guide-text { font-size:12px; color:#888; margin-bottom:10px; }
    .form-control { border-radius:0; border:1px solid #ddd; padding:12px; height:auto; }
    .form-control[readonly] { background-color:#f8f8f8; }
    .btn-black { background:#000; color:#fff; border-radius:0; padding:16px; width:100%; font-weight:bold; border:none; }
    .btn-black:hover { background:#333; }
    .btn-post { background:#f8f8f8; border:1px solid #ddd; border-radius:0; font-size:13px; padding:0 15px; }
</style>

<div class="container">
    <div class="edit-container">
        <div class="title">EDIT PROFILE</div>

        <form name="editFrm" method="post" action="<%=ctxPath%>/js_member/membereditend.sp">

            <!-- userid -->
            <input type="hidden" name="userid"
                   value="${sessionScope.loginuser.userid}">

            <!-- ================= 비밀번호 ================= -->
            <div class="section-title">PASSWORD CHANGE</div>

            <div class="form-group mb-4">
                <label class="form-label">새 비밀번호</label>
                <p class="guide-text">비밀번호를 변경하려면 입력하세요. (8~16자)</p>
                <input type="password" name="new_passwd" class="form-control">
            </div>

            <div class="form-group mb-4">
                <label class="form-label">새 비밀번호 확인</label>
                <input type="password" name="new_passwd_confirm" class="form-control">
            </div>

            <!-- ================= 기본 정보 ================= -->
            <div class="section-title">BASIC INFO</div>

            <div class="form-group mb-4">
                <label class="form-label">이름</label>
                <input type="text" name="name" class="form-control"
                       value="${sessionScope.loginuser.name}" required>
            </div>

            <div class="form-group mb-4">
                <label class="form-label">이메일</label>
                <input type="email" name="email" class="form-control"
                       value="${sessionScope.loginuser.email}" required>
            </div>

            <div class="form-group mb-4">
                <label class="form-label">연락처</label>
                <input type="text" name="mobile" class="form-control"
                       value="${sessionScope.loginuser.mobile}">
            </div>

            <!-- ================= 주소 ================= -->
            <div class="section-title">ADDRESS</div>

            <div class="form-group">
                <label class="form-label">우편번호</label>
                <div class="input-group mb-2">
                    <input type="text" name="postcode" id="postcode"
                           class="form-control"
                           value="${sessionScope.loginuser.postcode}" readonly>
                    <div class="input-group-append">
                        <button type="button" class="btn btn-post"
                                onclick="execDaumPostcode()">주소검색</button>
                    </div>
                </div>

                <input type="text" name="address" id="address"
                       class="form-control mb-2"
                       value="${sessionScope.loginuser.address}" readonly>

                <input type="text" name="detailaddress"
                       class="form-control mb-2"
                       value="${sessionScope.loginuser.detailaddress}"
                       placeholder="상세주소">

                <input type="text" name="extraaddress"
                       class="form-control"
                       value="${sessionScope.loginuser.extraaddress}"
                       placeholder="참고항목">
            </div>

            <!-- ================= 추가 정보 ================= -->
            <div class="section-title">ADDITIONAL INFO</div>

            <!-- 성별 -->
            <div class="form-group mb-4">
                <label class="form-label">성별</label>
                <div class="d-flex mt-2">
                    <div class="custom-control custom-radio mr-4">
                        <input type="radio" class="custom-control-input"
                               id="male" value="1"
                               ${sessionScope.loginuser.gender == '1' ? 'checked' : ''}
                               disabled>
                        <label class="custom-control-label" for="male">남자</label>
                    </div>
                    <div class="custom-control custom-radio">
                        <input type="radio" class="custom-control-input"
                               id="female" value="2"
                               ${sessionScope.loginuser.gender == '2' ? 'checked' : ''}
                               disabled>
                        <label class="custom-control-label" for="female">여자</label>
                    </div>
                </div>

                <!-- 서버로 실제 값 전송 -->
                <input type="hidden" name="gender"
                       value="${sessionScope.loginuser.gender}">
            </div>

            <!-- 생년월일 : 25/12/28 → 2025-12-28 변환 -->
            <div class="form-group mb-5">
                <label class="form-label">생년월일</label>

                <fmt:parseDate value="${sessionScope.loginuser.birthday}"
                               pattern="yy/MM/dd"
                               var="birthDate" />

                <fmt:formatDate value="${birthDate}"
                                pattern="yyyy-MM-dd"
                                var="birthForInput" />

                <input type="date" name="birthday"
                       class="form-control"
                       value="${birthForInput}">
            </div>

            <!-- 버튼 -->
            <button type="button" class="btn-black mb-2" onclick="goEdit()">
                UPDATE ACCOUNT
            </button>

            <button type="button"
                    class="btn btn-outline-secondary btn-block border-0"
                    style="border-radius:0; padding:15px; font-weight:bold;"
                    onclick="history.back()">
                CANCEL
            </button>
        </form>
    </div>
</div>

<jsp:include page="../footer.jsp" />

<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script>
function execDaumPostcode() {
    new daum.Postcode({
        oncomplete: function(data) {
            document.getElementById('postcode').value = data.zonecode;
            document.getElementById('address').value = data.roadAddress;
            document.editFrm.detailaddress.focus();
        }
    }).open();
}

function goEdit() {
    const frm = document.editFrm;

    const newPwd = frm.new_passwd.value.trim();
    const newPwdConfirm = frm.new_passwd_confirm.value.trim();

    if (newPwd !== "" || newPwdConfirm !== "") {
        if (newPwd !== newPwdConfirm) {
            alert("비밀번호와 확인용 비밀번호가 일치하지 않습니다.");
            return;
        }
        if (newPwd.length < 8 || newPwd.length > 16) {
            alert("비밀번호는 8~16자 사이로 입력하세요.");
            return;
        }
    }

    if (frm.name.value.trim() === "") {
        alert("성함을 입력하세요.");
        frm.name.focus();
        return;
    }

    frm.submit();
}
</script>
