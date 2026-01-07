<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
    // =========================
    // 0) midSort 기본값 (컨트롤러가 안 넣어줘도 안전)
    // =========================
    if (request.getAttribute("midSort") == null) {
        String midSort = request.getParameter("midSort");
        if (midSort == null || midSort.trim().isEmpty()) midSort = "reviewCount";
        request.setAttribute("midSort", midSort);
    }

    // mid 리스트가 null이면(컨트롤러가 아직 미세팅) 빈 리스트로만 세팅 (데이터 창작 X)
    if (request.getAttribute("mid_reviewCount") == null) request.setAttribute("mid_reviewCount", new java.util.ArrayList<>());
    if (request.getAttribute("mid_recentSales") == null) request.setAttribute("mid_recentSales", new java.util.ArrayList<>());
    if (request.getAttribute("mid_avgRating") == null) request.setAttribute("mid_avgRating", new java.util.ArrayList<>());
    if (request.getAttribute("mid_newProduct") == null) request.setAttribute("mid_newProduct", new java.util.ArrayList<>());

    // =========================
    // 1) 상단 "인플루언서 리뷰" (더미 유지)
    // =========================
    if (request.getAttribute("heroReviews") == null) {

        java.util.List<java.util.Map<String,Object>> heroReviews = new java.util.ArrayList<>();
        java.util.Map<String,Object> h;

        h = new java.util.HashMap<>();
        h.put("image","img/review/r1.jpg");
        h.put("rating",5);
        h.put("title","[카린에이트×조은진님 협찬 리뷰] 카키 그레이 컬러가 오묘하면서도 빈티지한 매력");
        h.put("code","RONENN_R_C2");
        heroReviews.add(h);

        h = new java.util.HashMap<>();
        h.put("image","img/review/r2.jpg");
        h.put("rating",5);
        h.put("title","[카린에이트×하율님 협찬 리뷰] 어떤 룩에도 찰떡! 데일리로 손이 자주 가요");
        h.put("code","ARNO_R_C3");
        heroReviews.add(h);

        h = new java.util.HashMap<>();
        h.put("image","img/review/r3.jpg");
        h.put("rating",5);
        h.put("title","[카린에이트×OOO님 협찬 리뷰] 디테일이 예뻐서 포인트 주기 좋아요");
        h.put("code","DENSE_C5");
        heroReviews.add(h);

        // 반복 더미
        for(int k=0;k<3;k++){
            h = new java.util.HashMap<>();
            h.put("image","img/review/r1.jpg");
            h.put("rating",5);
            h.put("title","[카린에이트×조은진님 협찬 리뷰] 카키 그레이 컬러가 오묘하면서도 빈티지한 매력");
            h.put("code","RONENN_R_C2");
            heroReviews.add(h);

            h = new java.util.HashMap<>();
            h.put("image","img/review/r2.jpg");
            h.put("rating",5);
            h.put("title","[카린에이트×하율님 협찬 리뷰] 어떤 룩에도 찰떡! 데일리로 손이 자주 가요");
            h.put("code","ARNO_R_C3");
            heroReviews.add(h);

            h = new java.util.HashMap<>();
            h.put("image","img/review/r3.jpg");
            h.put("rating",5);
            h.put("title","[카린에이트×OOO님 협찬 리뷰] 디테일이 예뻐서 포인트 주기 좋아요");
            h.put("code","DENSE_C5");
            heroReviews.add(h);
        }

        request.setAttribute("heroReviews", heroReviews);
        request.setAttribute("heroPageCount", (heroReviews.size() + 2) / 3);
    }

    // =========================
    // 3) allReviews 더미(컨트롤러가 안 넣어준 경우만)
    // =========================
    if (request.getAttribute("allReviews") == null) {
        java.util.List<java.util.Map<String,Object>> allReviews = new java.util.ArrayList<>();
        java.util.Map<String,Object> r;

        java.util.List<String> photos;
        java.util.List<String> tags;

        r = new java.util.HashMap<>();
        r.put("writer","김**");
        r.put("verified", 1);
        r.put("date","오늘 작성");
        r.put("rating", 5);
        r.put("badge", "NEW");
        r.put("productCode","DENSE_C5");
        r.put("review_content","이번겨울에 추운날 안경하다가 픽 부러졌어요...\n2년가량 매일 잘 쓰고 다녔던 터라 아쉽지만 재구매 합니다.");
        photos = new java.util.ArrayList<>();
        photos.add("img/review/r3.jpg");
        photos.add("img/review/r4.jpg");
        r.put("photos", photos);
        tags = new java.util.ArrayList<>();
        tags.add("배송이 빨라요");
        tags.add("포장이 꼼꼼해요");
        tags.add("유니크한 디테일이 있어요");
        tags.add("데일리로 착용하기 좋아요");
        r.put("tags", tags);
        r.put("commentCount", 0);
        r.put("adminReply","소중한 후기 정말 감사드립니다~!!\n항상 고객님께 만족을 드릴 수 있도록 노력하겠습니다!\n고객님의 목소리로 더 발전하는 카린이 되겠습니다 :-)");
        allReviews.add(r);

        r = new java.util.HashMap<>();
        r.put("writer","김**");
        r.put("verified", 1);
        r.put("date","1일 전 작성");
        r.put("rating", 5);
        r.put("badge", "NEW");
        r.put("productCode","AIR 2 R_C2");
        r.put("review_content","너무 예뻐요. 역시 카린은 믿고 삽니다! 🌿 감사합니다!");
        photos = new java.util.ArrayList<>();
        r.put("photos", photos);
        tags = new java.util.ArrayList<>();
        tags.add("배송이 빨라요");
        tags.add("포장이 꼼꼼해요");
        tags.add("데일리로 착용하기 좋아요");
        tags.add("가벼워요");
        r.put("tags", tags);
        r.put("commentCount", 0);
        r.put("adminReply","소중한 후기 정말 감사드립니다~!!\n항상 고객님께 만족을 드릴 수 있도록 노력하겠습니다!\n고객님의 목소리로 더 발전하는 카린이 되겠습니다 :-)");
        allReviews.add(r);

        r = new java.util.HashMap<>();
        r.put("writer","송**");
        r.put("verified", 0);
        r.put("date","25.12.24 작성");
        r.put("rating", 5);
        r.put("badge", "");
        r.put("productCode","RONENN_R_C4");
        r.put("review_content","컬러가 묘~하게 빈티지하고 포인트 돼요.\n블루라이트 렌즈 덕분에 눈도 편합니다.");
        photos = new java.util.ArrayList<>();
        photos.add("img/review/r5.jpg");
        photos.add("img/review/r1.jpg");
        r.put("photos", photos);
        tags = new java.util.ArrayList<>();
        tags.add("컬러가 예뻐요");
        tags.add("착용감이 좋아요");
        r.put("tags", tags);
        r.put("commentCount", 0);
        r.put("adminReply","감사합니다. 더 좋은 상품으로 만족 드리겠습니다!");
        allReviews.add(r);

        request.setAttribute("allReviews", allReviews);
    }

    if (request.getAttribute("totalReviews") == null) {
        request.setAttribute("totalReviews", 0);
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
<title>Review</title>

<style>
  *{ box-sizing:border-box; }
  body{ margin:0; font-family: Arial, "Noto Sans KR", sans-serif; color:#111; background:#fff; }
  a{ color:inherit; text-decoration:none; }
  a:hover{ text-decoration:none; }

  .wrap{ width:100%; padding:24px 0 80px; }
  .inner{ width:92%; max-width:1500px; margin:0 auto; }

  .stars{ display:inline-flex; gap:1px; font-size:12px; }
  .star{ color:#111; }
  .star.off{ color:#ddd; }

  .hero-wrap{ padding:18px 0 24px; }
  .hero-card{ border:1px solid #f2f2f2; border-radius:14px; overflow:hidden; background:#fff; height:100%; }
  .hero-img{ aspect-ratio:1/1; background:#fafafa; overflow:hidden; }
  .hero-img img{ width:100%; height:100%; object-fit:cover; }
  .hero-body{ padding:10px 12px 14px; }
  .hero-title{ margin-top:8px; font-size:12px; line-height:1.35; height:34px; overflow:hidden; }
  .hero-code{ margin-top:8px; font-size:12px; color:#666; }

  .hero-nav{
    position:absolute; top:50%; transform:translateY(-50%);
    width:44px; height:44px; border-radius:50%;
    border:1px solid #ddd; background:#fff; z-index:20;
  }
  .hero-nav::before{
    content:'‹'; font-size:26px; color:#111;
    position:absolute; inset:0; display:flex; align-items:center; justify-content:center;
  }
  .hero-nav.next::before{ content:'›'; }
  .hero-nav.prev{ left:10px; }
  .hero-nav.next{ right:10px; }

  .carousel-nav{
    position:absolute; top:50%; transform:translateY(-50%);
    width:54px; height:120px;
    background:rgba(0,0,0,.75); color:#fff;
    border-radius:10px; display:flex;
    align-items:center; justify-content:center;
    font-size:34px; z-index:50;
  }
  .carousel-nav:hover{ background:rgba(0,0,0,.85); }
  .carousel-nav.prev{ left:10px; }
  .carousel-nav.next{ right:10px; }
  @media (max-width:576px){
    .carousel-nav{ width:44px; height:90px; font-size:28px; }
  }

  .mid-tabs{
    display:flex; justify-content:center; align-items:center;
    gap:14px; margin:30px 0 14px; font-size:13px;
  }
  .mid-tabs a{ color:#999; font-weight:500; }
  .mid-tabs a.active{ color:#111; font-weight:700; }
  .mid-tabs .divider{ width:1px; height:12px; background:#e2e2e2; }

  .mid-card{ border:1px solid #f0f0f0; border-radius:16px; background:#fff; padding:14px; height:100%; }
  .mid-main{
    background:#f6f6f6; border-radius:16px;
    aspect-ratio:1/1.15; display:flex; align-items:center; justify-content:center;
    overflow:hidden;
  }
  .mid-main img{ width:100%; height:100%; object-fit:contain; }
  .mid-code{ margin-top:12px; font-size:12px; font-weight:700; }
  .mid-sub{ font-size:12px; color:#666; margin-top:4px; }

  @media (max-width:768px){
    .mid-col{ flex:0 0 50%; max-width:50%; }
  }

  .bottom-bar{
    display:flex; align-items:center; justify-content:space-between;
    padding: 10px 0 12px;
    border-top: 1px solid #ededed; border-bottom: 1px solid #ededed;
    margin-top: 18px;
  }
  .bottom-bar-right{ display:flex; align-items:center; gap:14px; font-size:12px; color:#666; }
  .bottom-bar-right a{ color:#666; text-decoration:none; }
  .bottom-bar-right a.active{ color:#111; font-weight:600; }
  .bottom-bar-right .divider{ color:#cfcfcf; }
  .bottom-search-btn{
    border:0; background:transparent; padding:4px; margin-left:2px;
    cursor:pointer; color:#9a9a9a; display:inline-flex; align-items:center; justify-content:center;
  }
  .bottom-search-btn:hover{ color:#111; }

  .allreview-wrap{ margin-top:28px; padding-top:18px; border-top:1px solid #ededed; }
  .review-item{
    display:grid; grid-template-columns: 160px 1fr; gap:18px;
    padding:18px 0; border-bottom:1px solid #f1f1f1;
  }
  .r-left{ font-size:12px; color:#666; display:flex; flex-direction:column; gap:6px; }
  .pill{
    display:inline-flex; align-items:center; justify-content:center;
    height:18px; padding:0 8px; border-radius:999px;
    border:1px solid #eaeaea; font-size:11px; color:#666; width:max-content; background:#fff;
  }
  .r-right{ min-width:0; }
  .r-top{ display:flex; align-items:center; gap:10px; padding:10px 12px; border-radius:12px; background:#fafafa; }
  .badge{ display:inline-flex; align-items:center; justify-content:center; height:18px; padding:0 8px; border-radius:999px; background:#3b82f6; color:#fff; font-size:11px; }
  .prodcode{ font-size:12px; font-weight:700; color:#111; margin-left:6px; }
  .r-content{ padding:12px 0 10px; font-size:13px; line-height:1.55; color:#111; white-space:pre-line; }
  .r-photos{
    margin-top:6px; display:grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap:12px; max-width:420px;
  }
  .r-photo{ border-radius:12px; overflow:hidden; background:#f2f2f2; aspect-ratio: 1 / 1; }
  .r-photo img{ width:100%; height:100%; object-fit:cover; display:block; transform:scale(1); transition:transform .25s ease; }
  .r-photo:hover img{ transform:scale(1.06); }
  .r-tags{ margin-top:12px; display:flex; flex-wrap:wrap; gap:8px; }
  .tag{ font-size:11px; color:#555; border:1px solid #ececec; background:#f7f7f7; padding:6px 10px; border-radius:999px; }
  .r-actions{ margin-top:14px; display:flex; align-items:center; gap:16px; color:#666; font-size:12px; }
  .r-actions a{ color:#666; }
  .r-actions a:hover{ color:#111; text-decoration:none; }
  .admin-reply{ margin-top:14px; border-top:1px solid #eee; padding-top:12px; color:#444; font-size:12px; line-height:1.5; white-space:pre-line; }
  .admin-name{ margin-top:10px; font-size:12px; color:#666; }

  @media (max-width: 560px){
    .review-item{ grid-template-columns: 1fr; }
    .bottom-bar-right{ gap:10px; }
    .bottom-bar-right .divider{ display:none; }
  }

  .pager{ display:flex; align-items:center; justify-content:center; gap:10px; color:#777; font-size:12px; }
  .pager a, .pager span{
    display:inline-flex; align-items:center; justify-content:center;
    min-width:30px; height:30px; border-radius:8px; border:1px solid #ececec;
    padding:0 8px; background:#fff;
  }
  .pager a:hover{ border-color:#ddd; text-decoration:none; }
  .pager .active{ border-color:#111; color:#111; font-weight:700; }
  .pager .arrow{ color:#666; font-size:14px; }

  .review-float-btn{
    position: fixed; right: 30px; bottom: 30px; z-index: 9999;
    border-radius: 999px; padding: 12px 16px; font-size: 13px; line-height: 1;
  }

  .page-title{ font-size:26px; font-weight:500; letter-spacing:.3px; margin:26px 0 18px; }
</style>
</head>

<body>
<jsp:include page="../header.jsp"/>

<div class="wrap">
  <div class="inner">
    <div class="page-title">Reviews</div>

    <!-- =========================
      상단 인플루언서 캐러셀 (Bootstrap)
    ========================= -->
    <div class="hero-wrap">
      <div id="heroCarousel" class="carousel slide" data-ride="carousel" data-interval="false">
        <div class="carousel-inner">
          <c:forEach var="page" begin="0" end="${heroPageCount - 1}">
            <div class="carousel-item ${page == 0 ? 'active' : ''}">
              <div class="row">
                <c:forEach var="i" begin="0" end="2">
                  <c:set var="idx" value="${page*3 + i}" />
                  <c:if test="${idx < heroReviews.size()}">
                    <c:set var="h" value="${heroReviews[idx]}" />
                    <div class="col-12 col-md-4 px-2">
                      <a href="#" class="hero-card d-block">
                        <div class="hero-img"><img src="${h.image}"></div>
                        <div class="hero-body">
                          <div class="stars">
                            <c:forEach var="s" begin="1" end="5">
                              <span class="star ${s > h.rating ? 'off' : ''}">★</span>
                            </c:forEach>
                          </div>
                          <div class="hero-title">${h.title}</div>
                          <div class="hero-code">${h.code}</div>
                        </div>
                      </a>
                    </div>
                  </c:if>
                </c:forEach>
              </div>
            </div>
          </c:forEach>
        </div>

        <a class="hero-nav prev" href="#heroCarousel" data-slide="prev"></a>
        <a class="hero-nav next" href="#heroCarousel" data-slide="next"></a>
      </div>
    </div>

    <!-- =========================
      ✅ 중단부: "탭 = 캐러셀 슬라이드" (4개씩, 각 탭 상위 4개)
      ※ 화살표 prev/next = 앞/뒤 탭 이동 (wrap=true)
      ※ 탭 순서(화살표 인접관계): 리뷰많은순 -> 최근판매량순 -> 리뷰평점순 -> 최근상품순 -> (wrap)
    ========================= -->
    <div class="mid-tabs" id="midTabs">
      <a href="javascript:void(0)" data-slide-to="0"
         class="${empty midSort || midSort eq 'reviewCount' ? 'active' : ''}">리뷰 많은순</a>
      <div class="divider"></div>

      <a href="javascript:void(0)" data-slide-to="1"
         class="${midSort eq 'recentSales' ? 'active' : ''}">최근 판매량순</a>
      <div class="divider"></div>

      <a href="javascript:void(0)" data-slide-to="2"
         class="${midSort eq 'avgRating' ? 'active' : ''}">리뷰 평점순</a>
      <div class="divider"></div>

      <a href="javascript:void(0)" data-slide-to="3"
         class="${midSort eq 'newProduct' ? 'active' : ''}">최근 상품순</a>
    </div>

    <div id="midRank"></div>

    <div id="midSortCarousel" class="carousel slide" data-ride="carousel" data-interval="false" data-wrap="true">
      <div class="carousel-inner">

        <!-- 0) 리뷰 많은순 -->
        <div class="carousel-item ${empty midSort || midSort eq 'reviewCount' ? 'active' : ''}">
          <div class="row">
            <c:set var="list0" value="${mid_reviewCount}" />
            <c:forEach var="i" begin="0" end="3">
              <c:choose>
                <c:when test="${i < fn:length(list0)}">
                  <c:set var="rp" value="${list0[i]}" />
                  <div class="col-6 col-md-3 px-2 mid-col">
                    <div class="mid-card">
                      <div class="mid-main position-relative">
                        <span class="badge badge-dark position-absolute"
                              style="top:10px; left:10px; border-radius:999px; padding:6px 10px; font-size:12px; opacity:.9;">
                          ${i + 1}
                        </span>
                        <img src="${rp.main}"
                             onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/img/product/default.png';">
                      </div>
                      <div class="mid-code">${rp.code}</div>
                      <div class="mid-sub">리뷰 ${rp.count}개</div>
                    </div>
                  </div>
                </c:when>
                <c:otherwise>
                  <!-- 데이터 부족 시: 빈 카드(준비중) -->
                  <div class="col-6 col-md-3 px-2 mid-col">
                    <div class="mid-card">
                      <div class="mid-main position-relative">
                        <span class="badge badge-dark position-absolute"
                              style="top:10px; left:10px; border-radius:999px; padding:6px 10px; font-size:12px; opacity:.9;">
                          ${i + 1}
                        </span>
                        <img src="${pageContext.request.contextPath}/img/product/default.png">
                      </div>
                      <div class="mid-code">준비중</div>
                      <div class="mid-sub">&nbsp;</div>
                    </div>
                  </div>
                </c:otherwise>
              </c:choose>
            </c:forEach>
          </div>
        </div>

        <!-- 1) 최근 판매량순 (결제완료만 집계한 값이 컨트롤러에서 들어온다고 가정) -->
        <div class="carousel-item ${midSort eq 'recentSales' ? 'active' : ''}">
          <div class="row">
            <c:set var="list1" value="${mid_recentSales}" />
            <c:forEach var="i" begin="0" end="3">
              <c:choose>
                <c:when test="${i < fn:length(list1)}">
                  <c:set var="rp" value="${list1[i]}" />
                  <div class="col-6 col-md-3 px-2 mid-col">
                    <div class="mid-card">
                      <div class="mid-main position-relative">
                        <span class="badge badge-dark position-absolute"
                              style="top:10px; left:10px; border-radius:999px; padding:6px 10px; font-size:12px; opacity:.9;">
                          ${i + 1}
                        </span>
                        <img src="${rp.main}"
                             onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/img/product/default.png';">
                      </div>
                      <div class="mid-code">${rp.code}</div>
                      <div class="mid-sub">최근판매 ${rp.salesQty}개</div>
                    </div>
                  </div>
                </c:when>
                <c:otherwise>
                  <div class="col-6 col-md-3 px-2 mid-col">
                    <div class="mid-card">
                      <div class="mid-main position-relative">
                        <span class="badge badge-dark position-absolute"
                              style="top:10px; left:10px; border-radius:999px; padding:6px 10px; font-size:12px; opacity:.9;">
                          ${i + 1}
                        </span>
                        <img src="${pageContext.request.contextPath}/img/product/default.png">
                      </div>
                      <div class="mid-code">준비중</div>
                      <div class="mid-sub">&nbsp;</div>
                    </div>
                  </div>
                </c:otherwise>
              </c:choose>
            </c:forEach>
          </div>
        </div>

        <!-- 2) 리뷰 평점순 -->
        <div class="carousel-item ${midSort eq 'avgRating' ? 'active' : ''}">
          <div class="row">
            <c:set var="list2" value="${mid_avgRating}" />
            <c:forEach var="i" begin="0" end="3">
              <c:choose>
                <c:when test="${i < fn:length(list2)}">
                  <c:set var="rp" value="${list2[i]}" />
                  <div class="col-6 col-md-3 px-2 mid-col">
                    <div class="mid-card">
                      <div class="mid-main position-relative">
                        <span class="badge badge-dark position-absolute"
                              style="top:10px; left:10px; border-radius:999px; padding:6px 10px; font-size:12px; opacity:.9;">
                          ${i + 1}
                        </span>
                        <img src="${rp.main}"
                             onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/img/product/default.png';">
                      </div>
                      <div class="mid-code">${rp.code}</div>
                      <div class="mid-sub">평균 ${rp.rating}점 · 리뷰 ${rp.count}개</div>
                    </div>
                  </div>
                </c:when>
                <c:otherwise>
                  <div class="col-6 col-md-3 px-2 mid-col">
                    <div class="mid-card">
                      <div class="mid-main position-relative">
                        <span class="badge badge-dark position-absolute"
                              style="top:10px; left:10px; border-radius:999px; padding:6px 10px; font-size:12px; opacity:.9;">
                          ${i + 1}
                        </span>
                        <img src="${pageContext.request.contextPath}/img/product/default.png">
                      </div>
                      <div class="mid-code">준비중</div>
                      <div class="mid-sub">&nbsp;</div>
                    </div>
                  </div>
                </c:otherwise>
              </c:choose>
            </c:forEach>
          </div>
        </div>

        <!-- 3) 최근 상품순 -->
        <div class="carousel-item ${midSort eq 'newProduct' ? 'active' : ''}">
          <div class="row">
            <c:set var="list3" value="${mid_newProduct}" />
            <c:forEach var="i" begin="0" end="3">
              <c:choose>
                <c:when test="${i < fn:length(list3)}">
                  <c:set var="rp" value="${list3[i]}" />
                  <div class="col-6 col-md-3 px-2 mid-col">
                    <div class="mid-card">
                      <div class="mid-main position-relative">
                        <span class="badge badge-dark position-absolute"
                              style="top:10px; left:10px; border-radius:999px; padding:6px 10px; font-size:12px; opacity:.9;">
                          ${i + 1}
                        </span>
                        <img src="${rp.main}"
                             onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/img/product/default.png';">
                      </div>
                      <div class="mid-code">${rp.code}</div>
                      <div class="mid-sub">입고일 ${rp.stockDate}</div>
                    </div>
                  </div>
                </c:when>
                <c:otherwise>
                  <div class="col-6 col-md-3 px-2 mid-col">
                    <div class="mid-card">
                      <div class="mid-main position-relative">
                        <span class="badge badge-dark position-absolute"
                              style="top:10px; left:10px; border-radius:999px; padding:6px 10px; font-size:12px; opacity:.9;">
                          ${i + 1}
                        </span>
                        <img src="${pageContext.request.contextPath}/img/product/default.png">
                      </div>
                      <div class="mid-code">준비중</div>
                      <div class="mid-sub">&nbsp;</div>
                    </div>
                  </div>
                </c:otherwise>
              </c:choose>
            </c:forEach>
          </div>
        </div>

      </div>

      <a class="carousel-nav prev" href="#midSortCarousel" data-slide="prev">‹</a>
      <a class="carousel-nav next" href="#midSortCarousel" data-slide="next">›</a>
    </div>

    <!-- =========================
      하단: allReviews (기존 유지)
    ========================= -->
    <div class="allreview-wrap" id="allReviews">
      <div class="bottom-bar">
        <div class="title">All Reviews</div>
        <div class="bottom-bar-right">
          <a href="${pageContext.request.contextPath}/reviews.sp?sort=recent&searchWord=${fn:escapeXml(searchWord)}#allReviews"
             class="${sort eq 'recent' ? 'active' : ''}">최신순</a>
          <a href="${pageContext.request.contextPath}/reviews.sp?sort=rating&searchWord=${fn:escapeXml(searchWord)}#allReviews"
             class="${sort eq 'rating' ? 'active' : ''}">별점 높은순</a>
          <span class="divider">|</span>
          <a href="javascript:void(0);" id="btnToggleSearch">직접검색</a>
          <button type="button" class="bottom-search-btn" aria-label="검색" id="btnSearchIcon">
            (SVG는 너 기존 그대로)
          </button>
        </div>
      </div>

      <div id="searchBox" style="display:none; margin-top:10px;">
        <form method="get" action="${pageContext.request.contextPath}/reviews.sp">
          <input type="hidden" name="sort" value="${sort}" />
          <input type="text" name="searchWord" value="${fn:escapeXml(searchWord)}" placeholder="제목/내용 검색" />
          <button type="submit">검색</button>
        </form>
      </div>

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

            <div class="r-content">${r.review_content}</div>

            <c:if test="${not empty r.photos}">
              <div class="r-photos">
                <c:forEach var="ph" items="${r.photos}" varStatus="st">
                  <c:if test="${st.index < 2}">
                    <div class="r-photo"><img src="${ph}" alt="review photo"></div>
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
          </div>
        </div>
      </c:forEach>
    </div>

    <!-- 페이지네이션(기존 유지) -->
    <div class="pager" style="margin-top:26px;">
      <c:choose>
        <c:when test="${currentShowPageNo > 1}">
          <a class="arrow"
             href="${pageContext.request.contextPath}/reviews.sp?sort=${sort}&searchWord=${fn:escapeXml(searchWord)}&currentShowPageNo=${currentShowPageNo-1}#allReviews"
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
            <a href="${pageContext.request.contextPath}/reviews.sp?sort=${sort}&searchWord=${fn:escapeXml(searchWord)}&currentShowPageNo=${p}#allReviews">${p}</a>
          </c:otherwise>
        </c:choose>
      </c:forEach>

      <c:choose>
        <c:when test="${currentShowPageNo < totalPage}">
          <a class="arrow"
             href="${pageContext.request.contextPath}/reviews.sp?sort=${sort}&searchWord=${fn:escapeXml(searchWord)}&currentShowPageNo=${currentShowPageNo+1}#allReviews"
             aria-label="다음">&rsaquo;</a>
        </c:when>
        <c:otherwise>
          <span class="arrow" aria-label="다음">&rsaquo;</span>
        </c:otherwise>
      </c:choose>
    </div>

    <a href="${pageContext.request.contextPath}/reviewWrite.sp"
       class="btn btn-dark shadow review-float-btn" id="reviewFloatBtn">
      리뷰 작성
    </a>

  </div>
</div>

<script>
/* 하단 플로팅 버튼(기존 유지) */
(function(){
  const btn = document.getElementById('reviewFloatBtn');
  if(!btn) return;

  const baseRight = 30;
  const baseBottom = 30;

  function findFooter(){
    return document.querySelector('.container-fluid.border-top.mt-5');
  }

  function update(){
    const footer = findFooter();
    if(!footer) return;

    const footerRect = footer.getBoundingClientRect();
    const vh = window.innerHeight;
    const overlap = vh - footerRect.top;

    if(overlap > 0){
      btn.style.bottom = (baseBottom + overlap + 10) + 'px';
    }else{
      btn.style.bottom = baseBottom + 'px';
    }
    btn.style.right = baseRight + 'px';
  }

  window.addEventListener('load', ()=>{
    update();
    window.addEventListener('scroll', update, {passive:true});
    window.addEventListener('resize', update);
  });
})();

/* 직접검색 토글(기존 유지) */
(function(){
  const toggleBtn = document.getElementById('btnToggleSearch');
  const iconBtn = document.getElementById('btnSearchIcon');
  const box = document.getElementById('searchBox');
  if(!box) return;

  function toggle(){
    box.style.display = (box.style.display === 'none' || box.style.display === '') ? 'block' : 'none';
  }

  if(toggleBtn) toggleBtn.addEventListener('click', toggle);
  if(iconBtn) iconBtn.addEventListener('click', toggle);
})();

/* ✅ midSortCarousel 탭 동기화(수정본: DOM 기준 index, event.relatedTarget 미사용) */
(function(){
  const $carousel = $('#midSortCarousel');
  const $tabs = $('#midTabs a[data-slide-to]');

  if($carousel.length === 0 || $tabs.length === 0) return;

  const sortByIndex = ['reviewCount','recentSales','avgRating','newProduct'];

  function setActiveByIndex(idx){
    $tabs.removeClass('active');
    $tabs.filter('[data-slide-to="'+idx+'"]').addClass('active');

    const sort = sortByIndex[idx] || 'reviewCount';
    const url = new URL(window.location.href);
    url.searchParams.set('midSort', sort);
    url.hash = 'midRank';
    history.replaceState(null, '', url.toString());
  }

  function syncFromDom(){
    const idx = $carousel.find('.carousel-item.active').index();
    if(idx >= 0) setActiveByIndex(idx);
  }

  // 탭 클릭 -> 해당 슬라이드로
  $tabs.on('click', function(e){
    e.preventDefault();
    const idx = parseInt($(this).attr('data-slide-to'), 10);
    $carousel.carousel(idx);
  });

  // 슬라이드 이동 완료 -> 탭 active 갱신
  $carousel.on('slid.bs.carousel', function(){
    syncFromDom();
  });

  // 최초 로딩 -> URL midSort 있으면 맞추기
  const url = new URL(window.location.href);
  const midSort = url.searchParams.get('midSort') || 'reviewCount';
  const initIdx = sortByIndex.indexOf(midSort);

  if(initIdx >= 0){
    $carousel.carousel(initIdx);
    setTimeout(syncFromDom, 0);
  } else {
    setTimeout(syncFromDom, 0);
  }
})();
</script>

<jsp:include page="../footer.jsp"/>
</body>
</html>
