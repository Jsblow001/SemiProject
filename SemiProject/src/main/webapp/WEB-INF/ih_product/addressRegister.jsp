<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% String ctxPath = request.getContextPath(); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>새 배송지 등록</title>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
<style>
    body { background-color: #f8f9fa; }
    .container { background-color: #fff; margin-top: 20px; border-radius: 10px; padding: 30px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
    .label-title { font-weight: bold; color: #333; }
</style>
</head>
<body>

<div class="container">
    <h4 class="text-center mb-4">🏠 새 배송지 등록</h4>
    
    <form name="addrFrm" action="<%= ctxPath %>/product/addressRegister.sp" method="POST">
        
        <div class="form-group">
            <label class="label-title">우편번호</label>
            <div class="input-group">
                <input type="text" name="postcode" id="postcode" class="form-control" placeholder="우편번호" readonly required>
                <div class="input-group-append">
                    <button type="button" class="btn btn-info" onclick="execDaumPostcode()">주소찾기</button>
                </div>
            </div>
        </div>

        <div class="form-group">
            <label class="label-title">주소</label>
            <input type="text" name="address" id="address" class="form-control" placeholder="기본주소" readonly required>
        </div>

        <div class="form-group">
            <label class="label-title">상세주소</label>
            <input type="text" name="detailaddress" id="detailaddress" class="form-control" placeholder="나머지 상세주소를 입력하세요" required>
        </div>

        <div class="form-group">
            <label class="label-title">참고항목</label>
            <input type="text" name="extraaddress" id="extraaddress" class="form-control" placeholder="참고항목" readonly>
        </div>

        <div class="text-center mt-4">
            <button type="button" class="btn btn-primary px-4" onclick="goRegister()">등록하기</button>
            <button type="button" class="btn btn-secondary px-4" onclick="window.close()">취소</button>
        </div>
        
    </form>
</div>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
    // 카카오 주소 찾기 API 로직
    function execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                var addr = ''; // 주소 변수
                var extraAddr = ''; // 참고항목 변수

                if (data.userSelectedType === 'R') { addr = data.roadAddress; } 
                else { addr = data.jibunAddress; }

                if(data.userSelectedType === 'R'){
                    if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){ extraAddr += data.bname; }
                    if(data.buildingName !== '' && data.apartment === 'Y'){
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    if(extraAddr !== ''){ extraAddr = ' (' + extraAddr + ')'; }
                    document.getElementById("extraaddress").value = extraAddr;
                } else {
                    document.getElementById("extraaddress").value = '';
                }

                document.getElementById('postcode').value = data.zonecode;
                document.getElementById("address").value = addr;
                document.getElementById("detailaddress").focus();
            }
        }).open();
    }

    // 등록 버튼 클릭 시 유효성 검사 후 전송
    function goRegister() {
        const postcode = document.getElementById("postcode").value;
        const detail = document.getElementById("detailaddress").value;

        if(postcode == "") {
            alert("주소찾기를 통해 주소를 입력해주세요.");
            return;
        }
        if(detail.trim() == "") {
            alert("상세주소를 입력해주세요.");
            return;
        }

        document.addrFrm.submit();
    }
</script>

</body>
</html>