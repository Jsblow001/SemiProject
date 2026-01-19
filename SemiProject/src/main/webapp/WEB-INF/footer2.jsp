<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

                </div> </div> </div> </div> 
</body>
<% String ctxPath = request.getContextPath(); %>

<div class="container-fluid border-top mt-5" style="background-color: var(--light-bg); color: #333;">
    <div class="container-fluid py-5 px-xl-5">
        
        <div class="row px-xl-5 mb-4">
            <div class="col-12 text-left">
                <a href="/" class="text-decoration-none">
                    <h1 class="m-0 display-5 font-weight-semi-bold">
                        <span class="text-wood font-weight-bold px-0">SISEON</span>
                    </h1>
                </a>
            </div>
        </div>

        <div class="row px-xl-5">
            
            <div class="col-lg-6 col-md-12 mb-5">
			    <p class="font-weight-bold mb-3" style="color: var(--dark-wood); padding-bottom: 5px;">Company Information</p>
			    
			    <div class="text-dark" style="font-size: 0.9rem; width: 100%;">
			        
			        <div class="d-flex justify-content-between mb-1" padding-bottom: 2px;">
			            <span class="font-weight-medium">사업자명</span>
			            <span>쌍용</span>
			        </div>
			
			        <div class="d-flex justify-content-between mb-1" padding-bottom: 2px;">
			            <span class="font-weight-medium">대표자명</span>
			            <span>6반 1팀</span>
			        </div>
			
			        <div class="d-flex justify-content-between mb-1" padding-bottom: 2px;">
			            <span class="font-weight-medium">주소</span>
			            <span class="text-right pl-3">서울특별시 강남구 테헤란로70길 12 9층</span>
			        </div>
			
			        <div class="d-flex justify-content-between mb-1" padding-bottom: 2px;">
			            <span class="font-weight-medium">사업자번호</span>
			            <span>753-98-42615</span>
			        </div>
			
			        <div class="d-flex justify-content-between mb-1" padding-bottom: 2px;">
			            <span class="font-weight-medium">대표전화번호</span>
			            <span>0507-1316-4632</span>
			        </div>
			
			        <div class="d-flex justify-content-between mb-1" padding-bottom: 2px;">
			            <span class="font-weight-medium">운영시간</span>
			            <span>09:00 - 18:00 (주말/공휴일 휴무)</span>
			        </div>
			
			        <div class="d-flex justify-content-between mb-1" padding-bottom: 2px;">
			            <span class="font-weight-medium">이메일</span>
			            <span>ss@siseon2026.com</span>
			        </div>
			        
			    </div>
			</div>

            <a class="text-dark mb-2" href="<%= ctxPath %>/qnaList.sp">QnA</a>
                    <a class="text-dark mb-2" href="<%= ctxPath %>/shop/orderList.sp">주문조회</a>
                    <a class="text-dark mb-2" href="<%= ctxPath %>/reservation.sp">예약하기</a>
                    <a class="text-dark mb-2" href="<%= ctxPath %>/storeLocation2.sp">매장찾기</a>
                    <a class="text-dark mb-2" href="<%= ctxPath %>/terms.sp">이용약관</a>
                    <a class="text-dark mb-2" href="<%= ctxPath %>/information.sp">개인정보처리방침</a>

            <div class="col-lg-2 col-md-6 mb-5 text-lg-right">
                <p class="font-weight-bold mb-3" style="color: var(--dark-wood); padding-bottom: 5px;">Social</p>
                <div class="d-inline-flex align-items-center">
                    <a class="text-wood px-2" href=""><i class="fab fa-facebook-f fa-lg"></i></a>
                    <a class="text-wood px-2" href=""><i class="fab fa-instagram fa-lg"></i></a>
                    <a class="text-wood px-2" href=""><i class="fab fa-youtube fa-lg"></i></a>
                </div>
            </div>
            
        </div>

        <div class="row border-top mx-xl-5 py-4" style="border-color: rgba(93, 64, 55, 0.1) !important;">
            <div class="col-md-6 px-xl-0">
                <p class="mb-md-0 text-center text-md-left text-dark">
                    &copy; <a class="text-wood font-weight-semi-bold" href="#">SISEON</a>. All Rights Reserved.
                </p>
            </div>
        </div>
    </div>
</div>
<a href="#" class="btn btn-wood back-to-top" style="position: fixed; right: 30px; bottom: 30px; display: none; z-index: 11; border-radius: 50%;"><i class="fa fa-angle-double-up"></i></a>

<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>