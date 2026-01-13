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

  /* 기존 첨부 표시 */
  .att-list{display:flex;flex-direction:column;gap:12px;}
  .att-item{display:flex;gap:12px;align-items:flex-start;border:1px solid #eee;border-radius:10px;padding:10px;}
  .att-thumb{width:120px;height:90px;object-fit:cover;border-radius:8px;background:#fafafa;border:1px solid #eee;}
  .att-meta{flex:1;min-width:0;}
  .att-name{font-weight:700;word-break:break-all;}
  .att-actions{display:flex;gap:14px;align-items:center;flex-wrap:wrap;margin-top:6px;}
  .att-actions label{display:flex;gap:6px;align-items:center;}
  .att-replace{margin-top:6px;}
  .att-small{font-size:12px;color:#666;}
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

    <!-- ✅ 기존 첨부(삭제/교체) -->
    <div class="qna-row">
      <label class="qna-label">기존 첨부파일</label>

      <c:choose>
        <c:when test="${empty fileList}">
          <div class="qna-help">기존 첨부파일이 없습니다.</div>
        </c:when>

        <c:otherwise>
          <div class="att-list">
            <c:forEach var="f" items="${fileList}">
              <div class="att-item">
                <img class="att-thumb"
                     src="${pageContext.request.contextPath}/images/qna/${f.saveFilename}"
                     onerror="this.style.display='none';" />

                <div class="att-meta">
                  <div class="att-name">${f.orgFilename}</div>
                  <div class="att-small">저장명: ${f.saveFilename}</div>

                  <div class="att-actions">
                    <!-- ✅ 삭제 체크박스 (value는 QNA_FILE_ID) -->
                    <label>
                      <input type="checkbox" name="delFileId" value="${f.qnaFileId}">
                      이 첨부 삭제
                    </label>
                  </div>

                  <!-- ✅ 교체 업로드: name="files_{QNA_FILE_ID}" -->
                  <div class="att-replace">
                    <div class="att-small">교체할 파일 선택(선택)</div>
                    <input type="file" name="files_${f.qnaFileId}">
                  </div>
                </div>
              </div>
            </c:forEach>
          </div>

          <div class="qna-help">
            삭제 체크 후 수정완료하면 해당 첨부가 삭제됩니다. 교체 파일을 선택하면 해당 첨부가 새 파일로 바뀝니다.
          </div>
        </c:otherwise>
      </c:choose>
    </div>

    <!-- ✅ 새 첨부 추가 -->
    <div class="qna-row">
      <label class="qna-label">첨부파일(추가 업로드)</label>
      <input type="file" name="files" multiple>
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
