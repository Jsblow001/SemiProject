<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String ctxPath = request.getContextPath(); %>

<head>
    <meta charset="utf-8">
    <title>SISEON</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">

	<link rel="preconnect" href="https://fonts.gstatic.com">
	<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@100;200;300;400;500;600;700;800;900&display=swap" rel="stylesheet"> 
	<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
	<link href="<%= ctxPath%>/css/style.css" rel="stylesheet">
	<script src="<%= ctxPath%>/js/jquery-3.7.1.min.js"></script>
	<script src="<%= ctxPath%>/js/main.js"></script>
    <script src="<%= ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js" type="text/javascript"></script>
    
    <style>
        :root {
            --dark-wood: #5D4037;
            --text-brown: #5D4037; 
            --light-bg: #EFEBE9;
        }

        .fixed-top-header {
            position: fixed;
            top: 0; left: 0; width: 100%;
            z-index: 2000;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05); 
        }

        body { padding-top: 105px; }

		.top-announcement-bar { background-color: var(--dark-wood); height: 35px; }
		.announcement-item { height: 35px; line-height: 35px; text-align: center; text-decoration: none !important; }
		.announcement-text { color: #ffffff; font-size: 0.85rem; display: block; }
		
        .center-logo {
            position: absolute;
            left: 50%; top: 50%;
            transform: translate(-50%, -50%);
            z-index: 1000;
        }
        .navbar-nav .nav-link { font-weight: 400 !important; color: #555 !important; font-size: 0.95rem; }
        .text-wood { color: var(--text-brown) !important; }
        .btn-wood { background-color: var(--dark-wood) !important; color: white !important; }

        /* --- 모바일 사이드 메뉴 스타일 (오버레이 제거 버전) --- */
        @media (max-width: 991px) {
            body { padding-top: 95px; }
            .navbar-collapse {
                position: fixed;
                top: 0;
                left: -100%; 
                width: 280px;
                height: 100vh;
                background-color: #fff;
                z-index: 3000;
                transition: left 0.3s ease-in-out;
                display: block !important;
                padding: 60px 20px;
                overflow-y: auto;
                box-shadow: 5px 0 15px rgba(0,0,0,0.1);
            }
            .navbar-collapse.show {
                left: 0;
            }

            .mobile-close-btn {
                position: absolute;
                top: 15px;
                right: 20px;
                font-size: 1.5rem;
                color: var(--dark-wood);
                cursor: pointer;
            }
            
            /* 모바일 드롭다운 메뉴 강제 표시 설정 */
            .navbar-nav .dropdown-menu {
                position: static !important;
                float: none;
                width: 100%;
                background-color: #fcfcfc;
                border: none;
                padding-left: 20px;
                display: none; /* 기본 숨김 */
            }
            .navbar-nav .dropdown-menu.show {
                display: block; /* 클릭 시 표시 */
            }
            .navbar-nav .nav-item { margin-bottom: 10px; }
        }

        @media (min-width: 992px) {
            .mobile-close-btn { display: none !important; }
        }

        /* 검색 패널 유지 */
        .header-search-panel{
            position: absolute; left: 0; right: 0; top: 100%;
            background: #fff; border-bottom: 1px solid #eee;
            box-shadow: 0 6px 20px rgba(0,0,0,0.06); z-index: 1999;
            max-height: 0; overflow: hidden; opacity: 0;
            transform: translateY(-8px);
            transition: max-height .25s ease, opacity .2s ease, transform .25s ease;
        }
        .header-search-panel.is-open{ max-height: 360px; opacity: 1; transform: translateY(0); }
    </style>
</head>

<body>
    <div class="fixed-top-header">
        <div class="container-fluid top-announcement-bar p-0">
            <div id="noticeCarousel" class="carousel slide" data-ride="carousel" data-interval="4000">
                <div class="carousel-inner">
                    <a href="<%= ctxPath %>/noticeView.sp?noticeId=5" class="carousel-item active announcement-item">
                        <span class="announcement-text">[공지] 신규 회원 가입 시 5000 포인트 즉시 지급</span>
                    </a>
                    <a href="<%= ctxPath %>/noticeView.sp?noticeId=8" class="carousel-item announcement-item">
                        <span class="announcement-text">[이벤트] SISEON x Collaboration 컬렉션 무료 배송</span>
                    </a>
                    <a href="<%= ctxPath %>/noticeView.sp?noticeId=9" class="carousel-item announcement-item">
                        <span class="announcement-text">[안내] 평일 오후 2시 이전 결제 시 당일 출고</span>
                    </a>
                </div>
            </div>
        </div>

        <div class="container-fluid border-bottom" style="background-color: var(--light-bg);">
            <nav class="navbar navbar-expand-lg navbar-light py-2 px-xl-5 position-relative">
                
                <div class="collapse navbar-collapse" id="navbarCollapse">
                    <div class="mobile-close-btn" id="closeSidebar">
                        <i class="fa fa-times"></i>
                    </div>

                    <div class="navbar-nav mr-auto">
                        <a href="<%= ctxPath %>/product/productList.sp?category=sunglasses" class="nav-item nav-link">SUNGLASSES</a>
                        <a href="<%= ctxPath %>/product/productList.sp?category=eyeglasses" class="nav-item nav-link">EYEGLASSES</a>
                        <a href="<%= ctxPath %>/product/productList.sp?category=accessory" class="nav-item nav-link">ACC</a>
                        <a href="<%= ctxPath %>/product/productList.sp?category=collaboration" class="nav-item nav-link">COLLABORATION</a>
                    </div>
                    
                    <div class="navbar-nav ml-auto">
                        <c:if test="${not empty sessionScope.loginuser && sessionScope.loginuser.userid == 'admin'}">
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle text-primary" href="#" data-toggle="dropdown">관리자전용</a>
                                <div class="dropdown-menu shadow border-0">
                                    <a class="dropdown-item" href="<%= ctxPath%>/admin/memberList.sp">회원관리</a>
                                    <a class="dropdown-item" href="<%= ctxPath%>/admin/allproductList.sp">상품관리</a>
                                    <a class="dropdown-item" href="<%= ctxPath%>/adminQnaList.sp">문의관리</a>
                                    <a class="dropdown-item" href="<%= ctxPath%>/revenue.sp">운영관리</a>
                                </div>
                            </li>
                        </c:if>

                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle text-primary" href="#" data-toggle="dropdown">BRAND</a>
                            <div class="dropdown-menu shadow border-0">
                                <a class="dropdown-item" href="<%= ctxPath%>/introduction.sp">Brand Story</a>
                            </div>
                        </li>

                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle text-primary" href="#" data-toggle="dropdown">COMMUNITY</a>
                            <div class="dropdown-menu shadow border-0">
                                <a class="dropdown-item" href="<%= ctxPath%>/noticeList.sp">Notice</a>
                                <a class="dropdown-item" href="<%= ctxPath%>/reviews.sp">Review</a>
                                <a class="dropdown-item" href="<%= ctxPath%>/qnaList.sp">QnA</a>
                                <a class="dropdown-item" href="<%= ctxPath%>/reservation.sp">예약하기</a>
                                <a class="dropdown-item" href="<%= ctxPath%>/storeLocation2.sp">매장찾기</a>
                            </div>
                        </li>
                    </div>
                </div>

                <button class="navbar-toggler" type="button" id="openSidebar">
                    <span class="navbar-toggler-icon"></span>
                </button>

                <div class="center-logo">
                    <a href="<%= ctxPath %>" class="text-decoration-none">
                        <h1 class="m-0 font-weight-bold text-wood px-3">SISEON</h1>
                    </a>
                </div>

                <div class="d-flex align-items-center ml-auto" style="z-index: 1001;">
                    <button id="btnHeaderSearch" class="btn btn-link text-wood p-0 mr-3"><i class="fa fa-search"></i></button>
                    
                    <c:choose>
                        <c:when test="${not empty sessionScope.loginuser}">
                            <a href="<%= ctxPath %>/mypage.sp" class="btn p-0 mr-3 text-primary"><i class="fas fa-user"></i></a>
                        </c:when>
                        <c:otherwise>
                            <a href="<%= ctxPath %>/loginSelect.sp" class="btn p-0 mr-3 text-wood"><i class="fas fa-user"></i></a>
                        </c:otherwise>
                    </c:choose>
                    
                    <a href="<%= ctxPath%>/product/cartList.sp" class="btn p-0 mr-3 text-wood"><i class="fas fa-shopping-cart"></i></a>
                    <c:if test="${not empty sessionScope.loginuser}">
                        <a href="<%=ctxPath%>/logout.sp" class="btn p-0 text-wood"><i class="fas fa-sign-out-alt"></i></a>
                    </c:if>
                </div>
            </nav>
        </div>

      	<div id="headerSearchPanel" class="header-search-panel">
            <div class="container-fluid px-xl-5 py-3 d-flex flex-column align-items-center">
                <form id="headerSearchForm" method="get" action="<%=ctxPath%>/productSearchResult.sp" class="search-row" style="width:33%; min-width:320px;">
                    <input id="headerSearchInput" name="q" type="text" class="form-control" placeholder="상품명을 입력하세요" autocomplete="off" />
                    <button type="submit" class="btn btn-wood">검색</button>
                </form>
                <div id="headerSearchResult" class="search-result mt-3" style="width:33%; min-width:320px;"></div>
            </div>   
        </div>
    </div> 

<script type="text/javascript">
$(function () {
    const $sidebar = $("#navbarCollapse");

    // 사이드바 열기
    $("#openSidebar").on("click", function() {
        $sidebar.addClass("show");
    });

    // 사이드바 닫기 (X 버튼 클릭)
    $("#closeSidebar").on("click", function() {
        $sidebar.removeClass("show");
    });

    // 모바일에서 드롭다운 메뉴 클릭 시 동작 보강
    $(".navbar-nav .dropdown-toggle").on("click", function(e) {
        if ($(window).width() < 992) {
            e.preventDefault();
            e.stopPropagation();
            const $nextMenu = $(this).next(".dropdown-menu");
            
            // 다른 열려있는 메뉴 닫기
            $(".dropdown-menu").not($nextMenu).removeClass("show");
            // 클릭한 메뉴 토글
            $nextMenu.toggleClass("show");
        }
    });

    // 검색창 로직
    const $searchPanel = $("#headerSearchPanel");
    $("#btnHeaderSearch").on("click", function (e) {
        e.stopPropagation();
        $searchPanel.toggleClass("is-open");
    });

    $(document).on("click", function(e){
        if(!$(e.target).closest('#headerSearchPanel').length) $searchPanel.removeClass("is-open");
        // 사이드바 외부 클릭 시 닫기
        if($(window).width() < 992 && !$(e.target).closest('#navbarCollapse').length && !$(e.target).closest('#openSidebar').length) {
            $sidebar.removeClass("show");
        }
    });
});
</script>
</body>