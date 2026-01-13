<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<% String ctxPath = request.getContextPath(); %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>관리자 | 상품관리</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

<style>
    body {
        font-family: 'Pretendard', Arial, sans-serif;
        background-color: #f7f6f3;
        color: #333;
    }
    
    .container-custom {
        width: 1200px;
        margin: 60px auto;
        background-color: #fff;
        padding: 40px;
        border-radius: 4px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.06);
    }

    /* ===== 상단 타이틀 영역 ===== */
    .admin-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 40px;
    }
    
    .admin-header h3 {
        font-size: 18px;
        font-weight: 700;
        letter-spacing: -0.3px;
        color: #2f2b2a;
        margin: 0;
    }

    .btn-register {
        padding: 10px 18px;
        background-color: #3e3a39 !important;
        color: #fff !important;
        text-decoration: none;
        border-radius: 3px;
        font-size: 14px;
        font-weight: 600;
        transition: background-color 0.2s ease;
    }
    
    .btn-register:hover {
        background-color: #2f2b2a !important;
    }

    .filter-area {
        background: #fff;
        padding: 20px;
        border-radius: 4px;
        margin-bottom: 30px;
        border: 1px solid #eee;
        display: flex;
        justify-content: center;
        gap: 8px;
    }

    .filter-btn {
        padding: 8px 20px;
        border: 1px solid #ddd;
        background: #fff;
        color: #666;
        font-size: 13px;
        font-weight: 600;
        border-radius: 20px;
        text-decoration: none;
        transition: all 0.2s;
    }

    .filter-btn:hover {
        background: #f2f1ee;
        color: #333;
    }

    .filter-btn.active {
        background: #6d4c41;
        color: #fff;
        border-color: #6d4c41;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        font-size: 14px;
    }
    
    thead th {
        background-color: #f2f1ee;
        font-weight: 600;
        color: #555;
        padding: 14px 10px;
        border-bottom: 2px solid #ddd;
    }
    
    tbody td {
        padding: 15px 10px;
        border-bottom: 1px solid #eee;
        color: #444;
        vertical-align: middle;
        text-align: center;
    }
    
    tbody tr:hover {
        background-color: #faf9f7;
    }

    /* 상품 이미지 */
    .admin-prod-img {
        width: 60px;
        height: 60px;
        object-fit: cover;
        border-radius: 4px;
        border: 1px solid #eee;
    }

    /* 재고/상태 뱃지 */
    .badge-custom {
        display: inline-block;
        padding: 4px 10px;
        border-radius: 3px;
        font-size: 12px;
        font-weight: 600;
    }
    .status-soldout { background: #f8d7da; color: #b71c1c; }
    .status-warning { background: #fff3cd; color: #856404; }
    .status-normal { background: #e2e3e5; color: #383d41; }

    /* 관리 버튼 */
    .action-btns {
        display: flex;
        gap: 5px;
        justify-content: center;
    }
    .btn-edit, .btn-del {
        padding: 6px 12px;
        font-size: 12px;
        border-radius: 3px;
        cursor: pointer;
        border: 1px solid #ddd;
        background: #fff;
        font-weight: 600;
    }
    .btn-edit:hover { background: #f2f1ee; color: #2f2b2a; }
    .btn-del { color: #b71c1c; }
    .btn-del:hover { background: #fff5f5; }

    a.prod-link { color: #333; text-decoration: none; font-weight: 600; }
    a.prod-link:hover { text-decoration: underline; }
</style>
</head>

<body>

<jsp:include page="../header2.jsp" />

<div class="container-custom">
    
    <div class="admin-header">
        <h3>상품 관리</h3>
        <a href="${pageContext.request.contextPath}/admin/productRegister.sp" class="btn-register">
            <i class="fas fa-plus mr-1"></i> 신규 상품 등록
        </a>
    </div>

    <div class="filter-area">
        <a href="allproductList.sp" class="filter-btn ${empty currentCategory ? 'active' : ''}">전체보기</a>
        <a href="allproductList.sp?category=1" class="filter-btn ${currentCategory == '1' ? 'active' : ''}">SUNGLASSES</a>
        <a href="allproductList.sp?category=2" class="filter-btn ${currentCategory == '2' ? 'active' : ''}">EYEGLASSES</a>
        <a href="allproductList.sp?category=3" class="filter-btn ${currentCategory == '3' ? 'active' : ''}">ACCESSORY</a>
        <a href="allproductList.sp?category=4" class="filter-btn ${currentCategory == '4' ? 'active' : ''}">COLLABORATION</a>
    </div>

    <table>
        <thead>
            <thead>
			    <tr>
			        <th style="width: 10%; text-align: center;">ID</th>
			        <th style="width: 20%; text-align: center;">이미지</th>
			        <th style="width: 30%; text-align: center;">상품명</th>
			        <th style="width: 10%; text-align: center;">판매가</th>
			        <th style="width: 10%; text-align: center;">재고</th>
			        <th style="width: 20%; text-align: center;">관리</th>
			    </tr>
			</thead>
        </thead>
        <tbody>
            <c:if test="${not empty productList}">
                <c:forEach var="p" items="${productList}">
                    <tr>
                        <td>${p.product_id}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/product/productDetail.sp?product_id=${p.product_id}">
                                <img src="${pageContext.request.contextPath}/img/${p.pimage}" class="admin-prod-img">
                            </a>
                        </td>
                        <td style="text-align: left; padding-left: 20px;">
                            <small style="color:#999; font-weight: 600;">CAT ${p.fk_category_id}</small><br>
                            <a href="${pageContext.request.contextPath}/product/productDetail.sp?product_id=${p.product_id}" class="prod-link">
                                ${p.product_name}
                            </a>
                        </td>
                        <td>

                            <span style="font-weight: 700; color: #2f2b2a;">
                                <fmt:formatNumber value="${p.sale_price}" pattern="#,###"/>원
                            </span>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${p.stock == 0}">
                                    <span class="badge-custom status-soldout">품절</span>
                                </c:when>
                                <c:when test="${p.stock <= 5}">
                                    <span class="badge-custom status-warning">재고임박 (${p.stock})</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge-custom status-normal">${p.stock}개</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <div class="action-btns">
                                <button type="button" class="btn-edit" onclick="location.href='<%= ctxPath%>/admin/productUpdate.sp?product_id=${p.product_id}'">수정</button>
                                <button type="button" class="btn-del" onclick="delProduct('${p.product_id}', '${p.product_name}')">삭제</button>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
            </c:if>
            <c:if test="${empty productList}">
                <tr>
                    <td colspan="6" style="padding: 60px 0; color: #999;">
                        <i class="fas fa-box-open fa-2x mb-3"></i><br>
                        등록된 상품이 없습니다.
                    </td>
                </tr>
            </c:if>
        </tbody>
    </table>
</div>

<script>
function delProduct(id, name) {
    if(confirm("[" + name + "] 상품을 정말 삭제하시겠습니까?")) {
        location.href = "${pageContext.request.contextPath}/admin/productDelete.sp?product_id=" + id;
    }
}
</script>

<jsp:include page="../footer2.jsp" />

</body>
</html>