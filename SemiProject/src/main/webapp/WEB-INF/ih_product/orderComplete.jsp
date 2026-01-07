<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% String ctxPath = request.getContextPath(); %>

<jsp:include page="../header.jsp" />

<div class="container text-center" style="padding: 120px 0;">
    <div class="mb-4">
        <i class="fas fa-check-circle" style="font-size: 80px; color: #28a745;"></i>
    </div>
    
    <h2 class="font-weight-bold">THANK YOU!</h2>
    <p class="text-muted" style="font-size: 1.2rem;">주문이 정상적으로 접수되었습니다.</p>
    
    <hr class="my-5" style="width: 50%; margin: 0 auto;">
    
    <div class="mt-4">
        <p>빠른 시일 내에 안전하게 배송해 드리겠습니다.<br>
        주문 내역은 마이페이지에서 확인 가능합니다.</p>
    </div>

    <div class="mt-5">
        <a href="<%= ctxPath %>/index.sp" class="btn btn-dark btn-lg px-5 mr-2" style="border-radius: 0;">쇼핑 계속하기</a>
        <a href="<%= ctxPath %>/shop/orderList.sp" class="btn btn-outline-dark btn-lg px-5" style="border-radius: 0;">주문내역 확인</a>
    </div>
</div>

<jsp:include page="../footer.jsp" />