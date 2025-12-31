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

        /* 스케치 이미지 기반 등급 원형 스타일 */
        .grade-circle {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            border: 2px solid #5D4037;
            background-color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            color: #5D4037;
            font-size: 14px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            margin: 0 auto;
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
    </style>
</head>
<body>

    <%-- 상단 헤더 인클루드 --%>
    <jsp:include page="../header.jsp" />

    <div class="container mypage-container">
        
        <%-- 사용자 요약 정보 영역 (등급 테이블 연동) --%>
        <div class="summary-box row align-items-center mx-0">
            <div class="col-md-6 border-right py-2">
                <h2 style="font-size: 26px; font-weight: 500; letter-spacing: 1px; color: #333;">MY PAGE</h2>
                <p class="text-muted mb-0" style="font-size: 15px; margin-top: 10px;">
                    반갑습니다, <span style="color: #5D4037; font-weight: 700; font-size: 18px;">${sessionScope.loginuser.name}</span>님!
                    <br>
                    현재 고객님은 <span style="color: #5D4037; font-weight: 600;">${sessionScope.loginuser.grade_name}</span> 등급입니다.
                </p>
            </div>
            
            <div class="col-md-6 d-flex justify-content-around align-items-center py-2">
                <%-- 포인트 표시 --%>
                <div class="text-center">
                    <div style="font-size: 12px; color: #888; margin-bottom: 8px; letter-spacing: 1px;">MEMBERSHIP</div>
                    <div class="grade-circle">
                        ${sessionScope.loginuser.grade_name}
                    </div>
                </div>

                <%-- 회원 등급 원형 표시 (이미지 반영) --%>
                <div class="text-center border-left pl-5">
                    <div style="font-size: 12px; color: #888; margin-bottom: 8px; letter-spacing: 1px;">AVAILABLE POINT</div>
                    <div style="font-weight: 600; font-size: 22px; color: #5D4037;">
                        <fmt:formatNumber value="${sessionScope.loginuser.point}" pattern="#,###" /> <span style="font-size: 16px;">P</span>
                    </div>
                </div>
            </div>
        </div>

        <%-- 메뉴 카드 영역 --%>
        <div class="row text-center mb-5">
            <div class="col-md-3 mb-4">
                <a href="<%= ctxPath %>/shop/orderList.sp" class="btn-mypage-card">
                    <div class="card-icon">📦</div>
                    <div class="card-title">주문내역</div>
                    <div class="card-desc">최근 주문 현황 확인</div>
                </a>
            </div>
            <div class="col-md-3 mb-4">
                <a href="<%= ctxPath %>/js_member/memberedit.sp" class="btn-mypage-card">
                    <div class="card-icon">👤</div>
                    <div class="card-title">정보수정</div>
                    <div class="card-desc">내 정보 및 비밀번호 변경</div>
                </a>
            </div>
            <div class="col-md-3 mb-4">
                <a href="<%= ctxPath %>/shop/wishlist.sp" class="btn-mypage-card">
                    <div class="card-icon">🖤</div>
                    <div class="card-title">위시리스트</div>
                    <div class="card-desc">담아둔 관심 상품</div>
                </a>
            </div>
            <div class="col-md-3 mb-4">
                <a href="<%= ctxPath %>/customer/qnaList.sp" class="btn-mypage-card">
                    <div class="card-icon">💬</div>
                    <div class="card-title">나의문의</div>
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

    <%-- 하단 푸터 인클루드 --%>
    <jsp:include page="../footer.jsp" />

</body>
</html>