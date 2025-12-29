<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<jsp:include page="../header.jsp" />


<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container mt-5">
    <div class="row">
        <div class="col-md-6 text-center">
            <img src="${pageContext.request.contextPath}/img/${pdto.pimage}" class="img-fluid rounded shadow-sm" alt="${pdto.product_name}">
        </div>

        <div class="col-md-6">
            
            <%-- 1. 카테고리 ID 표시 부분 (관리자만 보이게) --%>
			<nav aria-label="breadcrumb">
			    <ol class="breadcrumb">
			        <c:if test="${sessionScope.loginuser.userid == 'admin'}">
			            <li class="breadcrumb-label mr-2 text-primary font-weight-bold">
			                [관리자 전용] Category ID: ${pdto.fk_category_id}
			            </li>
			        </c:if>
			        <%-- 일반 사용자에게도 보일 내용이 있다면 여기에 추가 --%>
			    </ol>
			</nav>
            
            
            <h2 class="font-weight-bold">${pdto.product_name}</h2>
            <hr>

            <div class="price-box mb-3">
                <p class="text-muted mb-1" style="text-decoration: line-through;">
                    정가: <fmt:formatNumber value="${pdto.list_price}" pattern="###,###" />원
                </p>
                <h3 class="text-danger font-weight-bold">
                    판매가: <fmt:formatNumber value="${pdto.sale_price}" pattern="###,###" />원
                </h3>
            </div>

            <p class="mt-4 p-3 bg-light rounded" style="min-height: 100px;">
                ${pdto.product_description}
            </p>
            
            <div class="mt-3">
                <c:choose>
                    <c:when test="${pdto.stock > 0}">
                        <span class="badge badge-success">재고 있음 (${pdto.stock}개)</span>
                    </c:when>
                    <c:otherwise>
                        <span class="badge badge-secondary">품절 (Out of Stock)</span>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <div class="d-flex mt-5">
                <button class="btn btn-outline-dark btn-lg mr-2" style="flex: 1;">장바구니 담기</button>
                <button class="btn btn-dark btn-lg" style="flex: 2;" ${pdto.stock == 0 ? 'disabled' : ''}>바로 구매하기</button>
            </div>
            
            <%-- 2. 하단 수정/삭제 버튼 부분 (관리자만 보이게) --%>
			<c:if test="${sessionScope.loginuser.userid == 'admin'}">
			    <div class="mt-4 text-right">
			        <div class="alert alert-warning d-inline-block p-2">
			            <small class="font-weight-bold">상품 관리 메뉴:</small>
			            <small>
			                <a href="productUpdate.sp?product_id=${pdto.product_id}" class="btn btn-sm btn-outline-secondary ml-2">상품 수정</a>
			                <a href="javascript:delProduct('${pdto.product_id}')" class="btn btn-sm btn-outline-danger ml-1">상품 삭제</a>
			            </small>
			        </div>
			    </div>
			</c:if>
            
            
        </div>
    </div>
</div>

<script>
function delProduct(id) {
    if(confirm("이 상품을 정말 삭제하시겠습니까?")) {
        location.href = "productDelete.sp?product_id=" + id;
    }
}
</script>
<jsp:include page="../footer.jsp" />