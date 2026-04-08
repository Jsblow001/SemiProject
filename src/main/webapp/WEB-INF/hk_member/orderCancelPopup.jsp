<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

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
table{
    width:100%;
    border-collapse:collapse;
    margin-bottom:15px;
}
th, td{
    border:1px solid #ddd;
    padding:8px;
    text-align:center;
}
th{background:#f5f5f5;}
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

    const selected = document.querySelector("input[name='selectDetail']:checked");
    const type = document.querySelector("input[name='typeRadio']:checked").value;
    const reason = document.getElementById("reason").value;

    if(!selected){
        alert("상품을 선택하세요.");
        return;
    }

    if(reason.trim() === ""){
        alert("사유를 입력해주세요.");
        return;
    }

    document.getElementById("odrdetailno").value = selected.value;
    document.getElementById("type").value = type;

    document.getElementById("cancelForm").submit();
}
</script>

</head>
<body>

<h3>주문번호 : ${odrcode}</h3>
<p>이 주문에 포함된 상품 중 하나를 선택하세요.</p>

<form id="cancelForm" method="post" action="<%=ctxPath%>/orderCancelRequest.sp">

    <!-- 서버로 보낼 hidden 값 -->
    <input type="hidden" name="odrdetailno" id="odrdetailno">
    <input type="hidden" name="type" id="type">

    <!-- 상품 선택 테이블 -->
    <table>
        <tr>
            <th>선택</th>
            <th>상품명</th>
            <th>수량</th>
        </tr>

        <c:forEach var="d" items="${detailList}">
        <tr>
            <td>
                <input type="radio" name="selectDetail" value="${d.odrDetailNo}">
            </td>
            <td>${d.productName}</td>
            <td>${d.odrQty}</td>
        </tr>
        </c:forEach>
    </table>

    <!-- 취소/반품/교환 선택 -->
    <div class="radio-group">
        <label><input type="radio" name="typeRadio" value="CANCEL" checked> 취소</label>
        <label><input type="radio" name="typeRadio" value="RETURN"> 반품</label>
        <label><input type="radio" name="typeRadio" value="EXCHANGE"> 교환</label>
    </div>

    <!-- 사유 -->
    <p>사유</p>
    <textarea id="reason" name="reason" placeholder="취소 / 반품 / 교환 사유를 입력하세요"></textarea>

</form>

<div class="btn-box">
    <button type="button" onclick="submitCancel()">확인</button>
    <button type="button" onclick="window.close()">닫기</button>
</div>

</body>
</html>
