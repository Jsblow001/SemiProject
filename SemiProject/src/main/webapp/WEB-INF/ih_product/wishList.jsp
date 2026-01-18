<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<% String ctxPath = request.getContextPath(); %>

<script type="text/javascript" src="<%= ctxPath%>/js/ih_product/product.js?v=<%= System.currentTimeMillis() %>"></script>

<jsp:include page="../header.jsp" />      

<style>
    .wish-card {
        border-radius: 15px;
        overflow: hidden;
        border: 1px solid #eee;
        transition: transform 0.2s;
    }
    .wish-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 10px 20px rgba(0,0,0,0.08);
    }

    .wish-img-box {
        width: 100%;
        height: 200px;
        overflow: hidden;
    }
    .wish-img-box img {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    /* 판매 중지 상품 흑백 처리 스타일 */
    .img-disabled {
        filter: grayscale(100%);
        opacity: 0.6;
    }

    .heart-remove-btn, .btn-cart-custom {
        background: none !important;
        border: none !important;
        outline: none !important;
        box-shadow: none !important;
        padding: 0 !important;
        cursor: pointer;
        transition: transform 0.2s ease;
        display: flex;
        align-items: center;
        justify-content: center;
    }
    
    .heart-remove-btn i, .btn-cart-custom i {
        font-size: 1.3rem; 
    }
    
    .heart-remove-btn i { color: #ff4d4d; }
    .btn-cart-custom i { color: #444; }
    
    .heart-remove-btn:hover, .btn-cart-custom:hover { transform: scale(1.15); }

    .wish-action-area {
        display: flex;
        align-items: center;
        justify-content: flex-end;
        gap: 12px;
    }

    /* 커서 스타일 추가 */
    .goDetail { cursor: pointer; }
    .noDetail { cursor: not-allowed; }
</style>

<div class="container mt-5">
    <h3 class="text-center my-5">나의 위시리스트</h3>
    
    <div class="row">
        <c:if test="${not empty wishList}">
            <c:forEach var="p" items="${wishList}">
                <div class="col-md-4 mb-4">
                    <div class="card wish-card h-100">
                        <%-- 1. 이미지 클릭 시 상세 이동 (판매종료 시 alert & 흑백) --%>
                        <div class="wish-img-box">
                            <c:choose>
                                <c:when test="${p.pstatus == 1}">
                                    <img src="${pageContext.request.contextPath}/img/${p.pimage}" alt="${p.product_name}" class="goDetail"
                                         onclick="location.href='${pageContext.request.contextPath}/product/productDetail.sp?product_id=${p.product_id}'">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/img/${p.pimage}" alt="${p.product_name}" class="img-disabled noDetail"
                                         onclick="alert('판매 종료된 상품은 상세페이지로 이동할 수 없습니다.')">
                                </c:otherwise>
                            </c:choose>
                        </div>
                        
                        <div class="card-body">
                            <div class="d-flex align-items-center">
                                
                                <%-- 2. 상품명 클릭 시 상세 이동 (판매종료 시 alert) --%>
                                <div style="flex: 0 0 70%;" class="pr-2">
                                    <c:choose>
                                        <c:when test="${p.pstatus == 1}">
                                            <h6 class="card-title mb-1 text-truncate goDetail" style="font-weight: 600;"
                                                onclick="location.href='${pageContext.request.contextPath}/product/productDetail.sp?product_id=${p.product_id}'">
                                                ${p.product_name}
                                            </h6>
                                        </c:when>
                                        <c:otherwise>
                                            <h6 class="card-title mb-1 text-truncate noDetail text-muted" style="font-weight: 600;"
                                                onclick="alert('판매 종료된 상품입니다.')">
                                                ${p.product_name}
                                            </h6>
                                            <small class="text-danger" style="font-size: 11px; font-weight: bold;">[판매 종료]</small>
                                        </c:otherwise>
                                    </c:choose>
                                    <p class="card-text text-dark mb-0" style="font-size: 0.95rem;">
                                        <fmt:formatNumber value="${p.sale_price}" pattern="#,###" />원
                                    </p>
                                </div>

                                <div style="flex: 0 0 35%;" class="text-right">
                                    <div class="wish-action-area">
                                        <button type="button" class="heart-remove-btn" 
                                                onclick="goWish('${p.product_id}', '${pageContext.request.contextPath}')">
                                            <i class="fas fa-heart"></i>
                                        </button>
                                            
                                        <c:choose>
                                            <%-- 판매중(1)이고 재고가 있을 때만 장바구니 허용 --%>
                                            <c:when test="${p.pstatus == 1 and p.stock > 0}">
                                                <button type="button" class="btn-cart-custom cart-btn-${p.product_id}" 
                                                        onclick="goCart('${p.product_id}', '1', '${pageContext.request.contextPath}')">
                                                    <i class="fas fa-shopping-cart mr-5 ml-2"></i>
                                                </button>
                                            </c:when>

                                            <c:otherwise>
                                                <button type="button" class="btn-cart-custom" 
                                                        style="color: #adb5bd; cursor: not-allowed;"
                                                        onclick="alert('${p.pstatus == 0 ? "죄송합니다. 판매 종료된 상품입니다." : "죄송합니다. 이 상품은 현재 품절되었습니다."}')">
                                                    <i class="fas fa-shopping-cart mr-5 ml-2"></i>
                                                </button>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:if>
        
        <c:if test="${empty wishList}">
            <div class="col-12 text-center py-5">
                <p class="text-muted">찜한 상품이 없습니다.</p>
            </div>
        </c:if>
    </div>
</div>
<jsp:include page="../footer.jsp" />