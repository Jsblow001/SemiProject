<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<% String ctxPath = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<link rel="stylesheet" href="<%=ctxPath%>/css/jh_review/reviews.css">
<title>Review</title>
</head>

<body>
<jsp:include page="../header.jsp"/>

<c:set var="midSort" value="${empty param.midSort ? 'reviewCount' : param.midSort}" />
<c:set var="sort" value="${empty param.sort ? (empty sort ? 'recent' : sort) : param.sort}" />
<c:set var="searchWord" value="${empty param.searchWord ? (empty searchWord ? '' : searchWord) : param.searchWord}" />

<script>
  const ctxPath = "<%= request.getContextPath() %>";
  const isLogin = ${sessionScope.loginuser == null ? "false" : "true"};
</script>

<style>
.pager{
  display:flex;
  justify-content:center;
  align-items:center;
  gap:6px;
  flex-wrap:wrap;     /* 줄바꿈 허용 */
  padding: 10px 0;
}

.pager a, .pager span{
  display:inline-flex;
  justify-content:center;
  align-items:center;
  min-width:34px;
  height:34px;
  border-radius:8px;
  border:1px solid #ddd;
  padding:0 10px;
  font-size:14px;
}

.pager .active{
  font-weight:700;
  border-color:#111;
}

.pager .arrow{
  font-weight:700;
}

.pager .disabled{
  opacity:.35;
}

.reportInner{
  display:flex;
  gap:8px;
  align-items:center;
}

.reportMsg{
  flex:1;
  padding:10px 12px;
  border:1px solid #ddd;
  border-radius:10px;
  font-size:14px;
  outline:none;
}

.reportMsg:focus{
  border-color:#111;
}

.btnReportSubmit{
  padding:10px 14px;
  border:0;
  border-radius:10px;
  background:#111;
  color:#fff;
  font-size:13px;
  cursor:pointer;
}

.btnReportSubmit:hover{
  opacity:0.92;
}

#allReviews{
  scroll-margin-top: 60px;
}

</style>

