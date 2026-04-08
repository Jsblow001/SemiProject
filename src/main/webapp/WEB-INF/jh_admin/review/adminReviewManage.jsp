<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    String ctxPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>관리자 | 리뷰 관리</title>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<style>
  body{
    margin:0;
    font-family: Pretendard, Arial, sans-serif;
    background:#f7f6f3;
    color:#111;
  }

  .wrap{
    width: 1100px;
    margin: 70px auto;
    background:#fff;
    border-radius:10px;
    padding: 34px 34px 26px;
    box-shadow: 0 6px 18px rgba(0,0,0,0.07);
  }

  .topRow{
    display:flex;
    justify-content:space-between;
    align-items:flex-end;
    gap:16px;
    margin-bottom:18px;
  }

  .titleBox .title{
    font-size:22px;
    font-weight:900;
    margin:0 0 6px 0;
  }

  .titleBox .desc{
    font-size:13px;
    color:#666;
    line-height:1.35;
  }

  .filters{
    display:flex;
    align-items:center;
    gap:10px;
  }

  select{
    padding:10px 12px;
    border:1px solid #ddd;
    border-radius:10px;
    font-size:14px;
    outline:none;
    background:#fff;
    cursor:pointer;
  }

  .countBadge{
    font-size:13px;
    color:#444;
    background:#f1f1f1;
    border:1px solid #e5e5e5;
    padding:8px 10px;
    border-radius:999px;
  }

  .adminTable{
    width:100%;
    border-collapse:collapse;
    margin-top:12px;
    overflow:hidden;
    border-radius:10px;
  }

  .adminTable thead th{
    background:#111;
    color:#fff;
    font-size:13px;
    padding:13px 10px;
    text-align:center;
    font-weight:800;
    letter-spacing:0.2px;
  }

  .adminTable tbody td{
    border-bottom:1px solid #eee;
    padding:13px 10px;
    font-size:13px;
    text-align:center;
    vertical-align:middle;
  }

  .adminTable tbody tr{
    cursor:pointer;
    transition: background 0.12s ease;
  }

  .adminTable tbody tr:hover{
    background:#fafafa;
  }

  .left{
    text-align:left !important;
  }

  .pill{
    display:inline-block;
    padding:5px 10px;
    border-radius:999px;
    font-size:12px;
    border:1px solid #e5e5e5;
    background:#f7f7f7;
    color:#333;
  }

  .pill.red{
    background:#fff1f1;
    border-color:#ffd6d6;
    color:#c13535;
    font-weight:700;
  }

  .emptyBox{
    padding:50px 0;
    text-align:center;
    color:#777;
    font-size:14px;
  }

  /* ✅ 페이지네이션 (10블록) */
  .pager{
    margin-top:22px;
    display:flex;
    justify-content:center;
    align-items:center;
    gap:6px;
    flex-wrap:wrap;
  }

  .pager a, .pager span{
    display:inline-flex;
    justify-content:center;
    align-items:center;
    min-width:34px;
    height:34px;
    padding:0 10px;
    border-radius:10px;
    border:1px solid #ddd;
    background:#fff;
    color:#111;
    font-size:13px;
    text-decoration:none;
  }

  .pager a:hover{
    background:#f4f4f4;
  }

  .pager .active{
    background:#111;
    color:#fff;
    border-color:#111;
    font-weight:800;
  }

  .pager .arrow{
    font-weight:900;
  }

  .pager .disabled{
    opacity:0.35;
    cursor:not-allowed;
  }

  /* 반응형 */
  @media (max-width: 1200px){
    .wrap{ width: calc(100% - 30px); }
  }
</style>

