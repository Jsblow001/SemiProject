<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../header2.jsp" />

<input type="hidden" id="ctxPath" value="${pageContext.request.contextPath}" />

<div class="container-fluid pt-5">
    <div class="row px-xl-5">
        <div class="col-lg-8 table-responsive mb-5">
            <h4 class="mb-4">주문 상태 관리</h4>
            
            <table class="table table-light table-borderless table-hover text-center mb-0">
                <thead class="thead-dark">
                    <tr>
                        <th>주문번호</th>
                        <th>주문자</th>
                        <th>결제금액</th>
                        <th>주문일시</th>
                        <th>배송상태</th>
                    </tr>
                </thead>
                <tbody class="align-middle">
                    <tr>
                        <td class="align-middle">${order.orderNo}</td>
                        <td class="align-middle">${order.memberId}</td>
                        <td class="align-middle">
                            <fmt:formatNumber value="${order.totalPrice}" pattern="#,###"/>원
                        </td>
                        <td class="align-middle">${order.orderDate}</td>
                        <td class="align-middle">
                            <select class="status-select form-control-sm" data-order-no="${order.orderNo}">
                                <option value="1" ${order.status == '1' ? 'selected' : ''}>결제완료</option>
                                <option value="2" ${order.status == '2' ? 'selected' : ''}>배송중</option>
                                <option value="3" ${order.status == '3' ? 'selected' : ''}>배송완료</option>
                                <option value="4" ${order.status == '4' ? 'selected' : ''}>주문취소</option>
                            </select>
                        </td>
                    </tr>
                </tbody>
            </table>
            
            <div class="mt-4">
                <button type="button" class="btn btn-primary" onclick="history.back();">목록으로</button>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/js/ih_product/adminOrder.js"></script>

<jsp:include page="../footer2.jsp" />