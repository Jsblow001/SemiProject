<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="../header.jsp" />    
    
    
<table class="table">
    <thead>
        <tr>
            <th>번호</th>
            <th>이미지</th>
            <th>상품명</th>
            <th>판매가</th>
            <th>재고</th>
            <th>관리</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="pdto" items="${productList}">
            <tr>
                <td>${pdto.product_id}</td>
                <td>
                    <a href="productDetail.sp?product_id=${pdto.product_id}">
                        <img src="${pageContext.request.contextPath}/img/${pdto.pimage}" width="80">
                    </a>
                </td>
                <td><a href="productDetail.sp?product_id=${pdto.product_id}">${pdto.product_name}</a></td>
                <td>${pdto.sale_price}원</td>
                <td>${pdto.stock}</td>
                <td>
                    <button onclick="location.href='productUpdate.sp?product_id=${pdto.product_id}'">수정</button>
                    <button onclick="delProduct('${pdto.product_id}')">삭제</button>
                </td>
            </tr>
        </c:forEach>
    </tbody>
</table>

<script>
function delProduct(id) {
    if(confirm("정말 삭제하시겠습니까?")) {
        location.href = "productDelete.sp?product_id=" + id;
    }
}
</script>



<jsp:include page="../footer.jsp" />