<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
  String ctxPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>내 방문예약</title>
<jsp:include page="../header.jsp"/>
<script src="<%=ctxPath%>/js/jquery-3.7.1.min.js"></script>
<style>
  .wrap{max-width:1100px;margin:24px auto;padding:0 16px;}
  table{width:100%;border-collapse:collapse;}
  th,td{border-bottom:1px solid #eee;padding:12px 10px;text-align:left;vertical-align:top;}
  th{background:#fafafa;}
  .badge{display:inline-block;padding:4px 8px;border:1px solid #ddd;border-radius:999px;font-size:12px;}
  .ok{background:#f3f7ff;}
  .cancel{background:#fff3f3;}
  .btn{border:1px solid #ccc;background:#fff;border-radius:8px;padding:6px 10px;cursor:pointer;}
  .btn:hover{background:#f6f6f6;}
  .muted{color:#666;font-size:13px;}
  .msg{white-space:pre-wrap;color:#333;}
</style>
</head>
<body>

<div class="wrap">
  <h2>내 방문예약</h2>
  <p class="muted">비회원 예약은 취소가 불가하며, 회원 예약만 여기서 취소 가능합니다.</p>

  <table>
    <thead>
      <tr>
        <th style="width:120px;">상태</th>
        <th>예약 정보</th>
        <th style="width:140px;">조치</th>
      </tr>
    </thead>
    <tbody>
      <c:if test="${empty list}">
        <tr><td colspan="3">예약 내역이 없습니다.</td></tr>
      </c:if>

      <c:forEach var="r" items="${list}">
        <tr>
          <td>
            <c:choose>
              <c:when test="${r.status eq 'CONFIRMED'}">
                <span class="badge ok">확정</span>
              </c:when>
              <c:when test="${r.status eq 'CANCELLED'}">
                <span class="badge cancel">취소</span>
              </c:when>
              <c:otherwise>
                <span class="badge">${r.status}</span>
              </c:otherwise>
            </c:choose>
          </td>

          <td>
            <div><strong>${r.storeName}</strong></div>
            <div>${r.startAt} ~ ${r.endAt}</div>
            <div>사유: ${r.reason} (${r.durationMin}분)</div>
            <c:if test="${not empty r.message}">
              <div class="msg">메시지: ${r.message}</div>
            </c:if>
          </td>

          <td>
            <c:if test="${r.status eq 'CONFIRMED'}">
              <button type="button" class="btn btnCancel" data-id="${r.reservationId}">예약 취소</button>
            </c:if>
            <c:if test="${r.status ne 'CONFIRMED'}">
              <span class="muted">-</span>
            </c:if>
          </td>
        </tr>
      </c:forEach>
    </tbody>
  </table>
</div>

<script>
$(function(){
  $(".btnCancel").on("click", function(){
    const reservationId = $(this).data("id");
    if(!confirm("예약을 취소할까요?")) return;

    $.post("<%=ctxPath%>/api/reservationsCancel.sp", { reservationId })
      .done(function(res){
        const data = (typeof res === "string") ? JSON.parse(res) : res;
        if(data.ok){
          alert("취소 완료");
          location.reload();
        } else {
          alert(data.message || "취소 실패");
        }
      })
      .fail(function(){
        alert("통신 실패");
      });
  });
});
</script>
<jsp:include page="../footer.jsp"/>
</body>
</html>
