<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<jsp:include page="../header.jsp" />

<% String ctxPath = request.getContextPath(); %>


<div class="container mt-5" style="max-width: 800px;">
    <h2 class="text-center mb-4">상품 등록 (Admin Only)</h2>
    
    <form action="<%= ctxPath%>/admin/productRegisterEnd.sp" 
          method="POST" enctype="multipart/form-data">
        
        <div class="card p-4 shadow-sm">
            <div class="form-group mb-3">
                <label for="category" class="font-weight-bold">카테고리</label>
                <select name="fk_category_id" class="form-control" required>
                    <option value="">-- 선택하세요 --</option>
                    <option value="1">SUNGLASSES</option>
                    <option value="2">EYEGLASSES</option>
                    <option value="3">ACCESSORY</option>
                    <option value="4">COLLABORATION</option>
                </select>
            </div>

            <div class="form-group mb-3">
                <label for="product_name" class="font-weight-bold">상품명</label>
                <input type="text" name="product_name" id="product_name" class="form-control" placeholder="상품명을 입력하세요" required>
            </div>

            <div class="row mb-3">
			    <div class="col-md-6">
			        <label for="list_price" class="font-weight-bold">정가 (List Price)</label>
			        <input type="number" name="list_price" id="list_price" class="form-control" 
			               placeholder="예: 250000" step="1000" min="0" required>
			    </div>
			    <div class="col-md-6">
			        <label for="sale_price" class="font-weight-bold">판매가 (Sale Price)</label>
			        <input type="number" name="sale_price" id="sale_price" class="form-control" 
			               placeholder="예: 219000" step="1000" min="0" required>
			    </div>
			</div>

			
			<div class="row mb-3">
			    <div class="col-md-6">
			        <label>재고량</label>
			        <input type="number" name="stock" class="form-control" value="10" required>
			    </div>
			    <div class="col-md-6">
			        <label>스펙 ID (1:NEW, 2:BEST, 3:GEN)</label>
			        <input type="number" name="fk_spec_id" class="form-control" value="1" required>
			    </div>
			</div>
			

            <div class="form-group mb-3">
                <label for="product_desc" class="font-weight-bold">상품 상세설명</label>
                <textarea name="product_desc" id="product_desc" rows="5" class="form-control" placeholder="상품에 대한 설명을 적어주세요"></textarea>
            </div>

            <div class="form-group mb-4">
                <label for="pimage" class="font-weight-bold">상품 대표 이미지</label>
                <input type="file" name="pimage" id="pimage" class="form-control-file border p-1 w-100" accept="image/*" required>
                <small class="text-muted">권장 사이즈: 500x500 px (jpg, png, gif)</small>
            </div>

            <div class="text-center mt-4">
                <button type="submit" class="btn btn-dark btn-lg px-5">상품 등록하기</button>
                <button type="reset" class="btn btn-outline-secondary btn-lg px-5">취소</button>
            </div>
        </div>
    </form>
</div>

<jsp:include page="../footer.jsp" />