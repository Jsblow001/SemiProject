<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String ctxPath = request.getContextPath(); %>

<script type="text/javascript" src="<%= ctxPath%>/js/ih_product/product.js"></script>
<script type="text/javascript" src="<%= ctxPath%>/js/ih_product/product.js?v=<%= System.currentTimeMillis() %>"></script>

<jsp:include page="../header.jsp" />      

<style>
    /* 테이블 행의 높이를 고정 */
    .table-wishlist tbody tr {
        height: 100px; /* 원하는 높이로 조절하세요 */
    }

    /* 모든 셀의 내용을 수직 중앙 정렬 */
    .table-wishlist td {
        vertical-align: middle !important;
    }

    /* 이미지 크기 고정 및 비율 유지 */
    .wish-img {
        width: 80px;
        height: 80px;
        object-fit: cover; /* 이미지가 찌그러지지 않게 해줍니다 */
    }
</style>
        
<div class="container mt-5">
    <h3>위시리스트</h3>
    <table class="table table-hover mt-4 table-wishlist">
        <thead>
            <tr>
                <th>상품이미지</th>
                <th>상품명</th>
                <th>판매가</th>
                <th>삭제</th>
            </tr>
        </thead>
        <tbody>
            <c:if test="${not empty wishList}">
                <c:forEach var="p" items="${wishList}">
                    <tr>
                        <td>
                            <img src="${pageContext.request.contextPath}/img/${p.pimage}" width="80">
                        </td>
                        <td>${p.product_name}</td>
                        <td>${p.sale_price}원</td>
                        <td>
                            <button class="btn btn-sm btn-outline-danger" 
                                    onclick="goWish('${p.product_id}', '${pageContext.request.contextPath}')">삭제</button>
                        </td>
                    </tr>
                </c:forEach>
            </c:if>
            <c:if test="${empty wishList}">
                <tr>
                    <td colspan="4" class="text-center">찜한 상품이 없습니다.</td>
                </tr>
            </c:if>
        </tbody>
    </table>
</div>   


<jsp:include page="../footer.jsp" />      