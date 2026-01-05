<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="../header.jsp" />      
    
<div class="container mt-5">
    <h3>위시리스트</h3>
    <table class="table table-hover mt-4">
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