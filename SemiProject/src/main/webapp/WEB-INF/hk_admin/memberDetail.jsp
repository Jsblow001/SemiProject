<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> <%-- 전화번호 - --%>
<% String ctxPath = request.getContextPath(); %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>관리자 | 회원 상세</title>

<style>
    body {
        font-family: 'Pretendard', Arial, sans-serif;
        background-color: #f7f6f3;
        color: #333;
    }

    .container {
        width: 900px;
        margin: 60px auto;
        background-color: #fff;
        padding: 40px;
        border-radius: 4px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.06);
    }

    h3 {
        font-size: 18px;
        font-weight: 700;
        margin-bottom: 30px;
        color: #2f2b2a;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        font-size: 14px;
    }

    th {
        width: 160px;
        background: #f2f1ee;
        text-align: left;
        padding: 14px;
        border-bottom: 1px solid #ddd;
        color: #555;
    }

    td {
        padding: 14px;
        border-bottom: 1px solid #eee;
    }

    .btn-box {
        margin-top: 40px;
        text-align: center;
    }

    .btn {
        display: inline-block;
        padding: 10px 18px;
        font-size: 14px;
        border-radius: 4px;
        text-decoration: none;
        margin: 0 5px;
    }

    .btn-list {
        background: #3e3a39;
        color: #fff;
    }

    .btn-list:hover {
        background: #2f2b2a;
    }
    /* ===== 관리자 SMS 박스 ===== */
	.admin-action th {
	    vertical-align: top;
	}
	
	.sms-box {
	    background: #faf9f6;
	    border: 1px solid #ddd;
	    padding: 20px;
	    border-radius: 4px;
	}
	
	/* 공통 필드 */
	.sms-field {
	    margin-bottom: 18px;
	}
	
	.sms-field label {
	    display: block;
	    font-weight: 600;
	    font-size: 14px;
	    margin-bottom: 8px;
	    color: #2f2b2a;
	}
	
	/* 예약 발송 인라인 */
	.sms-inline {
	    display: flex;
	    align-items: center;
	    gap: 10px;
	}
	
	.sms-inline input[type="date"],
	.sms-inline input[type="time"] {
	    padding: 6px 8px;
	    font-size: 13px;
	}
	
	.sms-hint {
	    font-size: 12px;
	    color: #888;
	}
	
	/* textarea */
	#smsContent {
	    width: 100%;
	    resize: none;
	    padding: 10px;
	    font-size: 13px;
	    border: 1px solid #ccc;
	    border-radius: 3px;
	    box-sizing: border-box;
	}
	
	/* 버튼 영역 */
	.sms-btn-area {
	    display: flex;
	    align-items: center;
	    gap: 15px;
	}
	
	.sms-result {
	    font-size: 13px;
	    color: #2f6f4e;
	    display: none;
	}
	
	/* ===== 관리자 버튼 커스터마이징 ===== */
	.admin-btn {
    display: inline-block;
    padding: 10px 22px;
    background: #3e3a39;
    color: #fff;
    font-size: 14px;
    border-radius: 3px;
    cursor: pointer;
    text-decoration: none;
	}
	
	.admin-btn:hover {
	    background: #2f2b2a;
	}
	
	/* ===== 보조 버튼 (목록으로) ===== */
	a.admin-btn.light,
	a.admin-btn.light:link,
	a.admin-btn.light:visited {
	    background: #e6e4e1;
	    color: #3e3a39 !important;
	    text-decoration: none;
	}
	
	/* hover */
	a.admin-btn.light:hover {
	    background: #d8d5d1;
	    color: #2f2b2a !important;
	}	
	    
</style>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<script>
$(function(){

    $("#smsResult").hide();

    $("#btnSend").on("click", function(){

        const smsContent = $("#smsContent").val().trim();
        if(smsContent === ""){
            alert("문자 내용을 입력하세요.");
            return;
        }

        let dataObj = {
            mobile : "${member.mobile}",
            smsContent : smsContent
        };

        if($("#reservedate").val() && $("#reservetime").val()){
            const datetime =
                $("#reservedate").val().replaceAll("-", "") +
                $("#reservetime").val().replaceAll(":", "");
            dataObj.datetime = datetime;
        }

        $.ajax({
            url : "${pageContext.request.contextPath}/admin/member/smsSend.sp",
            type : "get",
            data : dataObj,
            dataType : "json",
            success : function(json){
                $("#smsResult").show().text("문자 전송 완료");
            },
            error : function(req){
                alert("문자 전송 실패");
            }
        });
    });

});
</script>



</head>

<body>

<!-- 고정 헤더 -->
<jsp:include page="../header2.jsp" />

<div class="container">

    <h3 class="font-weight-bold mb-4 text-dark">회원 상세 정보</h3>

    <table>
        <tr>
            <th>아이디</th>
            <td>${member.userid}</td>
        </tr>
        <tr>
            <th>이름</th>
            <td>${member.name}</td>
        </tr>
        <tr>
            <th>성별</th>
            <td>
                <c:choose>
                    <c:when test="${member.gender == '1'}">남</c:when>
                    <c:when test="${member.gender == '2'}">여</c:when>
                    <c:otherwise>미입력</c:otherwise>
                </c:choose>
            </td>
        </tr>
        <tr>
            <th>이메일</th>
            <td>${member.email}</td>
        </tr>
        <tr>
		    <th>전화번호</th>
		    <td>
		        <c:choose>
		            <c:when test="${empty member.mobile}">
		                미입력
		            </c:when>
		            <c:otherwise>
		                ${fn:substring(member.mobile, 0, 3)}-
		                ${fn:substring(member.mobile, 3, 7)}-
		                ${fn:substring(member.mobile, 7, 11)}
		            </c:otherwise>
		        </c:choose>
		    </td>
		</tr>
        <tr>
            <th>가입일</th>
            <td>${member.registerday}</td>
        </tr>
        <tr>
            <th>상태</th>
            <td>
                <c:choose>
                    <c:when test="${member.status == 1}">정상</c:when>
                    <c:otherwise>탈퇴</c:otherwise>
                </c:choose>
            </td>
        </tr>
    </table>

	<!-- ==== 휴대폰 SMS(문자) 보내기 ==== -->
	<table class="admin-action">
	    <tr>
	        <th>관리자 기능<br>(문자 발송)</th>
	        <td>
	
	            <div class="sms-box">
	
	                <!-- 예약 발송 -->
	                <div class="sms-field">
	                    <label>예약 발송</label>
	                    <div class="sms-inline">
	                        <input type="date" id="reservedate">
	                        <input type="time" id="reservetime">
	                        <span class="sms-hint">(미선택 시 즉시 발송)</span>
	                    </div>
	                </div>
	
	                <!-- 문자 내용 -->
	                <div class="sms-field">
	                    <label>문자 내용</label>
	                    <textarea id="smsContent" rows="4"
	                              placeholder="회원에게 보낼 문자 내용을 입력하세요."></textarea>
	                </div>
	
	                <!-- 버튼 -->
	                <div class="sms-btn-area">
	                    <button id="btnSend" class="admin-btn">문자 전송</button>
	                    <span id="smsResult" class="admin-btn"></span>
	                </div>
	
	            </div>
	
	        </td>
	    </tr>
	</table>


    <div class="btn-box">
        <a href="<%=ctxPath%>/admin/memberList.sp" class="admin-btn light">
            목록으로
        </a>
    </div>

</div>

<!-- 고정 푸터 -->
<jsp:include page="../footer2.jsp" />

</body>
</html>
