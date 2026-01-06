<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../header.jsp" />

<script src="${pageContext.request.contextPath}/js/ih_product/product.js"></script>

<style>
    .cart-img { width: 100px; height: 100px; object-fit: cover; border-radius: 8px; }
    .table td { vertical-align: middle !important; }
    .qty-input { width: 50px; text-align: center; border: 1px solid #ddd; }
    .total-section { background-color: #f8f9fa; padding: 20px; border-radius: 10px; }
    .cart-checkbox { width: 18px; height: 18px; cursor: pointer; }
</style>

<div class="container mt-5">
    <h2 class="mb-4">🛒 장바구니</h2>

    <div class="row">
        <div class="col-lg-9">
            <div class="mb-2">
                <button type="button" class="btn btn-outline-secondary btn-sm" 
                        onclick="deleteSelected('${pageContext.request.contextPath}')">선택 삭제</button>
            </div>
            
            <table class="table table-hover">
                <thead class="thead-light">
                    <tr>
                        <th style="width: 50px;">
                            <input type="checkbox" id="checkAll" class="cart-checkbox">
                        </th>
                        <th>이미지</th>
                        <th>상품명</th>
                        <th>판매가</th>
                        <th>수량</th>
                        <th>합계</th>
                        <th>삭제</th>
                    </tr>
                </thead>
                <tbody>
                    <c:if test="${not empty cartList}">
                        <c:set var="totalSum" value="0" />
                        <c:forEach var="cart" items="${cartList}">
                            <tr>
                                <td>
                                    <input type="checkbox" name="cartCheck" class="cart-checkbox chk" value="${cart.cart_id}">
                                </td>
                                <td>
                                    <img src="${pageContext.request.contextPath}/img/${cart.pdto.pimage}" class="cart-img">
                                </td>
                                <td>
                                    <strong>${cart.pdto.product_name}</strong>
                                </td>
                                <td>
                                    <fmt:formatNumber value="${cart.pdto.sale_price}" pattern="#,###" />원
                                </td>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <button class="btn btn-sm btn-light border" 
                                                onclick="updateQty('${cart.cart_id}', -1, '${pageContext.request.contextPath}')">-</button>
                                        
                                        <input type="text" class="qty-input mx-2" value="${cart.cart_qty}" readonly>
                                        
                                        <button class="btn btn-sm btn-light border" 
                                                onclick="updateQty('${cart.cart_id}', 1, '${pageContext.request.contextPath}')">+</button>
                                    </div>
                                </td>
                                <td>
                                    <fmt:formatNumber value="${cart.pdto.sale_price * cart.cart_qty}" pattern="#,###" />원
                                </td>
                                <td>
                                    <button class="btn btn-sm btn-outline-danger" 
                                            onclick="deleteCart('${cart.cart_id}', '${pageContext.request.contextPath}')">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </td>
                            </tr>
                            <c:set var="totalSum" value="${totalSum + (cart.pdto.sale_price * cart.cart_qty)}" />
                        </c:forEach>
                    </c:if>
                    
                    <c:if test="${empty cartList}">
                        <tr>
                            <td colspan="7" class="text-center py-5">장바구니가 비어 있습니다.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <div class="col-lg-3">
            <div class="total-section shadow-sm">
                <h4>주문 요약</h4>
                <hr>
                <div class="d-flex justify-content-between mb-2">
                    <span>상품 금액</span>
                    <span><fmt:formatNumber value="${totalSum}" pattern="#,###" />원</span>
                </div>
                <div class="d-flex justify-content-between mb-2">
                    <span>배송비</span>
                    <span>
                        <c:choose>
                            <c:when test="${totalSum >= 50000 || totalSum == 0}">0원</c:when>
                            <c:otherwise>3,000원</c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <hr>
                <div class="d-flex justify-content-between mb-4">
                    <strong>총 결제금액</strong>
                    <strong class="text-danger" style="font-size: 1.2rem;">
                        <fmt:formatNumber value="${totalSum + (totalSum >= 50000 || totalSum == 0 ? 0 : 3000)}" pattern="#,###" />원
                    </strong>
                </div>
                <button class="btn btn-primary btn-block btn-lg" onclick="goOrder()">주문하기</button>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function() {
        // [전체 선택] 체크박스
        $("#checkAll").click(function() {
            $(".chk").prop("checked", $(this).is(":checked"));
        });

        // [개별 체크박스] 클릭 시 전체 선택 체크박스 상태 업데이트
        $(document).on("click", ".chk", function() {
            let total = $(".chk").length;
            let checked = $(".chk:checked").length;
            $("#checkAll").prop("checked", total === checked);
        });
    });

    // 주문 페이지 이동
    function goOrder() {
        if($(".chk").length == 0) {
            alert("장바구니에 담긴 상품이 없습니다.");
            return;
        }
        location.href = "${pageContext.request.contextPath}/order/checkout.sp";
    }
</script>

<jsp:include page="../footer.jsp" />