<div class="wrap">
  <div class="inner">
    <div class="page-title">Reviews</div>

	<%-- =========================
	     Mid Tabs (클릭 → 슬라이드 이동)
	========================= --%>
	<div class="mid-tabs" id="midTabs">
	  <a href="#" data-idx="0" class="${midSort eq 'reviewCount' ? 'active' : ''}">리뷰 많은순</a>
	  <div class="divider"></div>
	  <a href="#" data-idx="1" class="${midSort eq 'recentSales' ? 'active' : ''}">최근 판매량순</a>
	  <div class="divider"></div>
	  <a href="#" data-idx="2" class="${midSort eq 'avgRating' ? 'active' : ''}">리뷰 평점순</a>
	  <div class="divider"></div>
	  <a href="#" data-idx="3" class="${midSort eq 'newProduct' ? 'active' : ''}">최근 상품순</a>
	</div>
	
	<%-- =========================
	     Mid Sort Carousel (탭 4장)
	     좌/우 화살표 = 탭 이동
	========================= --%>
	<div class="midrank-wrap" id="midRank">
	  <div id="midSortCarousel" class="carousel slide" data-ride="carousel" data-interval="false" data-wrap="true">
	    <div class="carousel-inner">
	
	      <%-- 1) 리뷰 많은순 --%>
	      <div class="carousel-item ${midSort eq 'reviewCount' ? 'active' : ''}" data-sort="reviewCount">
	        <div class="mid-row">
	          <c:forEach var="m" items="${mid_reviewCount}">
	            <div class="mid-col">
	              <div class="card midrank-card">
	                <a href="<%=ctxPath%>/product/productDetail.sp?product_id=${m.productId}">
	                  <div class="mid-main">
	                    <img src="<%=ctxPath%>/img/${m.pimage}" alt="${m.code}">
	                  </div>
	                </a>
	
	                <div class="midrank-body">
	                  <div class="midrank-title">
	                    <a href="<%=ctxPath%>/product/productDetail.sp?product_id=${m.productId}">${m.code}</a>
	                  </div>
	                  <div class="midrank-meta">
	                    <span>리뷰 ${m.count}</span>
	                    <span>평점 ${m.rating}</span>
	                  </div>
	                  <div class="midrank-actions">
	                    <button type="button" class="btn btn-sm p-0" onclick="toggleWish('${m.productId}')">
	                      <i class="${m.isWish == 1 ? 'fas' : 'far'} fa-heart text-danger wish-icon-${m.productId}"></i>
	                    </button>
	                  </div>
	                </div>
	
	              </div>
	            </div>
	          </c:forEach>
	        </div>
	      </div>
	
	      <%-- 2) 최근 판매량순 --%>
	      <div class="carousel-item ${midSort eq 'recentSales' ? 'active' : ''}" data-sort="recentSales">
	        <div class="mid-row">
	          <c:forEach var="m" items="${mid_recentSales}">
	            <div class="mid-col">
	              <div class="card midrank-card">
	                <a href="<%=ctxPath%>/product/productDetail.sp?product_id=${m.productId}">
	                  <div class="mid-main">
	                    <img src="<%=ctxPath%>/img/${m.pimage}" alt="${m.code}">
	                  </div>
	                </a>
	
	                <div class="midrank-body">
	                  <div class="midrank-title">
	                    <a href="<%=ctxPath%>/product/productDetail.sp?product_id=${m.productId}">${m.code}</a>
	                  </div>
	                  <div class="midrank-meta">
	                    <span>리뷰 ${m.count}</span>
	                    <span>평점 ${m.rating}</span>
	                    <span>월간판매 ${m.salesQty}</span>
	                  </div>
	                  <div class="midrank-actions">
	                    <button type="button" class="btn btn-sm p-0" onclick="toggleWish('${m.productId}')">
	                      <i class="${m.isWish == 1 ? 'fas' : 'far'} fa-heart text-danger wish-icon-${m.productId}"></i>
	                    </button>
	                  </div>
	                </div>
	
	              </div>
	            </div>
	          </c:forEach>
	        </div>
	      </div>
	
	      <%-- 3) 리뷰 평점순 --%>
	      <div class="carousel-item ${midSort eq 'avgRating' ? 'active' : ''}" data-sort="avgRating">
	        <div class="mid-row">
	          <c:forEach var="m" items="${mid_avgRating}">
	            <div class="mid-col">
	              <div class="card midrank-card">
	                <a href="<%=ctxPath%>/product/productDetail.sp?product_id=${m.productId}">
	                  <div class="mid-main">
	                    <img src="<%=ctxPath%>/img/${m.pimage}" alt="${m.code}">
	                  </div>
	                </a>
	
	                <div class="midrank-body">
	                  <div class="midrank-title">
	                    <a href="<%=ctxPath%>/product/productDetail.sp?product_id=${m.productId}">${m.code}</a>
	                  </div>
	                  <div class="midrank-meta">
	                    <span>리뷰 ${m.count}</span>
	                    <span>평점 ${m.rating}</span>
	                  </div>
	                  <div class="midrank-actions">
	                    <button type="button" class="btn btn-sm p-0" onclick="toggleWish('${m.productId}')">
	                      <i class="${m.isWish == 1 ? 'fas' : 'far'} fa-heart text-danger wish-icon-${m.productId}"></i>
	                    </button>
	                  </div>
	                </div>
	
	              </div>
	            </div>
	          </c:forEach>
	        </div>
	      </div>
	
	      <%-- 4) 최근 상품순 --%>
	      <div class="carousel-item ${midSort eq 'newProduct' ? 'active' : ''}" data-sort="newProduct">
	        <div class="mid-row">
	          <c:forEach var="m" items="${mid_newProduct}">
	            <div class="mid-col">
	              <div class="card midrank-card">
	                <a href="<%=ctxPath%>/product/productDetail.sp?product_id=${m.productId}">
	                  <div class="mid-main">
	                    <img src="<%=ctxPath%>/img/${m.pimage}" alt="${m.code}">
	                  </div>
	                </a>
	
	                <div class="midrank-body">
	                  <div class="midrank-title">
	                    <a href="<%=ctxPath%>/product/productDetail.sp?product_id=${m.productId}">${m.code}</a>
	                  </div>
	                  <div class="midrank-meta">
	                    <span>리뷰 ${m.count}</span>
	                    <span>평점 ${m.rating}</span>
	                  </div>
	                  <div class="midrank-actions">
	                    <button type="button" class="btn btn-sm p-0" onclick="toggleWish('${m.productId}')">
	                      <i class="${m.isWish == 1 ? 'fas' : 'far'} fa-heart text-danger wish-icon-${m.productId}"></i>
	                    </button>
	                  </div>
	                </div>
	
	              </div>
	            </div>
	          </c:forEach>
	        </div>
	      </div>
	
	    </div>
	
	    <%-- 좌/우 화살표: 이제 “탭 이동”이 됨 --%>
	    <a class="carousel-control-prev" href="#midSortCarousel" role="button" data-slide="prev">
	      <span class="carousel-control-prev-icon" aria-hidden="true"></span>
	      <span class="sr-only">Previous</span>
	    </a>
	    <a class="carousel-control-next" href="#midSortCarousel" role="button" data-slide="next">
	      <span class="carousel-control-next-icon" aria-hidden="true"></span>
	      <span class="sr-only">Next</span>
	    </a>
	
	  </div>
	</div>





    <!-- =========================
      하단: allReviews (실데이터)
    ========================= -->
    <div class="allreview-wrap" id="allReviews">
      <div class="bottom-bar">
        <div class="title">All Reviews</div>
        <div class="bottom-bar-right">
          <a href="${pageContext.request.contextPath}/reviews.sp?midSort=${midSort}&sort=recent&searchWord=${fn:escapeXml(searchWord)}#allReviews"
             class="${sort eq 'recent' ? 'active' : ''}">최신순</a>
          <a href="${pageContext.request.contextPath}/reviews.sp?midSort=${midSort}&sort=rating&searchWord=${fn:escapeXml(searchWord)}#allReviews"
             class="${sort eq 'rating' ? 'active' : ''}">별점 높은순</a>
          <span class="divider">|</span>
          <a href="javascript:void(0);" id="btnToggleSearch">직접검색</a>
		  
        </div>
      </div>

      <div id="searchBox" class="searchbox">
		  <form method="get" action="${pageContext.request.contextPath}/reviews.sp#allReviews">
		    <input type="hidden" name="midSort" value="${midSort}" />
		    <input type="hidden" name="sort" value="${sort}" />
		    <!-- 검색 시 페이지는 1로 리셋(권장) -->
		    <input type="hidden" name="currentShowPageNo" value="1" />
		
		    <input type="text" id="searchWordInput" name="searchWord"
		           value="${fn:escapeXml(searchWord)}"
		           placeholder="제목/내용 검색" />
		    <button type="submit">검색</button>
		  </form>
		</div>

      <c:choose>
        <c:when test="${empty allReviews}">
          <div style="padding:22px 0; color:#666; font-size:13px;">등록된 리뷰가 없습니다.</div>
        </c:when>
        <c:otherwise>
          <c:forEach var="r" items="${allReviews}">
            <div class="review-item">
              <div class="r-left">
                <div style="display:flex; gap:8px; align-items:center;">
                  <div style="font-weight:700; color:#111;">${r.writer}</div>
                  <c:if test="${r.verified == 1}">
                    <span class="pill">구매 인증</span>
                  </c:if>
                </div>
                <div>${r.date}</div>
                
              </div>

              <div class="r-right">
	              <a href="${pageContext.request.contextPath}/reviewView.sp?reviewId=${r.review_id}"
	     			style="display:block; color:inherit;">
	                <div class="r-top">
	                  
	                  <span class="stars">
	                    <c:forEach var="i" begin="1" end="5">
	                      <c:choose>
	                        <c:when test="${i <= r.rating}">
	                          <span class="star">★</span>
	                        </c:when>
	                        <c:otherwise>
	                          <span class="star off">★</span>
	                        </c:otherwise>
	                      </c:choose>
	                    </c:forEach>
	                  </span>
	
	                  <c:if test="${not empty r.badge}">
	                    <span class="badge">${r.badge}</span>
	                  </c:if>
	
	                  <span class="prodcode">${r.productCode}</span>
	                </div>
	                <br>
					<span class="r-title">${r.review_title}</span>
	                <div class="r-content">${r.review_content}</div>
	
	                <c:if test="${not empty r.photos}">
	                  <div class="r-photos">
	                    <c:forEach var="ph" items="${r.photos}" varStatus="st">
	                      <c:if test="${st.index < 2}">
	                        <div class="r-photo">
							  <img src="${pageContext.request.contextPath}/img/review/${ph}"
							       alt="review photo"
							       onerror="this.style.display='none';">
							</div>
	                      </c:if>
	                    </c:forEach>
	                  </div>
	                </c:if>
	
	                <c:if test="${not empty r.tags}">
	                  <div class="r-tags">
	                    <c:forEach var="t" items="${r.tags}">
	                      <span class="tag">${t}</span>
	                    </c:forEach>
	                  </div>
	                </c:if>
	
	                <div class="r-actions">
	                  <!-- ✅ 신고 버튼 -->
					  <a href="javascript:void(0);"
					     class="btnReport"
					     data-review-id="${r.review_id}">
					    ⚑ 신고
					  </a>
	                </div>
	                
	                <!-- ✅ 신고 입력창(처음엔 숨김) -->
					<div class="reportBox" id="reportBox_${r.review_id}" style="display:none; margin-top:10px;">
					  <div class="reportInner">
					    <input type="text"
					           class="reportMsg"
					           maxlength="200"
					           placeholder="신고 내용을 입력해주세요." />
					
					    <button type="button"
					            class="btnReportSubmit"
					            data-review-id="${r.review_id}">
					      작성완료
					    </button>
					  </div>
					</div>
	
	                <c:if test="${not empty r.adminReply}">
	                  <div class="admin-reply">
	                    ${r.adminReply}
	                    <div class="admin-name">시선 올림</div>
	                  </div>
	                </c:if>
	                
                </a>
              </div>
            </div>
          </c:forEach>
        </c:otherwise>
      </c:choose>
    </div>

    <!-- 페이지네이션 -->
	<c:if test="${totalPage > 1}">
	  <div class="pager" style="margin-top:26px;">
	
	    <!-- ◀ 이전 블록 -->
	    <c:if test="${startPage > 1}">
	      <a class="arrow"
	         href="${pageContext.request.contextPath}/reviews.sp?midSort=${midSort}&sort=${sort}&searchWord=${fn:escapeXml(searchWord)}&currentShowPageNo=${startPage-1}#allReviews"
	         aria-label="이전 블록">&laquo;</a>
	    </c:if>
	
	    <!-- ◀ 이전 페이지 -->
	    <c:choose>
	      <c:when test="${currentShowPageNo > 1}">
	        <a class="arrow"
	           href="${pageContext.request.contextPath}/reviews.sp?midSort=${midSort}&sort=${sort}&searchWord=${fn:escapeXml(searchWord)}&currentShowPageNo=${currentShowPageNo-1}#allReviews"
	           aria-label="이전">&lsaquo;</a>
	      </c:when>
	      <c:otherwise>
	        <span class="arrow disabled">&lsaquo;</span>
	      </c:otherwise>
	    </c:choose>
	
	    <!-- 페이지 번호 (블록만 출력) -->
	    <c:forEach var="p" begin="${startPage}" end="${endPage}">
	      <c:choose>
	        <c:when test="${p == currentShowPageNo}">
	          <span class="active">${p}</span>
	        </c:when>
	        <c:otherwise>
	          <a href="${pageContext.request.contextPath}/reviews.sp?midSort=${midSort}&sort=${sort}&searchWord=${fn:escapeXml(searchWord)}&currentShowPageNo=${p}#allReviews">${p}</a>
	        </c:otherwise>
	      </c:choose>
	    </c:forEach>
	
	    <!-- ▶ 다음 페이지 -->
	    <c:choose>
	      <c:when test="${currentShowPageNo < totalPage}">
	        <a class="arrow"
	           href="${pageContext.request.contextPath}/reviews.sp?midSort=${midSort}&sort=${sort}&searchWord=${fn:escapeXml(searchWord)}&currentShowPageNo=${currentShowPageNo+1}#allReviews"
	           aria-label="다음">&rsaquo;</a>
	      </c:when>
	      <c:otherwise>
	        <span class="arrow disabled">&rsaquo;</span>
	      </c:otherwise>
	    </c:choose>
	
	    <!-- ▶ 다음 블록 -->
	    <c:if test="${endPage < totalPage}">
	      <a class="arrow"
	         href="${pageContext.request.contextPath}/reviews.sp?midSort=${midSort}&sort=${sort}&searchWord=${fn:escapeXml(searchWord)}&currentShowPageNo=${endPage+1}#allReviews"
	         aria-label="다음 블록">&raquo;</a>
	    </c:if>
	
	  </div>
	</c:if>


    <a href="${pageContext.request.contextPath}/reviewWrite.sp"
       class="btn btn-dark shadow review-float-btn" id="reviewFloatBtn">
      리뷰 작성
    </a>

  </div>
