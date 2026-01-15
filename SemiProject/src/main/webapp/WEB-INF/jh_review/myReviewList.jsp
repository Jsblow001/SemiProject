<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    String ctxPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>CARIN | 내 리뷰</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%=ctxPath%>/bootstrap-4.6.2-dist/css/bootstrap.min.css">

<style>
body {
    font-family: 'Poppins','Pretendard',sans-serif;
    background:#FBFAF8;
}

.review-container {
    margin: 150px auto 120px;
    max-width: 1100px;
}

/* ===== 필터 영역 ===== */
.filter-box {
    display:flex;
    justify-content:space-between;
    align-items:center;
    font-size:13px;
    margin-bottom:15px;
}

.filter-left select {
    height:32px;
    font-size:13px;
}

.filter-right button,
.filter-right input {
    height:32px;
    font-size:12px;
}

.filter-right button {
    background:#3b2f2a;
    color:#fff;
    border:none;
    padding:0 12px;
}

/* ===== 안내 문구 ===== */
.notice {
    font-size:12px;
    color:#999;
    margin-bottom:15px;
}

/* ===== 테이블 ===== */
.review-table {
    width:100%;
    background:#fff;
    border-top:2px solid #3b2f2a;
    font-size:13px;
}
.review-table th {
    background:#fafafa;
    color:#777;
    text-align:center;
    padding:15px 5px;
}
.review-table td {
    text-align:center;
    padding:22px 5px;
    border-top:1px solid #eee;
}
.empty-msg {
    padding:80px 0;
    color:#999;
}

/* 제목 링크 */
.review-title-link{
    color:#333;
    text-decoration:none;
}
.review-title-link:hover{
    text-decoration:underline;
}

/* ===== 버튼 ===== */
.btn-pill {
    display:inline-block;
    padding:6px 14px;
    font-size:12px;
    font-weight:500;
    border:1px solid #e3e0dc;
    border-radius:20px;
    background:#fff;
    text-decoration:none;
    transition:all .2s ease;
    color:#3b2f2a;
    cursor:pointer;
}

.btn-pill:hover {
    background:#3b2f2a;
    color:#fff;
    border-color:#3b2f2a;
}

/* 삭제 버튼(위험 색상) */
.btn-pill.danger {
    color:#c62828;
    border-color:#f0d5d5;
}
.btn-pill.danger:hover{
    background:#c62828;
    color:#fff;
    border-color:#c62828;
}

/* ===== 페이지네이션 ===== */
.pagination { justify-content:center; margin-top:40px; }
.pagination .page-item .page-link {
    color: #3b2f2a;
    border: 1px solid #e3e0dc;
    background-color: #fff;
    margin: 0 3px;
    padding: 6px 12px;
    font-size: 13px;
    border-radius: 20px;
    transition: all 0.2s ease;
}
.pagination .page-item .page-link:hover {
    background-color: #f5f3ef;
    border-color: #3b2f2a;
    color: #3b2f2a;
}
.pagination .page-item.active .page-link {
    background-color: #3b2f2a;
    border-color: #3b2f2a;
    color: #fff;
    font-weight: 500;
}
.pagination .page-item.disabled .page-link {
    color: #bbb;
    background-color: #fafafa;
    border-color: #eee;
    pointer-events: none;
}
</style>

<script>
function goDeleteReview(reviewId){
    if(!confirm("정말 이 리뷰를 삭제할까요?\n삭제하면 복구할 수 없습니다.")) return;

    // ✅ 삭제 후 돌아올 URL(현재 리스트 상태 유지)
    const returnUrl =
        "<%=ctxPath%>/myReviewList.sp?page=${page}&sort=${sort}&searchWord=${searchWord}";

    const f = document.createElement("form");
    f.method = "post";
    f.action = "<%=ctxPath%>/reviewDelete.sp";

    const i1 = document.createElement("input");
    i1.type = "hidden";
    i1.name = "reviewId";
    i1.value = reviewId;

    const i2 = document.createElement("input");
    i2.type = "hidden";
    i2.name = "returnUrl";
    i2.value = returnUrl;

    f.appendChild(i1);
    f.appendChild(i2);

    document.body.appendChild(f);
    f.submit();
}
</script>

