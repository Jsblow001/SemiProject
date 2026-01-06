<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

    
<jsp:include page="../header.jsp" />    
    
<div class="container text-center" style="padding: 100px 0;">
    <i class="fas fa-check-circle text-success" style="font-size: 5rem;"></i>
    <h2 class="mt-4">주문이 정상적으로 완료되었습니다!</h2>
    <p class="text-muted">빠른 시일 내에 배송해 드리겠습니다.</p>
    <div class="mt-5">
        <a href="<%=request.getContextPath()%>/index.sp" class="btn btn-dark btn-lg">쇼핑 계속하기</a>
        <a href="<%=request.getContextPath()%>/product/orderList.sp" class="btn btn-outline-dark btn-lg">주문 내역 보기</a>
    </div>
</div>




<jsp:include page="../footer.jsp" />