<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/header2.jsp"/>

<div class="container" style="max-width: 980px; margin: 30px auto;">

  <c:set var="n" value="${noticeDto}" />

  <h3 style="margin-bottom: 18px; font-weight: 800;">공지 수정(관리자)</h3>

  <form method="post" action="adminNoticeEdit.sp">
    <input type="hidden" name="noticeId" value="${n.noticeId}" />

    <div class="form-group">
      <label style="font-weight:700;">제목</label>
      <input type="text" name="subject" class="form-control" maxlength="200"
             value="<c:out value='${n.subject}'/>" required />
    </div>

    <div class="form-group" style="margin-top:12px;">
      <label style="font-weight:700;">내용</label>
      <textarea name="content" class="form-control" rows="10" required><c:out value="${n.content}"/></textarea>
    </div>

    <div class="form-group" style="margin-top:12px;">
      <label>
        <input type="checkbox" name="isFixed" value="1" <c:if test="${n.isFixed == 1}">checked</c:if> />
        상단 고정(공지)
      </label>
    </div>

    <div style="margin-top:18px; display:flex; gap:10px;">
      <button type="submit" class="btn btn-primary">수정완료</button>
      <a class="btn btn-secondary" href="noticeView.sp?noticeId=${n.noticeId}">취소</a>
      <a class="btn btn-dark" href="adminNoticeList.sp">목록</a>
    </div>
  </form>

</div>

<jsp:include page="/WEB-INF/footer2.jsp"/>
