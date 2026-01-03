<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String ctxPath = request.getContextPath(); %>
<%-- 
    관리자 헤더 (아직 미구현 상태라 주석 처리)
    나중에 헤더 완성되면 주석만 해제하면 됨
--%>
<%-- <jsp:include page="" /> --%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>관리자 | 회원관리</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #fff;
        }
        h3 {
            margin-bottom: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: center;
        }
        th {
            background-color: #f5f5f5;
        }
    </style>
</head>

<body>

<div class="container">

    <div style="display:flex; justify-content:space-between; align-items:center;">
        <h3>회원 관리</h3>

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
    <table>
        <thead>
            <tr>
                <th>아이디</th>
                <th>이름</th>
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
            <c:forEach var="m" items="${memberList}">
                <tr>
                    <%-- MemberDTO.getUserid() --%>
                    <td>${m.userid}</td>

                    <%-- MemberDTO.getName() --%>
                    <td>${m.name}</td>

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

<%-- 관리자 푸터 (나중에 필요하면) --%>
<%-- <jsp:include page="" /> --%>

</body>
</html>
