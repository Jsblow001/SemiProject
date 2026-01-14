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
/* ✅ 멀티 아이템 캐러셀(#recipeCarousel) 전용 */
#recipeCarousel .carousel-inner .carousel-item.active,
#recipeCarousel .carousel-inner .carousel-item-next,
#recipeCarousel .carousel-inner .carousel-item-prev {
  display: flex;
}

#recipeCarousel .carousel-inner .carousel-item-right.active,
#recipeCarousel .carousel-inner .carousel-item-next {
  transform: translateX(25%);
}

#recipeCarousel .carousel-inner .carousel-item-left.active,
#recipeCarousel .carousel-inner .carousel-item-prev {
  transform: translateX(-25%);
}

#recipeCarousel .carousel-inner .carousel-item-right,
#recipeCarousel .carousel-inner .carousel-item-left {
  transform: translateX(0);
}
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

  </style>
  
<%-- 임시 이동 버튼 --%>
<br><br>
<a href="<%= request.getContextPath() %>/reservation.sp">reservation</a>&nbsp&nbsp
<a href="<%= request.getContextPath() %>/myReservations.sp">my_reservation</a>&nbsp&nbsp
<a href="<%= request.getContextPath() %>/admin/schedule.sp">reservation_admin</a>
<%-- 임시 review, notice, qna 이동 버튼 --%>
    
    <!-- Navbar Start -->
    <div class="container-fluid">
        <div class="row border-top pt-10 px-xl-5">
            <div class="col-lg">
                
                <div id="header-carousel" class="carousel slide" data-ride="carousel">
                    <div class="carousel-inner">
					    <div class="carousel-item active">
					      <img class="d-block w-100 carousel-img" src="img/index_upper_carousel/carousel-1.jpg" alt="Image">
					    </div>
					    <div class="carousel-item">
					      <img class="d-block w-100 carousel-img" src="img/index_upper_carousel/carousel-2.jpg" alt="Image">
					    </div>
					    <div class="carousel-item">
					      <img class="d-block w-100 carousel-img" src="img/index_upper_carousel/carousel-3.jpg" alt="Image">
					    </div>
					</div>
                    <a class="carousel-control-prev" href="#header-carousel" data-slide="prev">
                        <div class="btn btn-dark" style="width: 45px; height: 45px;">
                            <span class="carousel-control-prev-icon mb-n2"></span>
                        </div>
                    </a>
                    <a class="carousel-control-next" href="#header-carousel" data-slide="next">
                        <div class="btn btn-dark" style="width: 45px; height: 45px;">
                            <span class="carousel-control-next-icon mb-n2"></span>
                        </div>
                    </a>
                </div>
            </div>
        </div>
    </div>
    <!-- Navbar End -->


	<div class="container text-center my-5">
	    <h2 class="mb-3">Monthly Best</h2>
	    <div class="row mx-auto my-auto">
	        <div id="recipeCarousel" class="carousel slide w-100" data-ride="carousel">
	            <div class="carousel-inner w-100" role="listbox">
	                <div class="carousel-item active">
	                    <img class="d-block col-3 img-fluid" src="img/glasses/product_1.png">
	                </div>
	                <div class="carousel-item">
	                    <img class="d-block col-3 img-fluid" src="img/glasses/product_4.png">
	                </div>
	                <div class="carousel-item">
	                    <img class="d-block col-3 img-fluid" src="img/glasses/product_9.png">
	                </div>
	                <div class="carousel-item">
	                    <img class="d-block col-3 img-fluid" src="img/glasses/product_20.png">
	                </div>
	                <div class="carousel-item">
	                    <img class="d-block col-3 img-fluid" src="img/glasses/product_11.png">
	                </div>
	                <div class="carousel-item">
	                    <img class="d-block col-3 img-fluid" src="img/glasses/product_13.png">
	                </div>
	                <div class="carousel-item">
	                    <img class="d-block col-3 img-fluid" src="img/glasses/product_14.png">
	                </div>
	                <div class="carousel-item">
	                    <img class="d-block col-3 img-fluid" src="img/glasses/product_17.png">
	                </div>
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
	

    <!-- 안경 인트로 Start -->
    <div class="container-fluid pt-5">
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
	          <div class="col-lg-3 col-md-6 col-sm-12 pb-1">
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
	          <div class="col-lg-3 col-md-6 col-sm-12 pb-1">
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




    <!-- Subscribe Start -->
    <div class="container-fluid bg-secondary my-5">
        <div class="row justify-content-md-center py-5 px-xl-5">
            <div class="col-md-6 col-12 py-5">
                <div class="text-center mb-2 pb-2">
                    <h2 class="section-title px-5 mb-3"><span class="bg-secondary px-2">Stay Updated</span></h2>
                    <p>Amet lorem at rebum amet dolores. Elitr lorem dolor sed amet diam labore at justo ipsum eirmod duo labore labore.</p>
                </div>
                <form action="">
                    <div class="input-group">
                        <input type="text" class="form-control border-white p-4" placeholder="Email Goes Here">
                        <div class="input-group-append">
                            <button class="btn btn-primary px-4">Subscribe</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <!-- Subscribe End -->



    <jsp:include page="footer.jsp"/>


    <!-- Back to Top -->
    <a href="/SemiProject/" class="btn btn-primary back-to-top"><i class="fa fa-angle-double-up"></i></a>



    
<script src="${pageContext.request.contextPath}/js/ih_product/product.js"></script>

<script type="text/javascript">
$(document).ready(function(){
	
	$('#recipeCarousel').carousel({
  	  interval :2000
  	});

	$('#recipeCarousel .carousel-item').each(function(){
	    var next = $(this).next();
	    if (!next.length) next = $(this).siblings(':first');

	    next.children(':first-child').clone().appendTo($(this));

	    for (var i=0;i<2;i++) {
	        next = next.next();
	        if (!next.length) next = $(this).siblings(':first');
	        next.children(':first-child').clone().appendTo($(this));
	    }
	});

});
</script>
</body>

</html>