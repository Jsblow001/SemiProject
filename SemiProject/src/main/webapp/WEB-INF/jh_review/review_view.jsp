<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>Review Detail</title>

<style>
  *{ box-sizing:border-box; }
  body{ margin:0; font-family: Arial, "Noto Sans KR", sans-serif; color:#111; background:#fff; }
  a{ color:inherit; text-decoration:none; }
  a:hover{ text-decoration:none; }

  .inner{ width:92%; max-width:1100px; margin:0 auto; padding:26px 0 60px; }

  .top{ display:flex; justify-content:space-between; align-items:flex-start; gap:12px; }
  .title{ font-size:22px; font-weight:800; margin:0 0 8px; }
  .meta{ display:flex; gap:16px; color:#666; font-size:12px; padding:10px 0 14px; border-bottom:1px solid #e9e9e9; flex-wrap:wrap; }
  .stars{ display:inline-flex; gap:1px; font-size:14px; }
  .star{ color:#111; }
  .star.off{ color:#ddd; }
  .prod{ font-size:12px; font-weight:700; color:#111; padding:6px 10px; border:1px solid #eee; border-radius:999px; background:#fafafa; }

  .content{ padding:18px 0 10px; font-size:14px; line-height:1.7; white-space:pre-wrap; }
  .tags{ margin-top:10px; display:flex; flex-wrap:wrap; gap:8px; }
  .tag{ font-size:11px; color:#555; border:1px solid #ececec; background:#f7f7f7; padding:6px 10px; border-radius:999px; }

  .photos{ margin-top:16px; display:grid; grid-template-columns: repeat(2, minmax(0,1fr)); gap:12px; max-width:520px; }
  .photo{ border-radius:12px; overflow:hidden; background:#f2f2f2; aspect-ratio:1/1; }
  .photo img{ width:100%; height:100%; object-fit:cover; display:block; }

  .admin-reply{ margin-top:22px; border-top:1px solid #eee; padding-top:12px; color:#444; font-size:12px; line-height:1.6; white-space:pre-line; }
  .admin-name{ margin-top:10px; font-size:12px; color:#666; }

  .btns{ display:flex; justify-content:flex-end; gap:10px; margin-top:18px; }
  .btn{ height:34px; padding:0 14px; font-size:12px; border:1px solid #2b2321; background:#fff; color:#2b2321; cursor:pointer; border-radius:10px; }
  .btn.dark{ background:#2b2321; color:#fff; }
  .btn.danger{ border-color:#d9534f; background:#d9534f; color:#fff; }

  @media (max-width:560px){
    .photos{ grid-template-columns: 1fr; max-width:100%; }
  }
</style>
</head>

<body>
<jsp:include page="../header.jsp"/>

<div class="inner">

  <div class="top">
    <div>
      <div class="title">${review.review_title}</div>

      <div class="meta">
        <div class="stars">
          <c:forEach var="i" begin="1" end="5">
            <c:choose>
              <c:when test="${i <= review.rating}">
                <span class="star">★</span>
              </c:when>
              <c:otherwise>
                <span class="star off">★</span>
              </c:otherwise>
            </c:choose>
          </c:forEach>
        </div>

        <div>작성자: ${review.writer}</div>
        <div>작성일: ${review.review_date}</div>
        <div class="prod">${review.productCode}</div>

        <c:if test="${review.verified == 1}">
          <div>✅ 구매 인증</div>
        </c:if>
      </div>
    </div>
  </div>

  <div class="content">${review.review_content}</div>

  <c:if test="${not empty review.tags}">
    <div class="tags">
      <c:forEach var="t" items="${review.tags}">
        <span class="tag">${t}</span>
      </c:forEach>
    </div>
  </c:if>

  <c:if test="${not empty review.photos}">
    <div class="photos">
      <c:forEach var="ph" items="${review.photos}">
        <div class="photo">
          <img src="${pageContext.request.contextPath}/img/review/${ph}"
               onerror="this.style.display='none';" />
        </div>
      </c:forEach>
    </div>
  </c:if>

  <c:if test="${not empty review.adminReply}">
    <div class="admin-reply">
      ${review.adminReply}
      <div class="admin-name">시선 올림</div>
    </div>
  </c:if>
  
  <!-- ✅ 관리자만 댓글 입력 가능 -->
<c:if test="${isAdmin}">
  <div style="margin-top:18px; border-top:1px solid #eee; padding-top:14px;">
    <div style="font-size:12px; color:#666; margin-bottom:8px;">
      관리자 댓글
    </div>

    <form method="post"
          action="${pageContext.request.contextPath}/reviewCommentWrite.sp">
      
      <input type="hidden" name="reviewId" value="${review.review_id}" />

      <!-- ✅ 저장 후 다시 이 상세로 돌아오기 -->
      <input type="hidden" name="returnUrl"
             value="${pageContext.request.contextPath}/reviewView.sp?reviewId=${review.review_id}" />

      <textarea name="comment_content"
                rows="4"
                style="width:100%; padding:12px; border:1px solid #ddd; border-radius:10px; resize:none; font-size:13px;"
                placeholder="관리자 댓글을 입력하세요.">${review.adminReply}</textarea>

      <div style="display:flex; justify-content:flex-end; gap:10px; margin-top:10px;">
        <button type="submit" class="btn dark"
                onclick="return confirm('댓글을 저장할까요?');">
          <c:choose>
            <c:when test="${empty review.adminReply}">댓글 등록</c:when>
            <c:otherwise>댓글 수정</c:otherwise>
          </c:choose>
        </button>
      </div>
    </form>
  </div>
</c:if>
  

  <div class="btns">
    <button type="button" class="btn"
            onclick="location.href='${referer}'">목록</button>

    <!-- ✅ 삭제는 상세에서만 -->
    <c:if test="${isAdmin || isOwner}">
      <form id="delReviewFrm" method="post"
            action="${pageContext.request.contextPath}/reviewDelete.sp"
            style="display:inline;">
        <input type="hidden" name="reviewId" value="${review.review_id}" />
        <button type="button" class="btn danger"
                onclick="if(confirm('정말 삭제할까요?')) document.getElementById('delReviewFrm').submit();">
          삭제
        </button>
      </form>
    </c:if>
  </div>

</div>

<jsp:include page="../footer.jsp"/>
</body>
</html>
