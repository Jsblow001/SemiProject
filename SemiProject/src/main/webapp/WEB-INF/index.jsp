<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">

<jsp:include page="header.jsp"/>
<!-- Customized Bootstrap Stylesheet -->
<link href="<%= request.getContextPath() %>/css/style.css" rel="stylesheet">
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<style type="text/css">

/* index 상품 카드 공통 */
.index-product .product-item { transition: transform .2s; border-radius: 10px; overflow: hidden; }
.index-product .product-item:hover { transform: translateY(-8px); box-shadow: 0 10px 20px rgba(0,0,0,.1) !important; }

.index-product .product-img{
  width:100%;
  aspect-ratio: 4 / 5;
  overflow:hidden;
  background:#fff;
  display:flex;
  align-items:center;
  justify-content:center;
  padding:10px !important;
}
.index-product .product-img img{
  width:100%;
  height:100%;
  object-fit:contain;
  transition:transform .5s;
}
.index-product .product-item:hover .product-img img{ transform:scale(1.08); }

.index-product .btn-wish, .index-product .btn-cart { border:none; background:none; transition:all .2s; }
.index-product .btn-wish:hover i { font-weight:900; }
.index-product .btn-cart:hover i { color:#f39c12; }

/* 링크 hover 밑줄 제거 */
.index-product a:hover{ text-decoration:none !important; }

/* 캐러셀 이미지 기본: 찌그러짐 방지 + 꽉 채우기 */
.carousel-img{
  width: 100%;
  height: 420px;          /* PC 기본 높이 */
  object-fit: cover;      /* 비율 유지하며 채우고 넘치는 부분은 크롭 */
  object-position: center;
}

/* 모바일에서는 너무 높으면 답답하니 높이 줄이기 */
@media (max-width: 991px){
  .carousel-img{
    height: 220px;        /* 모바일 높이 */
  }
  .monthly-best-img{
    height: 190px;    /* ✅ 모바일은 적당히 */
  }
}



#recipeCarousel .carousel-inner{
  overflow: hidden;
}


.monthly-best-img{
  height: 260px;      /* ✅ PC에서 크게 */
  object-fit: contain;
  border-radius: 12px;
}

.monthly-best-item{
  background: #fff;
  border-radius: 14px;
  padding: 10px;
  box-shadow: 0 6px 16px rgba(0,0,0,.06);
  transition: transform .2s;
}

.monthly-best-item:hover{
  transform: translateY(-4px);
}

/* ✅ 4개 세트가 컨테이너 좌우를 꽉 채우되, 간격 유지 */
.monthly-best-row{
  margin-left: -14px;
  margin-right: -14px;
}

.monthly-best-col{
  padding-left: 14px;
  padding-right: 14px;
  margin-bottom: 18px;  /* 아래 여백 */
}

/* ✅ 클릭 영역(카드 느낌) */
.monthly-best-item{
  background:#fff;
  border-radius: 14px;
  padding: 10px;
  box-shadow: 0 6px 16px rgba(0,0,0,.06);
  transition: transform .2s;
}

.monthly-best-item:hover{
  transform: translateY(-4px);
}

/* ✅ 이미지 크기 반응형 */
.monthly-best-img{
  height: clamp(170px, 20vw, 340px);  /* 최소/유동/최대 */
  object-fit: contain;                /* 제품 사진은 contain 추천 */
  border-radius: 10px;
}
.carousel-control-prev-icon,
.carousel-control-next-icon{
  filter: invert(40%);  /* 대충 회색 느낌 */
}

/* ✅ Monthly Best 캐러셀 화살표를 바깥으로 이동 */
#recipeCarousel{
  position: relative; /* 컨트롤 absolute 기준 */
}

#recipeCarousel .carousel-control-prev{
  left: -40px;   /* ✅ 숫자 조절 (20~60 추천) */
  width: 40px;
}

#recipeCarousel .carousel-control-next{
  right: -40px;  /* ✅ 숫자 조절 */
  width: 40px;
}

/* 버튼 자체 크기 살짝 키우고 싶으면(선택) */
#recipeCarousel .carousel-control-prev-icon,
#recipeCarousel .carousel-control-next-icon{
  width: 28px;
  height: 28px;
}

@media (max-width: 991px){
  #recipeCarousel .carousel-control-prev{ left: -18px; }
  #recipeCarousel .carousel-control-next{ right: -18px; }
}
#recipeCarousel .carousel-inner{
  width: 100%;
}

#recipeCarousel .carousel-item .monthly-best-row{
  justify-content: center;
  margin-left: 0;
  margin-right: 0;
}

