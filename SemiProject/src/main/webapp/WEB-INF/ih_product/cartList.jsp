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
                            <tr>
                                <td>
                                    <input type="checkbox" name="cartCheck" class="cart-checkbox chk" 
                                           value="${cart.cart_id}" 
                                           data-unit-price="${cart.pdto.sale_price}"
                                           data-price="${cart.pdto.sale_price * cart.cart_qty}" checked>
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

        // [전체 선택] 체크박스 이벤트
        $("#checkAll").on("click", function() {
            $(".chk").prop("checked", $(this).is(":checked"));
            calculateTotal();
        });

        // [개별 체크박스] 클릭 이벤트
        $(document).on("click", ".chk", function() {
            let total = $(".chk").length;
            let checked = $(".chk:checked").length;
            $("#checkAll").prop("checked", total === checked);
            calculateTotal();
        });
    });

    // 실시간 금액 계산 함수
    function calculateTotal() {
        let totalSum = 0;
        
        // 체크된 항목들의 price 합산
        $(".chk:checked").each(function() {
            let price = $(this).attr("data-price");
            if(price) {
                totalSum += parseInt(price);
            }
        });

        // 배송비 계산 (5만원 이상 무료)
        let delivery = 0;
        if(totalSum > 0 && totalSum < 50000) {
            delivery = 3000;
        }

        let finalPrice = totalSum + delivery;

        // 화면 갱신
        $("#display-totalSum").text(totalSum.toLocaleString() + "원");
        $("#display-delivery").text(delivery.toLocaleString() + "원");
        $("#display-finalPrice").text(finalPrice.toLocaleString() + "원");
    }

    // 주문 페이지 이동
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