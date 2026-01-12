<%@ page contentType="text/html; charset=UTF-8" %>
<%
    String ctxPath = request.getContextPath();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>취소 / 반품 / 교환 신청</title>

<style>
body{
    font-family:Pretendard, sans-serif;
    margin:20px;
    font-size:14px;
}
h3{margin-bottom:10px;}
.radio-group label{margin-right:15px;}
textarea{
    width:100%;
    height:120px;
    margin-top:10px;
    resize:none;
}
.btn-box{
    text-align:center;
    margin-top:20px;
}
button{
    padding:8px 16px;
    margin:0 5px;
}
</style>

<script>
function submitCancel(){

    const type = document.querySelector("input[name='type']:checked").value;
    const reason = document.getElementById("reason").value;

    if(reason.trim() === ""){
        alert("사유를 입력해주세요.");
        return;
    }

    location.href =
        "<%=ctxPath%>/orderCancelRequest.sp" +
        "?odrcode=${odrcode}" +
        "&type=" + type +
        "&reason=" + encodeURIComponent(reason);
}
</script>

</head>
<body>

<h3>주문번호 : ${odrcode}</h3>
<p>현재상태 : ${status}</p>

<div class="radio-group">
    <label><input type="radio" name="type" value="CANCEL" checked> 취소</label>
    <label><input type="radio" name="type" value="RETURN"> 반품</label>
    <label><input type="radio" name="type" value="EXCHANGE"> 교환</label>
</div>

<p>사유</p>
<textarea id="reason" placeholder="취소 / 반품 / 교환 사유를 입력하세요"></textarea>

<div class="btn-box">
    <button type="button" onclick="submitCancel()">확인</button>
    <button type="button" onclick="window.close()">닫기</button>
</div>

</body>
</html>
