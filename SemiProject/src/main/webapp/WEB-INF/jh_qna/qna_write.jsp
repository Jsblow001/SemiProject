<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>QnA 글쓰기</title>
<style>
  .wrap{max-width:900px;margin:30px auto;padding:0 16px;}
  .row{margin:14px 0;}
  label{display:block;font-weight:700;margin-bottom:6px;}
  input[type=text], textarea{width:100%;box-sizing:border-box;padding:10px 12px;border:1px solid #ddd;border-radius:8px;}
  textarea{min-height:220px;resize:vertical;}
  .inline{display:flex;gap:12px;align-items:center;flex-wrap:wrap;}
  .badge{padding:6px 10px;border-radius:999px;background:#f5f5f5;}
  .help{font-size:13px;color:#666;margin-top:6px;}
  .btns{display:flex;justify-content:flex-end;gap:10px;margin-top:18px;}
  .btn{border:0;border-radius:10px;padding:10px 14px;cursor:pointer;}
  .btn.primary{background:#111;color:#fff;}
  .btn.ghost{background:#eee;}
</style>
</head>
<body>
<jsp:include page="../header.jsp"/>
<div class="wrap">
  <h2>QnA 글쓰기</h2>

  <form id="frm"
        method="post"
        action="<%=request.getContextPath()%>/qnaWrite.sp"
        enctype="multipart/form-data">

    <div class="row">
      <label>제목</label>
      <input type="text" name="subject" id="subject" placeholder="제목을 입력하세요">
    </div>

    <div class="row">
      <label>내용</label>
      <textarea name="content" id="content" placeholder="문의 내용을 입력하세요"></textarea>
    </div>

    <div class="row">
      <label>비밀글</label>
      <div class="inline">
        <span class="badge">
          <input type="checkbox" name="isSecret" id="isSecret" value="1">
          <label for="isSecret" style="display:inline;margin:0;font-weight:600;">비밀글</label>
        </span>
      </div>
      <div class="help">체크 안 하면 공개글(0)로 저장됩니다.</div>
    </div>

    <div class="row">
      <label>첨부파일(선택)</label>
      <input type="file" name="files" multiple>
      <div class="help">첨부가 없어도 글 등록 가능합니다.</div>
    </div>
    
	<input type="hidden" name="myUrl" value="${myUrl}">
	
    <div class="btns">
      <button type="button" class="btn ghost" onclick="history.back()">취소</button>
      <button type="submit" class="btn primary">등록</button>
    </div>
  </form>
</div>

<script>
  document.getElementById('frm').addEventListener('submit', (e) => {
    const subject = document.getElementById('subject').value.trim();
    const content = document.getElementById('content').value.trim();
    if(!subject || !content){
      alert("제목/내용은 필수입니다.");
      e.preventDefault();
    }
  });
</script>
<jsp:include page="../footer.jsp"/>
</body>
</html>
