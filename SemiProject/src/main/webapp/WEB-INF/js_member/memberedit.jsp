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
    .addr-item { border: 1px solid #eee; padding: 15px; margin-bottom: 10px; display: flex; justify-content: space-between; align-items: center; cursor: pointer; transition: background 0.2s; }
    .addr-item:hover { background-color: #f9f9f9; border-color: #333; }
    .addr-info { font-size: 13px; line-height: 1.6; flex-grow: 1; }
    .btn-add-addr { border: 1px solid #000; background: #fff; font-size: 12px; font-weight: bold; padding: 5px 12px; cursor: pointer; }
	
	.section-title::after, 
    .section-title::before {
        content: none !important;
        display: none !important;
    }
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
                <input type="text" name="detailaddress" id="detailaddress" class="form-control mb-2" value="${sessionScope.loginuser.detailaddress}" placeholder="상세주소">
                <input type="text" name="extraaddress" id="extraaddress" class="form-control" value="${sessionScope.loginuser.extraaddress}" placeholder="참고항목">
            </div>

            <div class="section-title d-flex justify-content-between align-items-center">
                <span>ADDITIONAL ADDRESSES</span>
                <button type="button" class="btn-add-addr" onclick="saveCurrentAddress()">+ ADD NEW</button>
            </div>
            
            <div id="extraAddressList" class="mb-5">
                <c:choose>
                    <c:when test="${not empty addressList}">
                        <c:forEach var="addr" items="${addressList}">
                            <div class="addr-item" onclick="selectAddress('${addr.postcode}', '${addr.address}', '${addr.detailaddress}', '${addr.extraaddress}')">
                                <div class="addr-info">
                                    <strong>[${addr.postcode}]</strong> ${addr.address}<br>
                                    ${addr.detailaddress} ${addr.extraaddress}
                                </div>
                                <button type="button" class="btn btn-sm btn-outline-danger" style="border-radius:0;" 
                                        onclick="event.stopPropagation(); deleteAddress(${addr.addrId})">DEL</button>
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

<jsp:include page="../footer.jsp" />

<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="<%=ctxPath%>/js/jquery-3.7.1.min.js"></script>
<script src="<%=ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js"></script>

<script>
//1. 카카오 주소 API 호출 (참고항목 로직 추가)
function execDaumPostcode(postid, addrid) {
    new daum.Postcode({
        oncomplete: function(data) {
            // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

            // 각 주소의 노출 규칙에 따라 주소를 조합한다.
            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가짐
            let addr = ''; // 주소 변수
            let extraAddr = ''; // 참고항목 변수

            // 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
            if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                addr = data.roadAddress;
            } else { // 사용자가 지번 주소를 선택했을 경우(J)
                addr = data.jibunAddress;
            }

            // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
            if(data.userSelectedType === 'R'){
                // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                    extraAddr += data.bname;
                }
                // 건물명이 있고, 공동주택일 경우 추가한다.
                if(data.buildingName !== '' && data.apartment === 'Y'){
                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                if(extraAddr !== ''){
                    extraAddr = ' (' + extraAddr + ')';
                }
            } else {
                extraAddr = '';
            }

            // 우편번호와 주소 정보를 해당 필드에 넣는다.
            document.getElementById(postid).value = data.zonecode;
            document.getElementById(addrid).value = addr;
            
            // 참고항목 필드에 값을 넣는다.
            document.getElementById("extraaddress").value = extraAddr;
            
            // 커서를 상세주소 필드로 이동한다.
            document.getElementById('detailaddress').focus();
        }
    }).open();
}

//2. 현재 상단 필드에 적힌 주소를 DB에 저장하고 목록에 추가
function saveCurrentAddress() {
    const postData = {
        postcode: $('#postcode').val(),
        address: $('#address').val(),
        detailaddress: $('#detailaddress').val(),
        extraaddress: $('#extraaddress').val()
    };

    // [검증 1] 필수 입력 체크
    if(!postData.postcode || !postData.address) {
        alert("먼저 '주소검색'을 통해 주소를 입력해주세요.");
        return;
    }

    // [검증 2] 중복 체크 (프론트엔드)
    let isDuplicate = false;
    $('.addr-item').each(function() {
        const existingText = $(this).find('.addr-info').text();
        // 목록에 있는 우편번호와 주소, 상세주소를 합쳐서 비교
        if (existingText.includes(postData.postcode) && 
            existingText.includes(postData.address) && 
            existingText.includes(postData.detailaddress)) {
            isDuplicate = true;
            return false; // each 반복문 탈출
        }
    });

    if (isDuplicate) {
        alert("이미 추가 배송지 목록에 등록된 주소입니다.");
        return;
    }

    // [검증 3] 기본 주소와 중복되는지 체크 (옵션: 필요 시 사용)
    /*
    if (postData.postcode === "${sessionScope.loginuser.postcode}" && 
        postData.address === "${sessionScope.loginuser.address}" &&
        postData.detailaddress === "${sessionScope.loginuser.detailaddress}") {
        alert("현재 기본 배송지로 등록된 주소입니다.");
        return;
    }
    */

    $.ajax({
        url: "<%=ctxPath%>/js_member/addAddress.sp",
        type: "POST",
        data: postData,
        dataType: "json",
        success: function(json) {
            if(json.success) {
                // 저장 성공 시 리스트에 동적으로 추가
                let newAddrHtml = `
                    <div class="addr-item" onclick="selectAddress('\${postData.postcode}', '\${postData.address}', '\${postData.detailaddress}', '\${postData.extraaddress}')">
                        <div class="addr-info">
                            <strong>[\${postData.postcode}]</strong> \${postData.address}<br>
                            \${postData.detailaddress} \${postData.extraaddress}
                        </div>
                        <button type="button" class="btn btn-sm btn-outline-danger" 
                                style="border-radius:0;" onclick="event.stopPropagation(); deleteAddress(\${json.new_addr_id})">DEL</button>
                    </div>`;

                if($('#extraAddressList p.guide-text').length > 0) {
                    $('#extraAddressList').empty();
                }
                
                $('#extraAddressList').append(newAddrHtml);
                alert("현재 주소가 목록에 추가되었습니다.");
            } else {
                alert("저장 실패: " + (json.message || "이미 등록된 주소이거나 오류가 발생했습니다."));
            }
        },
        error: function() {
            alert("서버 통신 중 오류가 발생했습니다.");
        }
    });
}

// 3. 목록의 주소를 클릭하면 다시 상단 입력칸으로 복사
function selectAddress(postcode, address, detail, extra) {
    $('#postcode').val(postcode);
    $('#address').val(address);
    $('#detailaddress').val(detail);
    $('#extraaddress').val(extra);
    
    alert("선택한 주소가 상단 필드에 반영되었습니다.");
    window.scrollTo({ top: 300, behavior: 'smooth' });
}

// 4. 배송지 삭제
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
            } else {
                alert(json.errorMsg || "삭제할 수 없습니다. (이미 주문에 사용된 주소일 수 있습니다.)");
            }
        },
        error: function() {
            alert("삭제 처리 중 오류가 발생했습니다.");
        }
    });
}

// 5. 전체 정보 수정 제출
function goEdit() {
    const frm = document.editFrm;
    if (frm.name.value.trim() === "") { alert("성함을 입력하세요."); return; }
    
    const newPwd = frm.new_passwd.value.trim();
    const newPwdConfirm = frm.new_passwd_confirm.value.trim();
    if (newPwd !== "" && newPwd !== newPwdConfirm) { alert("비밀번호가 일치하지 않습니다."); return; }

    frm.submit();
}
</script>