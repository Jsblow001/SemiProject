<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>리뷰 작성</title>
<style>
  .wrap{max-width:900px;margin:30px auto;padding:0 16px;}
  .row{margin:14px 0;}
  .label{display:block;font-weight:700;margin-bottom:6px;}
  .input, .textarea, select{width:100%;box-sizing:border-box;padding:10px 12px;border:1px solid #ddd;border-radius:8px;}
  .textarea{min-height:220px;resize:vertical;}
  .chips{display:flex;flex-wrap:wrap;gap:10px;}
</style>
</head>
<body>

<jsp:include page="../header.jsp"/>

<div class="wrap">
  <h2>리뷰 작성</h2>

  <form method="post" action="${pageContext.request.contextPath}/reviewWrite.sp" enctype="multipart/form-data">

    <div class="row">
      <label class="label">구매 상품 선택</label>
      <select id="purchaseSelect" name="fk_product_id">
        <option value="">구매 상품 선택</option>
        <c:forEach var="p" items="${purchaseList}">
          <option value="${p.product_id}">
            ${p.product_name} (주문번호:${p.last_odrcode}, ${p.last_order_date})
          </option>
        </c:forEach>
      </select>
    </div>

    <div class="row">
      <label class="label">제목</label>
      <input type="text" class="input" id="reviewTitle" name="review_title" disabled />
    </div>

    <div class="row">
      <label class="label">내용</label>
      <textarea class="textarea" id="reviewContent" name="review_content" disabled></textarea>
    </div>

    <div class="row">
      <label class="label">평점(1~5)</label>
      <div id="ratingBox">
        <label><input type="radio" name="rating" value="5" disabled> 5</label>
        <label><input type="radio" name="rating" value="4" disabled> 4</label>
        <label><input type="radio" name="rating" value="3" disabled> 3</label>
        <label><input type="radio" name="rating" value="2" disabled> 2</label>
        <label><input type="radio" name="rating" value="1" disabled> 1</label>
      </div>
    </div>

    <div class="row">
      <label class="label">칭찬 키워드(복수 선택)</label>
      <div class="chips">
        <label><input type="checkbox" name="praise" value="배송이 빨라요" disabled> 배송이 빨라요</label>
        <label><input type="checkbox" name="praise" value="포장이 꼼꼼해요" disabled> 포장이 꼼꼼해요</label>
        <label><input type="checkbox" name="praise" value="유니크한 디테일이 있어요" disabled> 유니크한 디테일이 있어요</label>
        <label><input type="checkbox" name="praise" value="데일리로 착용하기 좋아요" disabled> 데일리로 착용하기 좋아요</label>
      </div>
    </div>

    <div class="row">
      <label class="label">사진(선택, 복수 가능)</label>
      <input type="file" id="reviewImages" name="review_images" accept="image/*" multiple disabled />
    </div>

    <div class="row">
      <button type="submit" id="btnSubmit" disabled>글작성</button>
    </div>

  </form>
</div>

<script>
  const sel = document.getElementById('purchaseSelect');
  const title = document.getElementById('reviewTitle');
  const content = document.getElementById('reviewContent');
  const ratingInputs = document.querySelectorAll('input[name="rating"]');
  const praiseInputs = document.querySelectorAll('input[name="praise"]');
  const images = document.getElementById('reviewImages');
  const btn = document.getElementById('btnSubmit');

  sel.addEventListener('change', () => {
    const ok = sel.value !== "";
    title.disabled = !ok;
    content.disabled = !ok;
    ratingInputs.forEach(x => x.disabled = !ok);
    praiseInputs.forEach(x => x.disabled = !ok);
    images.disabled = !ok;
    btn.disabled = !ok;
  });
</script>

<jsp:include page="../footer.jsp"/>
</body>
</html>
