<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<jsp:include page="../header2.jsp" />

<div class="carin-admin-wrap" style="max-width:600px;">
    <h2 class="page-title">클레임 반려 사유 입력</h2>

    <form method="post" action="${pageContext.request.contextPath}/admin/claimReject.sp">

        <!-- 어떤 주문 상세를 반려하는지 -->
        <input type="hidden" name="odrdetailno" value="${claim.odrDetailNo}" />
		
		<!-- 고객 주문취소 요청 내역 -->
		<div style="border:1px solid #e0e0e0;
                padding:20px;
                margin-bottom:30px;
                background:#fafafa;
                font-size:13px;">
	        <p style="margin-bottom:8px;">
	            <strong>주문번호</strong> :
	            <span>${claim.odrCode}</span>
	        </p>
	
	        <p style="margin-bottom:8px;">
	            <strong>상품명</strong> :
	            <span>${claim.productName}</span>
	        </p>
	
	        <p style="margin-bottom:0;">
	            <strong>고객 요청 사유</strong><br>
	            <span style="color:#555;">
	                ${claim.claimReason}
	            </span>
	        </p>
    	</div>
		
	    <!-- 반려 사유 -->
        <div style="margin-bottom:30px;">
            <label style="font-size:13px;font-weight:600;">반려 사유</label>
            <textarea name="rejectReason"
                      rows="6"
                      style="width:100%;padding:10px;border:1px solid #ccc;"
                      placeholder="관리자 반려 사유를 입력하세요."
                      required></textarea>
        </div>

        <div style="text-align:center;">
            <button type="submit" class="btn-admin btn-approve">반려 확정</button>
            <button type="button" class="btn-admin"
                    onclick="history.back();">취소</button>
        </div>

    </form>
</div>

<jsp:include page="../footer2.jsp" />
