<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String ctxPath = request.getContextPath(); %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>관리자 | 회원관리</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script> <%-- jquery 추가 --%>

<style>
body{font-family:'Pretendard',Arial,sans-serif;background:#f7f6f3;color:#333}
.container{width:1100px;margin:60px auto;background:#fff;padding:40px;border-radius:4px;box-shadow:0 4px 12px rgba(0,0,0,.06)}
h3{font-size:18px;font-weight:700;letter-spacing:-.3px;color:#2f2b2a;margin-bottom:0}
.container>div a{background:#3e3a39!important;transition:.2s}
.container>div a:hover{background:#2f2b2a!important}

/* ===== 회원 조회 ===== */
.search-area{background:#fff;padding:30px;border-radius:4px;margin-bottom:40px;box-shadow:0 4px 12px rgba(0,0,0,.05)}
.search-area h3{margin-bottom:20px;font-size:16px;font-weight:600}
.search-area form{display:flex;gap:10px}
.search-area select,.search-area input{padding:10px 12px;border:1px solid #ccc;border-radius:3px;font-size:14px}
.search-area input{flex:1}
.search-area button{padding:10px 18px;border:none;background:#6d4c41;color:#fff;font-weight:600;cursor:pointer;border-radius:3px}
.search-area button:hover{background:#5d4037}

/* ===== 전체목록 버튼 ===== */
a.reset-btn,a.reset-btn:link,a.reset-btn:visited{display:inline-block;padding:10px 18px;background:#9a9693!important;color:#fff!important;font-size:14px;font-weight:600;border-radius:3px;text-decoration:none;transition:.2s}
a.reset-btn:hover,a.reset-btn:active{background:#a89288;color:#fff!important}

/* ===== 테이블 ===== */
table{width:100%;border-collapse:collapse;margin-top:30px;font-size:14px}
thead th{background:#f2f1ee;font-weight:600;color:#555;padding:14px 10px;border-bottom:2px solid #ddd}
tbody td{padding:14px 10px;border-bottom:1px solid #eee;color:#444}
tbody tr:hover{background:#faf9f7}
tbody td:last-child{font-weight:600}
tbody tr td[colspan]{padding:30px 0;color:#777;font-size:14px}

/* ===== 페이지 바 ===== */
.pagination .page-item .page-link{color:#3b2f2a;border:1px solid #e3e0dc;background:#fff;margin:0 3px;padding:6px 12px;font-size:13px;border-radius:20px;transition:.2s}
.pagination .page-link:hover{background:#f5f3ef!important;border-color:#3b2f2a!important;color:#3b2f2a!important}
.pagination .page-item.active .page-link{background:#3b2f2a!important;border-color:#3b2f2a!important;color:#fff!important}
</style>

<script type="text/javascript">
	$(function(){
	
	    // 회원 행 클릭 시 상세보기 이동
	    $("table#memberTbl tr.memberInfo").on("click", function(){
	
	        // 클릭한 행에서 userid 가져오기
	        const userid = $(this).find(".userid").text().trim();
	
	        // hidden form에 값 넣기
	        const frm = document.memberOneDetailFrm;
	        frm.userid.value = userid;
	
	        // 이동
	        frm.action = "<%=ctxPath%>/admin/memberDetail.sp";
	        frm.method = "post";
	        frm.submit();
	    });
	
	});
</script>

</head>

<body>

<!--  고정 헤더 -->
<jsp:include page="../header2.jsp" />


<div class="container">

    <div style="display:flex; justify-content:space-between; align-items:center;">
        <h3 class="font-weight-bold mb-4 text-dark">회원 관리</h3>

        <!-- 메인페이지로 돌아가기 -->
        <a href="<%= ctxPath %>/admin/memberMain.sp"
           style="padding:8px 14px;
                  background:#333;
                  color:#fff;
                  text-decoration:none;
                  border-radius:4px;
                  font-size:14px;">
            메인페이지로
        </a>
    </div>

	<%-- ===============================
     회원 조회 영역
   =============================== --%>
	<div class="search-area">
	    <h3>회원 조회</h3>
	    <form action="<%=ctxPath%>/admin/memberList.sp" method="get">
	        <select name="searchType">
	            <option value="userid">아이디</option>
	            <option value="name">이름</option>
	        </select>
	        <input type="text" name="searchWord" placeholder="검색어 입력">
	        <button type="submit">조회</button>
	        
	        <!--  검색했을 때만 전체 목록 버튼 노출 -->
	        <c:if test="${not empty param.searchWord}">
	            <a href="<%=ctxPath%>/admin/memberList.sp" class="reset-btn">
	                전체 목록 보기
	            </a>
	        </c:if>
	    </form>
	</div>
	
	

    <%-- ===============================
         회원 목록 테이블
         memberList 는 컨트롤러에서
         request.setAttribute("memberList", memberList)
         로 넘어온 값
       =============================== --%>
    <table id="memberTbl">
        <thead>
            <tr>
            	<th style="width:60px;">No</th>
                <th>아이디</th>
                <th>이름</th>
                <th>성별</th>
                <th>이메일</th>
                <th>가입일</th>
                <th>상태</th>
            </tr>
        </thead>

        <tbody>

            <%-- 회원이 한 명도 없을 경우 --%>
            <c:if test="${empty memberList}">
                <tr>
                    <td colspan="6">등록된 회원이 없습니다.</td>
                </tr>
            </c:if>

            <%-- 회원 목록 반복 출력 --%>
            <c:forEach var="m" items="${memberList}" varStatus="status">
                <tr class="memberInfo">
                	<td>${status.count}</td>
                    <%-- MemberDTO.getUserid() --%>
                    <td class="userid">${m.userid}</td>

                    <%-- MemberDTO.getName() --%>
                    <td>${m.name}</td>

					<%-- 성별 추가 --%>
					<td>
					    <c:choose>
					        <c:when test="${m.gender == '1'}">
					            남
					        </c:when>
					        <c:when test="${m.gender == '2'}">
					            여
					        </c:when>
					        <c:otherwise>
					            미입력
					        </c:otherwise>
					    </c:choose>
					</td>
					
					
                    <%-- MemberDTO.getEmail() --%>
                    <td>${m.email}</td>

                    <%-- 
                        가입일
                        DTO 필드명: registerday
                        getter   : getRegisterday()
                    --%>
                    <td>${m.registerday}</td>
                    

                    <%-- 
                        회원 상태
                        status : 1 = 정상 / 0 = 탈퇴
                    --%>
                    <td>
                        <c:choose>
                            <c:when test="${m.status == 1}">
                                정상
                            </c:when>
                            <c:otherwise>
                                탈퇴
                            </c:otherwise>
                        </c:choose>
                    </td>                 
                </tr>
            </c:forEach>

        </tbody>
    </table>

	<!-- 페이지네이션 -->
	<ul class="pagination justify-content-center mt-4">
	
	    <!-- 이전 -->
	    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
	        <a class="page-link"
	           href="<%=ctxPath%>/admin/memberList.sp?pageNo=${currentPage - 1}">
	            ‹
	        </a>
	    </li>
	
	    <!-- 페이지 번호 -->
	    <c:forEach begin="1" end="${totalPage}" var="i">
	        <li class="page-item ${currentPage == i ? 'active' : ''}">
	            <a class="page-link"
	               href="<%=ctxPath%>/admin/memberList.sp?pageNo=${i}">
	                ${i}
	            </a>
	        </li>
	    </c:forEach>
	
	    <!-- 다음 -->
	    <li class="page-item ${currentPage == totalPage ? 'disabled' : ''}">
	        <a class="page-link"
	           href="<%=ctxPath%>/admin/memberList.sp?pageNo=${currentPage + 1}">
	            ›
	        </a>
	    </li>
	
	</ul>

	

</div>

<!-- 회원 더미 추가 버튼 -->
<a href="<%=ctxPath%>/admin/dummyMember50.sp"
   onclick="return confirm('더미 회원 50명을 생성하시겠습니까?');"
   style="padding:8px 14px;background:#5d4037;color:#fff;border-radius:4px;text-decoration:none;">
   더미회원 50명 생성(비번 1234 통일)
</a>

<%-- 폼태그 추가 --%>
<form name="memberOneDetailFrm">
   <input type="hidden" name="userid" />
</form>


<%-- 고정 푸터 --%>
<jsp:include page="../footer2.jsp" />

</body>
</html>
