<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Q&amp;A</title>

<style>
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
    }
    .btn-write:hover{ filter:brightness(1.05); }

    /* pageBar가 <li> 기반이면 UL 스타일 필요 */
    ul.pagebar { list-style:none; padding:0; margin:26px 0; display:flex; gap:6px; justify-content:center; }
    ul.pagebar li a{ display:inline-block; padding:4px 8px; border:1px solid #ddd; font-size:12px; }
    ul.pagebar li.active a{ background:#2b2321; color:#fff; border-color:#2b2321; }
</style>
</head>

<body>
<jsp:include page="../header.jsp"/>

<div class="page-wrap">
  <div class="inner">
    <div class="page-title">Q&amp;A</div>
    <div class="title-rule"></div>

    <table class="board-table" aria-label="Q&A 목록">
      <thead>
        <tr>
          <th class="col-no">번호</th>
          <th>제목</th>
          <th class="col-writer">작성자</th>
          <th class="col-date">작성일</th>
        </tr>
      </thead>

      <tbody>
        <c:if test="${not empty qnaList}">
          <c:forEach var="qna" items="${qnaList}" varStatus="status">

            <fmt:parseNumber var="currentShowPageNo" value="${requestScope.currentShowPageNo}"/>
            <fmt:parseNumber var="sizePerPage" value="${requestScope.sizePerPage}"/>

            <tr>
              <!-- 페이징 순번 공식 -->
              <td class="col-no">
                ${requestScope.totalQnaCount - (currentShowPageNo-1)*sizePerPage - status.index}
              </td>

              <td>
                <c:set var="isSecret" value="${qna.isSecret == 1}" />
                <c:set var="isAdmin" value="${sessionScope.loginuser != null && sessionScope.loginuser.userid == 'admin'}" />
                <c:set var="loginId" value="${sessionScope.loginuser != null ? sessionScope.loginuser.userid : ''}" />

                <c:set var="canView" value="${!isSecret || isAdmin || (loginId != '' && loginId == qna.fkMemberId)}"/>

                <c:choose>
                  <c:when test="${canView}">
                    <a href="<%=request.getContextPath()%>/qnaView.sp?no=${qna.qnaId}" title="${qna.subject}">
                      <span class="title-line">
                        <c:if test="${qna.hasReply}">
                          <span class="badge-re">RE</span>
                        </c:if>
                        <c:if test="${qna.answered}">
                          <span class="badge-ans">답변완료</span>
                        </c:if>
                        <span class="title-text">${qna.subject}</span>
                        <c:if test="${isSecret}">
                          <span class="lock">🔒</span>
                        </c:if>
                      </span>
                    </a>
                  </c:when>

                  <c:otherwise>
                    <a href="<%=request.getContextPath()%>/qnaView.sp?no=${qna.qnaId}" title="비밀글입니다">
                      <span class="title-line">
                        <span class="title-text">비밀글입니다</span>
                        <span class="lock">🔒</span>
                      </span>
                    </a>
                  </c:otherwise>
                </c:choose>
              </td>

              <td class="col-writer">${qna.fkMemberId}</td>

              <td class="col-date">
                <fmt:formatDate value="${qna.regDate}" pattern="yy-MM-dd"/>
              </td>
            </tr>
          </c:forEach>
        </c:if>

        <c:if test="${empty qnaList}">
          <tr>
            <td colspan="4">데이터가 존재하지 않습니다.</td>
          </tr>
        </c:if>
      </tbody>
    </table>

    <div class="btn-row">
      <a class="btn-write" href="<%=request.getContextPath()%>/qnaWrite.sp?myUrl=/qnaList.sp">글쓰기</a>
    </div>

    <!-- ✅ pageBar 출력 -->
    <ul class="pagebar">
      ${requestScope.pageBar}
    </ul>

  </div>
</div>

<jsp:include page="../footer.jsp"/>
</body>
</html>
