<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>QnA 글수정</title>
<style>
  .qna-wrap{max-width:900px;margin:30px auto;padding:0 16px;}
  .qna-row{margin:14px 0;}
  .qna-label{display:block;font-weight:700;margin-bottom:6px;}
  .qna-input, .qna-textarea{width:100%;box-sizing:border-box;padding:10px 12px;border:1px solid #ddd;border-radius:8px;}
  .qna-textarea{min-height:220px;resize:vertical;}
  .qna-inline{display:flex;gap:12px;align-items:center;flex-wrap:wrap;}
  .qna-badge{padding:6px 10px;border-radius:999px;background:#f5f5f5;}
  .qna-help{font-size:13px;color:#666;margin-top:6px;}

  .qna-btns{display:flex;justify-content:space-between;gap:10px;margin-top:18px;align-items:center;}
  .qna-btn-right{display:flex;gap:10px;justify-content:flex-end;}
  .qna-btn{border:0;border-radius:10px;padding:10px 14px;cursor:pointer;}
  .qna-btn.primary{background:#111;color:#fff;}
  .qna-btn.ghost{background:#eee;}
  .qna-btn.danger{background:#d9534f;color:#fff;}
</style>
</head>
<body>
<jsp:include page="../header.jsp"/>

<div class="qna-wrap">
  <h2>QnA 글수정</h2>

  <form id="editFrm"
        method="post"
        action="<%=request.getContextPath()%>/qnaEditEnd.sp"
        enctype="multipart/form-data">

    
    <!-- 글번호 -->
	<input type="hidden" name="qnaId" value="${qnaId}" />
	
	<div class="qna-row">
	  <label class="qna-label">제목</label>
	  <input type="text" name="subject" id="subject" class="qna-input"
	         placeholder="제목을 입력하세요"
	         value="${qdto.subject}">
	</div>


    <div class="qna-row">
      <label class="qna-label">내용</label>
      <textarea name="content" id="content" class="qna-textarea"
                placeholder="문의 내용을 입력하세요"><c:out value="${qdto.content}"/></textarea>
    </div>

    <div class="qna-row">
      <label class="qna-label">비밀글</label>
      <div class="qna-inline">
        <span class="qna-badge">
          <input type="checkbox" name="isSecret" id="isSecret" value="1"
                 <c:if test="${qdto.isSecret == 1}">checked</c:if> >
          <label for="isSecret" style="display:inline;margin:0;font-weight:600;">비밀글</label>
        </span>
      </div>
      <div class="qna-help">체크 안 하면 공개글(0)로 저장됩니다.</div>
    </div>

    <div class="qna-row">
      <label class="qna-label">첨부파일(추가 업로드)</label>
      <input type="file" name="files" multiple>
      <div class="qna-help">기존 첨부 목록/삭제는 다음 단계에서 확장 가능.</div>
    </div>

    <div class="qna-btns">
      <button type="button" class="qna-btn danger" onclick="goDelete()">삭제</button>

      <div class="qna-btn-right">
        <button type="button" class="qna-btn ghost" onclick="self.close()">취소</button>
        <button type="submit" class="qna-btn primary">수정완료</button>
      </div>
    </div>
  </form>

  <!-- 삭제 폼 -->
  <form id="delFrm" method="post" action="<%=request.getContextPath()%>/qnaDelete.sp">
	  <input type="hidden" name="qnaId" value="${qnaId}" />
  </form>

</div>

<script>
  document.getElementById('editFrm').addEventListener('submit', (e) => {
    const subject = document.getElementById('subject').value.trim();
    const content = document.getElementById('content').value.trim();
    if(!subject || !content){
      alert("제목/내용은 필수입니다.");
      e.preventDefault();
    }
  });

  function goDelete(){
    if(confirm("정말 삭제할까요? 삭제하면 복구할 수 없습니다.")){
      document.getElementById('delFrm').submit();
    }
  }
</script>

<jsp:include page="../footer.jsp"/>
</body>
</html>
