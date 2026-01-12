<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../header2.jsp" />

<c:set var="ctxPath" value="${pageContext.request.contextPath}" />

<style>
    :root {
        --dark-wood: #5D4037;
        --light-bg: #EFEBE9;
    }
    
    body { background-color: #fcfcfc; }
    
    .card { border-radius: 10px; overflow: hidden; }
    .card-header { font-size: 1.1rem; border-bottom: none; }
    
    .bg-wood { background-color: var(--dark-wood) !important; color: white !important; }
    
    .table thead th {
        background-color: var(--light-bg);
        border-top: none;
        color: var(--dark-wood);
        font-weight: 600;
    }
    
    .order-summary-text { font-size: 0.95rem; line-height: 1.8; }
    .price-total { font-size: 1.4rem; color: #d9534f; }
</style>

<div class="container-fluid pt-5 mt-3">
    <div class="row px-xl-5">
        <div class="col-lg-12">
            
            <div class="d-flex justify-content-between align-items-center mb-4 pb-2 border-bottom">
                <h2 class="font-weight-semi-bold">
                    <i class="fas fa-clipboard-list mr-2"></i>주문 상세 내역
                    <small class="text-muted" style="font-size: 0.6em;">[주문번호: ${orderInfo.odrcode}]</small>
                </h2>
                <a href="${ctxPath}/admin/adminOrderList.sp" class="btn btn-outline-dark btn-sm shadow-sm">
                    <i class="fas fa-list mr-1"></i> 목록으로 돌아가기
                </a>
            </div>

            <c:choose>
                <c:when test="${not empty orderInfo}">
                    <div class="row">
                        <div class="col-md-6 mb-4">
                            <div class="card shadow-sm border-0 h-100">
                                <div class="card-header bg-wood">
                                    <i class="fas fa-user-circle mr-2"></i>주문자 정보
                                </div>
                                <div class="card-body bg-white order-summary-text">
                                    <p class="mb-2"><strong>성함 :</strong> ${orderInfo.name}</p>
                                    <p class="mb-2"><strong>아이디 :</strong> ${orderInfo.fk_userid}</p>
                                   	<p class="mb-2"><strong>연락처 :</strong> ${orderInfo.mobile}</p>
                                    <p class="mb-2"><strong>이메일 :</strong> ${orderInfo.email}</p>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6 mb-4">
                            <div class="card shadow-sm border-0 h-100">
                                <div class="card-header bg-wood">
                                    <i class="fas fa-credit-card mr-2"></i>결제 요약
                                </div>
                                <div class="card-body bg-white order-summary-text">
                                    <div class="d-flex justify-content-between mb-2">
                                        <span>주문 총액</span>
                                        <span><fmt:formatNumber value="${orderInfo.odrtotalprice}" pattern="#,###"/>원</span>
                                    </div>
                                    <div class="d-flex justify-content-between mb-2">
                                        <span>배송비</span>
                                        <span>+ 3,000원</span>
                                    </div>
                                    <!--<div class="d-flex justify-content-between mb-3 text-muted" style="font-size: 0.85rem;">
                                        <span>(사용 포인트)</span>
                                        <span>- <fmt:formatNumber value="${orderInfo.odrtotalpoint}" pattern="#,###"/>P</span>
                                    </div>  -->
                                    <hr>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <span class="font-weight-bold">최종 실결제액</span>
                                        <span class="font-weight-bold price-total"><fmt:formatNumber value="${orderInfo.odrtotalprice}" pattern="#,###"/>원</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-12 mb-4">
                            <div class="card shadow-sm border-0">
                                <div class="card-header bg-secondary bg-wood">
                                    <i class="fas fa-map-marker-alt mr-2"></i>배송지 및 수령 정보
                                </div>
                                <div class="card-body row">
                                    <div class="col-md-6 border-right">
                                        <p><strong>우편번호 :</strong> ${orderInfo.postcode}</p>
                                        <p><strong>주소 :</strong> ${orderInfo.address} ${orderInfo.detailaddress}</p>
                                        <p class="mb-0 text-primary"><strong>배송메시지 :</strong> 부재 시 경비실에 맡겨주세요.</p>
                                    </div>
                                    <div class="col-md-6">
                                        <p><strong>주문일시 :</strong> ${orderInfo.odrdate}</p>
                                        <p><strong>결제상태 :</strong> 
                                            <c:if test="${orderInfo.payment_status == 1}"><span class="text-success font-weight-bold">결제완료</span></c:if>
                                            <c:if test="${orderInfo.payment_status == 0}"><span class="text-danger font-weight-bold">미결제</span></c:if>
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card shadow-sm border-0 mb-5">
                        <div class="card-header bg-wood d-flex justify-content-between align-items-center">
                            <span><i class="fas fa-box-open mr-2"></i>주문 상품 목록</span>
                        </div>
                        <div class="table-responsive">
                            <table class="table table-hover text-center mb-0">
                                <thead>
                                    <tr>
                                        <th>이미지</th>
                                        <th>상품정보</th>
                                        <th>수량</th>
                                        <th>단가</th>
                                        <th>배송상태</th>
                                        <th>관리</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${detailList}">
                                        <tr>
                                            <td class="align-middle">
                                                <img src="${ctxPath}/img/${item.pimage}" class="img-thumbnail" style="width: 60px; height: 60px; object-fit: cover;">
                                            </td>
                                            <td class="align-middle text-left font-weight-bold">${item.pname}</td>
                                            <td class="align-middle">${item.odrqty}개</td>
                                            <td class="align-middle"><fmt:formatNumber value="${item.odrprice}" pattern="#,###"/>원</td>
                                            <td class="align-middle">
                                                <c:choose>
                                                    <c:when test="${item.deliverystatus == 1}"><span class="badge badge-info p-2">주문완료</span></c:when>
                                                    <c:when test="${item.deliverystatus == 2}"><span class="badge badge-warning p-2">배송중</span></c:when>
                                                    <c:when test="${item.deliverystatus == 3}"><span class="badge badge-success p-2">배송완료</span></c:when>
                                                    <c:otherwise><span class="badge badge-secondary p-2">상태미정</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="align-middle">
                                                <button class="btn btn-sm btn-outline-primary shadow-sm" onclick="openInvoiceModal('${item.odrdetailno}')">송장수정</button>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="text-center py-5">
                        <i class="fas fa-exclamation-triangle fa-3x text-muted mb-3"></i>
                        <p class="lead">주문 상세 데이터를 찾을 수 없습니다.</p>
                        <a href="javascript:history.back()" class="btn btn-wood">뒤로 가기</a>
                    </div>
                </c:otherwise>
            </c:choose>
            
            <div class="text-right pb-5">
                <button class="btn btn-secondary mr-2 shadow-sm"><i class="fas fa-print mr-1"></i>운송장 출력</button>
                <button class="btn btn-danger shadow-sm"><i class="fas fa-times-circle mr-1"></i>주문 전체 취소</button>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../footer2.jsp" />