</div>

<script>

/* =========================
0) 로그인 체크 -> 컨펌창 -> 입력창 -> 작성완료 -> 새로고침 jquery
========================= */ 
$(function(){

  // ✅ 신고 버튼 클릭
  $(document).on("click", ".btnReport", function(){

    const reviewId = $(this).data("review-id");

    // 1) 로그인 안 했으면 alert → 로그인 이동
    if(!isLogin){
      alert("로그인 후 이용해주세요.");

      // 로그인 후 돌아오고 싶으면 goBackURL 추가 가능
      const goBackURL = encodeURIComponent(location.pathname + location.search + location.hash);
      location.href = ctxPath + "/loginSelect.sp?goBackURL=" + goBackURL;

      return;
    }

    // 2) 로그인 상태면 confirm
    if(!confirm("해당 리뷰를 신고하시겠습니까?")){
      return;
    }

    // 3) 다른 신고 입력창 닫고, 해당 리뷰 입력창만 열기
    $(".reportBox").not("#reportBox_" + reviewId).slideUp(150);

    $("#reportBox_" + reviewId).slideDown(180, function(){
      $(this).find(".reportMsg").focus();

      // ✅ 자연스럽게 입력창으로 스크롤 이동
      this.scrollIntoView({ behavior:"smooth", block:"center" });
    });
  });


  // ✅ 작성완료 버튼 클릭 → 신고 접수
  $(document).on("click", ".btnReportSubmit", function(){

    const reviewId = $(this).data("review-id");
    const $box = $("#reportBox_" + reviewId);

    const reportContent = $box.find(".reportMsg").val().trim();

    if(reportContent.length < 3){
      alert("신고 내용을 3자 이상 입력해주세요.");
      return;
    }

    $.ajax({
      url: ctxPath + "/reviewReport.sp",
      type: "POST",
      data: {
        reviewId: reviewId,
        reportContent: reportContent
      },
      dataType: "json",
      success: function(res){
        if(res.ok){
          alert("신고가 접수되었습니다.");
          location.reload();
        } else {
          alert(res.message || "신고 접수에 실패했습니다.");
        }
      },
      error: function(){
        alert("서버 오류가 발생했습니다.");
      }
    });
  });

});


