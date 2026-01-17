<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% String ctxPath = request.getContextPath(); %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../header.jsp" />

<script type="text/javascript" src="<%= ctxPath%>/js/ih_product/product.js"></script>

<style>
    /* PC에서 구매박스 고정 */
    @media (min-width: 768px) {
        .sticky-sidebar {
            position: -webkit-sticky;
            position: sticky;
            top: 120px; 
            height: fit-content;
            z-index: 100;
        }
    }

    /* 상자 디자인 - 세로로 더 길게 보이도록 padding과 min-height 조정 */
    .sticky-sidebar {
        padding: 50px 30px; /* 상하 패딩을 높여 길게 만듦 */
        min-height: 600px;  /* 최소 높이 설정 */
        background-color: #fff;
        border: 1px solid #eee;
        border-radius: 12px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        display: flex;
        flex-direction: column;
        justify-content: center; /* 내용이 중앙에 오도록 */
    }

    /* 이미지 크기 - 컨테이너 크기 조절 */
    .product-img-container {
        width: 90%; /* 사진 자체를 컨테이너 안에서 조금 더 줄임 */
        margin: 0 auto;
    }
    .product-img-container img {
        width: 100%;
        height: auto;
        border-radius: 8px;
    }

    /* 후기 및 설명 간격 */
    .product-description, .review-container {
        padding: 0 10px;
        margin-top: 40px;
    }

    .star-rating { color: #ffc107; }

    /* 모바일에서 박스가 안 보이지 않도록 위치 강제 */
    @media (max-width: 767px) {
        .sticky-sidebar {
            position: relative !important;
            top: 0 !important;
            margin: 20px 0;
            display: block !important;
            min-height: auto; /* 모바일에서는 자동 높이 */
            padding: 30px 20px;
        }
        .product-img-container { width: 100%; }
    }
    
    /* 관리자 메뉴 래퍼 */
    .admin-manage-wrap {
        border-top: 1px dashed #ddd;
        padding-top: 25px;
    }

    /* ADMIN 배지 */
    .admin-badge {
        font-size: 10px;
        font-weight: 800;
        letter-spacing: 1px;
        color: #999;
        border: 1px solid #ddd;
        padding: 2px 8px;
        border-radius: 4px;
    }

    /* 버튼 그룹 컨테이너 */
    .admin-btn-group {
        display: flex;
        align-items: center;
        background: #fdfdfd;
        border: 1px solid #e0e0e0;
        border-radius: 30px;
        padding: 4px 16px;
        box-shadow: 0 2px 6px rgba(0,0,0,0.03);
    }

    /* 공통 버튼 스타일 */
    .btn-admin-edit, .btn-admin-del {
        background: none;
        border: none;
        padding: 6px 8px;
        font-size: 13px;
        font-weight: 600;
        display: flex;
        align-items: center;
        gap: 6px;
        transition: all 0.2s ease;
        cursor: pointer;
    }

    /* 수정 버튼 */
    .btn-admin-edit { color: #4A90E2; }
    .btn-admin-edit:hover { color: #235fa7; transform: translateY(-1px); }

    /* 삭제 버튼 */
    .btn-admin-del { color: #E94E4E; }
    .btn-admin-del:hover { color: #b33232; transform: translateY(-1px); }

    /* 세로 구분선 */
    .divider-v {
        width: 1px;
        height: 12px;
        background: #eee;
        margin: 0 8px;
    }

    /* 아이콘 크기 미세조정 */
    .admin-btn-group i {
        font-size: 12px;
    }

    @media (max-width: 767px) {
        .admin-manage-wrap {
            margin-bottom: 50px;
        }
    }
    
    .admin-category-badge {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        background-color: #f8f9fa; /* 아주 연한 회색 */
        padding: 4px 10px;
        border-radius: 4px;
        border: 1px solid #e9ecef;
    }

    /* ADMIN 태그 부분 */
    .admin-tag {
        font-size: 9px;
        font-weight: 800;
        color: #fff;
        background-color: var(--dark-wood); /* 브랜드 컬러 사용 */
        padding: 1px 5px;
        border-radius: 2px;
        letter-spacing: 0.5px;
    }

    /* 텍스트 부분 */
    .category-id-text {
        font-size: 11px;
        color: #666;
        letter-spacing: -0.2px;
    }

    .category-id-text strong {
        color: #333;
        margin-left: 2px;
    }
    .product-img-container {
        width: 100%; 
        margin: 0;
    }
    
    .sticky-sidebar {
        padding: 40px 25px;
        min-height: 550px;
    }

    @media (min-width: 768px) {
        .row { align-items: flex-start; }
    }
    
    
</style>

<div class="container mt-5 mb-5">
    <div class="row">
        
        <div class="col-md-6">
            <div class="product-img-container">
                <img src="${pageContext.request.contextPath}/img/${pdto.pimage}" class="shadow-sm">
            </div>
            <div class="d-block d-md-none"></div>
        </div>

        <div class="col-md-4">
        	
        	<%-- 카테고리 ID 표시 부분 (관리자만 보이게) --%>
			<c:if test="${not empty sessionScope.loginuser and sessionScope.loginuser.userid eq 'admin'}">
			    <div class="admin-category-badge mb-2">
			        <span class="admin-tag">ADMIN</span>
			        <span class="category-id-text">Category ID : <strong>${pdto.fk_category_id}</strong></span>
			    </div>
			</c:if>
			<%-- 카테고리 ID 표시 부분 (관리자만 보이게) --%>
			
			<%-- 상품 설명 --%>
            <div class="sticky-sidebar">
                <h2 class="font-weight-bold mb-4">${pdto.product_name}</h2>
                <div class="price-box mb-5">
                    <div class="text-muted mb-1" style="text-decoration: line-through;">
                        <fmt:formatNumber value="${pdto.list_price}" pattern="###,###" />원
                    </div>
                    <div class="text-danger font-weight-bold" style="font-size: 2.2rem;">
                        <fmt:formatNumber value="${pdto.sale_price}" pattern="###,###" />원
                    </div>
                </div>
                
                <!-- 
                <p class="mt-4 p-3 bg-light rounded" style="min-height: 100px;">
	                ${pdto.product_description}
	            </p>
				 -->
				<%-- ------------------------------------------------------------------------------------------------------ --%> 
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
				<%-- ------------------------------------------------------------------------------------------------------ --%>
                <c:if test="${pdto.stock > 0}">
                    <div class="mb-5 p-3 border rounded bg-light d-flex justify-content-between align-items-center">
                        <label for="order_qty" class="font-weight-bold">수량</label>
                        <div class="input-group" style="width: 120px;">
                            <div class="input-group-prepend">
                                <button class="btn btn-outline-secondary btn-sm" type="button" onclick="changeQty(-1)">-</button>
                            </div>
                            <input type="number" id="order_qty" name="order_qty" class="form-control text-center" 
				                   value="1" min="1" max="${pdto.stock}" onchange="checkStock(this)">
				            <div class="input-group-append">
				                <button class="btn btn-outline-secondary" type="button" onclick="changeQty(1)">+</button>
				            </div>
                        </div>
                    </div>
                </c:if>
                <%-- ------------------------------------------------------------------------------------------------------ --%>
				<div class="d-flex mt-2" style="gap: 10px; align-items: center;">
				
                <button type="button" class="btn btn-outline-secondary p-0 wish-btn-${pdto.product_id}" 
		            style="flex: 1; height: 50px; display: flex; align-items: center; justify-content: center;"
		            onclick="goWish('${pdto.product_id}', '${pageContext.request.contextPath}')">
		        <i class="far fa-heart text-danger wish-icon-${pdto.product_id}" style="font-size: 1.2rem;"></i>
			    </button>
			    
			    <%-- ------------------------------------------------------------------------------------------------------ --%>
			     <c:choose>
				    <c:when test="${pdto.stock > 0}">
					    <button type="button" class="btn btn-outline-secondary p-0 cart-btn-${pdto.product_id}" 
					            style="flex: 1; height: 50px; display: flex; align-items: center; justify-content: center;"
					            onclick="goCart('${pdto.product_id}', document.getElementById('order_qty').value, '<%= ctxPath %>')">
					        <i class="fas fa-shopping-cart cart-icon-bold cart-icon-${pdto.product_id}" style="font-size: 1.2rem;"></i>
					    </button>
				    </c:when>
					<c:otherwise>
				        <button type="button" class="btn btn-outline-secondary p-0 cart-btn-${pdto.product_id}" 
					            style="flex: 1; height: 50px; display: flex; align-items: center; justify-content: center;"
					            onclick="alert('죄송합니다. 해당 상품은 현재 품절되어 장바구니에 담을 수 없습니다.')">
				        	<i class="fas fa-shopping-cart cart-icon-bold cart-icon-${pdto.product_id}" style="font-size: 1.2rem;"></i>
				        </button>
				    </c:otherwise>
				</c:choose>
			    <%-- ------------------------------------------------------------------------------------------------------ --%>
			    
			    <button class="btn btn-dark" style="flex: 3; height: 50px; font-weight: bold;" ${pdto.stock == 0 ? 'disabled' : ''} 
			            onclick="buyProduct('${pdto.product_id}', '${pdto.product_name}')">
			        ${pdto.stock == 0 ? '품절' : '바로 구매하기'}
			    </button>
			    
                </div>
                <%-- ------------------------------------------------------------------------------------------------------ --%>
                <%-- 관리자 전용 상품 수정&삭제 버튼 --%>
				<c:if test="${sessionScope.loginuser.userid == 'admin'}">
				    <div class="admin-manage-wrap mt-5 mb-4">
				        <div class="d-flex align-items-center justify-content-end" style="gap: 12px;">
				            <span class="admin-badge">ADMIN ONLY</span>
				            
				            <div class="admin-btn-group">
				                <button type="button" class="btn-admin-edit" 
				                        onclick="location.href='<%= ctxPath%>/admin/productUpdate.sp?product_id=${pdto.product_id}'"
				                        title="상품 정보 수정">
				                    <i class="fas fa-pen"></i>
				                    <span>Edit</span>
				                </button>
				                
				                <div class="divider-v"></div>
				                
				                <button type="button" class="btn-admin-del" 
				                        onclick="delProduct('${pdto.product_id}', '${pdto.product_name}')"
				                        title="상품 삭제">
				                    <i class="fas fa-trash-alt"></i>
				                    <span>Delete</span>
				                </button>
				            </div>
				        </div>
				    </div>
				</c:if>
                <%-- 관리자 전용 상품 수정&삭제 버튼 --%>
            </div>
            <%-- 상품 설명 --%>
        </div>

        <div class="col-md-6">
            <div class="product-description">
                <h5 class="font-weight-bold">상품 상세정보</h5>
                <hr>
                <p class="text-muted" style="line-height: 1.8;">${pdto.product_description}</p>
            </div>

            <%-- 이 부분부터 수정된 리뷰 리스트 영역입니다 --%>
			<div class="review-container mb-5">
			    <h4 class="font-weight-bold mb-4">Review (${allReviews.size()})</h4>
			    <div id="review-list">
			        <c:choose>
			            <c:when test="${empty allReviews}">
			                <div style="padding:22px 0; color:#666; font-size:13px;">등록된 리뷰가 없습니다.</div>
			            </c:when>
			            <c:otherwise>
			                <c:forEach var="r" items="${allReviews}">
			                    <div class="review-item" style="border-bottom: 1px solid #eee; padding: 20px 0; display: flex;">
			                        <%-- 왼쪽: 작성자 및 날짜 --%>
			                        <div class="r-left" style="width: 150px;">
			                            <div style="display:flex; gap:8px; align-items:center;">
			                                <%-- DTO 필드명 fk_member_id와 일치시킴 --%>
			                                <div style="font-weight:700; color:#111;">${r.fk_member_id}</div>
			                            </div>
			                            <%-- DTO 필드명 review_date와 일치시킴 --%>
			                            <div style="font-size: 12px; color: #999;">${r.review_date}</div>
			                        </div>
			
			                        <%-- 오른쪽: 평점 및 내용 --%>
			                        <div class="r-right" style="flex: 1; padding-left: 20px;">
			                            <a href="${pageContext.request.contextPath}/reviewView.sp?reviewId=${r.review_id}"
			                               style="display:block; color:inherit; text-decoration: none;">
			                                <div class="r-top" style="margin-bottom: 10px;">
			                                    <span class="stars" style="color: #ffc107;">
			                                        <c:forEach var="i" begin="1" end="5">
			                                            <c:choose>
			                                                <%-- DTO 필드명 rating과 일치시킴 --%>
			                                                <c:when test="${i <= r.rating}">
			                                                    <span class="star">★</span>
			                                                </c:when>
			                                                <c:otherwise>
			                                                    <span class="star" style="color: #ddd;">★</span>
			                                                </c:otherwise>
			                                            </c:choose>
			                                        </c:forEach>
			                                    </span>
			                                    <span style="font-weight: bold; margin-left: 10px;">${r.review_title}</span>
			                                </div>
			
			                                <%-- DTO 필드명 review_content와 일치시킴 --%>
			                                <div class="r-content" style="font-size: 14px; line-height: 1.6;">${r.review_content}</div>
			
			                                <div class="r-actions" style="margin-top: 15px; font-size: 12px; color: #888;">
			                                    <span>💬 댓글 0</span>
			                                    <span style="margin: 0 10px;">|</span>
			                                    <span>⚑ 신고</span>
			                                </div>
			                            </a>
			                        </div>
			                    </div>
			                </c:forEach>
			            </c:otherwise>
			        </c:choose>
			    </div>
			    
			    <div class="mt-4">
			        <a href="${pageContext.request.contextPath}/reviewWrite.sp?product_id=${pdto.product_id}"
			           class="btn btn-dark shadow review-float-btn" id="reviewFloatBtn">
			           리뷰 작성
			        </a>
			    </div>
			</div>
			<%-- 리뷰 섹션 끝 --%>
            
            
            
            
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

function changeQty(num) {
    const qtyInput = document.getElementById("order_qty");
    let currentQty = parseInt(qtyInput.value);
    const maxStock = parseInt("${pdto.stock}");
    currentQty += num;
    if (currentQty < 1) currentQty = 1;
    if (currentQty > maxStock) currentQty = maxStock;
    qtyInput.value = currentQty;
}

function buyProduct(id, name) {
    const qty = document.getElementById("order_qty").value;
    if(confirm("[" + name + "] 상품 " + qty + "개를 바로 구매하시겠습니까?")) {
        location.href = "${pageContext.request.contextPath}/product/orderForm.sp?product_id=" + id + "&qty=" + qty;
    }
}

function submitReview() {
    // Ajax 후기 등록 로직 (필요 시 구현)
    alert("후기 등록 기능이 호출되었습니다.");
}

</script>
<jsp:include page="../footer.jsp" />