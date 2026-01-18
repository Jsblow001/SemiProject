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
body{
  margin:0;
  font-family: Arial, "Noto Sans KR", sans-serif;
  color:#111;
  background:#fff;
}
a{ color:inherit; text-decoration:none; }
a:hover{ text-decoration:none; }

.inner{
  width:92%;
  max-width:1100px;
  margin:0 auto;
  padding:26px 0 60px;
}

/* ===== 제목 ===== */
.title{
  font-size:22px;
  font-weight:800;
  margin:0 0 10px;
}

/* ===== 메타 (좌/우 정렬 + 구분선) ===== */
.meta{
  width:100%;
  display:flex;
  justify-content:space-between;
  align-items:center;
  gap:14px;
  padding:10px 0 14px;
  border-bottom:1px solid #e9e9e9;
  color:#666;
  font-size:12px;
}
.meta-left{
  display:flex;
  align-items:center;
  gap:14px;
  flex-wrap:wrap;
}
.meta-right{
  display:flex;
  align-items:center;
  gap:10px;
  flex-wrap:wrap;
  justify-content:flex-end;
}

/* 별점 */
.stars{ display:inline-flex; gap:1px; font-size:14px; }
.star{ color:#111; }
.star.off{ color:#ddd; }

/* 제품 pill */
.prod{
  font-size:12px;
  font-weight:700;
  color:#111;
  padding:6px 10px;
  border:1px solid #eee;
  border-radius:999px;
  background:#fafafa;
}

.verified{
  font-size:12px;
  font-weight:700;
  color:#111;
}

/* ===== 2단 레이아웃 ===== */
.two-col{
  display:flex;
  gap:22px;
  align-items:flex-start;
  padding-top:14px;
}

/* 좌측(2/3) */
.left-col{
  flex:2;
  min-width:0;
}

/* ✅ 우측(1/3) - ID로 강제 고정폭 */
#prodSide{
  flex:0 0 280px;
  max-width:280px;
  border:1px solid #eee;
  border-radius:12px;
  padding:12px;
  background:#fff;
}

/* ✅ 제품이미지 “커지는 문제” 여기서 종결 */
#prodSide .prod-thumb{
  width:100%;
  max-width:100%;
  height:170px;           /* ✅ 여기 숫자로 크기 조절 */
  display:block;
  object-fit:contain;
  border-radius:10px;
  background:#fafafa;
}

/* 상품명/힌트 */
#prodSide .prodSide-name{
  margin-top:10px;
  font-weight:800;
  font-size:13px;
  color:#111;
}
#prodSide .prodSide-hint{
  margin-top:4px;
  font-size:12px;
  color:#666;
}

/* 리뷰 내용 */
.content{
  padding:14px 0 10px;
  font-size:14px;
  line-height:1.7;
  white-space:pre-wrap;
}

/* 칭찬 태그 */
.tags{
  margin-top:10px;
  display:flex;
  flex-wrap:wrap;
  gap:8px;
}
.tag{
  font-size:11px;
  color:#555;
  border:1px solid #ececec;
  background:#f7f7f7;
  padding:6px 10px;
  border-radius:999px;
}

/* 리뷰 사진 */
.photos{
  margin-top:6px;
  display:grid;
  grid-template-columns: repeat(2, minmax(0,1fr));
  gap:12px;
  max-width:520px;
}
.photo{
  border-radius:12px;
  overflow:hidden;
  background:#f2f2f2;
  aspect-ratio:1/1;
}
.photo img{
  width:100%;
  height:100%;
  object-fit:cover;
  display:block;
}

/* 2단 아래 구분선 */
.divider{
  width:100%;
  height:1px;
  background:#eee;
  margin:18px 0 12px;
}

/* 관리자댓글 */
.admin-reply{
  margin-top:8px;
  color:#444;
  font-size:12px;
  line-height:1.6;
  white-space:pre-line;
}
.admin-name{
  margin-top:10px;
  font-size:12px;
  color:#666;
}

/* 하단 버튼 */
.btns{ display:flex; justify-content:flex-end; gap:10px; margin-top:18px; }
.btn{
  height:34px;
  padding:0 14px;
  font-size:12px;
  border:1px solid #2b2321;
  background:#fff;
  color:#2b2321;
  cursor:pointer;
  border-radius:10px;
}
.btn.dark{ background:#2b2321; color:#fff; }
.btn.danger{ border-color:#d9534f; background:#d9534f; color:#fff; }

/* 모바일 */
@media (max-width:768px){
  .two-col{ flex-direction:column; }
  #prodSide{ max-width:100%; flex:none; width:100%; }
  #prodSide .prod-thumb{ height:200px; }
}
@media (max-width:560px){
  .photos{ grid-template-columns: 1fr; max-width:100%; }
}

</style>
</head>

<body>
<jsp:include page="../header.jsp"/>

<div class="inner">

	<div class="top">
	  <div class="top-left">
	    <div class="title">${review.review_title}</div>
	
	    <!-- ✅ 메타 영역 좌/우 정렬 -->
	    <div class="meta">
	      <div class="meta-left">
	        <div>작성자: ${review.writer}</div>
	        <div>작성일: ${review.review_date}</div>
	        <div class="prod">${review.productCode}</div>
	      </div>
	
	      <div class="meta-right">
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
	
	        <c:if test="${review.verified == 1}">
	          <span class="verified">✅ 구매 인증</span>
	        </c:if>
	      </div>
	    </div>
	  </div>
	</div>

<!-- ✅ 2단 레이아웃 -->
<div class="two-col">

  <!-- ✅ 좌측(2/3) : 리뷰사진 → 리뷰내용 → 칭찬태그 -->
  <div class="left-col">

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

    <div class="content">${review.review_content}</div>

    <c:if test="${not empty review.tags}">
      <div class="tags">
        <c:forEach var="t" items="${review.tags}">
          <span class="tag">${t}</span>
        </c:forEach>
      </div>
    </c:if>

  </div>

  	<!-- ✅ 우측(1/3) : 상품이미지(클릭→상세) -->
	<div id="prodSide">
	  <a href="${pageContext.request.contextPath}/product/productDetail.sp?product_id=${review.fk_product_id}">
	    <img class="prod-thumb"
	         src="${pageContext.request.contextPath}/img/${review.pimage}"
	         alt="${review.productCode}"
	         onerror="this.style.display='none';" />
	  </a>
	
	  <div class="prodSide-name">${review.productCode}</div>
	  <div class="prodSide-hint">상품 상세로 이동</div>
	</div>


</div>

<!-- ✅ 두 단 아래 구분선 -->
<div class="divider"></div>

<!-- ✅ 관리자댓글은 구분선 아래 -->
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
  
  	<c:if test="${isAdmin}">
	  <div class="reportAdminBox" style="margin-top:24px; padding-top:12px; border-top:1px solid #eee;">
	    <div style="font-weight:800; margin-bottom:10px;">🚨 신고 내용</div>
	
	    <c:if test="${empty reportList}">
	      <div style="color:#777;">신고 내역이 없습니다.</div>
	    </c:if>
	
	    <c:forEach var="rep" items="${reportList}">
	      <div style="display:flex; justify-content:space-between; gap:10px; padding:10px 0; border-bottom:1px dashed #eee;">
	        <div style="font-weight:700;">${rep.reporter_name}</div>
	        <div style="flex:1; text-align:right;">${rep.report_content}</div>
	      </div>
	    </c:forEach>
	  </div>
	</c:if>
  

</div>


<jsp:include page="../footer.jsp"/>
</body>
</html>
