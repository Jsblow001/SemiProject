<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<% String ctxPath = request.getContextPath(); %>    

<jsp:include page="../header.jsp" />

<style>
    .borderless td, .borderless th { border: none; }
    .qty-display { font-weight: bold; color: #dc3545; }
</style>

<script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>

<div class="container mt-5">
    <h2 class="mb-4 text-center">ORDER SHEET</h2>
    
    <form name="orderFrm" action="<%= ctxPath %>/product/orderAdd.sp" method="POST">
        
        <input type="hidden" name="orderType" value="${orderType}" />
        <c:if test="${orderType eq 'direct'}">
            <input type="hidden" name="product_id" value="${pdto.product_id}" />
            <input type="hidden" name="qty" value="${qty}" />
        </c:if>
        <c:if test="${orderType eq 'cart'}">
            <input type="hidden" name="cartIds" value="${param.cartIds}" />
        </c:if>

        <div class="row">
            <div class="col-md-8">
                <div class="card mb-4 shadow-sm">
                    <div class="card-header bg-dark text-white">배송 정보</div>
                    <div class="card-body">
                        <div class="form-group">
                            <label for="receiver_name">수령인</label>
                            <input type="text" id="receiver_name" name="receiver_name" class="form-control" value="${loginuser.name}" required>
                        </div>
                        
                        <div class="form-group">
						    <label for="receiver_mobile">연락처</label>
						    <input type="tel" id="receiver_mobile" name="receiver_mobile" 
						           class="form-control" value="${loginuser.mobile}" 
						           placeholder="010-0000-0000"
						           maxlength="13"
						           oninput="this.value = this.value.replace(/[^0-9]/g, '')" <%-- 숫자 이외 제거 --%>
						           onkeyup="autoHyphen(this)" <%-- 하이픈 자동 삽입 --%>
						           required>
						    <small class="text-muted">숫자만 입력하시면 하이픈(-)이 자동으로 삽입됩니다.</small>
						</div>
                        
                        <div class="form-group">
                            <label for="fk_addr_id">배송지 선택</label>
                            <div class="d-flex gap-2 mb-2">
                                <select name="fk_addr_id" id="fk_addr_id" class="form-control">
                                    <c:if test="${not empty addrList}">
                                        <c:forEach var="addr" items="${addrList}">
                                            <option value="${addr.addr_id}">
                                                [${addr.postcode}] ${addr.address} ${addr.detailaddress} ${addr.extraaddress}
                                            </option>
                                        </c:forEach>
                                    </c:if>
                                    <c:if test="${empty addrList}">
                                        <option value="">등록된 배송지가 없습니다. 주소를 등록해주세요.</option>
                                    </c:if>
                                </select>
                                <button type="button" class="btn btn-outline-primary" style="white-space: nowrap;" 
                                        onclick="openAddressPopup('<%=request.getContextPath()%>')">새 주소 등록</button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card shadow-sm">
                    <div class="card-header bg-dark text-white">주문 상품 정보</div>
                    <div class="card-body">
                        <table class="table borderless">
                            <%-- 1. 바로 구매 상품 출력 --%>
                            <c:if test="${orderType eq 'direct'}">
                                <tr>
                                    <td width="100"><img src="<%=ctxPath%>/img/${pdto.pimage}" class="img-fluid rounded"></td>
                                    <td class="align-middle">
                                        <strong>${pdto.product_name}</strong><br>
                                        <span class="text-muted">수량: <span class="qty-display">${qty}</span>개</span>
                                    </td>
                                    <td class="text-right align-middle">
                                        <fmt:formatNumber value="${pdto.sale_price}" pattern="#,###"/>원
                                    </td>
                                </tr>
                            </c:if>
                
                            <%-- 2. 장바구니 상품 출력 --%>
                            <c:if test="${orderType eq 'cart'}">
                                <c:forEach var="map" items="${orderList}">
                                    <tr>
                                        <td width="100"><img src="<%=ctxPath%>/img/${map.pimage}" class="img-fluid rounded"></td>
                                        <td class="align-middle">
                                            <strong>${map.product_name}</strong><br>
                                            <span class="text-muted">수량: <span class="qty-display">${map.cart_qty}</span>개</span>
                                        </td>
                                        <td class="text-right align-middle">
                                            <fmt:formatNumber value="${map.sale_price}" pattern="#,###"/>원
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:if>
                        </table>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card shadow-sm">
                    <div class="card-header bg-danger text-white">결제 금액</div>
                    <div class="card-body">
                        <div class="d-flex justify-content-between mb-2">
                            <span>총 상품금액</span>
                            <span><fmt:formatNumber value="${totalPrice}" pattern="#,###"/>원</span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span>배송비</span>
                            <span>0원 (무료)</span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span>적립 예정 포인트</span>
                            <span class="text-info">+<fmt:formatNumber value="${totalPoint}" pattern="#,###"/>P</span>
                        </div>
                        <hr>
                        <div class="d-flex justify-content-between mb-4">
                            <strong>최종 결제금액</strong>
                            <strong class="text-danger" style="font-size: 1.2rem;">
                                <fmt:formatNumber value="${totalPrice}" pattern="#,###"/>원
                            </strong>
                        </div>
                        <button type="button" id="btnOrderPayment" class="btn btn-primary btn-lg btn-block" onclick="goOrderPayment()">
                            <fmt:formatNumber value="${totalPrice}" pattern="#,###"/>원 결제하기
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </form>
</div>    

<script type="text/javascript">
    
    function goOrderPayment() {
        // 유효성 검사
        const addrId = document.getElementById("fk_addr_id").value;
        if(!addrId || addrId == "") {
            alert("배송지를 선택하거나 등록해 주세요.");
            return;
        }
    
        const receiverName = document.getElementById("receiver_name").value;
        if(!receiverName || receiverName.trim() == "") {
            alert("수령인 성함을 입력해주세요.");
            document.getElementById("receiver_name").focus();
            return;
        }
    
        const receiverMobile = document.getElementById("receiver_mobile").value;
        const regExp_mobile = /^(01[016789]{1}|02|0[3-9]{1}[0-9]{1})-[0-9]{3,4}-[0-9]{4}$/;
        if (!regExp_mobile.test(receiverMobile)) {
            alert("연락처 형식이 올바르지 않습니다. (예: 010-1234-5678)");
            document.getElementById("receiver_mobile").focus();
            return;
        }
        
        if(!confirm("주문을 진행하시겠습니까?")) return;
        
        // 결제 정보 설정
        const orderType = "${orderType}";
        let pName = "";
        
        if(orderType === "direct") {
            pName = "${pdto.product_name}";
        } else {
            pName = "장바구니 주문 상품 외"; 
        }
        
        const totalPrice = "${totalPrice}"; 
        
        // 결제 실행
        var IMP = window.IMP; 
        IMP.init("imp46782436"); 

        IMP.request_pay({
            pg : 'html5_inicis', 
            pay_method : 'card',
            merchant_uid : 'merchant_' + new Date().getTime() + '_' + "${loginuser.userid}",
            name : pName,
            amount : 100, // 실제시 totalPrice 넣기 - 테스트시, 100원 결제되도록 설정함
            buyer_email : '${loginuser.email}',
            buyer_name : userName,
            buyer_tel : receiverMobile
        }, function(rsp) {
            if ( rsp.success ) {
                alert("결제가 완료되었습니다.");
                
                const btnPayment = document.getElementById("btnOrderPayment");
                btnPayment.disabled = true;
                btnPayment.innerText = "주문 처리 중...";
                
                document.orderFrm.submit(); 
            } else {
                alert("결제에 실패하였습니다. 사유: " + rsp.error_msg);
            }
        });
    }
    
    // 배송지 등록 팝업
    function openAddressPopup(ctxPath) {
        const url = ctxPath + "/product/addressRegister.sp";
        const width = 800; const height = 600;
        const left = (window.screen.width / 2) - (width / 2);
        const top = (window.screen.height / 2) - (height / 2);
        window.open(url, "addressRegisterPopup", `width=${width},height=${height},left=${left},top=${top},resizable=yes`);
    }

    // 팝업 성공 후 호출
    function refreshAddress() {
        location.reload(); 
    }
    
 	// 연락처 하이픈(-) 자동 완성 기능
    function autoHyphen(target) {
        target.value = target.value
            .replace(/[^0-9]/g, '') // 숫자가 아닌 문자 제거
            .replace(/^(\d{2,3})(\d{3,4})(\d{4})$/, `$1-$2-$3`) // 11자리 (010-1234-5678)
            .replace(/^(\d{2,3})(\d{3})(\d{4})$/, `$1-$2-$3`);  // 10자리 (02-123-4567)
    }
</script>

<jsp:include page="../footer.jsp" />