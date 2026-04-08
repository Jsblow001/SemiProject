<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String ctxPath = request.getContextPath();
%>

<jsp:include page="../header.jsp" />

<link rel="stylesheet" as="style" crossorigin
      href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.css" />

<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="<%=ctxPath%>/js/jquery-3.7.1.min.js"></script>

<style>
    body { background-color:#fff; font-family:'Pretendard', sans-serif; color:#333; }
    .register-container { max-width:550px; margin:60px auto; padding:20px; }
    .title { text-align:center; font-size:26px; font-weight:700; margin-bottom:50px; letter-spacing:5px; }
    .section-title { font-size:14px; font-weight:bold; margin:40px 0 20px; border-bottom:1px solid #000; }
    .form-label { font-size:13px; font-weight:600; margin-bottom:8px; display:block; }
    .guide-text { font-size:12px; color:#888; margin-bottom:10px; }
    .form-control { border-radius:0; border:1px solid #ddd; padding:12px; }
    .btn-black { background:#000; color:#fff; border-radius:0; padding:16px; width:100%; font-weight:bold; }
    .btn-post { background:#f8f8f8; border:1px solid #ddd; border-radius:0; font-size:13px; }
    .section-title::after,
    .section-title::before {
        content: none !important;
        display: none !important;
    }
</style>

<script>
/* ================================
   다음 우편번호
================================ */
function execDaumPostcode() {
    new daum.Postcode({
        oncomplete: function(data) {
            document.socialJoinFrm.postcode.value = data.zonecode;
            document.socialJoinFrm.address.value  = data.roadAddress;
            document.socialJoinFrm.detailaddress.focus();
        }
    }).open();
}

/* ================================
   유효성 검사 + submit
================================ */
function goSocialJoin() {

    const frm = document.socialJoinFrm;

    if(frm.name.value.trim() === "") {
        alert("이름을 입력하세요.");
        frm.name.focus();
        return;
    }

    // gender는 1/2 중 하나 선택(필수)
    if(!frm.gender.value) {
        alert("성별을 선택하세요.");
        return;
    }

    // birthday는 선택사항으로 둘거면 체크 빼도 됨
    // if(frm.birthday.value.trim() === "") {
    //     alert("생년월일을 입력하세요.");
    //     frm.birthday.focus();
    //     return;
    // }

    if(frm.postcode.value.trim() === "") {
        alert("주소검색을 통해 우편번호를 입력하세요.");
        return;
    }

    if(frm.address.value.trim() === "") {
        alert("주소를 입력하세요.");
        return;
    }

    if(frm.detailaddress.value.trim() === "") {
        alert("상세주소를 입력하세요.");
        frm.detailaddress.focus();
        return;
    }

    frm.submit();
}
</script>

<div class="register-container">
    <div class="title">추가 정보 입력</div>

    <form name="socialJoinFrm" method="post" action="<%=ctxPath%>/socialJoinEnd.sp">

        <!-- 소셜 userid -->
        <input type="hidden" name="userid" value="${requestScope.userid}" />

        <div class="section-title">BASIC INFO</div>

        <label class="form-label">이름 *</label>
        <input type="text" name="name" class="form-control"
               value="${requestScope.name}" placeholder="이름을 입력하세요">

        <div class="section-title">ADDRESS</div>

        <div class="input-group mb-2">
            <input type="text" name="postcode" class="form-control" readonly>
            <div class="input-group-append">
                <button type="button" class="btn btn-post" onclick="execDaumPostcode()">주소검색</button>
            </div>
        </div>

        <input type="text" name="address" class="form-control mb-2" readonly>
        <input type="text" name="detailaddress" class="form-control mb-2" placeholder="상세주소">
        <input type="text" name="extraaddress" class="form-control" placeholder="참고항목">

        <div class="section-title">ADDITIONAL INFO</div>

        <label class="form-label">성별 *</label>
        <div class="mb-3">
            <!-- ★ 너 register.jsp랑 동일하게 1/2 -->
            <input type="radio" name="gender" value="1" checked> 남자
            <input type="radio" name="gender" value="2"> 여자
        </div>

        <label class="form-label">생년월일</label>
        <!-- register.jsp랑 동일하게 date 타입 -->
        <input type="date" name="birthday" class="form-control">

        <button type="button" class="btn-black mt-5" onclick="goSocialJoin()">CREATE ACCOUNT</button>
    </form>
</div>

<jsp:include page="../footer.jsp" />
