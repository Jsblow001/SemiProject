<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String ctxPath = request.getContextPath(); %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>관리자 | 회원관리</title>

<style>
	body {
	    font-family: 'Pretendard', Arial, sans-serif;
	    background-color: #f7f6f3;
	    color: #333;
	}
	
	.container {
	    width: 1100px;
	    margin: 60px auto;
	    background-color: #fff;
	    padding: 40px;
	    border-radius: 4px;
	    box-shadow: 0 4px 12px rgba(0,0,0,0.06);
	}
	
	/* ===== 상단 타이틀 영역 ===== */
	h3 {
	    font-size: 18px;
	    font-weight: 700;
	    letter-spacing: -0.3px;
	    color: #2f2b2a;
	    margin-bottom: 0;
	}
	
	/* 상단 버튼 */
	.container > div a {
	    background-color: #3e3a39 !important;
	    transition: background-color 0.2s ease;
	}
	
	.container > div a:hover {
	    background-color: #2f2b2a !important;
	}
	
	/* ===== 테이블 ===== */
	table {
	    width: 100%;
	    border-collapse: collapse;
	    margin-top: 30px;
	    font-size: 14px;
	}
	
	thead th {
	    background-color: #f2f1ee;
	    font-weight: 600;
	    color: #555;
	    padding: 14px 10px;
	    border-bottom: 2px solid #ddd;
	}
	
	tbody td {
	    padding: 14px 10px;
	    border-bottom: 1px solid #eee;
	    color: #444;
	}
	
	tbody tr:hover {
	    background-color: #faf9f7;
	}
	
	/* 상태 컬럼 강조 */
	tbody td:last-child {
	    font-weight: 600;
	}
	
	/* 탈퇴 회원 */
	tbody tr td:last-child:contains("탈퇴") {
	    color: #b71c1c;
	}
	
	/* 회원 없을 때 */
	tbody tr td[colspan] {
	    padding: 30px 0;
	    color: #777;
	    font-size: 14px;
	}
</style>

<script type="text/javascript">
	$(function(){
	
	    // 회원 행 클릭 시 상세보기 이동
	    $("table#memberTbl tr.memberInfo").on("click", function(){
	
	        // 클릭한 행에서 userid 가져오기
	        const userid = $(this).find(".userid").text().trim();
	
	        // hidden form에 값 넣기
	        const frm = document.memberDetailFrm;
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

</div>

<%-- 폼태그 추가 --%>
<form name="memberOneDetailFrm">
   <input type="hidden" name="userid" />
</form>


<%-- 고정 푸터 --%>
<jsp:include page="../footer2.jsp" />

</body>
</html>
