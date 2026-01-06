<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Q&amp;A (Admin)</title>

<style>
/* ===== 네가 준 스타일 그대로 유지 ===== */
* { box-sizing: border-box; }
body { margin: 0; font-family: Arial, "Noto Sans KR", sans-serif; color:#111; background:#fff; }
a { color: inherit; text-decoration: none; }
a:hover { text-decoration: underline; }

.page-wrap{ width:100%; padding:0 0 60px; }
.inner{ width:92%; max-width:1500px; margin:0 auto; }

.page-title{ font-size:26px; font-weight:500; letter-spacing:.3px; margin:26px 0 18px; }
.title-rule{ height:1px; background:#e9e9e9; margin-bottom:22px; }

.board-table{ width:100%; border-collapse:collapse; table-layout:fixed; font-size:13px; }
.board-table thead th{
    text-align:left; font-weight:500; color:#666;
    padding:12px 10px; border-bottom:1px solid #e9e9e9;
}
.board-table tbody td{
    padding:14px 10px; border-bottom:1px solid #efefef;
    vertical-align:middle; color:#222;
    overflow:hidden; white-space:nowrap; text-overflow:ellipsis;
}

.col-no{ width:110px; }
.col-writer{ width:180px; }
.col-date{ width:130px; }

.title-line{
    display:inline-flex; align-items:center; gap:8px;
    min-width:0; max-width:100%;
}
.badge-re{
    display:inline-flex; align-items:center; justify-content:center;
    font-size:11px; line-height:1; padding:3px 6px;
    border-radius:2px; background:#b9b9b9; color:#fff;
    flex:0 0 auto;
}
.badge-ans{
  display:inline-flex; align-items:center; justify-content:center;
  font-size:11px; line-height:1; padding:3px 6px;
  border-radius:2px; background:#2b2321; color:#fff;
  flex:0 0 auto;
}
.lock{ font-size:12px; color:#111; opacity:.9; flex:0 0 auto; }
.title-text{ min-width:0; overflow:hidden; white-space:nowrap; text-overflow:ellipsis; }

.btn-row{ display:flex; justify-content:flex-end; margin-top:10px; }
.btn-write{
    display:inline-flex; align-items:center; justify-content:center;
    width:54px; height:34px; font-size:12px;
    border:1px solid #2b2321; background:#2b2321; color:#fff; cursor:pointer;
    text-decoration:none;
}
.btn-write:hover{ filter:brightness(1.05); }

.search-area{ display:flex; align-items:center; gap:8px; margin-top:18px; }
.search-area select, .search-area input{
    height:30px; border:1px solid #d9d9d9; padding:0 8px; font-size:12px; outline:none; background:#fff;
}
.search-area input[type="text"]{ width:240px; }
.btn-search{
    height:30px; padding:0 16px;
    border:1px solid #2b2321; background:#2b2321; color:#fff; font-size:12px; cursor:pointer;
}
.btn-search:hover{ filter:brightness(1.05); }

/* pageBar(bootstrap li) 대응 */
.pagination { list-style:none; padding:0; margin:26px 0; display:flex; gap:6px; justify-content:center; }
.page-item { }
.page-link { color:#777; font-size:12px; padding:4px 7px; border:1px solid #e9e9e9; }
.page-item.active .page-link { color:#111; font-weight:700; border-color:#111; }

@media (max-width: 900px){
    .col-writer{ width:120px; }
    .col-date{ width:92px; }
    .col-no{ width:80px; }
    .btn-write{ width:64px; }
    .search-area{ flex-wrap:wrap; }
    .search-area input[type="text"]{ width:100%; max-width:360px; }
}
</style>
</head>

<body>
<jsp:include page="../../header2.jsp"/>

<div class="page-wrap">
  <div class="inner">
    <div class="page-title">Q&amp;A (Admin)</div>
    <div class="title-rule"></div>

    <!-- ✅ 검색 + 페이지당 개수 (찾기 눌렀을 때만 submit) -->
<form name="qna_search_frm" class="search-area" method="get"
      action="<%=request.getContextPath()%>/adminQnaList.sp">

  <select name="searchType">
    <option value="">검색대상</option>
    <option value="writer">아이디</option>
    <option value="subject_content">검색어</option> <!-- 제목+내용 -->
  </select>

  <input type="text" name="keyword" placeholder="검색어 입력"
         value="${requestScope.keyword}" />

  <select name="sizePerPage">
    <option value="10">10개</option>
    <option value="5">5개</option>
    <option value="3">3개</option>
  </select>

  <!-- 페이지바 눌러서 들어올 수도 있으니 유지 -->
  <input type="hidden" name="currentShowPageNo" value="${requestScope.currentShowPageNo}" />

  <button type="button" class="btn-search" onclick="goSearch()">찾기</button>
</form>

<script>
(function(){

  // 1) 기존 선택값 유지
  var st = "${requestScope.searchType}";
  if(st){
    var stSel = document.querySelector('select[name="searchType"]');
    if(stSel) stSel.value = st;
  }

  var sp = "${requestScope.sizePerPage}";
  if(sp){
    var spSel = document.querySelector('select[name="sizePerPage"]');
    if(spSel) spSel.value = sp;
  }

  // 2) 엔터키로 검색되게
  var kw = document.querySelector('input[name="keyword"]');
  if(kw){
    kw.addEventListener("keydown", function(e){
      if(e.key === "Enter"){
        e.preventDefault();
        goSearch();
      }
    });
  }
  
  <!-- ✅ sizePerPage 선택값 유지 + sizePerPage 변경 시 자동 submit -->
//서버가 내려준 값 우선, 없으면 param
  var sp = "${empty requestScope.sizePerPage ? param.sizePerPage : requestScope.sizePerPage}";
  if(sp){
    var sel = document.querySelector('select[name="sizePerPage"]');
    if(sel) sel.value = sp;
  }

  var sel2 = document.querySelector('select[name="sizePerPage"]');
  if(sel2){
    sel2.addEventListener("change", function(){
      // size 바꿀 때도 1페이지로
      var frm = document.forms["qna_search_frm"];
      if(frm){
        frm.currentShowPageNo.value = "1";
        frm.submit();
      }
    });
  }

})();

function goSearch(){
  var frm = document.qna_search_frm;
  var searchType = frm.searchType.value;
  var keyword = frm.keyword.value.trim();

  // ✅ 검색어가 있는데 검색대상이 없으면 막기(원하면 제거 가능)
  if(keyword !== "" && searchType === ""){
    alert("검색대상을 선택하세요.");
    frm.searchType.focus();
    return;
  }

  // ✅ 찾기 누르면 1페이지부터
  frm.currentShowPageNo.value = "1";
  frm.submit();
}
</script>


    <table class="board-table" aria-label="Q&A 목록(관리자)">
      <thead>
        <tr>
          <th class="col-no">번호</th>
          <th>제목</th>
          <th class="col-writer">작성자</th>
          <th class="col-date">작성일</th>
        </tr>
      </thead>

      <tbody>
        <c:if test="${not empty requestScope.qnaList}">
          <c:forEach var="qna" items="${requestScope.qnaList}" varStatus="status">

            <fmt:parseNumber var="currentShowPageNo" value="${requestScope.currentShowPageNo}"/>
            <fmt:parseNumber var="sizePerPage" value="${requestScope.sizePerPage}"/>

            <tr>
              <td class="col-no">
                ${requestScope.totalQnaCount - (currentShowPageNo-1)*sizePerPage - status.index}
              </td>

              <td>
                <!-- 상세로 이동 시 list 파라미터 유지(선택) -->
                <a href="${pageContext.request.contextPath}/qnaView.sp?no=${qna.qnaId}"
                   title="${qna.subject}">

                  <span class="title-line">
                    <c:if test="${qna.hasReply}"><span class="badge-re">RE</span></c:if>
                    <c:if test="${qna.answered}"><span class="badge-ans">답변완료</span></c:if>

                    <span class="title-text">
                      <c:out value="${qna.subject}"/>
                    </span>

                    <c:if test="${qna.isSecret == 1}"><span class="lock">🔒</span></c:if>
                  </span>
                </a>
              </td>

              <td class="col-writer"><c:out value="${qna.fkMemberId}"/></td>
              <td class="col-date"><fmt:formatDate value="${qna.regDate}" pattern="yy-MM-dd"/></td>
            </tr>

          </c:forEach>
        </c:if>

        <c:if test="${empty requestScope.qnaList}">
          <tr>
            <td colspan="4">데이터가 존재하지 않습니다.</td>
          </tr>
        </c:if>
      </tbody>
    </table>

    <div class="btn-row">
      <a class="btn-write" href="${pageContext.request.contextPath}/qnaWrite.sp">글쓰기</a>
    </div>

    <!-- ✅ 컨트롤러가 만들어준 pageBar 출력 (pageBar는 <li class='page-item'>... 형태여야 함) -->
    <ul class="pagination">
      ${requestScope.pageBar}
    </ul>

  </div>
</div>

<jsp:include page="../../footer2.jsp"/>
</body>
</html>
