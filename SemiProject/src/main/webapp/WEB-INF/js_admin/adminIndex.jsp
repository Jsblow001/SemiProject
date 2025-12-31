<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    String ctxPath = request.getContextPath();
%>

<%-- 1. 제공된 헤더 포함 --%>
<jsp:include page="../header.jsp" />

<style>
    /* 관리자 페이지 레이아웃 */
    .admin-container {
        min-height: 800px;
        padding: 50px 0;
        background-color: #fff;
    }
    
    /* 사이드바 스타일 */
    .sidebar-menu {
        background-color: #fff;
        border: 1px solid #ddd;
    }
    
    .sidebar-menu .list-group-item {
        border: none;
        color: #333;
        font-size: 0.95rem;
        padding: 15px 20px;
        cursor: pointer;
        display: block;
        text-decoration: none;
        transition: background 0.2s;
    }

    /* 부모 메뉴 스타일 */
    .menu-parent {
        font-weight: 600;
        border-bottom: 1px solid #eee !important;
        position: relative;
        background-color: #fff;
    }
    
    .menu-parent:hover {
        background-color: var(--light-bg) !important;
        color: var(--dark-wood) !important;
    }

    /* 하위 메뉴 스타일 (계단식 들여쓰기) */
    .sub-menu-list {
        background-color: #fcfcfc;
        border-bottom: 1px solid #eee;
    }
    
    .sub-menu-list a {
        display: block;
        padding: 10px 20px 10px 50px;
        color: #777;
        font-size: 0.9rem;
        text-decoration: none;
        border-bottom: 1px solid #f1f1f1;
    }

    .sub-menu-list a:last-child { border-bottom: none; }

    .sub-menu-list a:hover {
        color: var(--dark-wood);
        background-color: #f5f5f5;
        font-weight: bold;
    }

    /* 대시보드 카드 스타일 */
    .dashboard-card {
        border: none;
        box-shadow: 0 4px 15px rgba(0,0,0,0.05);
        border-radius: 0;
    }
    .text-wood { color: var(--text-brown) !important; }
   
</style>

<div class="container-fluid admin-container px-xl-5">
    <div class="row px-xl-5">
        
        <div class="col-lg-2 mb-4">
            <h5 class="font-weight-bold mb-3" style="color: var(--dark-wood);">ADMIN MENU</h5>
            
            <div class="list-group sidebar-menu" id="adminAccordion">
                
                <a href="${pageContext.request.contextPath}/admin.sp" class="list-group-item list-group-item-action menu-parent">
                    메인 화면
                </a>

                <div class="menu-item">
                    <a class="list-group-item list-group-item-action menu-parent dropdown-toggle" 
                       data-toggle="collapse" href="#memberSub" aria-expanded="false">
                        회원관리
                    </a>
                    <div class="collapse" id="memberSub" data-parent="#adminAccordion">
                        <div class="sub-menu-list">
                            <a href="#">회원목록</a>
                        </div>
                    </div>
                </div>

                <div class="menu-item">
                    <a class="list-group-item list-group-item-action menu-parent dropdown-toggle" 
                       data-toggle="collapse" href="#productSub" aria-expanded="false">
                        상품관리
                    </a>
                    <div class="collapse" id="productSub" data-parent="#adminAccordion">
                        <div class="sub-menu-list">
                            <a href="#">상품 등록 / 수정</a>
                            <a href="#">재고관리</a>
                            <a href="#">주문목록</a>
                        </div>
                    </div>
                </div>

                <div class="menu-item">
            <a class="list-group-item list-group-item-action menu-parent dropdown-toggle" 
               data-toggle="collapse" href="#inquirySub" aria-expanded="false">
                문의관리
            </a>
            <div class="collapse" id="inquirySub" data-parent="#adminAccordion">
                <div class="sub-menu-list">
                    <a href="#">Q&A 답변관리</a>
                    <a href="#">1:1 문의내역</a>
                    <a href="#">리뷰 관리</a>
                </div>
            </div>
        </div>
        
        <div class="menu-item">
            <a class="list-group-item list-group-item-action menu-parent dropdown-toggle" 
               data-toggle="collapse" href="#operationSub" aria-expanded="false">
                운영관리
            </a>
            <div class="collapse" id="operationSub" data-parent="#adminAccordion">
                <div class="sub-menu-list">
                    <a href="#">공지사항 등록</a>
                    <a href="#">수익 관리</a>
                </div>
            </div>
        </div>

        </div>
        </div>

        <div class="col-lg-10">
            <h4 class="font-weight-bold mb-4 text-dark">운영 현황 요약</h4>
            <div class="row">
                <div class="col-md-4 mb-4">
                    <div class="card dashboard-card p-4" style="border-left: 5px solid var(--dark-wood) !important;">
                        <p class="text-muted mb-2">Total Members</p>
                        <h2 class="font-weight-bold">${requestScope.totalMemberCount} 명</h2>
                        <a href="#" class="small text-wood font-weight-bold mt-2">상세 명단 보기 ></a>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <div class="card dashboard-card p-4" style="border-left: 5px solid #BCAA8F !important;">
                        <p class="text-muted mb-2">New Orders</p>
                        <h2 class="font-weight-bold">${requestScope.newOrderCount} 건</h2>
                        <a href="#" class="small text-wood font-weight-bold mt-2">주문 내역 관리 ></a>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <div class="card dashboard-card p-4" style="border-left: 5px solid #D7CCC8 !important;">
                        <p class="text-muted mb-2 font-weight-medium">Today's Q&A</p>
                        <h2 class="font-weight-bold mb-3">5 건</h2>
                        <a href="#" class="small text-wood font-weight-bold text-decoration-none">미답변 문의 확인 ></a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%-- 2. 제공된 푸터 포함 --%>
<jsp:include page="../footer.jsp" />