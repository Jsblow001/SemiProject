<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<% String ctxPath = request.getContextPath(); %>
<jsp:include page="../header2.jsp" />

<style>
    /* 이미지 높이 및 크기 고정 */
    .admin-prod-img {
        width: 70px;
        height: 70px;
        object-fit: cover; 
        border-radius: 8px;
        transition: transform 0.2s;
    }
    .admin-prod-img:hover {
        transform: scale(1.1);
    }
   
    /* 테이블 행 높이 및 중앙 정렬 */
    .table td {
        vertical-align: middle !important;
        height: 90px;
    }

    /* 카테고리 필터 버튼 스타일 */
    .filter-container {
        display: flex;
        justify-content: center;
        gap: 10px;
        margin-bottom: 30px;
    }
    .filter-btn {
        min-width: 120px;
        border-radius: 25px;
        font-weight: 600;
        transition: all 0.3s;
    }
    .filter-btn:hover {
        box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    }
    
    /* 테이블 커스텀 */
    .table-container {
        background: white;
        padding: 20px;
        border-radius: 15px;
        box-shadow: 0 5px 15px rgba(0,0,0,0.05);
    }
</style>

<div class="container-fluid mt-5 px-5">
    <div class="d-flex justify-content-between align-items-center mb-5">
        <h2 class="font-weight-bold"><i class="fas fa-user mr-2"></i>상품관리 (관리자 모드)</h2>
        <a href="${pageContext.request.contextPath}/admin/productRegister.sp" class="btn btn-dark px-4 shadow-sm">
            <i class="fas fa-plus mr-1"></i> 상품 등록
        </a>
    </div>

    <div class="filter-container">
        <%-- currentCategory는 Controller에서 넘겨준 값 --%>
        <a href="allproductList.sp" 
           class="btn filter-btn ${empty currentCategory ? 'btn-dark' : 'btn-outline-dark'}">전체보기</a>
        
        <a href="allproductList.sp?category=1" 
           class="btn filter-btn ${currentCategory == '1' ? 'btn-dark' : 'btn-outline-dark'}">SUNGLASSES</a>
        
        <a href="allproductList.sp?category=2" 
           class="btn filter-btn ${currentCategory == '2' ? 'btn-dark' : 'btn-outline-dark'}">EYEGLASSES</a>
        
        <a href="allproductList.sp?category=3" 
           class="btn filter-btn ${currentCategory == '3' ? 'btn-dark' : 'btn-outline-dark'}">ACCESSORY</a>
        
        <a href="allproductList.sp?category=4" 
           class="btn filter-btn ${currentCategory == '4' ? 'btn-dark' : 'btn-outline-dark'}">COLLABORATION</a>
    </div>

    <div class="table-container">
        <table class="table table-hover text-center">
            <thead class="thead-light">
                <tr>
                    <th style="width: 80px;">ID</th>
                    <th style="width: 120px;">이미지</th>
                    <th>상품명</th>
                    <th style="width: 150px;">판매가</th>
                    <th style="width: 120px;">재고</th>
                    <th style="width: 200px;">관리</th>
                </tr>
            </thead>
            <tbody>
                <c:if test="${not empty productList}">
                    <c:forEach var="p" items="${productList}">
                        <tr>
                            <td>${p.product_id}</td>
                            <td>
							    <a href="${pageContext.request.contextPath}/product/productDetail.sp?product_id=${p.product_id}">
							        <img src="${pageContext.request.contextPath}/img/${p.pimage}" class="admin-prod-img border shadow-sm">
							    </a>
							</td>
                            <td class="text-left">
							    <span class="badge badge-secondary mb-1">${p.fk_category_id}</span><br>
							    <a href="${pageContext.request.contextPath}/product/productDetail.sp?product_id=${p.product_id}" class="text-dark font-weight-bold" style="text-size: 1.1rem; text-decoration: none;">
							        ${p.product_name}
							    </a>
							</td>
                            <td>
                                <span class="text-muted small" style="text-decoration: line-through;">
                                    <fmt:formatNumber value="${p.list_price}" pattern="#,###"/>원
                                </span><br>
                                <span class="text-danger font-weight-bold">
                                    <fmt:formatNumber value="${p.sale_price}" pattern="#,###"/>원
                                </span>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${p.stock == 0}">
                                        <span class="badge badge-danger p-2">품절</span>
                                    </c:when>
                                    <c:when test="${p.stock <= 5}">
                                        <span class="badge badge-warning p-2">임박 (${p.stock})</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="font-weight-bold">${p.stock}</span>개
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="btn-group">
                                    <button class="btn btn-sm btn-outline-primary px-3" 
                                            onclick="location.href='<%= ctxPath%>/admin/productUpdate.sp?product_id=${p.product_id}'">
                                        <i class="fas fa-edit mr-1"></i>수정
                                    </button>
                                    <button class="btn btn-sm btn-outline-danger px-3" 
                                            onclick="delProduct('${p.product_id}', '${p.product_name}')">
                                        <i class="fas fa-trash-alt mr-1"></i>삭제
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </c:if>
                <c:if test="${empty productList}">
                    <tr>
                        <td colspan="6" class="py-5 text-muted">
                            <i class="fas fa-box-open fa-3x mb-3"></i><br>
                            해당 조건에 맞는 상품이 없습니다.
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

<script>
function delProduct(id, name) {
    if(confirm("[" + name + "] 상품을 정말 삭제하시겠습니까?")) {
        // 실제 삭제를 처리할 Controller 주소로 이동
        location.href = "${pageContext.request.contextPath}/admin/productDelete.sp?product_id=" + id;
    }
}
</script>

<jsp:include page="../footer2.jsp" />