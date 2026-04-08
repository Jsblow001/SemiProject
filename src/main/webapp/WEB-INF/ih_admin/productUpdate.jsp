<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String ctxPath = request.getContextPath(); %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>관리자 | 상품수정</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

<style>
    body {
        font-family: 'Pretendard', Arial, sans-serif;
        background-color: #f7f6f3;
        color: #333;
    }
    
    .container-custom {
        width: 800px;
        margin: 60px auto;
        background-color: #fff;
        padding: 50px 60px;
        border-radius: 4px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.06);
    }

    /* ===== 상단 타이틀 ===== */
    .admin-title {
        font-size: 22px;
        font-weight: 700;
        letter-spacing: -0.5px;
        color: #2f2b2a;
        margin-bottom: 40px;
        text-align: center;
    }

    /* ===== 폼 라벨 및 입력창 ===== */
    .form-group {
        margin-bottom: 25px;
    }

    .form-label {
        display: block;
        font-size: 14px;
        font-weight: 700;
        color: #555;
        margin-bottom: 8px;
    }

    .form-control-custom {
        width: 100%;
        padding: 12px 15px;
        border: 1px solid #ddd;
        border-radius: 3px;
        font-size: 14px;
        transition: all 0.2s ease;
        box-sizing: border-box;
    }

    .form-control-custom:focus {
        outline: none;
        border-color: #6d4c41;
        box-shadow: 0 0 5px rgba(109, 76, 65, 0.1);
    }

    .form-row {
        display: flex;
        gap: 20px;
        margin-bottom: 25px;
    }
    
    .form-row > div {
        flex: 1;
    }

    /* ===== 이미지 미리보기 영역 ===== */
    .current-img-box {
        display: flex;
        align-items: center;
        gap: 20px;
        padding: 15px;
        background: #faf9f7;
        border-radius: 4px;
        margin-bottom: 15px;
        border: 1px solid #eee;
    }

    .current-img-box img {
        width: 80px;
        height: 80px;
        object-fit: cover;
        border-radius: 4px;
        border: 1px solid #ddd;
    }

    .file-input-wrapper {
        border: 1px dashed #ccc;
        padding: 20px;
        text-align: center;
        border-radius: 4px;
        background: #fff;
    }

    /* ===== 버튼 영역 ===== */
    .btn-area {
        display: flex;
        justify-content: center;
        gap: 12px;
        margin-top: 40px;
        padding-top: 30px;
        border-top: 1px solid #eee;
    }

    .btn-submit {
        padding: 14px 50px;
        background-color: #3e3a39;
        color: #fff;
        border: none;
        border-radius: 3px;
        font-size: 15px;
        font-weight: 700;
        cursor: pointer;
        transition: background-color 0.2s;
    }

    .btn-submit:hover {
        background-color: #2f2b2a;
    }

    .btn-reset {
        padding: 14px 50px;
        background-color: #fff;
        color: #666;
        border: 1px solid #ddd;
        border-radius: 3px;
        font-size: 15px;
        font-weight: 600;
        cursor: pointer;
    }

    textarea.form-control-custom {
        resize: none;
    }
</style>
</head>
<body>

<jsp:include page="../header2.jsp" />

<div class="container-custom">
    <h3 class="admin-title">상품 정보 수정</h3>
    
    <form action="${pageContext.request.contextPath}/admin/productUpdateEnd.sp" 
          method="POST" enctype="multipart/form-data">
        
        <input type="hidden" name="product_id" value="${pdto.product_id}">
        <input type="hidden" name="old_pimage" value="${pdto.pimage}">

        <div class="form-group">
            <label class="form-label">카테고리</label>
            <select name="fk_category_id" class="form-control-custom" required>
                <option value="1" ${pdto.fk_category_id == 1 ? 'selected' : ''}>SUNGLASSES</option>
                <option value="2" ${pdto.fk_category_id == 2 ? 'selected' : ''}>EYEGLASSES</option>
                <option value="3" ${pdto.fk_category_id == 3 ? 'selected' : ''}>ACCESSORY</option>
                <option value="4" ${pdto.fk_category_id == 4 ? 'selected' : ''}>COLLABORATION</option>
            </select>
        </div>

        <div class="form-group">
            <label class="form-label">상품명</label>
            <input type="text" name="product_name" class="form-control-custom" value="${pdto.product_name}" required>
        </div>

        <div class="form-row">
            <div>
                <label class="form-label">판매가 (Sale Price)</label>
                <input type="number" name="sale_price" class="form-control-custom" value="${pdto.sale_price}" required>
            </div>
            <div>
                <label class="form-label">재고량</label>
                <input type="number" name="stock" class="form-control-custom" value="${pdto.stock}" required>
            </div>
        </div>

        <div class="form-group">
            <label class="form-label">상품 상세설명</label>
            <textarea name="product_description" class="form-control-custom" rows="6" required>${pdto.product_description}</textarea>
        </div>

        <div class="form-group">
            <label class="form-label">상품 이미지</label>
            
            <div class="current-img-box">
                <img src="${pageContext.request.contextPath}/img/${pdto.pimage}" alt="현재이미지">
                <div>
                    <div style="font-size: 13px; color: #666; font-weight: 600;">현재 등록된 파일</div>
                    <div style="font-size: 12px; color: #999;">${pdto.pimage}</div>
                </div>
            </div>

            <div class="file-input-wrapper">
                <input type="file" name="pimage" style="width: 100%; font-size: 14px;" accept="image/*">
                <div style="font-size: 12px; color: #6d4c41; margin-top: 8px; font-weight: 600;">
                    <i class="fas fa-info-circle"></i> 이미지를 변경할 경우에만 새로운 파일을 선택하세요.
                </div>
            </div>
        </div>

        <div class="btn-area">
            <button type="submit" class="btn-submit">수정하기</button>
            <button type="button" class="btn-reset" onclick="history.back()">취소</button>
        </div>
    </form>
</div>

<jsp:include page="../footer2.jsp" />

</body>
</html>