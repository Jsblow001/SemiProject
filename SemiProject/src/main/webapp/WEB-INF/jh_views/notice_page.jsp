<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/header.jsp"/>

<div class="container" style="max-width: 980px; margin: 30px auto;">

  <h3 style="margin-bottom: 18px; font-weight: 800;">공지사항</h3>

  <table class="table table-hover">
    <thead>
      <tr>
        <th style="width:90px;">번호</th>
        <th>제목</th>
        <th style="width:140px;">작성자</th>
        <th style="width:140px;">작성일</th>
      </tr>
    </thead>

    <tbody>
      <!-- ✅ 고정글: 1페이지에서만 fixedList가 들어옴 -->
      <c:forEach var="n" items="${fixedList}">
        <tr style="background:#fff7f7;">
          <td>공지</td>
          <td>
            <a href="noticeView.sp?noticeId=${n.noticeId}">
              <span class="badge badge-danger">NOTICE</span>
              <c:out value="${n.subject}"/>
            </a>
          </td>
          <td><c:out value="${n.adminId}"/></td>
          <td><c:out value="${n.regDate}"/></td>
        </tr>
      </c:forEach>

      <!-- ✅ 일반글 -->
      <c:forEach var="n" items="${noticeList}">
        <tr>
          <td><c:out value="${n.noticeId}"/></td>
          <td>
            <a href="noticeView.sp?noticeId=${n.noticeId}">
              <c:out value="${n.subject}"/>
            </a>
          </td>
          <td><c:out value="${n.adminId}"/></td>
          <td><c:out value="${n.regDate}"/></td>
        </tr>
      </c:forEach>

      <c:if test="${empty fixedList and empty noticeList}">
        <tr><td colspan="4" style="text-align:center; padding: 30px 0;">등록된 공지사항이 없습니다.</td></tr>
      </c:if>
    </tbody>
  </table>

  <!-- 페이지바 -->
  <div style="margin-top: 20px;">
    ${pageBar}
  </div>

</div>

<jsp:include page="/WEB-INF/footer.jsp"/>