.monthly-best-col{
  padding-left: 12px;
  padding-right: 12px;
  margin-bottom: 18px;
}

  </style>
  
<%-- 임시 이동 버튼 --%>
<br><br>
<a href="<%= request.getContextPath() %>/reservation.sp">reservation</a>&nbsp&nbsp
<a href="<%= request.getContextPath() %>/myReservations.sp">my_reservation</a>&nbsp&nbsp
<a href="<%= request.getContextPath() %>/admin/schedule.sp">reservation_admin</a>
<%-- 임시 review, notice, qna 이동 버튼 --%>
    
    <!-- Navbar Start -->
    <div class="container-fluid">
        
            <div class="col-lg">
                
                <div id="header-carousel" class="carousel slide" data-ride="carousel">
                    <div class="carousel-inner">
                    	  	  <div class="carousel-item active">
							    <picture>
							      <!-- ✅ 모바일(991px 이하)일 때 -->
							      <source media="(max-width: 991px)" srcset="img/index_upper_carousel/carousel-1_m.jpg">
							      <!-- ✅ 기본(PC) -->
							      <img class="d-block w-100 carousel-img"
							           src="img/index_upper_carousel/carousel-1.jpg"
							           alt="Image 1">
							    </picture>
							  </div>
							
							  <div class="carousel-item">
							    <picture>
							      <source media="(max-width: 991px)" srcset="img/index_upper_carousel/carousel-2_m.jpg">
							      <img class="d-block w-100 carousel-img"
							           src="img/index_upper_carousel/carousel-2.jpg"
							           alt="Image 2">
							    </picture>
							  </div>
							
							  <div class="carousel-item">
							    <picture>
							      <source media="(max-width: 991px)" srcset="img/index_upper_carousel/carousel-3_m.jpg">
							      <img class="d-block w-100 carousel-img"
							           src="img/index_upper_carousel/carousel-3.jpg"
							           alt="Image 3">
							    </picture>
						  	  </div>
						 
					</div>
                    
                </div>
            </div>
        
    </div>
    <!-- Navbar End -->


	<div class="container text-center my-5">
	    <h2 class="section-title px-5"><span class="px-2">MONTHLY BEST</span></h2>
	    <div class="row mx-auto my-auto">
		  <div id="recipeCarousel" class="carousel slide w-100" data-ride="carousel">
		    <div class="carousel-inner w-100" role="listbox">
		
		      <c:forEach var="p" items="${monthlyBestList}" varStatus="st">
		
		        <!-- ✅ 4개마다 새 슬라이드 시작 -->
		        <c:if test="${st.index % 4 == 0}">
		          <div class="carousel-item ${st.index == 0 ? 'active' : ''}">
		            <div class="row w-100 monthly-best-row">
		        </c:if>
		
		              <!-- ✅ 이미지 1개 -->
		              <div class="col-6 col-md-3 monthly-best-col">
		                <a href="<%=request.getContextPath()%>/product/productDetail.sp?product_id=${p.productId}"
		                   class="d-block monthly-best-item">
		                  <img class="img-fluid w-100 monthly-best-img"
		                       src="<%=request.getContextPath()%>/img/${p.pimage}"
		                       alt="${p.code}"
		                       loading="lazy">
		                </a>
		              </div>
		
		        <!-- ✅ 4개 채우면 슬라이드 닫기 -->
		        <c:if test="${st.index % 4 == 3 || st.last}">
		            </div>
		          </div>
		        </c:if>
		
		      </c:forEach>
		      
				
		    </div>
		    	<a class="carousel-control-prev" href="#recipeCarousel" role="button" data-slide="prev">
	                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
	                <span class="sr-only">Previous</span>
	            </a>
	            <a class="carousel-control-next" href="#recipeCarousel" role="button" data-slide="next">
	                <span class="carousel-control-next-icon" aria-hidden="true"></span>
	                <span class="sr-only">Next</span>
	            </a>
		  </div>
		</div>

	        	

	            
	        </div>
	    </div>
	</div>
	

    <!-- 안경 인트로 Start -->
    <div class="container-fluid">
		<div class="d-none d-md-block pb-5">
		  	<img src="img/frame_on_the_table.jpg" class="img-fluid" alt="">
		</div>
    </div>
    <!-- 안경 인트로 End -->

	<%-- =========================
	     ✅ 안경제품 Start (EYEGLASSES 8개)
	     컨트롤러에서 request.setAttribute("eyeglasses8", ...) 로 내려온 리스트 사용
	   ========================= --%>
	
	<div class="container-fluid pt-5">
	<div class="text-center mb-4">
	    <h2 class="section-title px-5"><span class="px-2">EYEGLASSES</span></h2>
	  </div>
	  <div class="row px-xl-5 pb-3">
	
	    <c:choose>
	      <c:when test="${not empty eyeglasses8}">
	        <c:forEach var="p" items="${eyeglasses8}">
	          <div class="col-6 col-md-6 col-lg-3 pb-1">
	            <div class="card product-item border-0 mb-4 h-100 shadow-sm">
	
	              <div class="card-header product-img position-relative overflow-hidden bg-transparent border p-0">
	                <a href="${pageContext.request.contextPath}/product/productDetail.sp?product_id=${p.product_id}">
	                  <img class="img-fluid w-100" src="${pageContext.request.contextPath}/img/${p.pimage}" alt="${p.product_name}">
	                </a>
	              </div>
	
	              <div class="card-body border-left border-right text-center p-0 pt-4 pb-3">
	                <h6 class="text-truncate mb-3 px-3">
	                  <a href="${pageContext.request.contextPath}/product/productDetail.sp?product_id=${p.product_id}"
	                     class="text-dark text-decoration-none font-weight-bold">
	                    ${p.product_name}
	                  </a>
	                </h6>
	
	                <a href="${pageContext.request.contextPath}/product/productDetail.sp?product_id=${p.product_id}"
	                   class="text-decoration-none">
	                  <div class="d-flex justify-content-center">
	                    <h6 class="text-danger font-weight-bold">
	                      <fmt:formatNumber value="${p.sale_price}" pattern="#,###" />원
	                    </h6>
	
	                    <c:if test="${p.list_price ne p.sale_price}">
	                      <h6 class="text-muted ml-2">
	                        <del><fmt:formatNumber value="${p.list_price}" pattern="#,###" />원</del>
	                      </h6>
	                    </c:if>
	                  </div>
	                </a>
	              </div>
	
	              <div class="card-footer d-flex justify-content-between bg-white border">
	
	                <c:choose>
	                  <c:when test="${not empty sessionScope.loginuser}">
	                    <button type="button" class="btn btn-wish p-0 wish-btn-${p.product_id}"
	                            onclick="goWish('${p.product_id}', '${pageContext.request.contextPath}')">
	                      <c:choose>
	                        <c:when test="${p.is_wish > 0}">
	                          <i class="fas fa-heart text-danger mr-1 wish-icon-${p.product_id}"></i>
	                        </c:when>
	                        <c:otherwise>
	                          <i class="far fa-heart text-danger mr-1 wish-icon-${p.product_id}"></i>
	                        </c:otherwise>
	                      </c:choose>
	                      <span class="small text-dark">Wish</span>
	                    </button>
	                  </c:when>
	
	                  <c:otherwise>
	                    <a href="${pageContext.request.contextPath}/loginSelect.sp" class="btn btn-wish p-0">
	                      <i class="far fa-heart text-danger mr-1"></i>
	                      <span class="small text-dark">Wish</span>
	                    </a>
	                  </c:otherwise>
	                </c:choose>
	
	                <button type="button" class="btn btn-cart p-0 cart-btn-${p.product_id}"
	                        onclick="goCart('${p.product_id}', '1', '${pageContext.request.contextPath}')">
	                  <i class="fas fa-shopping-cart text-dark mr-1 cart-icon-${p.product_id}"></i>
	                  <span class="small text-dark">Cart</span>
	                </button>
	
	              </div>
	
	            </div>
	          </div>
	        </c:forEach>
	      </c:when>
	
	      <c:otherwise>
	        <div class="col-12 text-center py-5">
	          <h4 class="text-muted">현재 등록된 안경 상품이 없습니다.</h4>
	        </div>
	      </c:otherwise>
	    </c:choose>
	
	  </div>
	
	  <div class="text-center mt-2">
	    <a class="btn btn-outline-dark"
	       href="${pageContext.request.contextPath}/product/productList.sp?category=eyeglasses">
	      더보기
	    </a>
	  </div>
	</div>
	
	<%-- ✅ 안경제품 End --%>


   


    <!-- 선글라스 인트로 Start -->
    <div class="container-fluid pt-5">
		<div class="d-none d-md-block pb-5">
		  	<img src="img/sunglass_on_the_table.jpg" class="img-fluid" alt="">
		</div>
    </div>
    <!-- 선글라스 인트로 End -->


	<%-- =========================
	     ✅ 선글라스 제품 Start (SUNGLASSES 8개)
	     컨트롤러에서 request.setAttribute("sunglasses8", ...) 로 내려온 리스트 사용
	   ========================= --%>
	
	<div class="container-fluid pt-5">
	  <div class="text-center mb-4">
	    <h2 class="section-title px-5"><span class="px-2">SUNGLASSES</span></h2>
	  </div>
	
	  <div class="row px-xl-5 pb-3">
	
	    <c:choose>
	      <c:when test="${not empty sunglasses8}">
	        <c:forEach var="p" items="${sunglasses8}">
	          <div class="col-6 col-md-6 col-lg-3 pb-1">
	            <div class="card product-item border-0 mb-4 h-100 shadow-sm">
	
	              <div class="card-header product-img position-relative overflow-hidden bg-transparent border p-0">
	                <a href="${pageContext.request.contextPath}/product/productDetail.sp?product_id=${p.product_id}">
	                  <img class="img-fluid w-100" src="${pageContext.request.contextPath}/img/${p.pimage}" alt="${p.product_name}">
	                </a>
	              </div>
	
	              <div class="card-body border-left border-right text-center p-0 pt-4 pb-3">
	                <h6 class="text-truncate mb-3 px-3">
	                  <a href="${pageContext.request.contextPath}/product/productDetail.sp?product_id=${p.product_id}"
	                     class="text-dark text-decoration-none font-weight-bold">
	                    ${p.product_name}
	                  </a>
	                </h6>
	
	                <a href="${pageContext.request.contextPath}/product/productDetail.sp?product_id=${p.product_id}"
	                   class="text-decoration-none">
	                  <div class="d-flex justify-content-center">
	                    <h6 class="text-danger font-weight-bold">
	                      <fmt:formatNumber value="${p.sale_price}" pattern="#,###" />원
	                    </h6>
	
	                    <c:if test="${p.list_price ne p.sale_price}">
	                      <h6 class="text-muted ml-2">
	                        <del><fmt:formatNumber value="${p.list_price}" pattern="#,###" />원</del>
	                      </h6>
	                    </c:if>
	                  </div>
	                </a>
	              </div>
	
	              <div class="card-footer d-flex justify-content-between bg-white border">
	
	                <c:choose>
	                  <c:when test="${not empty sessionScope.loginuser}">
	                    <button type="button" class="btn btn-wish p-0 wish-btn-${p.product_id}"
	                            onclick="goWish('${p.product_id}', '${pageContext.request.contextPath}')">
	                      <c:choose>
	                        <c:when test="${p.is_wish > 0}">
	                          <i class="fas fa-heart text-danger mr-1 wish-icon-${p.product_id}"></i>
	                        </c:when>
	                        <c:otherwise>
	                          <i class="far fa-heart text-danger mr-1 wish-icon-${p.product_id}"></i>
	                        </c:otherwise>
	                      </c:choose>
	                      <span class="small text-dark">Wish</span>
	                    </button>
	                  </c:when>
	
	                  <c:otherwise>
	                    <a href="${pageContext.request.contextPath}/loginSelect.sp" class="btn btn-wish p-0">
	                      <i class="far fa-heart text-danger mr-1"></i>
	                      <span class="small text-dark">Wish</span>
	                    </a>
	                  </c:otherwise>
	                </c:choose>
	
	                <button type="button" class="btn btn-cart p-0 cart-btn-${p.product_id}"
	                        onclick="goCart('${p.product_id}', '1', '${pageContext.request.contextPath}')">
	                  <i class="fas fa-shopping-cart text-dark mr-1 cart-icon-${p.product_id}"></i>
	                  <span class="small text-dark">Cart</span>
	                </button>
	
	              </div>
	
	            </div>
	          </div>
	        </c:forEach>
	      </c:when>
	
	      <c:otherwise>
	        <div class="col-12 text-center py-5">
	          <h4 class="text-muted">현재 등록된 선글라스 상품이 없습니다.</h4>
	        </div>
	      </c:otherwise>
	    </c:choose>
	
	  </div>
	
	  <div class="text-center mt-2">
	    <a class="btn btn-outline-dark"
	       href="${pageContext.request.contextPath}/product/productList.sp?category=sunglasses">
	      더보기
	    </a>
	  </div>
	</div>
	
	<%-- ✅ 선글라스 제품 End --%>




    



    <jsp:include page="footer.jsp"/>


    <!-- Back to Top -->
    <a href="/SemiProject/" class="btn btn-primary back-to-top"><i class="fa fa-angle-double-up"></i></a>



    
<script src="${pageContext.request.contextPath}/js/ih_product/product.js"></script>

<script type="text/javascript">
$(document).ready(function(){
	
  $('#recipeCarousel').carousel({
    interval: 2000
  });

});
</script>
</body>

</html>