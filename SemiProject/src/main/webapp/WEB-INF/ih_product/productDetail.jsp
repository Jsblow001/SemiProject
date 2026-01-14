<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% String ctxPath = request.getContextPath(); %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../header.jsp" />

<script type="text/javascript" src="<%= ctxPath%>/js/ih_product/product.js"></script>
<script type="text/javascript" src="<%= ctxPath%>/js/ih_product/product.js?v=<%= System.currentTimeMillis() %>"></script>

<style>

.cart-icon-bold {
    color: #000 !important;     
    font-weight: 900 !important;
    font-size: 1.3rem;           
    opacity: 1 !important;       
    text-shadow: 0.2px 0px 0px #000; 
}

</style>
<div class="container mt-5">
    <div class="row">
        <div class="col-md-6 text-center">
            <img src="${pageContext.request.contextPath}/img/${pdto.pimage}" class="img-fluid rounded shadow-sm" alt="${pdto.product_name}">
        </div>

        <div class="col-md-6">
            
            <%-- 카테고리 ID 표시 부분 (관리자만 보이게) --%>
			<nav aria-label="breadcrumb">
			    <ol class="breadcrumb">
			        <c:if test="${sessionScope.loginuser.userid == 'admin'}">
			            <li class="breadcrumb-label mr-2 text-primary font-weight-bold">
			                [관리자 전용] Category ID: ${pdto.fk_category_id}
			            </li>
			        </c:if>

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
            
            
            
            <c:if test="${pdto.stock > 0}">
		    <div class="mt-4 mb-3 d-flex align-items-center" style="gap: 15px;">
		        <label for="order_qty" class="font-weight-bold mb-0">주문 수량 :</label>
		        <div class="input-group" style="width: 140px;">
		            <div class="input-group-prepend">
		                <button class="btn btn-outline-secondary" type="button" onclick="changeQty(-1)">-</button>
		            </div>
		            <input type="number" id="order_qty" name="order_qty" class="form-control text-center" 
		                   value="1" min="1" max="${pdto.stock}" onchange="checkStock(this)">
		            <div class="input-group-append">
		                <button class="btn btn-outline-secondary" type="button" onclick="changeQty(1)">+</button>
		            </div>
		        </div>
		    </div>
		</c:if>
		
		<div class="d-flex mt-2" style="gap: 10px; align-items: center;">
		    
		    <button type="button" class="btn btn-outline-secondary p-0 wish-btn-${pdto.product_id}" 
		            style="flex: 1; height: 50px; display: flex; align-items: center; justify-content: center;"
		            onclick="goWish('${pdto.product_id}', '${pageContext.request.contextPath}')">
		        <i class="far fa-heart text-danger wish-icon-${pdto.product_id}" style="font-size: 1.2rem;"></i>
		    </button>
		    
		    <button type="button" class="btn btn-outline-secondary p-0 cart-btn-${pdto.product_id}" 
		            style="flex: 1; height: 50px; display: flex; align-items: center; justify-content: center;"
		            onclick="goCart('${pdto.product_id}', document.getElementById('order_qty').value, '<%= ctxPath %>')">
		        <i class="fas fa-shopping-cart cart-icon-bold cart-icon-${pdto.product_id}" style="font-size: 1.2rem;"></i>
		    </button>
		    
		    <button class="btn btn-dark" style="flex: 3; height: 50px; font-weight: bold;" ${pdto.stock == 0 ? 'disabled' : ''} 
		            onclick="buyProduct('${pdto.product_id}', '${pdto.product_name}')">
		        ${pdto.stock == 0 ? '품절' : '바로 구매하기'}
		    </button>
		
		</div>
					
			</div>
            
            <%-- 하단 수정/삭제 버튼 부분 (관리자만 보이게) --%>
			<c:if test="${sessionScope.loginuser.userid == 'admin'}">
			    <div class="mt-4 text-right">
			        <div class="alert alert-warning d-inline-block p-2">
			            <small class="font-weight-bold">상품 관리 메뉴:</small>
			            <small>
			                <button class="btn btn-sm btn-outline-primary px-3" 
                                    onclick="location.href='<%= ctxPath%>/admin/productUpdate.sp?product_id=${pdto.product_id}'">
                                <i class="fas fa-edit mr-1"></i>상품 수정
                            </button>
			                
			                <button class="btn btn-sm btn-outline-danger px-3" 
                                    onclick="delProduct('${pdto.product_id}', '${pdto.product_name}')">
                                <i class="fas fa-trash-alt mr-1"></i>상품 삭제
                            </button>
			            </small>
			        </div>
			    </div>
			</c:if>
            
            
        </div>
    </div>
</div>

<script>
// 관리자 - 상품 삭제하기
function delProduct(id, name) {
    if(confirm("[" + name + "] 상품을 정말 삭제하시겠습니까?")) {
        // 실제 삭제를 처리할 Controller 주소로 이동
        location.href = "${pageContext.request.contextPath}/admin/productDelete.sp?product_id=" + id;
    }
}

//수량 증감 함수
function changeQty(num) {
    const qtyInput = document.getElementById("order_qty");
    let currentQty = parseInt(qtyInput.value);
    const maxStock = parseInt("${pdto.stock}");

    currentQty += num;

    if (currentQty < 1) {
        alert("최소 주문 수량은 1개입니다.");
        qtyInput.value = 1;
        return;
    }
    if (currentQty > maxStock) {
        alert("재고가 부족합니다. (최대 " + maxStock + "개)");
        qtyInput.value = maxStock;
        return;
    }
    qtyInput.value = currentQty;
}

// 직접 숫자 입력 시 체크 함수
function checkStock(input) {
    const maxStock = parseInt("${pdto.stock}");
    if (input.value > maxStock) {
        alert("재고가 부족합니다. 최대 수량인 " + maxStock + "개로 설정합니다.");
        input.value = maxStock;
    }
    if (input.value < 1) {
        input.value = 1;
    }
}

// 구매하기 함수 (수량 포함)
function buyProduct(id, name) {
    const qty = document.getElementById("order_qty").value;

    if(confirm("[" + name + "] 상품 " + qty + "개를 바로 구매하시겠습니까?")) {
        location.href = "${pageContext.request.contextPath}/product/orderForm.sp?product_id=" + id + "&qty=" + qty;
    }
}

</script>
<jsp:include page="../footer.jsp" />