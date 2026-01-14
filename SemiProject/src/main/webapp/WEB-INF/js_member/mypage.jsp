<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String ctxPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>CARIN | MY PAGE</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%=ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css">
    
    <style>
        body {
            font-family: 'Poppins', 'Pretendard', sans-serif !important;
            background-color: #FBFAF8 !important;
        }
        
        .mypage-container {
            margin-top: 150px; 
            margin-bottom: 100px;
        }
        
        /* 등급 및 포인트 요약 박스 */
        .summary-box {
            background: #fff;
            padding: 40px 30px;
            border: 1px solid #eee;
            margin-bottom: 40px;
            border-radius: 5px;
        }

        .grade-circle {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            border: 2px solid #5D4037;
            background-color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            color: #5D4037;
            font-size: 13px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            margin: 0 auto;
        }

        /* 정보수정 버튼 스타일 */
        .btn-edit-profile {
            display: inline-block;
            padding: 8px 18px;
            border: 1px solid #5D4037;
            color: #5D4037;
            font-size: 13px;
            font-weight: 500;
            border-radius: 30px;
            text-decoration: none !important;
            transition: all 0.3s ease;
        }
        .btn-edit-profile:hover {
            background: #5D4037;
            color: #fff;
        }
        
        .btn-mypage-card {
            display: block;
            padding: 35px 20px;
            background: #fff;
            border: 1px solid #eee;
            text-decoration: none !important;
            transition: all 0.3s ease;
            height: 100%;
            border-radius: 5px;
        }
        .btn-mypage-card:hover {
            border-color: #5D4037;
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }
        .card-icon { font-size: 30px; margin-bottom: 15px; }
        .card-title { font-size: 16px; font-weight: 600; color: #333; margin-bottom: 5px; }
        .card-desc { font-size: 12px; color: #999; }
   
        .account-box { border-top: 1px solid #eee; color: #888; }
        .account-title { font-size: 13px; letter-spacing: 2px; margin-bottom: 10px; color: #aaa; }
        .account-actions { font-size: 13px; }
        .account-link { color: #777; text-decoration: none; transition: color .2s; }
        .account-link:hover { color: #5D4037; }
        .account-link.withdraw:hover { color: #c62828; }
        .divider { margin: 0 10px; color: #ccc; }
    </style>
</head>
<body>

    <jsp:include page="../header.jsp" />

    <div class="container mypage-container">
        
        <%-- 사용자 요약 정보 영역 (등급 원형 아래에 포인트 배치) --%>
		<div class="summary-box row align-items-center mx-0">
		    <div class="col-md-5 border-right py-2">
		        <h2 style="font-size: 26px; font-weight: 500; letter-spacing: 1px; color: #333;">MY PAGE</h2>
		        <p class="text-muted mb-0" style="font-size: 15px; margin-top: 10px;">
		            반갑습니다, <span style="color: #5D4037; font-weight: 700; font-size: 18px;">${sessionScope.loginuser.name}</span>님!
		        </p>
		    </div>
		    
		    <div class="col-md-4 border-right py-2 text-center">
		        <div style="font-size: 12px; color: #888; margin-bottom: 12px; letter-spacing: 1px;">MEMBERSHIP & POINT</div>
		        
		        <%-- 등급 원형 --%>
		        <div class="grade-circle mb-3">
		            ${sessionScope.loginuser.grade_name}
		        </div>
		        
		        <%-- 원 바로 밑에 포인트 배치 --%>
		        <div class="text-center">
		            <div style="font-weight: 600; font-size: 20px; color: #5D4037; line-height: 1.2;">
		                <fmt:formatNumber value="${sessionScope.loginuser.point}" pattern="#,###" /> <span style="font-size: 14px;">P</span>
		            </div>
		            
		            
		        </div>
		    </div>
		
		    <div class="col-md-3 py-2 text-center">
		        <div style="font-size: 12px; color: #888; margin-bottom: 12px; letter-spacing: 1px;">ACCOUNT MANAGEMENT</div>
		        <a href="<%= ctxPath %>/js_member/memberedit.sp" class="btn-edit-profile">
		            내 정보 수정 <i class="ml-1">→</i>
		        </a>
		    </div>
		</div>

        <%-- 메뉴 카드 영역 --%>
        <div class="row text-center mb-5">
            <div class="col-md-3 mb-4">
                <a href="<%= ctxPath %>/reviewWrite.sp" class="btn-mypage-card">
                    <div class="card-icon">📝</div>
                    <div class="card-title">리뷰작성</div>
                    <div class="card-desc">상품리뷰 작성</div>
                </a>
            </div>
            <div class="col-md-3 mb-4">
                <a href="<%= ctxPath %>/myReservations.sp" class="btn-mypage-card">
                    <div class="card-icon">📅</div>
                    <div class="card-title">예약확인</div>
                    <div class="card-desc">매장 예약 확인</div>
                </a>
            </div>
            <div class="col-md-3 mb-4">
                <a href="<%= ctxPath %>/product/wishList.sp" class="btn-mypage-card">
                    <div class="card-icon">🖤</div>
                    <div class="card-title">위시리스트</div>
                    <div class="card-desc">담아둔 관심 상품</div>
                </a>
            </div>
            <div class="col-md-3 mb-4">
                <a href="<%= ctxPath %>/customer/myQnaList.sp" class="btn-mypage-card">
                    <div class="card-icon">💬</div>
                    <div class="card-title">내 문의</div>
                    <div class="card-desc">1:1 문의 내역 확인</div>
                </a>
            </div>
        </div>

        <%-- 최근 주문 정보 테이블 --%>
        <div class="mt-5">
            <div class="d-flex justify-content-between align-items-end mb-3">
                <h4 style="font-size: 18px; font-weight: 600; margin: 0; color: #333;">최근 주문 정보</h4>
                <a href="<%= ctxPath %>/shop/orderList.sp" style="font-size: 12px; color: #999; text-decoration: none;">전체보기 ></a>
            </div>
            <table class="table" style="font-size: 14px; border-top: 2px solid #5D4037; background: #fff;">
                <thead class="bg-light text-center text-muted">
                    <tr>
                    	<th style="width: 10%;">번호</th>
                        <th style="width: 15%;">날짜</th>
                        <th>상품명</th>
                        <th style="width: 15%;">결제금액</th>
                        <th style="width: 15%;">상태</th>
                    </tr>
                </thead>
                <tbody class="text-center">
				    <c:choose>
				        <c:when test="${not empty recentOrderList}">
				            <c:forEach var="o" items="${recentOrderList}" varStatus="status" end="4">
				                <tr>
				                	<td>${status.count}</td>
				                    <td><fmt:formatDate value="${o.odrDate}" pattern="yyyy-MM-dd"/></td>
				                    <td>${o.productName}</td>
				                    <td><fmt:formatNumber value="${o.odrTotalPrice}" pattern="#,###"/>원</td>
				                    <td>${o.paymentStatusName}</td>
				                </tr>
				            </c:forEach>
				        </c:when>
				        <c:otherwise>
				            <tr>
				                <td colspan="5" class="py-5 text-muted">
				                    최근 30일 내에 주문하신 내역이 없습니다.
				                </td>
				            </tr>
				        </c:otherwise>
				    </c:choose>
                </tbody>
            </table>
        </div>
        
         <%-- 계정 관리 영역 --%>
         <div class="account-box mt-5 pt-4 text-center">
             <div class="account-title">계정 설정</div>
             <div class="account-actions">
                 <a href="<%=ctxPath%>/logout.sp" class="account-link">로그아웃</a>
                 <span class="divider">|</span>
                 <a href="<%=ctxPath%>/withdraw.sp" class="account-link withdraw">회원탈퇴</a>
             </div>
         </div>
    </div>
     
    <jsp:include page="../footer.jsp" />

</body>
</html>