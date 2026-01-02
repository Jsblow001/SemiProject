<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="../header.jsp" />

<div class="container mt-5" style="max-width: 800px;">
    <h2 class="text-center mb-4 font-weight-bold">상품 정보 수정</h2>
    
    <form action="${pageContext.request.contextPath}/admin/productUpdateEnd.sp" 
          method="POST" enctype="multipart/form-data">
        
        <input type="hidden" name="product_id" value="${pdto.product_id}">
        <input type="hidden" name="old_pimage" value="${pdto.pimage}">

        <div class="card p-4 shadow-sm border-0">
            <div class="form-group mb-3">
                <label class="font-weight-bold">카테고리</label>
                <select name="fk_category_id" class="form-control" required>
                    <option value="1" ${pdto.fk_category_id == 1 ? 'selected' : ''}>SUNGLASSES</option>
                    <option value="2" ${pdto.fk_category_id == 2 ? 'selected' : ''}>EYEGLASSES</option>
                    <option value="3" ${pdto.fk_category_id == 3 ? 'selected' : ''}>ACCESSORY</option>
                    <option value="4" ${pdto.fk_category_id == 4 ? 'selected' : ''}>COLLABORATION</option>
                </select>
            </div>

            <div class="form-group mb-3">
                <label class="font-weight-bold">상품명</label>
                <input type="text" name="product_name" class="form-control" value="${pdto.product_name}" required>
            </div>

            <div class="row mb-3">
                <div class="col-md-6">
                    <label class="font-weight-bold">판매가 (Sale Price)</label>
                    <input type="number" name="sale_price" class="form-control" value="${pdto.sale_price}" required>
                </div>
                <div class="col-md-6">
                    <label class="font-weight-bold">재고량</label>
                    <input type="number" name="stock" class="form-control" value="${pdto.stock}" required>
                </div>
				<div class="form-group mb-3">
				    <label class="font-weight-bold">상품 설명</label>
				    <textarea name="product_description" class="form-control" rows="5" required>${pdto.product_description}</textarea>
				</div>
            </div>

            <div class="form-group mb-4">
                <label class="font-weight-bold">상품 이미지</label>
                <div class="mb-2">
                    <small class="text-muted">현재 파일: ${pdto.pimage}</small><br>
                    <img src="${pageContext.request.contextPath}/img/${pdto.pimage}" width="100" class="img-thumbnail">
                </div>
                <input type="file" name="pimage" class="form-control-file border p-1 w-100">
                <small class="text-info">* 이미지를 변경할 경우에만 파일을 선택하세요.</small>
            </div>

            <div class="text-center mt-4">
                <button type="submit" class="btn btn-dark btn-lg px-5">수정</button>
                <button type="button" class="btn btn-outline-secondary btn-lg px-5" onclick="history.back()">취소</button>
            </div>
        </div>
    </form>
</div>

<jsp:include page="../footer.jsp" />