<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String ctxPath = request.getContextPath(); %>

<script type="text/javascript" src="<%= ctxPath%>/js/ih_product/product.js"></script>
<script type="text/javascript" src="<%= ctxPath%>/js/ih_product/product.js?v=<%= System.currentTimeMillis() %>"></script>

<jsp:include page="../header.jsp" />      

<style>
    /* 카드 전체 테두리 둥글게 */
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

    /* 이미지 영역 비율 고정 */
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

    /* 꽉 찬 하트 버튼 스타일 커스텀 */
    .heart-remove-btn {
        background: none;
        border: none;
        font-size: 1.5rem;
        color: #ff4d4d; /* 하트 색상 */
        cursor: pointer;
        transition: transform 0.2s;
        padding: 0;
    }
    .heart-remove-btn:hover {
        transform: scale(1.2);
    }
</style>

<div class="container mt-5">
    <h3 class="text-center my-5">나의 위시리스트</h3>
    
    <div class="row">
        <c:if test="${not empty wishList}">
            <c:forEach var="p" items="${wishList}">
                <div class="col-md-4 mb-4">
                    <div class="card wish-card h-100">
                        <div class="wish-img-box">
                            <img src="${pageContext.request.contextPath}/img/${p.pimage}" alt="${p.product_name}">
                        </div>
                        
                        <div class="card-body">
                            <div class="d-flex align-items-center">
                                
                                <div style="flex: 0 0 70%;" class="pr-2">
                                    <h6 class="card-title mb-1 text-truncate" style="font-weight: 600;">
                                        ${p.product_name}
                                    </h6>
                                    <p class="card-text text-dark mb-0" style="font-size: 0.95rem;">
                                        ${p.sale_price}원
                                    </p>
                                </div>

                                <div style="flex: 0 0 30%;" class="text-right">
                                    <button type="button" class="heart-remove-btn" 
                                            onclick="goWish('${p.product_id}', '${pageContext.request.contextPath}')"
                                            title="찜 해제">
                                        <i class="fas fa-heart"></i> </button>
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