</head>

<body>

<jsp:include page="../header.jsp"/>

<div class="review-container">

    <h3 style="font-size:22px;font-weight:600;margin-bottom:20px;">내 리뷰</h3>

    <!-- 필터 -->
    <div class="filter-box">
        <div class="filter-left">
            <form method="get" action="<%=ctxPath%>/myReviewList.sp">
                <select name="sort" onchange="this.form.submit()">
                    <option value="recent" ${sort == 'recent' ? 'selected' : ''}>최신순</option>
                    <option value="rating" ${sort == 'rating' ? 'selected' : ''}>평점순</option>
                </select>
                <input type="hidden" name="searchWord" value="${searchWord}">
            </form>
        </div>

        <div class="filter-right">
            <form method="get" action="<%=ctxPath%>/myReviewList.sp"
                  style="display:flex;align-items:center;gap:6px;">
                <input type="text" name="searchWord" value="${searchWord}"
                       placeholder="제목/내용 검색"
                       style="width:180px;padding:0 8px;border:1px solid #ddd;border-radius:6px;">
                <button type="submit">조회</button>
                <input type="hidden" name="sort" value="${sort}">
            </form>
        </div>
    </div>

    <!-- 안내 -->
    <div class="notice">
        · 내가 작성한 리뷰만 조회됩니다.<br>
        · 삭제는 즉시 반영되며 복구할 수 없습니다.
    </div>

    <!-- 테이블 -->
    <table class="review-table">
        <thead>
            <tr>
                <th style="width:6%">No</th>
                <th style="width:14%">작성일</th>
                <th>상품명</th>
                <th>리뷰제목</th>
                <th style="width:8%">평점</th>
                <th style="width:10%">답변</th>
                <th style="width:12%">상세</th>
                <th style="width:12%">삭제</th>
            </tr>
        </thead>

        <tbody>
            <c:choose>
                <c:when test="${not empty myReviewList}">
                    <c:forEach var="r" items="${myReviewList}" varStatus="st">
                        <tr>
                            <td>${(page - 1) * 10 + st.count}</td>
                            <td>${r.review_date}</td>
                            <td>${r.product_name}</td>

                            <td style="text-align:left;">
                                <a class="review-title-link"
                                   href="<%=ctxPath%>/reviewView.sp?reviewId=${r.review_id}">
                                    ${r.review_title}
                                </a>
                            </td>

                            <td>${r.rating}</td>

                            <td>
                                <c:choose>
                                    <c:when test="${r.commentCount > 0}">
                                        <span style="color:#3b2f2a;font-weight:600;">완료</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color:#999;">대기</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <td>
                                <a href="<%=ctxPath%>/reviewView.sp?reviewId=${r.review_id}"
                                   class="btn-pill">
                                    상세보기
                                </a>
                            </td>

                            <td>
                                <a href="javascript:void(0);"
                                   onclick="goDeleteReview('${r.review_id}')"
                                   class="btn-pill danger">
                                    삭제
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>

                <c:otherwise>
                    <tr>
                        <td colspan="8" class="empty-msg">
                            작성한 리뷰가 없습니다.
                        </td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>

    <!-- 페이지네이션 -->
    <ul class="pagination">

        <li class="page-item ${page == 1 ? 'disabled' : ''}">
            <a class="page-link"
               href="<%=ctxPath%>/myReviewList.sp?page=${page - 1}&sort=${sort}&searchWord=${searchWord}">
                ‹
            </a>
        </li>

        <c:forEach begin="1" end="${totalPage}" var="i">
            <li class="page-item ${page == i ? 'active' : ''}">
                <a class="page-link"
                   href="<%=ctxPath%>/myReviewList.sp?page=${i}&sort=${sort}&searchWord=${searchWord}">
                    ${i}
                </a>
            </li>
        </c:forEach>

        <li class="page-item ${page == totalPage ? 'disabled' : ''}">
            <a class="page-link"
               href="<%=ctxPath%>/myReviewList.sp?page=${page + 1}&sort=${sort}&searchWord=${searchWord}">
                ›
            </a>
        </li>

    </ul>

</div>

<jsp:include page="../footer.jsp"/>

</body>
</html>
