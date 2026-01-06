<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<% String ctxPath = request.getContextPath(); %>    

<jsp:include page="../header.jsp" />
    
<div class="container mt-5">
    <h2 class="mb-4 text-center">ORDER SHEET</h2>
    
    <div class="row">
        <div class="col-md-8">
            <div class="card mb-4 shadow-sm">
                <div class="card-header bg-dark text-white">배송 정보</div>
                <div class="card-body">
                    <div class="form-group">
                        <label>수령인</label>
                        <input type="text" class="form-control" value="${loginuser.name}">
                    </div>
                    <div class="form-group">
                        <label for="fk_addr_id">배송지 선택</label>
						<select name="fk_addr_id" class="form-control">
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
                    </div>
                </div>
            </div>

            <div class="card shadow-sm">
                <div class="card-header bg-dark text-white">주문 상품 정보</div>
                <div class="card-body">
                    <table class="table borderless">
                        <tr>
                            <td><img src="<%=ctxPath%>/img/${pdto.pimage}" width="80"></td>
                            <td>
                                <strong>${pdto.product_name}</strong><br>
                                수량: ${qty}개
                            </td>
                            <td class="text-right">
                                <fmt:formatNumber value="${pdto.sale_price}" pattern="#,###"/>원
                            </td>
                        </tr>
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
                        <strong class="text-danger"><fmt:formatNumber value="${totalPrice}" pattern="#,###"/>원</strong>
                    </div>
                    <button class="btn btn-dark btn-block btn-lg" onclick="goOrderPayment()">결제하기</button>
                </div>
            </div>
        </div>
    </div>
</div>    


<jsp:include page="../footer.jsp" />