/* =========================
   1) 직접검색 슬라이드 토글
========================= */
(function(){
  var toggleBtn = document.getElementById('btnToggleSearch');
  var box = document.getElementById('searchBox');
  var input = document.getElementById('searchWordInput');
  if(!toggleBtn || !box) return;

  function openBox(){
    box.classList.add('open');
    if(input) setTimeout(function(){ input.focus(); }, 120);
  }
  function closeBox(){
    box.classList.remove('open');
  }

  toggleBtn.addEventListener('click', function(){
    if(box.classList.contains('open')) closeBox();
    else openBox();
  });

  if(input && input.value && input.value.trim().length > 0){
    box.classList.add('open');
  }
})();


/* =========================
   2) 리뷰 작성 플로팅 버튼 - footer 겹침 방지
========================= */
(function(){
  var btn = document.getElementById('reviewFloatBtn');
  if(!btn) return;

  var baseRight = 70;
  var baseBottom = 30;

  function findFooter(){
    return document.querySelector('footer')
        || document.querySelector('#footer')
        || document.querySelector('.container-fluid.border-top.mt-5');
  }

  function update(){
    var footer = findFooter();
    btn.style.right = baseRight + 'px';

    if(!footer){
      btn.style.bottom = baseBottom + 'px';
      return;
    }

    var footerRect = footer.getBoundingClientRect();
    var overlap = window.innerHeight - footerRect.top;
    btn.style.bottom = (overlap > 0 ? (baseBottom + overlap + 10) : baseBottom) + 'px';
  }

  window.addEventListener('load', update);
  window.addEventListener('scroll', update, {passive:true});
  window.addEventListener('resize', update);
})();


