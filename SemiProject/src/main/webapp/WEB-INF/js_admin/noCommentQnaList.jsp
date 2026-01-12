<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="../header2.jsp"/>

<style>
    /* 카린 스타일 관리자 가이드라인 */
    :root {
        --carin-black: #2b2321;
        --carin-point: #bcaaa4;
        --carin-gray: #757575;
        --carin-border: #e9e9e9;
    }

    .page-wrap { width:100%; padding:60px 0; background:#fff; }
    .inner { width:92%; max-width:1400px; margin:0 auto; }

    .admin-header { display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 20px; }
    .page-title { font-size:24px; font-weight:600; letter-spacing:1px; color: var(--carin-black); margin:0; }
    .no-comment-count { font-size: 14px; color: var(--carin-point); font-weight: 500; }

    .title-rule { height:2px; background: var(--carin-black); margin-bottom:30px; }

    .board-table { width:100%; border-collapse:collapse; table-layout:fixed; font-size:13px; }
    .board-table thead th {
        text-align:center; font-weight:600; color:#111;
        padding:15px 10px; border-bottom:1px solid #eee; background: #fafafa;
    }
    .board-table tbody td {
        padding:20px 10px; border-bottom:1px solid #f7f7f7;
        vertical-align:middle; color:#333; text-align:center;
    }

    .col-vno { width: 70px; }
    .col-id { width:130px; }
    .col-status { width:110px; }
    .col-date { width:130px; }
    .title-td { text-align: left !important; padding-left: 20px !important; }

    .badge-pending {
        font-size:11px; padding:5px 10px;
        background: #fff; color: var(--carin-point); border: 1px solid var(--carin-point);
        letter-spacing: 0.5px;
    }
    
    .member-id { font-weight: 500; color: #555; }
    .subject-link { transition: color 0.2s; color: #111; }
    .subject-link:hover { color: var(--carin-point); text-decoration: none; }

    /* 페이징바 스타일 */
    .pagebar-wrap { margin-top: 50px; display: flex; justify-content: center; }
    .pagebar { list-style:none; display:flex; gap:8px; padding:0; align-items: center; }
    
    .pagebar li a { 
        display: flex; align-items: center; justify-content: center;
        /* 수정된 부분: 고정 너비를 풀고 최소 너비와 좌우 여백 설정 */
        min-width: 35px; 
        height: 35px; 
        padding: 0 12px; 
        border: 1px solid var(--carin-border);
        color: #888; 
        text-decoration: none; 
        font-size: 12px; 
        transition: 0.3s;
        white-space: nowrap; /* 텍스트 줄바꿈 방지 */
    }

    /* [맨처음], [마지막] 등 텍스트가 들어간 버튼을 더 강조하고 싶을 때 */
    .pagebar li a:contains('[') {
        font-weight: 500;
        background-color: #f9f9f9;
    }

    .pagebar li.active a { 
        background: var(--carin-black); 
        color: #fff; 
        border-color: var(--carin-black); 
        font-weight: 600;
    }

    .pagebar li a:hover:not(.active) { 
        border-color: var(--carin-black); 
        color: var(--carin-black); 
        background: #fff;
    }

    .btn-row { display:flex; justify-content:flex-end; margin-top:30px; gap: 10px; }
    .btn-admin {
        display:inline-flex; align-items:center; justify-content:center;
        padding: 0 25px; height:45px; font-size:13px; letter-spacing: 0.5px;
        border:1px solid var(--carin-black); transition: all 0.3s; text-decoration: none;
    }
    .btn-dark { background: var(--carin-black); color: #fff; }
    .btn-outline { background: #fff; color: var(--carin-black); }
</style>

<div class="page-wrap">
  <div class="inner">
    <div class="admin-header">
        <h2 class="page-title">미답변 문의 관리</h2>
        <span class="no-comment-count">현재 답변 대기 중인 문의가 <strong>${noCommentCnt}</strong>건 있습니다.</span>
    </div>
    <div class="title-rule"></div>

    <table class="board-table">
      <thead>
        <tr>
          <th class="col-vno">번호</th>
          <th class="col-id">작성자</th>
          <th class="col-status">상태</th>
          <th>문의 제목</th>
          <th class="col-date">등록일</th>
        </tr>
      </thead>

      <tbody>
        <c:if test="${not empty qnaList}">
          <c:forEach var="qna" items="${qnaList}" varStatus="status">
            <tr>
              <td>${vno - status.index}</td>
              <td class="member-id">${qna.fkMemberId}</td> <td>
                <span class="badge-pending">답변대기</span>
              </td>
              <td class="title-td">
                <a href="<%=request.getContextPath()%>/qnaView.sp?no=${qna.qnaId}" class="subject-link"> ${qna.subject}
                    <c:if test="${qna.isSecret == 1}">
                      <span style="opacity:0.4; margin-left:5px;">🔒</span>
                    </c:if>
                </a>
              </td>
              <td class="col-date" style="color:#999;">
                <fmt:formatDate value="${qna.regDate}" pattern="yyyy.MM.dd"/> </td>
            </tr>
          </c:forEach>
        </c:if>

        <c:if test="${empty qnaList}">
          <tr>
            <td colspan="5" style="padding:120px 0; color:#bbb; font-size: 14px;">모든 답변이 완료되었습니다.</td>
          </tr>
        </c:if>
      </tbody>
    </table>

    <div class="pagebar-wrap">
      <ul class="pagebar">
        ${pageBar}
      </ul>
    </div>

    <div class="btn-row">
      <a class="btn-admin btn-dark" href="<%=request.getContextPath()%>/adminQnaList.sp">전체 문의 보기</a>
    </div>

  </div>
</div>

<jsp:include page="../footer2.jsp"/>