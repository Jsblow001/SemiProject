<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/header2.jsp"/>

<div class="container" style="max-width: 980px; margin: 30px auto;">

  <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom: 14px;">
    <h3 style="margin:0; font-weight: 800;">공지사항(관리자)</h3>
    <a class="btn btn-dark" href="adminNoticeWrite.sp">글쓰기</a>
  </div>

  <!-- 검색(관리자만) -->
  <form method="get" action="adminNoticeList.sp" style="display:flex; gap:10px; align-items:center; margin-bottom: 12px;">
    <select name="searchType" class="form-control" style="max-width:180px;">
      <option value="" <c:if test="${searchType == ''}">selected</c:if>>선택</option>
      <option value="subject" <c:if test="${searchType == 'subject'}">selected</c:if>>제목</option>
      <option value="content" <c:if test="${searchType == 'content'}">selected</c:if>>내용</option>
      <option value="subject_content" <c:if test="${searchType == 'subject_content'}">selected</c:if>>제목+내용</option>
    </select>

    <input type="text" name="searchWord" class="form-control" placeholder="검색어"
           value="<c:out value='${searchWord}'/>"/>

    <select name="sizePerPage" class="form-control" style="max-width:120px;">
      <option value="10" <c:if test="${sizePerPage == '10'}">selected</c:if>>10</option>
      <option value="5"  <c:if test="${sizePerPage == '5'}">selected</c:if>>5</option>
      <option value="3"  <c:if test="${sizePerPage == '3'}">selected</c:if>>3</option>
    </select>

    <button type="submit" class="btn btn-primary">검색</button>
  </form>

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
      <!-- ✅ 고정글 -->
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
        <tr><td colspan="4" style="text-align:center; padding: 30px 0;">검색 결과가 없습니다.</td></tr>
      </c:if>
    </tbody>
  </table>

  <!-- 페이지바 -->
  <div style="margin-top: 20px;">
    ${pageBar}
  </div>

</div>

<jsp:include page="/WEB-INF/footer2.jsp"/>
