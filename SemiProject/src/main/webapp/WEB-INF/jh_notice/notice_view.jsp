<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/header.jsp"/>

<div class="container" style="max-width: 980px; margin: 30px auto;">

  <c:set var="n" value="${noticeDto}" />

  <div style="display:flex; justify-content:space-between; align-items:flex-start; gap:12px;">
    <div>
      <h3 style="margin:0 0 10px; font-weight:800;">
        <c:out value="${n.subject}"/>
        <c:if test="${n.isFixed == 1}">
          <span class="badge badge-danger" style="margin-left:8px;">NOTICE</span>
        </c:if>
      </h3>

      <div style="color:#666; font-size:14px; display:flex; gap:14px; flex-wrap:wrap;">
        <span>작성자: <b><c:out value="${n.adminId}"/></b></span>
        <span>작성일: <c:out value="${n.regDate}"/></span>

        <c:if test="${not empty n.updateDate}">
          <span>수정일: <c:out value="${n.updateDate}"/></span>
        </c:if>
      </div>
    </div>

    <!-- ✅ 관리자 버튼 -->
    <c:if test="${isAdmin}">
      <div style="display:flex; gap:8px;">
        <!-- 수정/삭제는 컨트롤러 만들면 실제 URL로 교체 -->
        <a class="btn btn-outline-dark" href="adminNoticeEdit.sp?noticeId=${n.noticeId}">수정</a>
        <a class="btn btn-danger"
           href="adminNoticeDelete.sp?noticeId=${n.noticeId}"
           onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
      </div>
    </c:if>
  </div>

  <hr/>

  <div style="min-height:240px; line-height:1.75; white-space:pre-wrap;">
    <c:out value="${n.content}"/>
  </div>

  <div style="margin-top:20px; display:flex; gap:10px;">
    <!-- 일반회원 목록 -->
    <a class="btn btn-secondary" href="noticeList.sp">목록</a>

    <!-- 관리자면 관리자 목록으로 -->
    <c:if test="${isAdmin}">
	  <div style="display:flex; gap:8px;">
	    <a class="btn btn-outline-dark" href="adminNoticeEdit.sp?noticeId=${n.noticeId}">수정</a>
	    <a class="btn btn-danger"
	       href="adminNoticeDelete.sp?noticeId=${n.noticeId}"
	       onclick="return confirm('정말 삭제하시겠습니까?');">삭제</a>
	  </div>
	</c:if>

  </div>

</div>

<jsp:include page="/WEB-INF/footer.jsp"/>
