<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>Q&amp;A 상세</title>
<style>
  body{margin:0;font-family:Arial,"Noto Sans KR",sans-serif;color:#111;background:#fff}
  .inner{width:92%;max-width:1100px;margin:0 auto;padding:26px 0 60px}
  .title{font-size:22px;font-weight:700;margin:0 0 8px}
  .meta{display:flex;gap:18px;color:#666;font-size:12px;padding:10px 0 14px;border-bottom:1px solid #e9e9e9}
  .content{padding:18px 0 22px;font-size:14px;line-height:1.7;border-bottom:1px solid #efefef;white-space:pre-wrap}
  .btns{display:flex;justify-content:flex-end;gap:8px;margin-top:14px}
  .btn{height:34px;padding:0 14px;font-size:12px;border:1px solid #2b2321;background:#fff;color:#2b2321;cursor:pointer}
  .btn.dark{background:#2b2321;color:#fff}
  .cmt-wrap{margin-top:26px}
  .cmt-title{font-size:14px;font-weight:700;margin:0 0 10px}
  .cmt-item{padding:12px 0;border-bottom:1px solid #efefef}
  .cmt-meta{display:flex;gap:14px;color:#666;font-size:12px;margin-bottom:6px}
  .cmt-content{white-space:pre-wrap;font-size:13px;line-height:1.6}
  .cmt-form{margin-top:14px;display:flex;gap:8px}
  .cmt-form textarea{flex:1;min-height:70px;resize:vertical;border:1px solid #d9d9d9;padding:10px;font-size:13px;outline:none}
  .cmt-form button{width:90px;border:1px solid #2b2321;background:#2b2321;color:#fff;font-size:12px;cursor:pointer}
</style>
</head>
<body>

<jsp:include page="../header.jsp"/>

<div class="inner">
  <div class="title">${qna.subject}</div>

  <div class="meta">
    <div>작성자: ${qna.fkMemberId}</div>
    <div>작성일: ${qna.regDate}</div>
    <c:if test="${qna.updateDate != null}">
      <div>수정일: ${qna.updateDate}</div>
    </c:if>
    <c:if test="${qna.isSecret == 1}">
      <div>🔒 비밀글</div>
    </c:if>
  </div>

  <div class="content">${qna.content}</div>

  <div class="btns">
    <button class="btn" type="button"
      onclick="location.href='${requestScope.referer}'">목록</button>

    <!-- 작성자 or 관리자만 수정/삭제 버튼 -->
    <c:if test="${isAdmin || isOwner}">
      <button class="btn" type="button"
        onclick="window.open('<%=request.getContextPath()%>/qnaEdit.sp?qnaid=${qna.qnaId}',
                             'qnaEdit',
                             'width=900,height=750')">
	  	수정
	  </button>
      <button class="btn" type="button"
        onclick="if(confirm('정말 삭제할까요?')) location.href='<%=request.getContextPath()%>/qnaDelete.sp?qnaId=${qna.qnaId}';">삭제</button>
    </c:if>
  </div>

  <!-- 댓글 영역 -->
  <div class="cmt-wrap">
    <div class="cmt-title">댓글</div>

    <c:if test="${empty commentList}">
      <div style="color:#777;font-size:13px;padding:12px 0;">등록된 댓글이 없습니다.</div>
    </c:if>

    <c:forEach var="c" items="${commentList}">
      <div class="cmt-item">
        <div class="cmt-meta">
          <div>${c.fkMemberId}</div>
          <div>${c.regDate}</div>
        </div>
        <div class="cmt-content">${c.content}</div>
      </div>
    </c:forEach>

    <!-- 댓글 쓰기: 로그인한 경우만 -->
    <c:choose>
      <c:when test="${loginId != null}">
        <form class="cmt-form" method="post" action="<%=request.getContextPath()%>/qnaCommentWrite.sp">
          <input type="hidden" name="qnaId" value="${qna.qnaId}">
          <textarea name="content" placeholder="댓글을 입력하세요"></textarea>
          <button type="submit">등록</button>
        </form>
      </c:when>
      <c:otherwise>
        <div style="color:#777;font-size:13px;padding:12px 0;">댓글 작성은 로그인 후 가능합니다.</div>
      </c:otherwise>
    </c:choose>

  </div>
</div>

<jsp:include page="../footer.jsp"/>

</body>
</html>
