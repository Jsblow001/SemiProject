<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<% String ctxPath = request.getContextPath(); %>    

<jsp:include page="../header.jsp" />

<style>
    .borderless td, .borderless th { border: none; }
</style>

<script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>

<div class="container mt-5">
    <h2 class="mb-4 text-center">ORDER SHEET</h2>
    
    <form name="orderFrm" action="<%= ctxPath %>/product/orderAdd.sp" method="POST">
        
        <input type="hidden" name="product_id" value="${pdto.product_id}" />
        <input type="hidden" name="qty" value="${qty}" />
        <input type="hidden" name="sale_price" value="${pdto.sale_price}" />
        <input type="hidden" name="total_price" value="${totalPrice}" />
		<input type="hidden" name="cartIds" value="${param.cartIds}" />

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
						           oninput="this.value = this.value.replace(/[^0-9-]/g, '')" 
						           required>
						    <small class="text-muted">하이픈(-)을 포함하여 숫자만 입력 가능합니다.</small>
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
						    
						    <c:if test="${empty addrList}">
						        <small class="text-danger">배송지가 없으면 주문이 불가합니다. 새 주소를 등록해주세요.</small>
						    </c:if>
						</div>

                    </div>
                </div>

				<div class="card shadow-sm">
				    <div class="card-header bg-dark text-white">주문 상품 정보</div>
				    <div class="card-body">
				        <table class="table borderless">
				            <c:if test="${orderType eq 'direct'}">
				                <tr>
				                    <td width="100"><img src="<%=ctxPath%>/img/${pdto.pimage}" class="img-fluid"></td>
				                    <td class="align-middle">
				                        <strong>${pdto.product_name}</strong><br>
				                        <span class="text-muted">수량: ${qty}개</span>
				                    </td>
				                    <td class="text-right align-middle">
				                        <fmt:formatNumber value="${pdto.sale_price}" pattern="#,###"/>원
				                    </td>
				                </tr>
				            </c:if>
				
				            <c:if test="${orderType eq 'cart'}">
				                <c:forEach var="map" items="${orderList}">
				                    <tr>
				                        <td width="100"><img src="<%=ctxPath%>/img/${map.pimage}" class="img-fluid"></td>
				                        <td class="align-middle">
				                            <strong>${map.product_name}</strong><br>
				                            <span class="text-muted">수량: ${map.cart_qty}개</span>
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
                            <span>상품금액</span>
                            <span><fmt:formatNumber value="${totalPrice}" pattern="#,###"/>원</span>
                        </div>
                        <div class="d-flex justify-content-between mb-2">
                            <span>배송비</span>
                            <span>0원 (무료)</span>
                        </div>
                        <hr>
                        <div class="d-flex justify-content-between mb-4">
                            <strong>최종 결제금액</strong>
                            <strong class="text-danger" style="font-size: 1.2rem;">
                                <fmt:formatNumber value="${totalPrice}" pattern="#,###"/>원
                            </strong>
                        </div>
                        <button type="button" id="btnOrderPayment" class="btn btn-primary btn-lg btn-block" onclick="goOrderPayment()">
						    결제하기
						</button>
                    </div>
                </div>
            </div>
        </div>
    </form>
</div>    

<script type="text/javascript">
	
	function goOrderPayment() {
	    // 배송지 선택 확인
	    const addrId = document.getElementById("fk_addr_id").value;
	    if(!addrId || addrId == "") {
	        alert("배송지를 선택하거나 등록해 주세요.");
	        return;
	    }
	
	    // 수령인 및 연락처 유효성 검사
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
	    
	    // 결제 전 최종 확인
	    if(!confirm("정말로 주문을 진행하시겠습니까?")) return;
	    
	    // 결제 정보 준비 
	    
	    const orderType = "${orderType}";
		let pName = "";
		
		if(orderType === "direct") {
		    pName = "${pdto.product_name}"; // 단건 주문 시 상품명
		} else {
		    // 장바구니 주문 
		    pName = "장바구니 주문 상품 외"; 
		}
		
		if(!pName || pName === "") {
		    pName = "쇼핑몰 상품 결제";
		}
	    
	    const totalPrice = "${totalPrice}"; 
	    const userEmail = "${loginuser.email}";
	    const userName = document.getElementById("receiver_name").value;
	    const userMobile = receiverMobile;
	    
	    // 아임포트 초기화 및 실행
	    var IMP = window.IMP; 
	    IMP.init("imp46782436"); // 본인의 식별코드로 교체 필수
	
	    // 결제 요청
	    IMP.request_pay({
	        pg : 'html5_inicis', 
	        pay_method : 'card',
	        merchant_uid : 'merchant_' + new Date().getTime() + '_' + "${loginuser.userid}", // 중복 방지를 위해 아이디 조합
	        name : pName,
	        amount : 100,
	        buyer_email : '${loginuser.email}',
	        buyer_name : '${loginuser.name}',
	        buyer_tel : '${loginuser.mobile}'
	    }, function(rsp) {
	        if ( rsp.success ) {
	            // 결제 성공 시
	            alert("결제가 완료되었습니다. 주문 정보를 저장합니다.");
	            const frm = document.orderFrm;
	            // 버튼 비활성화 (중복 전송 방지)
	            const btnPayment = document.getElementById("btnOrderPayment");
	            if(btnPayment) {
	                btnPayment.disabled = true;
	                btnPayment.innerText = "주문 처리 중...";
	            }
	            
	            // 실제 서버로 폼 전송
	            frm.submit(); 
	        } else {
	            // 결제 실패 또는 창 닫기
	            
	            alert("결제에 실패하였습니다. 사유: " + rsp.error_msg);
	        }
	    });
	}
    
    
 	// 배송지 등록 팝업창 열기
    function openAddressPopup(ctxPath) {
        const url = ctxPath + "/product/addressRegister.sp";
        
        const width = 800;
        const height = 600;
        const left = (window.screen.width / 2) - (width / 2);
        const top = (window.screen.height / 2) - (height / 2);
        
        window.open(url, "addressRegisterPopup", 
                    `width=${width},height=${height},left=${left},top=${top},resizable=yes`);
    }

    // 팝업창에서 등록 성공 후 호출할 콜백 함수
    function refreshAddress() {
        location.reload(); 
    }
    
    // 연락처 하이픈(-) 자동 완성 기능
    function autoHyphen(target) {
        target.value = target.value
            .replace(/[^0-9]/g, '') // 숫자가 아닌 문자 제거
            .replace(/^(\d{2,3})(\d{3,4})(\d{4})$/, `$1-$2-$3`); // 하이픈 삽입
    }
    
    
</script>

<jsp:include page="../footer.jsp" />