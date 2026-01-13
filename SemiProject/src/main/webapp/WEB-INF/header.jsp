<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<% String ctxPath = request.getContextPath(); %>


<head>
    <meta charset="utf-8">
    <title>CARIN</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">

    <link rel="preconnect" href="https://fonts.gstatic.com">
    
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@100;200;300;400;500;600;700;800;900&display=swap" rel="stylesheet"> 

    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">

    <link href="<%= ctxPath%>/css/style.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="<%= ctxPath%>/css/index/index.css" />
    
    <script src="<%= ctxPath%>/js/jquery-3.7.1.min.js"></script>
    
    <script src="<%= ctxPath%>/bootstrap-4.6.2-dist/js/bootstrap.bundle.min.js" type="text/javascript"></script>
    <style>
        :root {
            --dark-wood: #5D4037;  
            --text-brown: #5D4037; 
            --light-bg: #EFEBE9;    
        }

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
        }

		.top-announcement-bar {
		    background-color: var(--dark-wood);
		    height: 35px;
		}
		.announcement-item {
		    height: 35px;
		    line-height: 35px; 
		    text-align: center;
		    text-decoration: none !important;
		}
		.announcement-text { 
		    color: #ffffff; 
		    font-size: 0.85rem; 
		    display: block; 
		}
		.navbar-nav {
		    list-style: none;
		}
		.nav-item.dropdown {
		    list-style: none;
		}

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
        
        /* ------------------------------------------------- */
        
      
      .header-search-panel{
        position: absolute;
        left: 0;
        right: 0;
        top: 100%;               
        background: #fff;
        border-bottom: 1px solid #eee;
        box-shadow: 0 6px 20px rgba(0,0,0,0.06);
        z-index: 1999;
      
        /* 슬라이드 애니메이션 */
        max-height: 0;
        overflow: hidden;
        opacity: 0;
        transform: translateY(-8px);
        transition: max-height .25s ease, opacity .2s ease, transform .25s ease;
      }
      
      .header-search-panel.is-open{
        max-height: 360px;   
        opacity: 1;
        transform: translateY(0);
      }
      
      .search-row{
        display: flex;
        align-items: center;
        gap: 10px;
      }
      
      .search-result{
        max-height: 260px;
        overflow: auto;
      }
      
      .search-item{
        display:flex;
        gap:12px;
        padding:10px 0;
        border-top:1px solid #f1f1f1;
      }
      .search-item:first-child{ border-top:none; }
      .search-thumb{
        width:56px; height:56px; object-fit:cover; border-radius:10px;
      }
      .search-meta .name{ font-weight:600; color:#222; }
      .search-meta .price{ font-size:.9rem; color:#666; }
      .search-empty{ color:#888; padding:12px 0; }
      
/* --------------- */
:root{
  --fixedHeaderH: 105px; /* 기본값(대충). JS가 실제 높이로 갱신 */
}

.fixed-top-header{
  position: fixed;
  top: 0; left: 0;
  width: 100%;
  z-index: 2000;
}

.sidenav{
  width: 0;
  position: fixed;
  left: 0;

  top: var(--fixedHeaderH);
  height: calc(100% - var(--fixedHeaderH));

  background: var(--light-bg);            /* 연베이지 */
  color: var(--text-brown);               /* 우드 텍스트 */
  overflow-x: hidden;
  transition: 0.5s;
  z-index: 1500;      /* ✅ header(2000)보다 낮게 */
  padding-top: 20px;  /* 기존 60px 과하면 줄이기 */
}
a.upper{
  padding: 10px 16px 10px 24px;
  text-decoration: none;
  font-size: 20px;
  color: var(--text-brown);
  font-weight: 500;
  display: block;
}
a.lower{
  padding: 10px 16px 10px 24px;
  text-decoration: none;
  font-size: 20px;
  color: var(--text-brown);
  font-weight: 500;
  display: inline;
}
.sidenav a:hover{ 
  background: rgba(93,64,55,.08);         /* 우드빛 하이라이트 */
  color: var(--dark-wood);
}

.sidenav .closebtn{
  color: var(--text-brown);
  position: absolute;
  top: 0;
  right: 18px;
  font-size: 36px;
}
.sidenav .closebtn:hover{
  color: var(--dark-wood);
}
/* 버튼 기본(bootstrap 토글버튼처럼 보이게) */
.side-toggle{
  border: none;
  background: transparent;
  padding: .25rem .5rem;
  outline: none;
}

/* 3줄 햄버거 */
.hamburger{
  display:inline-block;
  cursor:pointer;
}

.hamburger .bar1,
.hamburger .bar2,
.hamburger .bar3{
  display:block;
  width: 28px;
  height: 3px;
  background-color: #333;
  margin: 6px 0;
  transition: 0.35s;
  border-radius: 2px;
}

.side-toggle.is-open .bar1{
  transform: translate(0, 9px) rotate(-45deg);
}
.side-toggle.is-open .bar2{
  opacity: 0;
}
.side-toggle.is-open .bar3{
  transform: translate(0, -9px) rotate(45deg);
}

#btnSideToggle:focus,
#btnSideToggle:active,
#btnSideToggle:focus-visible{
  outline: none !important;
  box-shadow: none !important; 
}

#btnSideToggle{
  border: 0 !important;
  background: transparent !important;
}

.rs-modal-overlay{
  position:fixed; inset:0;
  background: rgba(0,0,0,.45);
  z-index: 9999;
  display:flex;
  align-items:center;
  justify-content:center;
  padding: 18px;
}

.rs-modal{
  width: min(1100px, 96vw);
  height: min(860px, 92vh);
  background:#fff;
  border-radius: 16px;
  overflow:hidden;
  box-shadow: 0 20px 60px rgba(0,0,0,.35);
  display:flex;
  flex-direction:column;
}

.rs-modal-top{
  height:52px;
  display:flex;
  align-items:center;
  justify-content:space-between;
  padding: 0 14px;
  border-bottom:1px solid #eee;
  background:#fafafa;
}
.rs-modal-title{ font-weight:900; }
.rs-modal-x{
  width:40px; height:40px;
  border:1px solid #ddd;
  background:#fff;
  border-radius:10px;
  font-size:22px;
  cursor:pointer;
}

.rs-modal-frame{
  width:100%;
  flex:1;
  border:0;
}

/* --------------- */
        
    </style>
</head>
<%------------%>
<!-- ===== Reservation Modal (iframe) ===== -->
<div id="rsModalOverlay" class="rs-modal-overlay" style="display:none;">
  <div class="rs-modal">
    <div class="rs-modal-top">
      <div class="rs-modal-title">안경원 방문예약</div>
      <button type="button" class="rs-modal-x" id="rsModalCloseBtn" aria-label="닫기">×</button>
    </div>

    <iframe id="rsModalFrame" class="rs-modal-frame"
            src="about:blank" frameborder="0"></iframe>
  </div>
</div>
<%------------%>
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
			
           <%-- <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarCollapse">  --%> 
                <%------------%>
                <button id="btnSideToggle" type="button" class="navbar-toggler side-toggle" aria-label="menu">
				  <span class="hamburger" aria-hidden="true">
				    <span class="bar1"></span>
				    <span class="bar2"></span>
				    <span class="bar3"></span>
				  </span>
				</button>
                <%------------%>

                <div class="center-logo">
                    <a href="<%= ctxPath %>" class="text-decoration-none text-center d-block">
                        <h1 class="m-0 display-5 font-weight-semi-bold">
                            <span class="text-wood font-weight-bold px-3">CARIN</span>
                        </h1>
                    </a>
                </div>

                <div class="d-flex align-items-center ml-auto" style="z-index: 1001;">
                    
                    <c:if test="${not empty sessionScope.loginuser && sessionScope.loginuser.userid == 'admin'}">
                    	<li class="nav-item dropdown" style="list-style: none;">
                    		<a class="nav-link dropdown-toggle menufont_size text-primary" href="#" id="adminDropdown" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">관리자전용</a>
                    		<div class="dropdown-menu dropdown-menu-right shadow border-0" aria-labelledby="adminDropdown">
                    			<a class="dropdown-item text-primary" href="<%= ctxPath%>">회원관리</a>
                    			<a class="dropdown-item text-primary" href="<%= ctxPath%>/admin/allproductList.sp">상품관리</a>
                    			<a class="dropdown-item text-primary" href="<%= ctxPath%>/qnaList.sp">문의관리</a>
                    			<a class="dropdown-item text-primary" href="<%= ctxPath%>">운영관리</a>
                    		</div>
                    	</li>
                    </c:if>
                    
                    <div class="collapse navbar-collapse mr-lg-4">
                        <div class="navbar-nav">
                        
                        	<li class="nav-item dropdown" style="list-style: none;">
		                   		<a class="nav-link dropdown-toggle menufont_size text-primary" href="#" id="navbarDropdown" data-toggle="dropdown">BRAND</a>
		                   		<div class="dropdown-menu dropdown-menu-right shadow border-0" aria-labelledby="navbarDropdown">
		                   			<a class="dropdown-item text-primary" href="<%= ctxPath%>/introduction.sp">Brand Story</a>

		                   		</div>
		                   	</li>
                        
	                       	<li class="nav-item dropdown" style="list-style: none;">
		                   		<a class="nav-link dropdown-toggle menufont_size text-primary" href="#" id="navbarDropdown" data-toggle="dropdown">COMMUNITY</a>
		                   		<div class="dropdown-menu dropdown-menu-right shadow border-0" aria-labelledby="navbarDropdown">
		                   			<a class="dropdown-item text-primary" href="<%= ctxPath%>/noticeList.sp">Notice</a>
		                   			<a class="dropdown-item text-primary" href="<%= ctxPath%>/reviews.sp">Review</a>
		                   			<a class="dropdown-item text-primary" href="<%= ctxPath%>/qnaList.sp">QnA</a>
		                   			<a class="dropdown-item text-primary" href="<%= ctxPath%>">매장찾기</a>
		                   		</div>
		                   	</li>
                    	
                        </div>
                    </div>

                    <div class="d-inline-flex align-items-center">
                        <div class="dropdown d-inline-block mr-3">
                        
                         <button id="btnHeaderSearch" class="btn btn-link text-wood p-0" type="button">
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
                        
					    <c:choose>
					        <%-- 로그인한 상태일 때 --%>
					        <c:when test="${not empty sessionScope.loginuser}">
					            <a href="<%= ctxPath %>/mypage.sp" class="btn p-0 mr-3" title="마이페이지">
					                <i class="fas fa-user text-primary"></i> 
					            </a>
					        </c:when>
					        
					        <%-- 로그인하지 않은 상태일 때 --%>
					        <c:otherwise>
					            <a href="<%= ctxPath %>/loginSelect.sp" class="btn p-0 mr-3" title="로그인">
					                <i class="fas fa-user text-wood"></i>
					            </a>
					        </c:otherwise>
					    </c:choose>
					    
                        <a href="<%= ctxPath%>/product/cartList.sp" class="btn p-0"><i class="fas fa-shopping-cart text-wood"></i></a>
                    </div>
                </div>
            </nav>
        </div>
        
      	<div id="headerSearchPanel" class="header-search-panel">
        <div class="container-fluid px-xl-5 py-3" style="display:flex; flex-direction:column; align-items:center;">
      
        <!-- form이 flex 컨테이너 역할까지 하게 -->
        <form id="headerSearchForm"
              method="get"
              action="<%=ctxPath%>/productSearchResult.sp"
              class="search-row"
              style="width:33.333%; min-width:320px; max-width:520px; gap:8px;">
    
         <input id="headerSearchInput" name="q" type="text" class="form-control"
                 placeholder="상품명을 입력하세요" autocomplete="off"
                 style="font-size:0.9rem; padding:6px 10px; height:36px;" />
    
         <button type="submit" class="btn btn-wood"
                 style="font-size:0.85rem; padding:6px 12px; height:36px; white-space:nowrap;">
            검색
         </button>
    
        </form>
    
        <!-- 결과 -->
        <div id="headerSearchResult" class="search-result mt-3"
             style="width:33.333%; min-width:320px; max-width:520px;">
        </div>
      </div>   
    </div>
  </div>
  <%------------%>
  <!-- fixed-top-header 닫힌 다음에 위치시키기 -->
  <div id="mySidenav" class="sidenav">
	  <a class="upper" href="<%= ctxPath %>/product/productList.sp?category=sunglasses">SUNGLASSES</a>
	  <a class="upper" href="<%= ctxPath %>/product/productList.sp?category=eyeglasses">EYEGLASSES</a>
	  <a class="upper" href="<%= ctxPath %>/product/productList.sp?category=accessory">ACC</a>
	  <a class="upper" href="<%= ctxPath %>/product/productList.sp?category=collaboration">COLLABORATION</a>
	  <hr style="border-color:rgba(255,255,255,.15);">
	  <a class="upper" href="<%= ctxPath %>/noticeList.sp">Notice</a>
	  <a class="upper" href="<%= ctxPath %>/reviews.sp">Review</a>
	  <a class="upper" href="<%= ctxPath %>/qnaList.sp">QnA</a>
	  <hr style="border-color:rgba(255,255,255,.15); height:10%;">
	  <a class="lower" href="<%= ctxPath %>/reservation.sp">예약하기</a>
	  <a class="lower" href="<%= ctxPath %>#">매장찾기</a>
	  
   </div>
   <%------------%>
    
<script type="text/javascript">

$(function () {
	  const $panel = $("#headerSearchPanel");
	  const $input = $("#headerSearchInput");
	  const $form  = $("#headerSearchForm");
	  const $result = $("#headerSearchResult");
	  const $btn = $("#btnHeaderSearch");

	  function openPanel(){
	    $panel.addClass("is-open");
	    setTimeout(() => $input.trigger("focus"), 150);
	  }
	  function closePanel(){
	    $panel.removeClass("is-open");
	  }

	  // 버튼 클릭: 토글
	  $btn.on("click", function (e) {
	    e.stopPropagation(); // 버튼 누른 클릭이 "바깥 클릭"으로 잡히지 않게
	    $panel.toggleClass("is-open");
	    if ($panel.hasClass("is-open")) openPanel();
	  });

	  // 패널 내부 클릭은 닫힘 방지
	  $panel.on("click", function(e){
	    e.stopPropagation();
	  });

	  // 문서 어디든 클릭: 패널이 열려있으면 닫기
	  $(document).on("click", function(){
	    closePanel();
	  });

	  // ESC 누르면 닫기
	  $(document).on("keydown", function(e){
	    if(e.key === "Escape") closePanel();
	  });

	  function adjustHeaderSearchWidth(){
	    const isMobile = window.matchMedia("(max-width: 991px)").matches;

	    const w = isMobile ? "92%" : "33.333%";
	    const minW = isMobile ? "" : "320px";
	    const maxW = isMobile ? "640px" : "520px";

	    $form.css({ width: w, minWidth: minW, maxWidth: maxW });
	    $result.css({ width: w, minWidth: minW, maxWidth: maxW });
	  }
	  
	  // submit 검증(2글자 미만 막기)
	  $form.on("submit", function(e){
	    const q = ($input.val() || "").trim();
	    if(q.length < 2){
	      e.preventDefault();
	      alert("검색어는 2글자 이상 입력하세요.");
	      $input.trigger("focus");
	      return;
	    }
	    closePanel(); // 제출 시 닫기(선택)
	  });
	  
	<%------------%>
	//===== sidenav 토글(한 번만 바인딩) =====
	$("#btnSideToggle").on("click", function(e){
	  e.preventDefault();
	  if($(this).hasClass("is-open")) closeNav();
	  else openNav();
	});
	
	// ESC로 닫기
	$(document).on("keydown", function(e){
	  if(e.key === "Escape") closeNav();
	});
	
	// sidenav 링크 클릭하면 닫기
	$("#mySidenav").on("click", "a", function(){
	  closeNav();
	});
	
	// 리사이즈 처리
	syncFixedHeaderHeight();
	autoCloseSideNavOnDesktop();
	
	$(window).on("resize", function(){
	  syncFixedHeaderHeight();
	  autoCloseSideNavOnDesktop();
	});
	
	// X 버튼 닫기
	$("#rsModalCloseBtn").on("click", function(){
	  closeReservationModal({ reloadMain:false });
	});
	
	// 오버레이 바깥 클릭 닫기
	$("#rsModalOverlay").on("click", function(e){
	  if(e.target === this){
	    closeReservationModal({ reloadMain:false });
	  }
	});
	
	// ESC 닫기
	$(document).on("keydown", function(e){
	  if(e.key === "Escape" && $("#rsModalOverlay").is(":visible")){
	    closeReservationModal({ reloadMain:false });
	  }
	});

}); // end of $(function () 
		
// function declaration
function syncFixedHeaderHeight(){
  const header = document.querySelector(".fixed-top-header");
  if(!header) return;
  const h = header.getBoundingClientRect().height;
  document.documentElement.style.setProperty("--fixedHeaderH", h + "px");
}

function openNav(){
  syncFixedHeaderHeight();
  document.getElementById("mySidenav").style.width = "100%";
  document.body.style.overflow = "hidden";
  $("#btnSideToggle").addClass("is-open");
}

function closeNav(){
  document.getElementById("mySidenav").style.width = "0";
  document.body.style.overflow = "";
  $("#btnSideToggle").removeClass("is-open");
}

function autoCloseSideNavOnDesktop(){
  const isDesktop = window.matchMedia("(min-width: 992px)").matches;
  if(isDesktop) closeNav();
}

/* ===== Reservation Modal Control ===== */
function openReservationModal(url){
  const $ov = $("#rsModalOverlay");
  $("#rsModalFrame").attr("src", url);
  $ov.show();

  // 배경 스크롤 막기(선택)
  document.body.style.overflow = "hidden";
}

function closeReservationModal(options){
  // options: { reloadMain: true/false, goUrl: "..." }
  const $ov = $("#rsModalOverlay");
  $("#rsModalFrame").attr("src", "about:blank");
  $ov.hide();
  document.body.style.overflow = "";

  if(options && options.reloadMain){
    const go = (options.goUrl) ? options.goUrl : "<%=request.getContextPath()%>/index.sp";
    // 새로고침 느낌 확실히
    location.href = go + (go.includes("?") ? "&" : "?") + "_=" + Date.now();
  }
}
<%------------%>
</script>

</body>