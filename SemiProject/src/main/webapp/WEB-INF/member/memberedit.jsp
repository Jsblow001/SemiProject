<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String ctxPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>CARIN | MODIFY INFO</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%=ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css">
    
    <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

    <style>
        body {
            font-family: 'Poppins', 'Pretendard', sans-serif !important;
            background-color: #FBFAF8 !important;
        }
        
        .edit-container {
            max-width: 600px;
            margin: 150px auto 100px auto; /* 헤더 높이 고려 */
            background: #fff;
            padding: 50px 40px;
            border: 1px solid #eee;
        }

        .edit-title {
            font-size: 24px;
            font-weight: 500;
            letter-spacing: 2px;
            text-align: center;
            margin-bottom: 40px;
            color: #333;
        }

        .form-label {
            font-size: 13px;
            font-weight: 600;
            color: #555;
            margin-bottom: 8px;
            display: block;
        }

        .form-control {
            border-radius: 0 !important;
            border: 1px solid #e1e1e1 !important;
            padding: 12px 15px !important;
            font-size: 14px !important;
            margin-bottom: 20px;
        }

        .form-control:focus {
            border-color: #5D4037 !important;
            box-shadow: none !important;
        }

        .btn-post {
            background-color: #333 !important;
            color: #fff !important;
            border-radius: 0 !important;
            font-size: 12px;
            padding: 10px 20px;
        }

        .btn-edit-submit {
            background-color: #5D4037 !important;
            color: #fff !important;
            border: none !important;
            border-radius: 0 !important;
            padding: 15px !important;
            font-weight: 500;
            letter-spacing: 1px;
            margin-top: 20px;
        }

        .btn-cancel {
            background-color: #fff !important;
            color: #888 !important;
            border: 1px solid #ddd !important;
            border-radius: 0 !important;
            padding: 15px !important;
            font-weight: 500;
            margin-top: 10px;
        }

        .readonly-input {
            background-color: #f9f9f9 !important;
            color: #999;
        }
    </style>
</head>
<body>

    <jsp:include page="/header.jsp" />

    <div class="container">
        <div class="edit-container shadow-sm">
            <h2 class="edit-title">MODIFY INFO</h2>

            <form name="editFrm" method="POST" action="<%= ctxPath %>/member/memberEditEnd.sp">
                
                <label class="form-label">ID</label>
                <input type="text" name="member_id" class="form-control readonly-input" value="${sessionScope.loginuser.member_id}" readonly>

                <label class="form-label">NAME</label>
                <input type="text" name="name" id="name" class="form-control" value="${sessionScope.loginuser.name}" required>

                <label class="form-label">PASSWORD</label>
                <input type="password" name="passwd" id="passwd" class="form-control" placeholder="현재 비밀번호를 입력해주세요" required>

                <label class="form-label">EMAIL</label>
                <input type="email" name="email" id="email" class="form-control" value="${sessionScope.loginuser.email}" required>

                <label class="form-label">MOBILE</label>
                <input type="text" name="mobile" id="mobile" class="form-control" value="${sessionScope.loginuser.mobile}" placeholder="01012345678">

                <label class="form-label">ADDRESS</label>
                <div class="input-group mb-2">
                    <input type="text" name="postcode" id="postcode" class="form-control mb-0 readonly-input" value="${sessionScope.loginuser.postcode}" readonly>
                    <div class="input-group-append">
                        <button class="btn btn-post" type="button" onclick="openPostcode()">POSTAL CODE</button>
                    </div>
                </div>
                <input type="text" name="address" id="address" class="form-control readonly-input" value="${sessionScope.loginuser.address}" readonly>
                <input type="text" name="detailaddress" id="detailaddress" class="form-control" value="${sessionScope.loginuser.detailaddress}" placeholder="상세주소를 입력하세요">

                <div class="d-flex flex-column">
                    <button type="button" class="btn btn-edit-submit" onclick="goEdit()">SAVE CHANGES</button>
                    <button type="button" class="btn btn-cancel" onclick="javascript:history.back()">CANCEL</button>
                </div>
            </form>
        </div>
    </div>

    <jsp:include page="/footer.jsp" />

    <script>
        // 주소 검색 함수
        function openPostcode() {
            new daum.Postcode({
                oncomplete: function(data) {
                    document.getElementById('postcode').value = data.zonecode;
                    document.getElementById('address').value = data.address;
                    document.getElementById('detailaddress').focus();
                }
            }).open();
        }

        // 수정 버튼 클릭 시
        function goEdit() {
            const name = document.getElementById("name").value.trim();
            const passwd = document.getElementById("passwd").value.trim();
            
            if(name == "") {
                alert("성명을 입력하세요.");
                return;
            }
            if(passwd == "") {
                alert("정보 수정을 위해 현재 비밀번호를 입력하세요.");
                return;
            }

            // 서브밋
            const frm = document.editFrm;
            frm.submit();
        }
    </script>
</body>
</html>