<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% String ctxPath = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>관리자 | 벌크등록 일괄삭제</title>
<style>
  body{font-family:Pretendard, Arial; background:#f7f6f3;}
  .box{width:650px; margin:90px auto; background:#fff; padding:40px; border-radius:6px;}
  .title{font-size:20px; font-weight:800; margin-bottom:12px;}
  .desc{font-size:13px; color:#666; line-height:1.6; margin-bottom:18px;}
  .btn{width:100%; padding:14px; border:none; border-radius:6px; cursor:pointer; font-weight:800;}
  .btn-danger{background:#d9534f; color:#fff;}
</style>
</head>
<body>

<jsp:include page="../header2.jsp" />

<div class="box">
  <div class="title">벌크 등록 상품 전체 삭제</div>
  <div class="desc">
    ✅ BULK_ 로 시작하는 이미지명을 가진 상품을 전부 삭제합니다.<br/>
    ✅ 운영폴더 / 개발폴더 이미지도 같이 삭제됩니다.<br/>
    ⚠ 주문/장바구니 등 참조 중인 상품은 삭제 실패할 수 있습니다.
  </div>

  <form method="post" action="<%=ctxPath%>/admin/bulkDeleteAllEnd.sp"
        onsubmit="return confirm('정말 벌크등록 상품을 모두 삭제할까요? 되돌릴 수 없습니다.');">
    <button type="submit" class="btn btn-danger">벌크등록 전체삭제 실행</button>
  </form>
</div>

<jsp:include page="../footer2.jsp" />
</body>
</html>
