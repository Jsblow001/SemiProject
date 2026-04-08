<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String ctxPath = request.getContextPath(); %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>관리자 | 상품등록</title>
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
        border-color: #6d4c41; /* 강조색 */
        box-shadow: 0 0 5px rgba(109, 76, 65, 0.1);
    }

    /* 가로 배치용 로우 */
    .form-row {
        display: flex;
        gap: 20px;
        margin-bottom: 25px;
    }
    
    .form-row > div {
        flex: 1;
    }

    /* 파일 입력 커스텀 */
    .file-input-wrapper {
        border: 1px dashed #ccc;
        padding: 20px;
        text-align: center;
        border-radius: 4px;
        background: #fafafa;
    }

    .file-info {
        font-size: 12px;
        color: #999;
        margin-top: 8px;
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

    .btn-reset:hover {
        background-color: #f9f9f9;
        color: #333;
    }

    textarea.form-control-custom {
        resize: none;
    }
</style>
</head>
<body>

<jsp:include page="../header2.jsp" />

<div class="container-custom">
    <h3 class="admin-title">상품 등록</h3>
    
    <form action="<%= ctxPath%>/admin/productRegisterEnd.sp" 
          method="POST" enctype="multipart/form-data">
        
        <div class="form-group">
            <label class="form-label">카테고리</label>
            <select name="fk_category_id" class="form-control-custom" required>
                <option value="">-- 카테고리를 선택하세요 --</option>
                <option value="1">SUNGLASSES</option>
                <option value="2">EYEGLASSES</option>
                <option value="3">ACCESSORY</option>
                <option value="4">COLLABORATION</option>
            </select>
        </div>

        <div class="form-group">
            <label class="form-label">상품명</label>
            <input type="text" name="product_name" class="form-control-custom" placeholder="상품명을 입력하세요" required>
        </div>

        <div class="form-row">
            <div>
                <label class="form-label">정가 (List Price)</label>
                <input type="number" name="list_price" class="form-control-custom" placeholder="예: 250000" step="1000" min="0" required>
            </div>
            <div>
                <label class="form-label">판매가 (Sale Price)</label>
                <input type="number" name="sale_price" class="form-control-custom" placeholder="예: 219000" step="1000" min="0" required>
            </div>
        </div>

        <div class="form-row">
            <div>
                <label class="form-label">초기 재고량</label>
                <input type="number" name="stock" class="form-control-custom" value="10" required>
            </div>
            <div>
                <label class="form-label">스펙 ID (1:NEW, 2:BEST, 3:HIT)</label>
                <input type="number" name="fk_spec_id" class="form-control-custom" value="1" required>
            </div>
        </div>

        <div class="form-group">
            <label class="form-label">상품 상세설명</label>
            <textarea name="product_desc" rows="6" class="form-control-custom" placeholder="상품에 대한 상세 정보를 입력하세요"></textarea>
        </div>

        <div class="form-group">
            <label class="form-label">상품 대표 이미지</label>
            <div class="file-input-wrapper">
                <input type="file" name="pimage" id="pimage" style="width: 100%; font-size: 14px;" accept="image/*" required>
                <div class="file-info">권장 사이즈: 500x500 px (jpg, png, gif)</div>
            </div>
        </div>

        <div class="btn-area">
            <button type="submit" class="btn-submit">상품 등록하기</button>
            <button type="reset" class="btn-reset" onclick="history.back();">취소</button>
        </div>
    </form>
</div>

<jsp:include page="../footer2.jsp" />

</body>
</html>