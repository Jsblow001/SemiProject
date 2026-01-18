<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../header.jsp" />

<style>
    .cart-img { width: 100px; height: 100px; object-fit: cover; border-radius: 8px; }
    /* 판매 중지 상품 이미지 흑백 처리 */
    .cart-img.disabled { filter: grayscale(100%); opacity: 0.6; }
    .table td { vertical-align: middle !important; }
    .qty-input { width: 50px; text-align: center; border: 1px solid #ddd; }
    .total-section { background-color: #f8f9fa; padding: 20px; border-radius: 10px; }
    .cart-checkbox { width: 18px; height: 18px; cursor: pointer; }
    .status-badge { font-size: 0.75rem; padding: 3px 8px; border-radius: 12px; }
</style>

<div class="container mt-5">
    <h2 class="mb-4">🛒 장바구니</h2>

    <div class="row">
        <div class="col-lg-9">
            <table class="table table-hover">
                <thead class="thead-light">
                    <tr>
                        <th style="width: 50px;">
                            <input type="checkbox" id="checkAll" class="cart-checkbox" checked>
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
                        <c:forEach var="cart" items="${cartList}">
                            <tr <c:if test="${cart.pdto.pstatus == 0}">style="background-color: #fcfcfc;"</c:if>>
                                <td>
                                    <c:choose>
                                        <c:when test="${cart.pdto.pstatus == 1}">
                                            <input type="checkbox" name="cartCheck" class="cart-checkbox chk" 
                                                   value="${cart.cart_id}" 
                                                   data-unit-price="${cart.pdto.sale_price}"
                                                   data-price="${cart.pdto.sale_price * cart.cart_qty}" checked>
                                        </c:when>
                                        <c:otherwise>
                                            <%-- 판매중지 상품은 체크 불가능 --%>
                                            <input type="checkbox" class="cart-checkbox" disabled>
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <td>
                                    <img src="${pageContext.request.contextPath}/img/${cart.pdto.pimage}" 
                                         class="cart-img ${cart.pdto.pstatus == 0 ? 'disabled' : ''}">
                                </td>
                                <td>
                                    <strong>${cart.pdto.product_name}</strong>
                                    <c:if test="${cart.pdto.pstatus == 0}">
                                        <br><span class="badge badge-secondary status-badge">판매 종료</span>
                                    </c:if>
                                </td>
                                <td>
                                    <fmt:formatNumber value="${cart.pdto.sale_price}" pattern="#,###" />원
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${cart.pdto.pstatus == 1}">
                                            <div class="d-flex align-items-center">
                                                <button class="btn btn-sm btn-light border" 
                                                        onclick="updateQty('${cart.cart_id}', -1, '${pageContext.request.contextPath}')">-</button>
                                                <input type="text" class="qty-input mx-2" value="${cart.cart_qty}" readonly>
                                                <button class="btn btn-sm btn-light border" 
                                                        onclick="updateQty('${cart.cart_id}', 1, '${pageContext.request.contextPath}')">+</button>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">구매불가</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:if test="${cart.pdto.pstatus == 1}">
                                        <fmt:formatNumber value="${cart.pdto.sale_price * cart.cart_qty}" pattern="#,###" />원
                                    </c:if>
                                    <c:if test="${cart.pdto.pstatus == 0}">-</c:if>
                                </td>
                                <td>
                                    <button class="btn btn-sm btn-outline-danger" 
                                            onclick="deleteCart('${cart.cart_id}', '${pageContext.request.contextPath}')">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </td>
                            </tr>
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
                    <span id="display-totalSum">0원</span> 
                </div>
                <div class="d-flex justify-content-between mb-2">
                    <span>배송비</span>
                    <span id="display-delivery">0원</span> 
                </div>
                <hr>
                <div class="d-flex justify-content-between mb-4">
                    <strong>총 결제금액</strong>
                    <strong id="display-finalPrice" class="text-danger" style="font-size: 1.2rem;">0원</strong> 
                </div>
                <button class="btn btn-primary btn-block btn-lg" onclick="goOrder()">주문하기</button>
            </div>
        </div>
    </div>
</div>

<script>
    $(document).ready(function() {
        calculateTotal();

        $("#checkAll").on("click", function() {
            // disabled가 아닌 체크박스만 선택
            $(".chk").not(":disabled").prop("checked", $(this).is(":checked"));
            calculateTotal();
        });

        $(document).on("click", ".chk", function() {
            let total = $(".chk").not(":disabled").length;
            let checked = $(".chk:checked").length;
            $("#checkAll").prop("checked", total === checked);
            calculateTotal();
        });
    });

    function calculateTotal() {
        let totalSum = 0;
        $(".chk:checked").each(function() {
            let price = $(this).attr("data-price");
            if(price) totalSum += parseInt(price);
        });

        let delivery = (totalSum > 0 && totalSum < 50000) ? 3000 : 0;
        let finalPrice = totalSum + delivery;

        $("#display-totalSum").text(totalSum.toLocaleString() + "원");
        $("#display-delivery").text(delivery.toLocaleString() + "원");
        $("#display-finalPrice").text(finalPrice.toLocaleString() + "원");
    }

    function goOrder() {
        let checkCnt = $(".chk:checked").length;
        if(checkCnt == 0) {
            alert("주문할 상품을 선택하세요.");
            return;
        }

        let cartIdArr = [];
        $(".chk:checked").each(function() {
            cartIdArr.push($(this).val());
        });
        
        let cartIds = cartIdArr.join(","); 
        
        if(confirm("선택하신 " + checkCnt + "개의 상품을 주문하시겠습니까?")) {
            location.href = "${pageContext.request.contextPath}/product/orderForm.sp?cartIds=" + cartIds;
        }
    }
</script>

<jsp:include page="../footer.jsp" />