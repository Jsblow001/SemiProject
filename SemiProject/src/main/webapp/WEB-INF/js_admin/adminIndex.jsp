<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    String ctxPath = request.getContextPath();
%>

<%-- 1. 제공된 헤더 포함 --%>
<jsp:include page="../header2.jsp" />

<style>
    /* 관리자 페이지 레이아웃 */
    .admin-container {
        min-height: 800px;
        padding: 50px 0;
        background-color: #fff;
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
   
   <div class="col-lg-10">
       <h4 class="font-weight-bold mb-4 text-dark">운영 현황 요약</h4>
       <div class="row">
           <div class="col-md-4 mb-4">
               <div class="card dashboard-card p-4" style="border-left: 5px solid var(--dark-wood) !important;">
                   <p class="text-muted mb-2">Total Members</p>
                   <h2 class="font-weight-bold">${(totalCount != null) ? totalCount : 0} 명</h2>
                   <a href="<%= ctxPath %>/admin/memberList.sp" class="small text-wood font-weight-bold mt-2">상세 명단 보기 ></a>
               </div>
           </div>
           <div class="col-md-4 mb-4">
               <div class="card dashboard-card p-4" style="border-left: 5px solid #BCAA8F !important;">
                   <p class="text-muted mb-2">New Orders</p>
                   <h2 class="font-weight-bold">${(newOrderCount != null) ? newOrderCount : 0} 건</h2>
                   <a href="<%= ctxPath%>/admin/adminOrderList.sp" class="small text-wood font-weight-bold mt-2">주문 내역 관리 ></a>
               </div>
           </div>
           <div class="col-md-4 mb-4">
               <div class="card dashboard-card p-4" style="border-left: 5px solid #D7CCC8 !important;">
                   <p class="text-muted mb-2 font-weight-medium">Today's QnA</p>
                   <h2 class="font-weight-bold mb-3">${(newQnACount != null) ? newQnACount : 0} 건</h2>
                   <a href="<%= ctxPath%>/noCommentQnaList.sp" class="small text-wood font-weight-bold text-decoration-none">미답변 문의 확인 ></a>
               </div>
           </div>
       </div>
   </div>
</div>

<%-- 2. 제공된 푸터 포함 --%>
<jsp:include page="../footer2.jsp" />