<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<% String ctxPath = request.getContextPath(); %>

<script type="text/javascript" src="<%= ctxPath%>/js/ih_product/product.js"></script>

<style>
    /* 상품 아이템 호버 효과 */
    .product-item { transition: transform 0.2s; border-radius: 10px; overflow: hidden; }
    .product-item:hover { transform: translateY(-8px); box-shadow: 0 10px 20px rgba(0,0,0,0.1) !important; }
    
    /* 이미지 박스 설정 (비율 고정) */
    .product-img {
        width: 100%;
        aspect-ratio: 4 / 5; 
        overflow: hidden;
        background-color: #ffffff; /* 공백 부분을 흰색으로 설정 (원하시면 #f8f9fa 등 설정 가능) */
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 10px !important; /* 사진이 테두리에 너무 붙지 않게 여백 추가 */
    }

    /* 이미지 정렬: 잘리지 않고 전체 다 보이기 */
    .product-img img { 
        width: 100%;
        height: 100%;
        /* cover 대신 contain을 사용합니다 */
        object-fit: contain; 
        transition: transform 0.5s; 
    }
    
    .product-item:hover .product-img img { transform: scale(1.08); }
    .text-decoration-none { text-decoration: none !important; }
    
    /* 버튼 스타일 */
    .btn-wish, .btn-cart { border: none; background: none; transition: all 0.2s; }
    .btn-wish:hover i { font-weight: 900; } 
    .btn-cart:hover i { color: #f39c12; }
</style>

<jsp:include page="../header.jsp" />

<div class="container mt-5">
    <div class="text-center mb-5">
        <h2 class="display-4 text-uppercase font-weight-bold">${category}</h2>
        <div class="mx-auto" style="width: 60px; height: 3px; background-color: #333;"></div>
    </div>

    <div class="row px-xl-5">
        <c:if test="${not empty productList}">
            <c:forEach var="p" items="${productList}">
                <div class="col-lg-3 col-md-4 col-sm-6 pb-4">
                    <div class="card product-item border-0 mb-4 h-100 shadow-sm">
                        
                        <div class="card-header product-img position-relative overflow-hidden bg-transparent border p-0">
                            <a href="<%= ctxPath%>/product/productDetail.sp?product_id=${p.product_id}">
                                <img class="img-fluid w-100" src="<%= ctxPath %>/img/${p.pimage}" alt="${p.product_name}">
                            </a>
                        </div>

                        <div class="card-body border-left border-right text-center p-0 pt-4 pb-3">
                            <h6 class="text-truncate mb-3 px-3">
                                <a href="<%= ctxPath%>/product/productDetail.sp?product_id=${p.product_id}" class="text-dark text-decoration-none font-weight-bold">
                                    ${p.product_name}
                                </a>
                            </h6>
                            
                            <a href="<%= ctxPath%>/product/productDetail.sp?product_id=${p.product_id}" class="text-decoration-none">
                                <div class="d-flex justify-content-center">
                                    <h6 class="text-danger font-weight-bold"><fmt:formatNumber value="${p.sale_price}" pattern="#,###" />원</h6>
                                    <c:if test="${p.list_price ne p.sale_price}">
                                        <h6 class="text-muted ml-2"><del><fmt:formatNumber value="${p.list_price}" pattern="#,###" />원</del></h6>
                                    </c:if>
                                </div>
                            </a>
                        </div>

                        <div class="card-footer d-flex justify-content-between bg-white border">
                            
                            <button type="button" class="btn btn-wish p-0 wish-btn-${p.product_id}" 
							        onclick="goWish('${p.product_id}', '${pageContext.request.contextPath}')">
							    <i class="far fa-heart text-danger mr-1 wish-icon-${p.product_id}"></i>
							    <span class="small text-dark">Wish</span>
							</button>
							
							<button type="button" class="btn btn-cart p-0 cart-btn-${p.product_id}" 
							        onclick="goCart('${p.product_id}', '1', '${pageContext.request.contextPath}')">
							    <i class="fas fa-shopping-cart text-dark mr-1 cart-icon-${p.product_id}"></i>
							    <span class="small text-dark">Cart</span>
							</button>
							
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:if>

        <c:if test="${empty productList}">
            <div class="col-12 text-center py-5">
                <h4 class="text-muted">현재 등록된 상품이 없습니다.</h4>
            </div>
        </c:if>
    </div>
</div>

<jsp:include page="../footer.jsp" />

