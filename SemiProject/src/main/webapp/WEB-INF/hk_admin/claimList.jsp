<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>취소 / 반품 / 교환 요청 관리</title>

<style>
body{
    font-family:Pretendard, sans-serif;
    background:#f7f7f7;
    padding:30px;
}
h2{margin-bottom:20px;}
table{
    width:100%;
    border-collapse:collapse;
    background:#fff;
}
th, td{
    border:1px solid #ddd;
    padding:10px;
    text-align:center;
}
th{background:#f0f0f0;}
button{
    padding:6px 12px;
    border:none;
    cursor:pointer;
}
.approve{background:#4caf50;color:#fff;}
.reject{background:#f44336;color:#fff;}
</style>

<script>
function processClaim(odrdetailno, action){
    location.href =
      "${pageContext.request.contextPath}/admin/claimProcess.sp" +
      "?odrdetailno=" + odrdetailno +
      "&action=" + action;
}
</script>

</head>
<body>

<h2>취소 / 반품 / 교환 요청 관리</h2>

<table>
<tr>
   <th>주문번호</th>
   <th>상품명</th>
   <th>수량</th>
   <th>요청유형</th>
   <th>사유</th>
   <th>상태</th>
   <th>처리</th>
</tr>

<c:forEach var="c" items="${claimList}">
<tr>
   <td>${c.odrCode}</td>
   <td>${c.productName}</td>
   <td>${c.odrQty}</td>
   <td>${c.claimType}</td>
   <td>${c.claimReason}</td>
   <td>${c.claimStatus}</td>
   <td>
      <button class="approve" onclick="processClaim('${c.odrDetailNo}','APPROVE')">승인</button>
      <button class="reject" onclick="processClaim('${c.odrDetailNo}','REJECT')">반려</button>
   </td>
</tr>
</c:forEach>

</table>

</body>
</html>
