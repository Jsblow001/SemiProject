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
	                  <a>💬 댓글 ${r.commentCount}</a>
	                  <a href="#">⚑ 신고</a>
	                </div>
	
	                <c:if test="${not empty r.adminReply}">
	                  <div class="admin-reply">
	                    ${r.adminReply}
	                    <div class="admin-name">카린 올림</div>
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
    <c:if test="${not empty totalPage && totalPage > 1}">
      <div class="pager" style="margin-top:26px;">
        <c:choose>
          <c:when test="${currentShowPageNo > 1}">
            <a class="arrow"
               href="${pageContext.request.contextPath}/reviews.sp?midSort=${midSort}&sort=${sort}&searchWord=${fn:escapeXml(searchWord)}&currentShowPageNo=${currentShowPageNo-1}#allReviews"
               aria-label="이전">&lsaquo;</a>
          </c:when>
          <c:otherwise>
            <span class="arrow" aria-label="이전">&lsaquo;</span>
          </c:otherwise>
        </c:choose>

        <c:forEach var="p" begin="1" end="${totalPage}">
          <c:choose>
            <c:when test="${p == currentShowPageNo}">
              <span class="active">${p}</span>
            </c:when>
            <c:otherwise>
              <a href="${pageContext.request.contextPath}/reviews.sp?midSort=${midSort}&sort=${sort}&searchWord=${fn:escapeXml(searchWord)}&currentShowPageNo=${p}#allReviews">${p}</a>
            </c:otherwise>
          </c:choose>
        </c:forEach>

        <c:choose>
          <c:when test="${currentShowPageNo < totalPage}">
            <a class="arrow"
               href="${pageContext.request.contextPath}/reviews.sp?midSort=${midSort}&sort=${sort}&searchWord=${fn:escapeXml(searchWord)}&currentShowPageNo=${currentShowPageNo+1}#allReviews"
               aria-label="다음">&rsaquo;</a>
          </c:when>
          <c:otherwise>
            <span class="arrow" aria-label="다음">&rsaquo;</span>
          </c:otherwise>
        </c:choose>
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

  var baseRight = 30;
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
