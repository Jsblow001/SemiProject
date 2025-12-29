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
            background-color: #FBFAF8 !important; /* 카린 특유의 밝은 베이지 배경 */
        }
        
        /* 마이페이지 전용 스타일 */
        .mypage-container {
            margin-top: 150px; /* 헤더가 fixed-top이므로 여백 충분히 확보 */
            margin-bottom: 100px;
        }
        
        .btn-mypage-card {
            display: block;
            padding: 35px 20px;
            background: #fff;
            border: 1px solid #eee;
            text-decoration: none !important;
            transition: all 0.3s ease;
            height: 100%;
        }
        .btn-mypage-card:hover {
            border-color: #5D4037;
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }
        .card-icon { font-size: 30px; margin-bottom: 15px; }
        .card-title { font-size: 16px; font-weight: 600; color: #333; margin-bottom: 5px; }
        .card-desc { font-size: 12px; color: #999; }
        
        .summary-box {
            background: #fff;
            padding: 30px;
            border: 1px solid #eee;
            margin-bottom: 40px;
        }
    </style>
</head>
<body>

    <jsp:include page="/header.jsp" />

    <div class="container mypage-container">
        
        <div class="summary-box row align-items-center mx-0">
            <div class="col-md-6 border-right">
                <h2 style="font-size: 24px; font-weight: 500; letter-spacing: 1px;">MY PAGE</h2>
                <p class="text-muted mb-0" style="font-size: 14px;">
                    안녕하세요, <span style="color: #5D4037; font-weight: 600;">${sessionScope.loginuser.name}</span>님 반가워요!
                </p>
            </div>
            <div class="col-md-6 d-flex justify-content-around align-items-center">
                <div class="text-center">
                    <div style="font-size: 12px; color: #888; margin-bottom: 5px;">COIN</div>
                    <div style="font-weight: 600; font-size: 18px; color: #5D4037;">
                        <fmt:formatNumber value="${sessionScope.loginuser.coin}" pattern="#,###" />원
                    </div>
                </div>
                <div class="text-center border-left pl-5">
                    <div style="font-size: 12px; color: #888; margin-bottom: 5px;">POINT</div>
                    <div style="font-weight: 600; font-size: 18px; color: #5D4037;">
                        <fmt:formatNumber value="${sessionScope.loginuser.point}" pattern="#,###" />P
                    </div>
                </div>
            </div>
        </div>

        <div class="row text-center mb-5">
            <div class="col-md-3 mb-4">
                <a href="<%= ctxPath %>/shop/orderList.sp" class="btn-mypage-card">
                    <div class="card-icon">📦</div>
                    <div class="card-title">주문내역</div>
                    <div class="card-desc">고객님의 주문 현황</div>
                </a>
            </div>
            <div class="col-md-3 mb-4">
                <a href="<%= ctxPath %>/member/memberedit.sp" class="btn-mypage-card">
                    <div class="card-icon">👤</div>
                    <div class="card-title">정보수정</div>
                    <div class="card-desc">개인정보를 안전하게 관리</div>
                </a>
            </div>
            <div class="col-md-3 mb-4">
                <a href="<%= ctxPath %>/shop/wishlist.sp" class="btn-mypage-card">
                    <div class="card-icon">🖤</div>
                    <div class="card-title">위시리스트</div>
                    <div class="card-desc">관심 상품 목록</div>
                </a>
            </div>
            <div class="col-md-3 mb-4">
                <a href="<%= ctxPath %>/customer/qnaList.sp" class="btn-mypage-card">
                    <div class="card-icon">💬</div>
                    <div class="card-title">나의문의</div>
                    <div class="card-desc">1:1 상담 및 상품 문의</div>
                </a>
            </div>
        </div>

        <div class="mt-5">
            <div class="d-flex justify-content-between align-items-end mb-3">
                <h4 style="font-size: 18px; font-weight: 600; margin: 0; color: #333;">최근 주문 정보</h4>
                <a href="<%= ctxPath %>/shop/orderList.sp" style="font-size: 12px; color: #999; text-decoration: none;">전체보기 ></a>
            </div>
            <table class="table" style="font-size: 14px; border-top: 2px solid #5D4037; background: #fff;">
                <thead class="bg-light text-center text-muted">
                    <tr>
                        <th style="width: 20%;">날짜</th>
                        <th>상품명</th>
                        <th style="width: 15%;">결제금액</th>
                        <th style="width: 15%;">상태</th>
                    </tr>
                </thead>
                <tbody class="text-center">
                    <tr>
                        <td colspan="4" class="py-5 text-muted">최근 30일 내에 주문하신 내역이 없습니다.</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

    <jsp:include page="/footer.jsp" />

</body>
</html>