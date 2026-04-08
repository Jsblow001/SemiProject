<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../header.jsp"/>

<style>
    /* 기존 Q&A 디자인 스타일 유지 및 마이페이지 최적화 */
    * { box-sizing: border-box; }
    body { margin: 0; font-family: Arial, "Noto Sans KR", sans-serif; color:#111; background:#fff; }
    a { color: inherit; text-decoration: none; }
    a:hover { text-decoration: underline; }

    .page-wrap{ width:100%; padding:0 0 60px; }
    .inner{ width:92%; max-width:1200px; margin:0 auto; } /* 마이페이지는 조금 더 좁게 설정해도 예쁩니다 */

    .page-title{ font-size:26px; font-weight:500; letter-spacing:.3px; margin:26px 0 18px; }
    .title-rule{ height:1px; background:#e9e9e9; margin-bottom:22px; }

    .board-table{ width:100%; border-collapse:collapse; table-layout:fixed; font-size:13px; }
    .board-table thead th{
        text-align:center; font-weight:500; color:#666;
        padding:12px 10px; border-bottom:1px solid #e9e9e9;
    }
    .board-table tbody td{
        padding:16px 10px; border-bottom:1px solid #efefef;
        vertical-align:middle; color:#222; text-align:center;
    }

    /* 마이페이지 전용 컬럼 너비 설정 */
    .col-no{ width:80px; }
    .col-status{ width:120px; }
    .col-date{ width:130px; }
    .title-td { text-align: left !important; overflow:hidden; white-space:nowrap; text-overflow:ellipsis; }

    .title-line{
        display:inline-flex; align-items:center; gap:8px;
        min-width:0; max-width:100%;
    }
    
    /* 상태 배지 스타일 */
    .badge-re{
        display:inline-flex; align-items:center; justify-content:center;
        font-size:11px; line-height:1; padding:4px 8px;
        border-radius:2px; background:#f4f4f4; color:#888; border: 1px solid #ddd;
    }
    .badge-ans{
        display:inline-flex; align-items:center; justify-content:center;
        font-size:11px; line-height:1; padding:4px 8px;
        border-radius:2px; background:#2b2321; color:#fff;
    }
    
    .lock{ font-size:12px; color:#111; opacity:.6; margin-left:5px; }

    .btn-row{ display:flex; justify-content:flex-end; margin-top:20px; }
    .btn-write{
        display:inline-flex; align-items:center; justify-content:center;
        padding: 0 20px; height:40px; font-size:13px;
        border:1px solid #2b2321; background:#2b2321; color:#fff; cursor:pointer;
        transition: all 0.2s;
    }
    .btn-write:hover{ background:#fff; color:#2b2321; text-decoration: none; }

    /* 페이징 스타일 */
    ul.pagebar { list-style:none; padding:0; margin:30px 0; display:flex; gap:6px; justify-content:center; }
    ul.pagebar li a{ display:inline-block; padding:6px 10px; border:1px solid #eee; font-size:12px; color:#777; }
    ul.pagebar li.active a{ background:#2b2321; color:#fff; border-color:#2b2321; font-weight: bold; }
</style>

<div class="page-wrap">
  <div class="inner">
    <div class="page-title">나의 문의 내역</div>
    <div class="title-rule"></div>

    <table class="board-table" aria-label="나의 Q&A 목록">
      <thead>
        <tr>
          <th class="col-no">번호</th>
          <th class="col-status">답변상태</th>
          <th>제목</th>
          <th class="col-date">문의일</th>
        </tr>
      </thead>

      <tbody>
        <c:if test="${not empty qnaList}">
          <c:forEach var="qna" items="${qnaList}" varStatus="status">
            <tr>
              <td>
                ${vno - status.index}
              </td>

              <td>
                <c:choose>
                  <c:when test="${qna.answered}">
                    <span class="badge-ans">답변완료</span>
                  </c:when>
                  <c:otherwise>
                    <span class="badge-re">답변대기</span>
                  </c:otherwise>
                </c:choose>
              </td>

              <td class="title-td">
                <a href="<%=request.getContextPath()%>/qnaView.sp?no=${qna.qnaId}">
                  <span class="title-line">
                    <span class="title-text">${qna.subject}</span>
                    <c:if test="${qna.isSecret == 1}">
                      <span class="lock">🔒</span>
                    </c:if>
                  </span>
                </a>
              </td>

              <td class="col-date">
                <fmt:formatDate value="${qna.regDate}" pattern="yyyy.MM.dd"/>
              </td>
            </tr>
          </c:forEach>
        </c:if>

        <c:if test="${empty qnaList}">
          <tr>
            <td colspan="4" style="padding:80px 0; color:#999;">작성하신 문의 내역이 없습니다.</td>
          </tr>
        </c:if>
      </tbody>
    </table>

    <div class="btn-row">
      <a class="btn-write" href="<%=request.getContextPath()%>/qnaWrite.sp?myUrl=/customer/myQnaList.sp">새 문의하기</a>
    </div>

    <ul class="pagebar">
      ${requestScope.pageBar}
    </ul>

  </div>
</div>

<jsp:include page="../footer.jsp"/>