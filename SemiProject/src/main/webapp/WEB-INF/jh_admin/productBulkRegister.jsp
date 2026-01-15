<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% String ctxPath = request.getContextPath(); %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>관리자 | 이미지 일괄등록</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style>
  body{font-family:Pretendard, Arial; background:#f7f6f3;}
  .box{width:800px; margin:80px auto; background:#fff; padding:40px; border-radius:6px;}
  .title{font-size:20px; font-weight:800; margin-bottom:20px;}
  .hint{font-size:13px; color:#666; margin-bottom:15px; line-height:1.6;}

  .row{display:flex; gap:12px; margin-bottom:12px;}
  .row > div{flex:1;}
  label{display:block; font-size:13px; font-weight:700; margin-bottom:6px; color:#333;}
  select,input[type=number]{
    width:100%; padding:12px; border:1px solid #ddd; border-radius:6px; background:#fff;
    font-size:14px;
  }

  input[type=file]{width:100%; padding:12px; border:1px dashed #bbb; border-radius:6px; background:#fafafa;}
  .btn{margin-top:20px; width:100%; padding:14px; border:none; border-radius:6px; background:#3e3a39; color:#fff; font-weight:800;}
</style>
</head>
<body>

<jsp:include page="../header2.jsp" />

<div class="box">
  <div class="title">이미지로 상품 일괄 등록</div>
  <div class="hint">
    ✅ 이미지 여러 장을 선택하면 자동으로 상품이 생성됩니다.<br>
    - 상품명 = 파일명(확장자 제외)<br>
    - 설명 = 자동 문구 생성<br>
    - 판매가 = 정가 - 20,000원(컨트롤러 정책)<br>
  </div>

  <form action="<%=ctxPath%>/admin/bulkRegisterByImagesEnd.sp"
        method="post" enctype="multipart/form-data">

    <div class="row">
      <div>
        <label>카테고리</label>
        <select name="fk_category_id" required>
          <option value="1">SUNGLASSES</option>
          <option value="2" selected>EYEGLASSES</option>
          <option value="3">ACCESSORY</option>
          <option value="4">COLLABORATION</option>
        </select>
      </div>

      <div>
        <label>정가(list price)</label>
        <input type="number" name="list_price" value="200000" step="1000" min="0" required>
      </div>
    </div>

    <label>이미지 파일 (복수 선택 가능)</label>
    <input type="file" name="pimages" multiple accept="image/*" required>

    <button class="btn" type="submit">일괄 등록하기</button>
  </form>
</div>

<jsp:include page="../footer2.jsp" />
</body>
</html>
