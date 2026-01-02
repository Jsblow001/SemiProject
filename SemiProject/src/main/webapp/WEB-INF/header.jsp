<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<% String ctxPath = request.getContextPath(); %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <title>CARIN</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">

    <link rel="preconnect" href="https://fonts.gstatic.com">
    
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@100;200;300;400;500;600;700;800;900&display=swap" rel="stylesheet"> 

    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">

    <link href="<%= ctxPath%>/css/style.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="<%= ctxPath%>/css/index/index.css" />
    
    <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
    
    <style>
        :root {
            --dark-wood: #5D4037;   /* 짙은 밤나무색 */
            --text-brown: #5D4037; 
            --light-bg: #EFEBE9;    /* 연한 베이지 브라운 */
        }

        /* [추가] 헤더 상단 고정 스타일 */
        .fixed-top-header {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            z-index: 2000;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05); /* 스크롤 시 하단과 구분되는 그림자 */
        }

        /* 헤더 고정으로 인해 가려지는 본문 영역 확보 */
        body {
            padding-top: 105px; /* 공지바(35px) + 내비바(70px) 합산 높이 */
        }

        /* 상단 공지 슬라이드 수정 */
		.top-announcement-bar {
		    background-color: var(--dark-wood);
		    height: 35px;
		}
		.announcement-item {
		    height: 35px;
		    line-height: 35px; /* 텍스트 수직 중앙 정렬 */
		    text-align: center;
		    text-decoration: none !important;
		}
		.announcement-text { 
		    color: #ffffff; 
		    font-size: 0.85rem; 
		    display: block; 
		}
		.navbar-nav {
		    list-style: none; /* 리스트 점 제거 */
		}
		.nav-item.dropdown {
		    list-style: none;
		}
        /* 2. 내비게이션 바 및 로고 정중앙 고정 */
        .center-logo {
            position: absolute;
            left: 50%;
            top: 50%;
            transform: translate(-50%, -50%);
            z-index: 1000;
        }
        .navbar-nav .nav-link {
            font-weight: 400 !important;
            color: #555 !important;
            font-size: 0.95rem;
        }
        .text-wood { color: var(--text-brown) !important; }
        .btn-wood { background-color: var(--dark-wood) !important; color: white !important; }

        @media (min-width: 992px) {
            .navbar-collapse.justify-content-start { padding-right: 120px; }
            .navbar-collapse.justify-content-end { padding-left: 120px; }
        }
        @media (max-width: 991px) {
            body { padding-top: 95px; }
            .center-logo h1 { font-size: 1.5rem; }
        }
    </style>
</head>

<body>
    <div class="fixed-top-header">
        <div class="container-fluid top-announcement-bar p-0">
            <div id="noticeCarousel" class="carousel slide" data-ride="carousel" data-interval="4000" data-pause="hover">
                <div class="carousel-inner">
                    <a href="/notice/1" class="carousel-item active announcement-item">
                        <span class="announcement-text">[공지] 신규 회원 가입 시 10% 할인 쿠폰 즉시 지급</span>
                    </a>
                    <a href="/notice/2" class="carousel-item announcement-item">
                        <span class="announcement-text">[이벤트] CARIN x Collaboration 컬렉션 무료 배송</span>
                    </a>
                    <a href="/notice/3" class="carousel-item announcement-item">
                        <span class="announcement-text">[안내] 평일 오후 2시 이전 결제 시 당일 출고</span>
                    </a>
                </div>
                <a class="carousel-control-prev" href="#noticeCarousel" role="button" data-slide="prev">
                    <span class="carousel-control-prev-icon"></span>
                </a>
                <a class="carousel-control-next" href="#noticeCarousel" role="button" data-slide="next">
                    <span class="carousel-control-next-icon"></span>
                </a>
            </div>
        </div>

        <div class="container-fluid border-bottom" style="background-color: var(--light-bg);">
            <nav class="navbar navbar-expand-lg navbar-light py-2 px-xl-5 position-relative">
                
                <div class="collapse navbar-collapse justify-content-start" id="navbarCollapse">
                    <div class="navbar-nav">
                        <a href="<%= ctxPath %>/product/productList.sp?category=sunglasses" class="nav-item nav-link text-nowrap mr-lg-3">SUNGLASSES</a>
                        <a href="<%= ctxPath %>/product/productList.sp?category=eyeglasses" class="nav-item nav-link text-nowrap mr-lg-3">EYEGLASSES</a>
                        <a href="<%= ctxPath %>/product/productList.sp?category=accessory" class="nav-item nav-link text-nowrap mr-lg-3">ACC</a>
                        <a href="<%= ctxPath %>/product/productList.sp?category=collaboration" class="nav-item nav-link text-nowrap">COLLABORATION</a>
                    </div>
                </div>

                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarCollapse">
                    <span class="navbar-toggler-icon"></span>
                </button>

                <div class="center-logo">
                    <a href="<%= ctxPath %>" class="text-decoration-none text-center d-block">
                        <h1 class="m-0 display-5 font-weight-semi-bold">
                            <span class="text-wood font-weight-bold px-3">CARIN</span>
                        </h1>
                    </a>
                </div>

                <div class="d-flex align-items-center ml-auto" style="z-index: 1001;">
                    
                    <%-- <c:if test="${not empty sessionScope.loginuser && sessionScope.loginuser.userid == 'admin'}"> --%> 
                    	<li class='nav-item dropdown'>
                    		<a class="nav-link dropdown-toggle menufont_size text-primary" href="#" id="navbarDropdown" data-toggle="dropdown">관리자전용</a>
                    		<div class="dropdown-menu" aria-labelledby="navbarDropdown">
                    			<a class="dropdown-item text-primary" href="<%= ctxPath%>">회원관리</a>
                    			<a class="dropdown-item text-primary" href="<%= ctxPath%>/admin/allproductList.sp">상품관리</a>
                    			<a class="dropdown-item text-primary" href="<%= ctxPath%>">문의관리</a>
                    			<a class="dropdown-item text-primary" href="<%= ctxPath%>">운영관리</a>
                    		</div>
                    	</li>
                    <%-- </c:if> --%> 
                    
                    <div class="collapse navbar-collapse mr-lg-4">
                        <div class="navbar-nav">
                            <a href="/stockist" class="nav-item nav-link text-nowrap mr-lg-3">BRAND</a>
                            <a href="/customer" class="nav-item nav-link text-nowrap">COMMUNITY</a>
                        </div>
                    </div>

                    <div class="d-inline-flex align-items-center">
                        <div class="dropdown d-inline-block mr-3">
                            <button class="btn btn-link text-wood p-0" type="button" data-toggle="dropdown">
                                <i class="fa fa-search"></i>
                            </button>
                            <div class="dropdown-menu dropdown-menu-right p-3 shadow border-0" style="width: 250px;">
                                <div class="input-group">
                                    <input type="text" class="form-control" placeholder="Search">
                                    <div class="input-group-append">
                                        <button class="btn btn-wood"><i class="fa fa-search"></i></button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <a href="/wish" class="btn p-0 mr-3"><i class="fas fa-user text-wood"></i></a>
                        <a href="/cart" class="btn p-0"><i class="fas fa-shopping-cart text-wood"></i></a>
                    </div>
                </div>
            </nav>
        </div>
    </div> 
    
</body>
</html>