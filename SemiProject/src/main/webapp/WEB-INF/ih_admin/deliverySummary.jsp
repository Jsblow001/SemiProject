<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Admin - 주문/배송 관리</title>

<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
    body { font-family: 'Inter', 'Noto Sans KR', sans-serif; background-color: #f8f9fc; color: #4e73df; }
    
    /* 대시보드 요약 카드 스타일 */
    .summary-card { border: none; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.05); transition: transform 0.3s ease; background: #fff; }
    .summary-card:hover { transform: translateY(-5px); }
    .border-left-primary { border-left: 5px solid #4e73df !important; }
    .border-left-warning { border-left: 5px solid #f6c23e !important; }
    .border-left-success { border-left: 5px solid #1cc88a !important; }
    .border-left-danger  { border-left: 5px solid #e74a3b !important; }
    
    .status-title { font-size: 0.75rem; font-weight: 700; text-transform: uppercase; color: #858796; letter-spacing: 0.5px; }
    .status-number { font-size: 1.5rem; font-weight: 700; color: #5a5c69; }

    /* 테이블 카드 스타일 */
    .main-table-card { border-radius: 15px; overflow: hidden; border: none; box-shadow: 0 10px 30px rgba(0,0,0,0.05); background: #fff; }
    .table thead th { background-color: #f8f9fc; text-transform: uppercase; font-size: 0.7rem; font-weight: 700; letter-spacing: 1px; color: #b7b9cc; padding: 15px; border-bottom: 1px solid #e3e6f0; }
    .table tbody td { padding: 16px 15px; vertical-align: middle; font-size: 0.85rem; color: #6e707e; border-bottom: 1px solid #f8f9fc; }
    
    /* 소프트 배지 (파스텔톤) */
    .badge-soft { padding: 6px 12px; border-radius: 50px; font-weight: 700; font-size: 0.7rem; display: inline-block; }
    .bg-soft-primary { background-color: #eef2ff; color: #4e73df; }
    .bg-soft-warning { background-color: #fff9ec; color: #f6c23e; }
    .bg-soft-success { background-color: #e6f9f1; color: #1cc88a; }
    .bg-soft-danger  { background-color: #fdeaea; color: #e74a3b; }

    /* 셀렉트 박스 커스텀 */
    .status-select { border-radius: 8px; border: 1px solid #e3e6f0; font-size: 0.8rem; color: #6e707e; padding: 4px 8px; background-color: #fff; transition: all 0.2s; }
    .status-select:focus { border-color: #bac8f3; box-shadow: 0 0 0 0.2rem rgba(78, 115, 223, 0.1); }
    
    .order-id { font-weight: 700; color: #4e73df; text-decoration: none; }
    .product-name { font-weight: 600; color: #5a5c69; }
    
    /* 새로고침 버튼 */
	.btn-refresh {
    background: linear-gradient(135deg, #6e8efb, #a777e3);
    color: white;
    border: none;
    border-radius: 8px;
    padding: 8px 16px;
    font-weight: 600;
    font-size: 0.85rem;
    display: flex;
    align-items: center;
    gap: 8px; /* 아이콘과 글자 간격 */
    transition: all 0.3s ease;
    box-shadow: 0 4px 15px rgba(110, 142, 251, 0.3);
	}
	
	.btn-refresh:hover {
	    transform: translateY(-2px) scale(1.02); /* 살짝 떠오르는 효과 */
	    box-shadow: 0 6px 20px rgba(110, 142, 251, 0.4);
	    color: white;}
	
	.btn-refresh:active {transform: translateY(0);}
	
	.btn-refresh i {transition: transform 0.6s ease;}
	.btn-refresh:hover i {transform: rotate(180deg);
	}
</style>
</head>
<body>

<jsp:include page="../header2.jsp" /> 

<div class="container py-5">
    <div class="d-sm-flex align-items-center justify-content-between mb-4">
        <h1 class="h3 mb-0 text-gray-800 fw-bold">배송 현황 대시보드</h1>
        <button class="btn-refresh" onclick="location.reload();">
		    <i class="fas fa-sync-alt"></i>
		    <span>Update</span>
		</button>
    </div>

    <div class="row mb-4">
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card summary-card border-left-primary h-100 py-2">
                <div class="card-body">
                    <div class="status-title mb-1">결제완료</div>
                    <div class="status-number">${summary.count1}<small class="ms-1" style="font-size: 0.9rem;">건</small></div>
                </div>
            </div>
        </div>
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card summary-card border-left-warning h-100 py-2">
                <div class="card-body">
                    <div class="status-title mb-1">배송중</div>
                    <div class="status-number">${summary.count2}<small class="ms-1" style="font-size: 0.9rem;">건</small></div>
                </div>
            </div>
        </div>
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card summary-card border-left-success h-100 py-2">
                <div class="card-body">
                    <div class="status-title mb-1">배송완료</div>
                    <div class="status-number">${summary.count3}<small class="ms-1" style="font-size: 0.9rem;">건</small></div>
                </div>
            </div>
        </div>
        <div class="col-xl-3 col-md-6 mb-4">
            <div class="card summary-card border-left-danger h-100 py-2">
                <div class="card-body">
                    <div class="status-title mb-1">주문취소</div>
                    <div class="status-number">${summary.count4}<small class="ms-1" style="font-size: 0.9rem;">건</small></div>
                </div>
            </div>
        </div>
    </div>

    <div class="card main-table-card">
        <div class="table-responsive">
            <table class="table table-hover mb-0">
                <thead>
                    <tr>
                        <th class="text-center">주문번호</th>
                        <th>주문자명</th>
                        <th>상품 정보</th>
                        <th class="text-end">결제금액</th>
                        <th class="text-center">현재상태</th>
                        <th class="text-center">상태변경</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="order" items="${orderList}">
                        <tr>
                            <td class="text-center"><span class="order-id">${order.odrcode}</span></td>
                            <td>
                                <div class="fw-bold text-dark">${order.name}</div>
                                <div class="small text-muted">${order.fk_userid}</div>
                            </td>
                            <td>
                                <div class="product-name">${order.pName}</div>
                                <div class="small text-muted">${order.odrdate}</div>
                            </td>
                            <td class="text-end fw-bold text-dark">
                                <fmt:formatNumber value="${order.totalprice}" pattern="#,###" />원
                            </td>
                            <td class="text-center">
							    <c:choose>
							        <c:when test="${order.deliverystatus == 1}">
							            <span class="badge-soft bg-soft-primary">● 결제완료</span>
							            <div class="progress mt-1" style="height: 3px; width: 60px; margin: 0 auto;">
							                <div class="progress-bar bg-primary" style="width: 25%"></div>
							            </div>
							        </c:when>
							        
							        <c:when test="${order.deliverystatus == 2}">
							            <span class="badge-soft bg-soft-warning">● 배송중</span>
							            <div class="progress mt-1" style="height: 3px; width: 60px; margin: 0 auto;">
							                <div class="progress-bar bg-warning" style="width: 60%"></div>
							            </div>
							        </c:when>
							        
							        <c:when test="${order.deliverystatus == 3}">
							            <span class="badge-soft bg-soft-success">● 배송완료</span>
							            <div class="progress mt-1" style="height: 3px; width: 60px; margin: 0 auto;">
							                <div class="progress-bar bg-success" style="width: 100%"></div>
							            </div>
							        </c:when>
							        
							        <c:otherwise>
							            <span class="badge-soft bg-soft-danger">● 주문취소</span>
							        </c:otherwise>
							    </c:choose>
							</td>
                            <td class="text-center" onclick="event.stopPropagation();">
                                <select class="status-select" 
                                        data-order-no="${order.odrcode}"
                                        data-origin-status="${order.deliverystatus}">
                                    <option value="1" ${order.deliverystatus == 1 ? 'selected' : ''}>결제완료</option>
                                    <option value="2" ${order.deliverystatus == 2 ? 'selected' : ''}>배송중</option>
                                    <option value="3" ${order.deliverystatus == 3 ? 'selected' : ''}>배송완료</option>
                                    <option value="4" ${order.deliverystatus == 4 ? 'selected' : ''}>주문취소</option>
                                </select>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
$(document).ready(function() {
    $(".status-select").on("change", function() {
        const $this = $(this);
        const orderNo = $this.data("order-no");
        const newStatus = $this.val();
        
        if(confirm("상태를 변경하시겠습니까?")) {
            $.ajax({
                url: "${pageContext.request.contextPath}/admin/updateOrderStatus.sp",
                type: "POST",
                data: { "orderNo": orderNo, "status": newStatus },
                dataType: "json",
                success: function(json) {
                    if(json.result >= 1) {
                        alert("변경 완료되었습니다.");
                        location.reload(); 
                    }
                }
            });
        }
    });
});
</script>
<jsp:include page="../footer2.jsp" />
</body>
</html>