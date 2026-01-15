<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String ctxPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>CARIN | MY PAGE</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%=ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
    
    <style>
        body {
            font-family: 'Poppins', 'Pretendard', sans-serif !important;
            background-color: #FBFAF8 !important;
        }
        
        .mypage-container {
            margin-top: 150px; 
            margin-bottom: 100px;
        }
        
        .summary-box {
            background: #fff;
            padding: 40px 30px;
            border: 1px solid #eee;
            margin-bottom: 40px;
            border-radius: 5px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.02);
        }

        .grade-circle {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            border: 2px solid #5D4037;
            background-color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            color: #5D4037;
            font-size: 13px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
            margin: 0 auto;
        }

        .btn-edit-profile {
            display: inline-block;
            padding: 8px 18px;
            border: 1px solid #5D4037;
            color: #5D4037;
            font-size: 13px;
            font-weight: 500;
            border-radius: 30px;
            text-decoration: none !important;
            transition: all 0.3s ease;
        }
        .btn-edit-profile:hover {
            background: #5D4037;
            color: #fff;
        }
        
        .btn-mypage-card {
            display: block;
            padding: 35px 20px;
            background: #fff;
            border: 1px solid #eee;
            text-decoration: none !important;
            transition: all 0.3s ease;
            height: 100%;
            border-radius: 5px;
        }
        .btn-mypage-card:hover {
            border-color: #5D4037;
            transform: translateY(-5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }

        /* 등급 프로그레스 바 커스텀 */
        .membership-progress-area {
            max-width: 220px;
            margin: 15px auto 0;
        }
        .progress {
            height: 8px;
            background-color: #f0f0f0;
            border-radius: 10px;
            overflow: hidden;
        }
        .progress-bar {
            background-color: #5D4037;
            transition: width 1s ease-in-out;
        }
        
        .card-icon { font-size: 30px; margin-bottom: 15px; }
        .card-title { font-size: 16px; font-weight: 600; color: #333; margin-bottom: 5px; }
        .card-desc { font-size: 12px; color: #999; }
        .account-box { border-top: 1px solid #eee; color: #888; }
        .account-title { font-size: 13px; letter-spacing: 2px; margin-bottom: 10px; color: #aaa; }
        .account-actions { font-size: 13px; }
        .account-link { color: #777; text-decoration: none; transition: color .2s; }
        .account-link:hover { color: #5D4037; }
        .account-link.withdraw:hover { color: #c62828; }
        .divider { margin: 0 10px; color: #ccc; }
    </style>
</head>
<body>

    <jsp:include page="../header.jsp" />

    <div class="container mypage-container">
        
        <%-- 사용자 요약 정보 영역 --%>
        <div class="summary-box row align-items-center mx-0">
            <div class="col-md-5 border-right py-2">
			    <h2 style="font-size: 26px; font-weight: 500; letter-spacing: 1px; color: #333;">MY PAGE</h2>
			    
			    <%-- 인사말 영역 --%>
			    <p class="text-muted mb-0" style="font-size: 15px; margin-top: 10px;">
			        반갑습니다, <span style="color: #5D4037; font-weight: 700; font-size: 18px;">${sessionScope.loginuser.name}</span>님!
			    </p>
			    
			    <%-- 보유 포인트 영역: mt-2와 함께 pl-0(왼쪽 패딩 제거) 적용 --%>
			    <div class="mt-2 d-flex align-items-center">
			        <span class="badge badge-light p-2 text-muted" style="font-size: 13px; margin-left: -8px;"> 
			            보유 포인트: 
			            <span class="text-dark font-weight-bold">
			                <fmt:formatNumber value="${sessionScope.loginuser.point}" pattern="#,###" /> P
			            </span>
			        </span>
			    </div>
			</div>
            
            <%-- 멤버십 및 다음 등급 안내 --%>
			<div class="col-md-5 border-right py-2">
			    <div style="font-size: 11px; color: #aaa; margin-bottom: 15px; letter-spacing: 1px; font-weight: 600; text-align: center;">
			        MEMBERSHIP PROGRESS
			    </div>
			    
			    <div class="d-flex align-items-center justify-content-center">
			        <%-- [왼쪽] 현재 등급 원형 --%>
			        <div class="grade-circle shadow-sm" style="margin: 0 25px 0 0; flex-shrink: 0;">
			            ${sessionScope.loginuser.grade_name}
			        </div>
			        
			        <%-- [오른쪽] 등급 및 프로그레스 정보 --%>
			        <div class="text-left" style="width: 200px;">
			            <c:choose>
			                <%-- 최상위 등급(골드)인 경우 --%>
			                <c:when test="${sessionScope.loginuser.grade_code eq '3'}">
			                    <div style="font-weight: 600; font-size: 16px; color: #333;">GOLD LEVEL</div>
			                    <div class="small text-muted">최고 등급 혜택 적용 중</div>
			                </c:when>
			                
			                <%-- 승급 진행 중인 경우 --%>
			                <c:otherwise>
			                    <div class="d-flex justify-content-between align-items-end mb-1">
			                        <span style="font-size: 12px; font-weight: 600; color: #333;">다음 등급: ${nextGradeName}</span>
			                        <span style="font-size: 11px; color: #5D4037; font-weight: 700;">${percent}%</span>
			                    </div>
			                    
			                    <%-- 프로그레스 바: 컨트롤러에서 계산한 percent 적용 --%>
			                    <div class="progress" style="height: 6px; background-color: #f0f0f0; border-radius: 10px;">
			                        <div class="progress-bar" role="progressbar" 
			                             style="width: ${percent}%; background-color: #5D4037;" 
			                             aria-valuenow="${percent}" aria-valuemin="0" aria-valuemax="100">
			                        </div>
			                    </div>
			                    
			                    <%-- [수정된 부분] 남은 금액 안내 또는 승급 심사 문구 --%>
							    <div class="mt-1" style="font-size: 11px; color: #999;">
							        <c:choose>
							            <c:when test="${neededAmount <= 0 || percent >= 100}">
							                <span class="font-weight-bold" style="color: #5D4037;">
							                    다음 정기 승급 시점에 승급 예정입니다.
							                </span>
							            </c:when>
							            <c:otherwise>
							                <span class="font-weight-bold text-dark">
							                    <fmt:formatNumber value="${neededAmount}" pattern="#,###"/>원
							                </span> 더 구매 시 승급 대상
							            </c:otherwise>
							        </c:choose>
							    </div>
							</c:otherwise>
			            </c:choose>
			        </div>
			    </div>
			</div>

            <div class="col-md-2 py-2 text-center">
                <div style="font-size: 10px; color: #aaa; margin-bottom: 25px; letter-spacing: 1px; font-weight: 600; text-align: center;">
                	ACCOUNT MANAGEMENT
                </div>
                <a href="<%= ctxPath %>/js_member/memberedit.sp" class="btn-edit-profile" style="margin-bottom: 26px">
                    내 정보 수정 <i class="ml-1">→</i>
                </a>
            </div>
        </div>

        <%-- 메뉴 카드 영역 (생략 없음) --%>
        <div class="row text-center mb-5">
            <div class="col-md-3 mb-4">
                <a href="<%= ctxPath %>/reviewWrite.sp" class="btn-mypage-card">
                    <div class="card-icon">📝</div>
                    <div class="card-title">리뷰작성</div>
                    <div class="card-desc">상품리뷰 작성</div>
                </a>
            </div>
            <div class="col-md-3 mb-4">
                <a href="<%= ctxPath %>/myReservations.sp" class="btn-mypage-card">
                    <div class="card-icon">📅</div>
                    <div class="card-title">예약확인</div>
                    <div class="card-desc">매장 예약 확인</div>
                </a>
            </div>
            <div class="col-md-3 mb-4">
                <a href="<%= ctxPath %>/product/wishList.sp" class="btn-mypage-card">
                    <div class="card-icon">🖤</div>
                    <div class="card-title">위시리스트</div>
                    <div class="card-desc">담아둔 관심 상품</div>
                </a>
            </div>
            <div class="col-md-3 mb-4">
                <a href="<%= ctxPath %>/customer/myQnaList.sp" class="btn-mypage-card">
                    <div class="card-icon">💬</div>
                    <div class="card-title">내 문의</div>
                    <div class="card-desc">1:1 문의 내역 확인</div>
                </a>
            </div>
        </div>

        <%-- 최근 주문 정보 테이블 --%>
        <div class="mt-5">
            <div class="d-flex justify-content-between align-items-end mb-3">
                <h4 style="font-size: 18px; font-weight: 600; margin: 0; color: #333;">최근 주문 정보</h4>
                <a href="<%= ctxPath %>/shop/orderList.sp" style="font-size: 12px; color: #999; text-decoration: none;">전체보기 ></a>
            </div>
            <table class="table" style="font-size: 14px; border-top: 2px solid #5D4037; background: #fff;">
                <thead class="bg-light text-center text-muted">
                    <tr>
                        <th style="width: 10%;">번호</th>
                        <th style="width: 15%;">날짜</th>
                        <th>상품명</th>
                        <th style="width: 15%;">결제금액</th>
                        <th style="width: 15%;">상태</th>
                    </tr>
                </thead>
                <tbody class="text-center">
                    <c:choose>
                        <c:when test="${not empty recentOrderList}">
                            <c:forEach var="o" items="${recentOrderList}" varStatus="status" end="4">
                                <tr>
                                    <td>${status.count}</td>
                                    <td><fmt:formatDate value="${o.odrDate}" pattern="yyyy-MM-dd"/></td>
                                    <td class="text-left font-weight-bold">${o.productName}</td>
                                    <td><fmt:formatNumber value="${o.odrTotalPrice}" pattern="#,###"/>원</td>
                                    <td><span class="badge badge-light px-3 py-2">${o.paymentStatusName}</span></td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="5" class="py-5 text-muted">
                                    최근 30일 내에 주문하신 내역이 없습니다.
                                </td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
        
        <%-- 최근 리뷰 정보 테이블 --%>
	      <div class="mt-5">
	          <div class="d-flex justify-content-between align-items-end mb-3">
	              <h4 style="font-size: 18px; font-weight: 600; margin: 0; color: #333;">최근 리뷰 정보</h4>
	              <a href="<%= ctxPath %>/myReviewList.sp"
	                 style="font-size: 12px; color: #999; text-decoration: none;">전체보기 ></a>
	          </div>
	      
	          <table class="table" style="font-size: 14px; border-top: 2px solid #5D4037; background: #fff;">
	              <thead class="bg-light text-center text-muted">
	                  <tr>
	                      <th style="width: 10%;">번호</th>
	                      <th style="width: 15%;">날짜</th>
	                      <th>상품명</th>
	                      <th>리뷰제목</th>
	                      <th style="width: 10%;">평점</th>
	                      <th style="width: 12%;">답변</th>
	                      <th style="width: 13%;">삭제</th>
	                  </tr>
	              </thead>
	      
	              <tbody class="text-center">
	                  <c:choose>
	                      <c:when test="${not empty recentReviewList}">
	                          <c:forEach var="r" items="${recentReviewList}" varStatus="st">
	                              <tr>
	                                  <td>${st.count}</td>
	                                  <td>${r.review_date}</td>
	                                  <td>${r.product_name}</td>
	      
	                                  <td style="text-align:left;">
	                                      <a href="<%=ctxPath%>/reviewView.sp?reviewId=${r.review_id}"
	                                         style="color:#333;text-decoration:none;">
	                                          ${r.review_title}
	                                      </a>
	                                  </td>
	      
	                                  <td>${r.rating}</td>
	      
	                                  <td>
	                                      <c:choose>
	                                          <c:when test="${r.commentCount > 0}">
	                                              <span style="color:#5D4037;font-weight:600;">완료</span>
	                                          </c:when>
	                                          <c:otherwise>
	                                              <span style="color:#999;">대기</span>
	                                          </c:otherwise>
	                                      </c:choose>
	                                  </td>
	      
	                                  <!-- ✅ 삭제 버튼 -->
	                                  <td>
	                                      <a href="javascript:void(0);"
	                                         onclick="goDeleteRecentReview('${r.review_id}')"
	                                         style="font-size:12px;color:#c62828;">
	                                          삭제
	                                      </a>
	                                  </td>
	                              </tr>
	                          </c:forEach>
	                      </c:when>
	      
	                      <c:otherwise>
	                          <tr>
	                              <td colspan="7" class="py-5 text-muted">
	                                  최근 작성한 리뷰가 없습니다.
	                              </td>
	                          </tr>
	                      </c:otherwise>
	                  </c:choose>
	              </tbody>
	          </table>
	      </div>
	      
	      <script>
	      function goDeleteRecentReview(reviewId){
	          if(!confirm("정말 이 리뷰를 삭제할까요?\n삭제하면 복구할 수 없습니다.")) return;
	      
	          // ✅ 삭제 후 마이페이지로 돌아오기
	          const returnUrl = "<%=ctxPath%>/mypage.sp";
	      
	          const f = document.createElement("form");
	          f.method = "post";
	          f.action = "<%=ctxPath%>/reviewDelete.sp";
	      
	          const i1 = document.createElement("input");
	          i1.type = "hidden";
	          i1.name = "reviewId";
	          i1.value = reviewId;
	      
	          const i2 = document.createElement("input");
	          i2.type = "hidden";
	          i2.name = "returnUrl";
	          i2.value = returnUrl;
	      
	          f.appendChild(i1);
	          f.appendChild(i2);
	      
	          document.body.appendChild(f);
	          f.submit();
	      }
	      </script>
        
        <%-- 계정 관리 영역 --%>
        <div class="account-box mt-5 pt-4 text-center">
            <div class="account-title">계정 설정</div>
            <div class="account-actions">
                <a href="<%=ctxPath%>/logout.sp" class="account-link">로그아웃</a>
                <span class="divider">|</span>
                <a href="<%=ctxPath%>/withdraw.sp" class="account-link withdraw">회원탈퇴</a>
            </div>
        </div>
    </div>
     
    <jsp:include page="../footer.jsp" />

</body>
</html>