/* =========================
   3) Mid Tabs <-> Carousel 연결 (Bootstrap4)
   - bootstrap.js가 footer에서 로드되는 경우 대비: "대기 후 초기화"
========================= */
(function(){
  function init(){
    if(!window.jQuery) return false;

    var $ = window.jQuery;

    // ✅ bootstrap carousel 플러그인이 아직 없으면 대기
    if(!$.fn || !$.fn.carousel) return false;

    var $car = $('#midSortCarousel');
    var $tabs = $('#midTabs');

    if($car.length === 0 || $tabs.length === 0) return true; // DOM 없으면 종료

    // ✅ 강제 초기화
    $car.carousel({ interval:false, wrap:true });

    function syncActiveTab(){
      var idx = $car.find('.carousel-item.active').index();
      if(idx < 0) idx = 0;

      $tabs.find('a[data-idx]').removeClass('active');
      $tabs.find('a[data-idx="'+idx+'"]').addClass('active');
    }

    // ✅ 탭 클릭 => 해당 슬라이드로 이동 + 즉시 active 반영
    $tabs.on('click', 'a[data-idx]', function(e){
      e.preventDefault();
      var idx = parseInt(this.getAttribute('data-idx'), 10);
      if(isNaN(idx)) idx = 0;

      $car.carousel(idx);
      // 이동이 즉시 안 보이더라도 active는 맞춰둠(이벤트 미발생 대비)
      $tabs.find('a[data-idx]').removeClass('active');
      $tabs.find('a[data-idx="'+idx+'"]').addClass('active');
    });

    // ✅ 좌/우 화살표 이동 끝나면 탭 active 동기화
    $car.on('slid.bs.carousel', function(){
      syncActiveTab();
    });

    // ✅ 초기 상태도 한번 맞추기
    syncActiveTab();

    return true;
  }

  // "추가 금지" 조건이라, 라이브러리 추가 대신 재시도만 함
  // footer에서 bootstrap.js가 로드되면 그 이후 init 성공
  var tries = 0;
  function retry(){
    tries++;
    if(init()) return;
    if(tries < 40) setTimeout(retry, 50); // 최대 2초 대기
  }

  // DOM 준비 후 시작
  if(document.readyState === 'loading'){
    document.addEventListener('DOMContentLoaded', retry);
  }else{
    retry();
  }
})();
</script>




<jsp:include page="../footer.jsp"/>
</body>
</html>
