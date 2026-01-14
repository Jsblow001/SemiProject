<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String ctxPath = request.getContextPath(); %>

<head>
    <meta charset="utf-8">
    <title>SISEON ADMIN</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">

    <link rel="preconnect" href="https://fonts.gstatic.com">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@100;200;300;400;500;600;700;800;900&display=swap" rel="stylesheet"> 
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="<%= ctxPath%>/css/style.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="<%= ctxPath%>/css/index/index.css" />
    
    <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
        
    <script src="lib/easing/easing.min.js"></script>
    <script src="lib/owlcarousel/owl.carousel.min.js"></script>
    
    <style>
        :root {
            --dark-wood: #5D4037;
            --text-brown: #5D4037; 
            --light-bg: #EFEBE9;
            --sidebar-sub: #fcfcfc;
        }

        .fixed-top-header { position: fixed; top: 0; left: 0; width: 100%; z-index: 2000; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
        body { padding-top: 105px; background-color: #f8f9fa; }

        .top-announcement-bar { background-color: var(--dark-wood); height: 35px; }
        .announcement-text { color: #ffffff; font-size: 0.85rem; line-height: 35px; text-align: center; display: block; }
        
        .center-logo { position: absolute; left: 50%; top: 50%; transform: translate(-50%, -50%); z-index: 1000; }
        .navbar-nav .nav-link { font-weight: 400 !important; color: #555 !important; font-size: 0.95rem; }
        .text-wood { color: var(--text-brown) !important; }

        /* [사이드바 디자인 - 아이콘 제거 버전] */
        .sidebar-sticky { position: sticky; top: 130px; height: fit-content; }
        .sidebar-menu { background-color: #fff; border: 1px solid #e0e0e0; border-radius: 8px; overflow: hidden; }
        
        .menu-parent { 
            font-weight: 600; 
            border-bottom: 1px solid #f1f1f1 !important; 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            padding: 15px 25px !important; 
            color: #444 !important;
            text-decoration: none !important;
            cursor: pointer;
            letter-spacing: 0.5px;
        }
        .menu-parent:hover { background-color: var(--light-bg) !important; color: var(--dark-wood) !important; }
        .menu-parent i.fa-chevron-down { font-size: 0.7rem; color: #ccc; transition: transform 0.3s; }
        .menu-parent.active i.fa-chevron-down { transform: rotate(180deg); color: var(--dark-wood); }
        .menu-parent.active { background-color: #fafafa; color: var(--dark-wood) !important; }

        .sub-menu-list { background-color: var(--sidebar-sub); }
        .sub-menu-list a { 
            display: block; 
            padding: 11px 25px 11px 35px; 
            color: #777; 
            font-size: 0.88rem; 
            text-decoration: none !important; 
            border-bottom: 1px solid #f9f9f9;
            transition: all 0.2s;
        }
        .sub-menu-list a:hover { color: var(--dark-wood); background-color: #f1f1f1; padding-left: 40px; font-weight: bold; }

        .admin-main-content { background-color: #ffffff; border: 1px solid #ddd; border-radius: 8px; padding: 40px; min-height: 700px; }
    </style>
</head>

<body>
    <div class="fixed-top-header">
        <div class="container-fluid top-announcement-bar p-0">
            <div class="announcement-item"><span class="announcement-text">[관리자 모드] 시스템 공지 및 모니터링 페이지입니다.</span></div>
        </div>

        <div class="container-fluid border-bottom" style="background-color: var(--light-bg);">
            <nav class="navbar navbar-expand-lg navbar-light py-2 px-xl-5 position-relative">
                <div class="collapse navbar-collapse justify-content-start">
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
                            <span class="text-wood font-weight-bold px-3">SISEON ADMIN</span>
                        </h1>
                    </a>
                </div>

                <div class="d-flex align-items-center ml-auto" style="z-index: 1001;">
                    <div class="navbar-nav mr-lg-4">
                        <a href="<%= ctxPath %>/index.sp" class="nav-item nav-link text-primary font-weight-bold">사용자홈 바로가기</a>
                    </div>
                    <div class="d-inline-flex align-items-center">
                        <a href="<%= ctxPath %>/admin.sp" class="btn p-0 mr-3"><i class="fas fa-user text-wood"></i></a>
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
                    <h5 class="font-weight-bold mb-4" style="color: var(--dark-wood); padding-left: 5px; letter-spacing: 1px; font-size: 1.1rem;">
                        ADMIN MENU
                    </h5>
                    <div class="list-group sidebar-menu" id="adminAccordion">
                        
                        <a href="<%= ctxPath %>/admin.sp" class="list-group-item list-group-item-action menu-parent">
                            <span>대시보드</span>
                        </a>

                        <div class="menu-item">
                            <a class="list-group-item list-group-item-action menu-parent" data-target="#memberSub">
                                <span>회원관리</span>
                                <i class="fas fa-chevron-down"></i>
                            </a>
                            <div class="collapse" id="memberSub">
                                <div class="sub-menu-list">
                             		<a href="<%= ctxPath %>/admin/memberList.sp">회원 목록</a>
                                    <a href="<%= ctxPath %>/admin/memberMain.sp">회원 관리</a>
                                    <a href="<%= ctxPath %>/memberGradeList.sp">회원 등급 관리</a>
                                </div>
                            </div>
                        </div>

                        <div class="menu-item">
                            <a class="list-group-item list-group-item-action menu-parent" data-target="#productSub">
                                <span>상품관리</span>
                                <i class="fas fa-chevron-down"></i>
                            </a>
                            <div class="collapse" id="productSub">
                                <div class="sub-menu-list">
                                    <a href="<%= ctxPath %>/admin/allproductList.sp">상품 전체목록</a>
                                    <a href="<%= ctxPath %>/admin/productRegister.sp">상품 등록</a>
                                    <a href="<%= ctxPath %>/admin/adminOrderList.sp">주문 현황</a>
                                    <a href="<%= ctxPath %>/admin/deliverySummary.sp">배송 현황</a>
                                </div>
                            </div>
                        </div>
                        
                        <div class="menu-item">
                            <a class="list-group-item list-group-item-action menu-parent" data-target="#questionSub">
                                <span>문의관리</span>
                                <i class="fas fa-chevron-down"></i>
                            </a>
                            <div class="collapse" id="questionSub">
                                <div class="sub-menu-list">
                                    <a href="<%= ctxPath %>/adminQnaList.sp">QnA 관리</a>
                                    <a href="<%= ctxPath %>/admin/revenueData.sp">리뷰 관리</a>
                                </div>
                            </div>
                        </div>

                        <div class="menu-item">
                            <a class="list-group-item list-group-item-action menu-parent" data-target="#operationSub">
                                <span>운영관리</span>
                                <i class="fas fa-chevron-down"></i>
                            </a>
                            <div class="collapse" id="operationSub">
                                <div class="sub-menu-list">
                                    <a href="<%= ctxPath %>/revenue.sp">수익 관리</a>
                                    <a href="<%= ctxPath %>/visitor.sp">방문자 관리</a>
                                    <a href="<%= ctxPath %>/adminNoticeList.sp">공지사항 관리</a>
                                    <a href="<%= ctxPath %>/admin/schedule.sp">예약 관리</a>
                                </div>
                            </div>
                        </div> 
                        
                        
                        
                    </div>
                </div>
            </div>

            <script>
            $(document).ready(function() {
                $('.menu-parent[data-target]').click(function() {
                    var targetId = $(this).data('target');
                    var $target = $(targetId);
                    var $this = $(this);

                    $('.collapse').not($target).collapse('hide');
                    $('.menu-parent').not($this).removeClass('active');

                    if ($target.hasClass('show')) {
                        $target.collapse('hide');
                        $this.removeClass('active');
                    } else {
                        $target.collapse('show');
                        $this.addClass('active');
                    }
                });
            });
            </script>

            <div class="col-lg-10">
                <div class="admin-main-content shadow-sm">