</head>
<body>
<jsp:include page="../../header2.jsp" />
<div class="wrap">

  <div class="topRow">
    <div class="titleBox">
      <div class="title">리뷰 관리</div>
      <div class="desc">
        드롭다운으로 <b>미답변 리뷰 / 신고된 리뷰</b>를 필터링해서 확인할 수 있습니다.<br/>
        신고된 리뷰는 <b>가장 최근 신고 일자 기준</b>으로 정렬됩니다.
      </div>
    </div>

    <div class="filters">
      <select id="viewSelect">
        <option value="unanswered" ${view == 'unanswered' ? 'selected' : ''}>미답변 리뷰</option>
        <option value="reported" ${view == 'reported' ? 'selected' : ''}>신고된 리뷰</option>
      </select>

      <span class="countBadge">
        총 <b>${totalCount}</b>건
      </span>
    </div>
  </div>

  <!-- ============================= -->
  <!-- ✅ 미답변 리뷰 -->
  <!-- ============================= -->
  <c:if test="${view == 'unanswered'}">

    <c:if test="${empty unansweredList}">
      <div class="emptyBox">미답변 리뷰가 없습니다.</div>
    </c:if>

    <c:if test="${not empty unansweredList}">
      <table class="adminTable">
        <thead>
          <tr>
            <th style="width:80px;">번호</th>
            <th>상품명</th>
            <th style="width:90px;">작성자</th>
            <th style="width:110px;">작성일</th>
            <th style="width:80px;">평점</th>
            <th style="width:120px;">상태</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="r" items="${unansweredList}">
            <tr onclick="goDetail('${r.review_id}')">
              <td>${r.review_id}</td>
              <td class="left">${fn:escapeXml(r.product_name)}</td>
              <td>${r.writer}</td>
              <td>${r.review_date}</td>
              <td>${r.rating}</td>
              <td><span class="pill">미답변</span></td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </c:if>

  </c:if>


  <!-- ============================= -->
  <!-- ✅ 신고된 리뷰 -->
  <!-- ============================= -->
  <c:if test="${view == 'reported'}">

    <c:if test="${empty reportedList}">
      <div class="emptyBox">신고된 리뷰가 없습니다.</div>
    </c:if>

    <c:if test="${not empty reportedList}">
      <table class="adminTable">
        <thead>
          <tr>
            <th style="width:80px;">번호</th>
            <th>상품명</th>
            <th style="width:90px;">작성자</th>
            <th style="width:110px;">리뷰작성일</th>
            <th style="width:150px;">최근신고일</th>
            <th style="width:90px;">신고횟수</th>
            <th style="width:120px;">상태</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="r" items="${reportedList}">
            <tr onclick="goDetail('${r.review_id}')">
              <td>${r.review_id}</td>
              <td class="left">${fn:escapeXml(r.product_name)}</td>
              <td>${r.writer}</td>
              <td>${r.review_date}</td>
              <td>${r.last_report_date}</td>

              <td>
                <c:choose>
                  <c:when test="${r.report_count >= 3}">
                    <span class="pill red">${r.report_count}회</span>
                  </c:when>
                  <c:otherwise>
                    <span class="pill">${r.report_count}회</span>
                  </c:otherwise>
                </c:choose>
              </td>

              <td><span class="pill red">신고됨</span></td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </c:if>

  </c:if>


  <!-- ============================= -->
  <!-- ✅ 페이지네이션 (10블록 방식) -->
  <!-- ============================= -->
  <c:if test="${totalPage > 1}">
    <div class="pager">

      <!-- 이전 블록 -->
      <c:if test="${startPage > 1}">
        <a class="arrow"
           href="<%=ctxPath%>/adminReviewManage.sp?view=${view}&currentShowPageNo=${startPage-1}">
          &laquo;
        </a>
      </c:if>

      <!-- 이전 페이지 -->
      <c:choose>
        <c:when test="${currentShowPageNo > 1}">
          <a class="arrow"
             href="<%=ctxPath%>/adminReviewManage.sp?view=${view}&currentShowPageNo=${currentShowPageNo-1}">
            &lsaquo;
          </a>
        </c:when>
        <c:otherwise>
          <span class="arrow disabled">&lsaquo;</span>
        </c:otherwise>
      </c:choose>

      <!-- 페이지 번호 -->
      <c:forEach var="p" begin="${startPage}" end="${endPage}">
        <c:choose>
          <c:when test="${p == currentShowPageNo}">
            <span class="active">${p}</span>
          </c:when>
          <c:otherwise>
            <a href="<%=ctxPath%>/adminReviewManage.sp?view=${view}&currentShowPageNo=${p}">
              ${p}
            </a>
          </c:otherwise>
        </c:choose>
      </c:forEach>

      <!-- 다음 페이지 -->
      <c:choose>
        <c:when test="${currentShowPageNo < totalPage}">
          <a class="arrow"
             href="<%=ctxPath%>/adminReviewManage.sp?view=${view}&currentShowPageNo=${currentShowPageNo+1}">
            &rsaquo;
          </a>
        </c:when>
        <c:otherwise>
          <span class="arrow disabled">&rsaquo;</span>
        </c:otherwise>
      </c:choose>

      <!-- 다음 블록 -->
      <c:if test="${endPage < totalPage}">
        <a class="arrow"
           href="<%=ctxPath%>/adminReviewManage.sp?view=${view}&currentShowPageNo=${endPage+1}">
          &raquo;
        </a>
      </c:if>

    </div>
  </c:if>

</div>


<script>
  // ✅ 필터 변경
  $(function(){
    $("#viewSelect").on("change", function(){
      const view = $(this).val();
      location.href = "<%=ctxPath%>/adminReviewManage.sp?view=" + view;
    });
  });

  // ✅ 상세 이동 (리뷰 상세 페이지 URL은 너희 프로젝트에 맞게 변경)
  function goDetail(reviewId){
    // reviewView.sp?reviewId=xxx 로 이동한다고 가정
    location.href = "<%=ctxPath%>/reviewView.sp?reviewId=" + reviewId;
  }
</script>
<jsp:include page="../../footer2.jsp" />
</body>
</html>
