<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String ctxPath = request.getContextPath(); %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="utf-8">
    <title>CARIN ADMIN</title>
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

        /* 헤더 상단 고정 스타일 */
        .fixed-top-header {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            z-index: 2000;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        body {
            padding-top: 105px; /* 공지바(35px) + 내비바(70px) 합산 높이 */
            background-color: #f8f9fa;
        }

        /* 상단 공지 슬라이드 */
        .top-announcement-bar { background-color: var(--dark-wood); height: 35px; }
        .announcement-item { height: 35px; line-height: 35px; text-align: center; text-decoration: none !important; }
        .announcement-text { color: #ffffff; font-size: 0.85rem; display: block; }
        
        /* 로고 및 네비게이션 */
        .center-logo { position: absolute; left: 50%; top: 50%; transform: translate(-50%, -50%); z-index: 1000; }
        .navbar-nav .nav-link { font-weight: 400 !important; color: #555 !important; font-size: 0.95rem; }
        .text-wood { color: var(--text-brown) !important; }
        .btn-wood { background-color: var(--dark-wood) !important; color: white !important; }

        /* 관리자 레이아웃 전용 스타일 */
        .admin-container { min-height: 800px; padding: 50px 0; }
        
        .sidebar-sticky {
            position: -webkit-sticky;
            position: sticky;
            top: 130px; /* 고정 헤더 높이 + 여백 */
            height: fit-content;
        }
        
        .sidebar-menu { background-color: #fff; border: 1px solid #ddd; border-radius: 0; }
        .sidebar-menu .list-group-item { border: none; color: #333; font-size: 0.95rem; padding: 15px 20px; text-decoration: none; display: block; }
        .menu-parent { font-weight: 600; border-bottom: 1px solid #eee !important; }
        .menu-parent:hover { background-color: var(--light-bg) !important; color: var(--dark-wood) !important; }
        .sub-menu-list { background-color: #fcfcfc; border-bottom: 1px solid #eee; }
        .sub-menu-list a { display: block; padding: 10px 20px 10px 50px; color: #777; font-size: 0.9rem; text-decoration: none; border-bottom: 1px solid #f1f1f1; }
        .sub-menu-list a:hover { color: var(--dark-wood); background-color: #f5f5f5; font-weight: bold; }

        /* 본문 흰색 박스 영역 */
        .admin-main-content {
            background-color: #ffffff;
            border: 1px solid #ddd;
            padding: 40px;
            min-height: 700px;
        }

        @media (max-width: 991px) {
            body { padding-top: 95px; }
            .sidebar-sticky { position: static; }
        }
    </style>
</head>

<body>
    <div class="fixed-top-header">
        <div class="container-fluid top-announcement-bar p-0">
            <div id="noticeCarousel" class="carousel slide" data-ride="carousel">
                <div class="carousel-inner">
                    <div class="carousel-item active announcement-item">
                        <span class="announcement-text">[관리자 모드] 시스템 공지 및 모니터링 페이지입니다.</span>
                    </div>
                </div>
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

                <div class="center-logo">
                    <a href="<%= ctxPath %>/admin.sp" class="text-decoration-none text-center d-block">
                        <h1 class="m-0 display-5 font-weight-semi-bold">
                            <span class="text-wood font-weight-bold px-3">CARIN ADMIN</span>
                        </h1>
                    </a>
                </div>

                <div class="d-flex align-items-center ml-auto" style="z-index: 1001;">
                    <div class="navbar-nav mr-lg-4">
                        <a href="<%= ctxPath %>/index.sp" class="nav-item nav-link text-primary font-weight-bold">사용자홈 바로가기</a>
                    </div>
                    <div class="d-inline-flex align-items-center">
                        <a href="#" class="btn p-0 mr-3"><i class="fas fa-user text-wood"></i></a>
                        <a href="#" class="btn p-0"><i class="fas fa-sign-out-alt text-wood"></i></a>
                    </div>
                </div>
            </nav>
        </div>
    </div> 

    <div class="container-fluid admin-container px-xl-5">
        <div class="row px-xl-5">
            
            <div class="col-lg-2 mb-4">
                <div class="sidebar-sticky">
                    <h5 class="font-weight-bold mb-3" style="color: var(--dark-wood);">ADMIN MENU</h5>
                    <div class="list-group sidebar-menu" id="adminAccordion">
                        
                        <a href="<%= ctxPath %>/admin.sp" class="list-group-item list-group-item-action menu-parent">대시보드</a>

                        <div class="menu-item">
                            <a class="list-group-item list-group-item-action menu-parent dropdown-toggle" 
                               data-toggle="collapse" href="#memberSub">회원관리</a>
                            <div class="collapse show" id="memberSub" data-parent="#adminAccordion">
                                <div class="sub-menu-list">
                                    <a href="#">회원목록조회</a>
                                </div>
                            </div>
                        </div>

                        <div class="menu-item">
                            <a class="list-group-item list-group-item-action menu-parent dropdown-toggle" 
                               data-toggle="collapse" href="#productSub">상품관리</a>
                            <div class="collapse show" id="productSub" data-parent="#adminAccordion">
                                <div class="sub-menu-list">
                                    <a href="<%= ctxPath %>/admin/allproductList.sp">상품 전체목록</a>
                                    <a href="#">상품 등록</a>
                                    <a href="#">재고 관리</a>
                                </div>
                            </div>
                        </div>

                        <div class="menu-item">
                            <a class="list-group-item list-group-item-action menu-parent dropdown-toggle" 
                               data-toggle="collapse" href="#operationSub">운영관리</a>
                            <div class="collapse show" id="operationSub" data-parent="#adminAccordion">
                                <div class="sub-menu-list">
                                    <a href="#">공지사항 관리</a>
                                    <a href="#">리뷰 관리</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-lg-10">
                <div class="admin-main-content shadow-sm">



