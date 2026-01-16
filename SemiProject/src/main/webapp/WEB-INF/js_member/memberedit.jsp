<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<% String ctxPath = request.getContextPath(); %>

<jsp:include page="../header.jsp" />

<link rel="stylesheet" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.css" />
<link rel="stylesheet" href="<%=ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css">

<style>
    body { background-color:#fff; font-family:'Pretendard', sans-serif; color:#333; }
    .edit-container { max-width:550px; margin:80px auto; padding:20px; }
    .title { text-align:center; font-size:26px; font-weight:700; margin-bottom:50px; letter-spacing:5px; }
    .section-title { font-size:14px; font-weight:bold; margin:40px 0 20px; border-bottom:1px solid #000; padding-bottom:10px; }
    .form-label { font-size:13px; font-weight:600; margin-bottom:8px; display:block; }
    .guide-text { font-size:12px; color:#888; margin-bottom:10px; }
    .form-control { border-radius:0; border:1px solid #ddd; padding:12px; height:auto; }
    .form-control[readonly] { background-color:#f8f8f8; }
    .btn-black { background:#000; color:#fff; border-radius:0; padding:16px; width:100%; font-weight:bold; border:none; transition: 0.3s; }
    .btn-black:hover { background:#333; color:#fff; }
    .btn-post { background:#f8f8f8; border:1px solid #ddd; border-radius:0; font-size:13px; padding:0 15px; }
    
    /* 추가 배송지 아이템 스타일 */
    .addr-item { border: 1px solid #eee; padding: 15px; margin-bottom: 10px; display: flex; justify-content: space-between; align-items: center; }
    .addr-info { font-size: 13px; line-height: 1.6; }
    .btn-add-addr { border: 1px solid #000; background: #fff; font-size: 12px; font-weight: bold; padding: 5px 12px; cursor: pointer; }
	
	.section-title::after, 
    .section-title::before {
        content: none !important; /* 내용 삭제 */
        display: none !important; /* 공간 삭제 */
</style>

<div class="container">
    <div class="edit-container">
        <div class="title">EDIT PROFILE</div>

        <form name="editFrm" method="post" action="<%=ctxPath%>/js_member/membereditend.sp">
            <input type="hidden" name="userid" value="${sessionScope.loginuser.userid}">

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

            <div class="section-title">BASIC INFO</div>
            <div class="form-group mb-4">
                <label class="form-label">이름</label>
                <input type="text" name="name" class="form-control" value="${sessionScope.loginuser.name}" required>
            </div>
            <div class="form-group mb-4">
                <label class="form-label">이메일</label>
                <input type="email" name="email" class="form-control" value="${sessionScope.loginuser.email}" required>
            </div>
            <div class="form-group mb-4">
                <label class="form-label">연락처</label>
                <input type="text" name="mobile" class="form-control" value="${sessionScope.loginuser.mobile}">
            </div>

            <div class="section-title">DEFAULT ADDRESS</div>
            <div class="form-group mb-4">
                <label class="form-label">우편번호</label>
                <div class="input-group mb-2">
                    <input type="text" name="postcode" id="postcode" class="form-control" value="${sessionScope.loginuser.postcode}" readonly>
                    <div class="input-group-append">
                        <button type="button" class="btn btn-post" onclick="execDaumPostcode('postcode', 'address')">주소검색</button>
                    </div>
                </div>
                <input type="text" name="address" id="address" class="form-control mb-2" value="${sessionScope.loginuser.address}" readonly>
                <input type="text" name="detailaddress" class="form-control mb-2" value="${sessionScope.loginuser.detailaddress}" placeholder="상세주소">
                <input type="text" name="extraaddress" class="form-control" value="${sessionScope.loginuser.extraaddress}" placeholder="참고항목">
            </div>

            <div class="section-title d-flex justify-content-between align-items-center">
                <span>ADDITIONAL ADDRESSES</span>
                <button type="button" class="btn-add-addr" onclick="openAddrModal()">+ ADD NEW</button>
            </div>
            
            <div id="extraAddressList" class="mb-5">
                <c:choose>
                    <c:when test="${not empty addressList}">
                        <c:forEach var="addr" items="${addressList}">
                            <div class="addr-item">
                                <div class="addr-info">
                                    <strong>[${addr.postcode}]</strong> ${addr.address}<br>
                                    ${addr.detailaddress} ${addr.extraaddress}
                                </div>
                                <button type="button" class="btn btn-sm btn-outline-danger" style="border-radius:0;" onclick="deleteAddress(${addr.addr_id})">DEL</button>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <p class="guide-text text-center py-3">등록된 추가 배송지가 없습니다.</p>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="section-title">ADDITIONAL INFO</div>
            <div class="form-group mb-4">
                <label class="form-label">성별</label>
                <div class="d-flex mt-2">
                    <div class="custom-control custom-radio mr-4">
                        <input type="radio" class="custom-control-input" id="male" value="1" ${sessionScope.loginuser.gender == '1' ? 'checked' : ''} disabled>
                        <label class="custom-control-label" for="male">남자</label>
                    </div>
                    <div class="custom-control custom-radio">
                        <input type="radio" class="custom-control-input" id="female" value="2" ${sessionScope.loginuser.gender == '2' ? 'checked' : ''} disabled>
                        <label class="custom-control-label" for="female">여자</label>
                    </div>
                </div>
                <input type="hidden" name="gender" value="${sessionScope.loginuser.gender}">
            </div>

            <div class="form-group mb-5">
                <label class="form-label">생년월일</label>
                <fmt:parseDate value="${sessionScope.loginuser.birthday}" pattern="yyyy-MM-dd" var="birthDate" />
                <fmt:formatDate value="${birthDate}" pattern="yyyy-MM-dd" var="birthForInput" />
                <input type="date" name="birthday" class="form-control" value="${birthForInput}">
            </div>

            <button type="button" class="btn-black mb-3 mt-4" onclick="goEdit()">UPDATE ACCOUNT</button>
            <button type="button" class="btn btn-danger btn-block" style="border-radius:0; padding:16px; font-weight:bold; border:none;" onclick="history.back()">CANCEL</button>
        </form>
    </div>
</div>

<div class="modal fade" id="addrModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border-radius:0;">
            <div class="modal-header border-0">
                <h6 class="modal-title font-weight-bold">새 배송지 추가</h6>
                <button type="button" class="close" data-dismiss="modal">&times;</button>
            </div>
            <div class="modal-body">
                <form id="addAddrFrm">
                    <div class="form-group">
                        <div class="input-group mb-2">
                            <input type="text" id="new_postcode" class="form-control" placeholder="우편번호" readonly>
                            <div class="input-group-append">
                                <button type="button" class="btn btn-post" onclick="execDaumPostcode('new_postcode', 'new_address')">찾기</button>
                            </div>
                        </div>
                        <input type="text" id="new_address" class="form-control mb-2" placeholder="기본주소" readonly>
                        <input type="text" id="new_detailaddress" class="form-control mb-2" placeholder="상세주소">
                        <input type="text" id="new_extraaddress" class="form-control" placeholder="참고항목">
                    </div>
                </form>
            </div>
            <div class="modal-footer border-0">
                <button type="button" class="btn btn-black" onclick="saveNewAddress()">저장</button>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../footer.jsp" />

<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="<%=ctxPath%>/js/jquery-3.7.1.min.js"></script>
<script src="<%=ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>

<script>
// 1. 주소 검색 (공통 사용)
function execDaumPostcode(postid, addrid) {
    new daum.Postcode({
        oncomplete: function(data) {
            document.getElementById(postid).value = data.zonecode;
            document.getElementById(addrid).value = data.roadAddress;
            if(postid === 'new_postcode') document.getElementById('new_detailaddress').focus();
        }
    }).open();
}

// 2. 추가 배송지 저장 (Ajax)
function saveNewAddress() {
    const postData = {
        postcode: $('#new_postcode').val(),
        address: $('#new_address').val(),
        detailaddress: $('#new_detailaddress').val(),
        extraaddress: $('#new_extraaddress').val()
    };

    if(!postData.postcode) { alert("주소를 검색해주세요."); return; }

    $.ajax({
        url: "<%=ctxPath%>/js_member/addAddress.sp",
        type: "POST",
        data: postData,
        dataType: "json",
        success: function(json) {
            if(json.success) {
                // 1. 새로운 주소 아이템 HTML 생성
                let newAddrHtml = `
                    <div class="addr-item">
                        <div class="addr-info">
                            <strong>[\${postData.postcode}]</strong> \${postData.address}<br>
                            \${postData.detailaddress} \${postData.extraaddress}
                        </div>
                        <button type="button" class="btn btn-sm btn-outline-danger" 
                                style="border-radius:0;" onclick="deleteAddress(\${json.new_addr_id})">DEL</button>
                    </div>`;

                // 2. 리스트 영역에 추가 (비어있을 때 나오던 안내 문구는 삭제)
                if($('#extraAddressList p.guide-text').length > 0) {
                    $('#extraAddressList').empty();
                }
                $('#extraAddressList').append(newAddrHtml);

                // 3. 모달 닫기 및 초기화
                $('#addrModal').modal('hide');
                alert("배송지가 추가되었습니다.");
            }
        },
        error: function() { alert("저장 중 오류가 발생했습니다."); }
    });
}

// 3. 배송지 삭제 (Ajax)
function deleteAddress(addr_id) {
    if(!confirm("해당 배송지를 삭제하시겠습니까?")) return;

    $.ajax({
        url: "<%=ctxPath%>/js_member/deleteAddress.sp",
        type: "POST",
        data: { "addr_id": addr_id },
        dataType: "json",
        success: function(json) {
            if(json.success) {
                location.reload();
            }
        }
    });
}

// 4. 모달 열기
function openAddrModal() {
    $('#addAddrFrm')[0].reset();
    $('#addrModal').modal('show');
}

// 5. 프로필 수정 제출
function goEdit() {
    const frm = document.editFrm;
    const newPwd = frm.new_passwd.value.trim();
    const newPwdConfirm = frm.new_passwd_confirm.value.trim();

    if (newPwd !== "" || newPwdConfirm !== "") {
        if (newPwd !== newPwdConfirm) { alert("비밀번호가 일치하지 않습니다."); return; }
        if (newPwd.length < 8) { alert("비밀번호는 8자 이상이어야 합니다."); return; }
    }
    if (frm.name.value.trim() === "") { alert("성함을 입력하세요."); return; }

    frm.submit();
}
</script>