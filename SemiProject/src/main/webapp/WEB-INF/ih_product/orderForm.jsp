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
        
        <%-- 최종 결제 금액 전송용 hidden 필드 --%>
        <input type="hidden" name="total_price" id="total_price" value="${totalPrice}" />
		
		<input type="hidden" name="product_name" id="product_name" value="" />
		
		<c:if test="${orderType eq 'direct'}">
	        <input type="hidden" name="product_id" value="${pdto.product_id}" />
	        <input type="hidden" name="qty" value="${qty}" />
	        <input type="hidden" name="sale_price" value="${pdto.sale_price}" />
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
						           oninput="this.value = this.value.replace(/[^0-9]/g, '')"
						           onkeyup="autoHyphen(this)"
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

                <%-- 포인트 사용 --%>
                <div class="card mb-4 shadow-sm">
                    <div class="card-header bg-dark text-white">포인트 사용</div>
                    <div class="card-body">
                        <div class="d-flex align-items-center">
						    <input type="number" id="use_point" name="use_point" class="form-control form-control-sm mr-2" 
						           style="width: 120px;" value="0" min="0" max="${loginuser.point}" onchange="calculateFinalPrice()">
						    
						    <button type="button" class="btn btn-outline-dark btn-sm" 
						            style="padding: 2px 8px; font-size: 0.75rem; font-weight: bold;" 
						            onclick="useAllPoint()">전액사용</button>
						</div>
                        <small class="text-muted">보유 포인트: <fmt:formatNumber value="${loginuser.point}" pattern="#,###"/>P</small>
                        <div id="point_error" class="text-danger small" style="display:none;">보유 포인트를 초과할 수 없습니다.</div>
                    </div>
                </div>

                <div class="card shadow-sm">
                    <div class="card-header bg-dark text-white">주문 상품 정보</div>
                    <div class="card-body">
                        <table class="table borderless">
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
			            
			            <div class="d-flex justify-content-between mb-2 text-danger">
			                <span>포인트 할인</span>
			                <span id="display_use_point">0원</span>
			            </div>
			
			           
			            <hr>
			            <div class="d-flex justify-content-between mb-4">
			                <strong>최종 결제금액</strong>
			                <strong class="text-danger" id="display_final_price" style="font-size: 1.2rem;">
			                    <fmt:formatNumber value="${totalPrice}" pattern="#,###"/>원
			                </strong>
			            </div>
			            <button type="button" id="btnOrderPayment" class="btn btn-primary btn-lg btn-block" onclick="goOrderPayment()">
			                <span id="btn_payment_text"><fmt:formatNumber value="${totalPrice}" pattern="#,###"/>원</span> 결제하기
			            </button>
			            
			            <div class="d-flex justify-content-between mb-2 mt-3 small">
			                <span>적립 예정 포인트</span>
			                <span class="text-info">+<fmt:formatNumber value="${totalPoint}" pattern="#,###"/>P</span>
			            </div>
			            
			        </div>
			    </div>
			</div>
            
            
        </div>
    </form>
</div>    

<script type="text/javascript">
    
    function goOrderPayment() {
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
        
        const orderType = "${orderType}";
        let pName = "";
        
        if(orderType === "direct") {
            pName = "${pdto.product_name}";
        } else {
            pName = "장바구니 주문 상품 외"; 
        }
        
        document.getElementById("product_name").value = pName;
        
        // 결제할 금액 가져오기 (포인트 차감된 금액)
        const finalPayAmount = document.getElementById("total_price").value;
        
        var IMP = window.IMP; 
        IMP.init("imp46782436"); 

        IMP.request_pay({
            pg : 'html5_inicis', 
            pay_method : 'card',
            merchant_uid : 'merchant_' + new Date().getTime() + '_' + "${loginuser.userid}",
            name : pName,
            amount : 100, // 테스트용 100원 설정
            buyer_email : '${loginuser.email}',
            buyer_name : "${loginuser.name}",
            buyer_tel : "${loginuser.mobile}"
        }, function(rsp) {
            if ( rsp.success ) {
                alert("결제가 완료되었습니다.");
                
                const btnPayment = document.getElementById("btnOrderPayment");
                btnPayment.disabled = true;
                btnPayment.innerText = "주문 처리 중...";
                // console.log("전송될 상품명: " + document.getElementById("product_name").value);
                document.orderFrm.submit(); 
            } else {
                alert("결제에 실패하였습니다. 사유: " + rsp.error_msg);
            }
        });
    }
    
    function openAddressPopup(ctxPath) {
        const url = ctxPath + "/product/addressRegister.sp";
        const width = 1200; const height = 900;
        const left = Math.ceil( (window.screen.width - width)/2 );
        const top = Math.ceil( (window.screen.height - height)/2 ); 
        window.open(url,"addressRegisterPopup",`width=${width},height=${height},left=${left},top=${top},resizable=yes`);
    }

    function refreshAddress() {
        location.reload(); 
    }
    
    function autoHyphen(target) {
        target.value = target.value
            .replace(/[^0-9]/g, '')
            .replace(/^(\d{2,3})(\d{3,4})(\d{4})$/, `$1-$2-$3`)
            .replace(/^(\d{2,3})(\d{3})(\d{4})$/, `$1-$2-$3`);
    }
 	
    function useAllPoint() {
        const totalPoint = parseInt("${loginuser.point}");
        document.getElementById("use_point").value = totalPoint;
        calculateFinalPrice();
    }

    function calculateFinalPrice() {
        const totalPrice = parseInt("${totalPrice}"); // 원래 총액
        const availablePoint = parseInt("${loginuser.point}"); // 보유 포인트
        let usePoint = parseInt(document.getElementById("use_point").value) || 0;

        //  유효성 검사
        if (usePoint > availablePoint) {
            document.getElementById("point_error").style.display = "block";
            usePoint = availablePoint;
            document.getElementById("use_point").value = usePoint;
        } else {
            document.getElementById("point_error").style.display = "none";
        }
        
        // 결제 금액보다 많이 쓰는 것 방지
        if (usePoint > totalPrice) {
            usePoint = totalPrice;
            document.getElementById("use_point").value = usePoint;
        }

        // 금액 계산
        const finalPrice = totalPrice - usePoint;

        // 포인트 할인 금액 표시 
        document.getElementById("display_use_point").innerText = "-" + usePoint.toLocaleString() + "원";
        
        // 최종 결제금액 표시
        document.getElementById("display_final_price").innerText = finalPrice.toLocaleString() + "원";
        
        // 결제 버튼 텍스트 표시
        document.getElementById("btn_payment_text").innerText = finalPrice.toLocaleString() + "원";
        
        // Controller로 보낼 hidden 데이터 업데이트
        document.getElementById("total_price").value = finalPrice;
    }
</script>

<jsp:include page="../footer.jsp" />