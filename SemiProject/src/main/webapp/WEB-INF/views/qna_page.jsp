<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    // ============================================================
    // 1) 서블릿/DB 없이 "더미데이터"만으로 qnaList 세팅
    //    - EL이 100% 안정적으로 읽도록 List<Map> 사용
    // ============================================================
    if (request.getAttribute("qnaList") == null) {

        java.util.List<java.util.Map<String, Object>> list = new java.util.ArrayList<>();

        java.util.Map<String, Object> r;

        // 공지
        r = new java.util.HashMap<>();
        r.put("no", "공지");                  // 이미지처럼 "공지" 텍스트
        r.put("notice", true);               // 공지 여부
        r.put("reply", false);               // RE 여부
        r.put("secret", false);              // 🔒 여부
        r.put("title", "[NOTICE] 고객께서 자주 문의하시는 질문에 대한 답변입니다.");
        r.put("author", "카린선글라스");
        r.put("date", "20-04-01");
        r.put("hit", true);                  // HIT 뱃지 (공지에만 보이게)
        list.add(r);

        // 일반글들 (원하는 만큼 추가)
        r = new java.util.HashMap<>();
        r.put("no", 8326);
        r.put("notice", false);
        r.put("reply", false);
        r.put("secret", true);
        r.put("title", "♥상품 문의");
        r.put("author", "채주왕");
        r.put("date", "25-12-24");
        r.put("hit", false);
        list.add(r);

        r = new java.util.HashMap<>();
        r.put("no", 8325);
        r.put("notice", false);
        r.put("reply", true);   // RE 표시
        r.put("secret", true);
        r.put("title", "♥상품 문의");
        r.put("author", "카린");
        r.put("date", "25-12-24");
        r.put("hit", false);
        list.add(r);

        r = new java.util.HashMap<>();
        r.put("no", 8324);
        r.put("notice", false);
        r.put("reply", false);
        r.put("secret", true);
        r.put("title", "♥기타 문의");
        r.put("author", "전아현");
        r.put("date", "25-12-19");
        r.put("hit", false);
        list.add(r);

        r = new java.util.HashMap<>();
        r.put("no", 8323);
        r.put("notice", false);
        r.put("reply", true);
        r.put("secret", true);
        r.put("title", "♥기타 문의");
        r.put("author", "카린");
        r.put("date", "25-12-19");
        r.put("hit", false);
        list.add(r);

        r = new java.util.HashMap<>();
        r.put("no", 8322);
        r.put("notice", false);
        r.put("reply", false);
        r.put("secret", true);
        r.put("title", "♥입고 문의");
        r.put("author", "김은미");
        r.put("date", "25-12-19");
        r.put("hit", false);
        list.add(r);

        // request에 세팅
        request.setAttribute("qnaList", list);

        // ============================================================
        // 2) 페이지네이션 더미 값
        // ============================================================
        request.setAttribute("currentPage", 1);
        request.setAttribute("totalPages", 5);
    }
%>

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

    .is-notice td{ background:#fafafa; }

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
    .badge-hit{
        display:inline-flex; align-items:center; justify-content:center;
        font-size:10px; line-height:1; padding:2px 5px;
        border-radius:2px; border:1px solid #e0e0e0; color:#888; background:#fff;
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

    .pager{
        display:flex; align-items:center; justify-content:center;
        gap:14px; margin:26px 0 26px; color:#777; font-size:12px;
    }
    .pager a, .pager span{
        display:inline-flex; align-items:center; justify-content:center;
        min-width:18px; height:18px; padding:0 2px; color:#777;
    }
    .pager .active{ color:#111; font-weight:600; }
    .pager .arrow{ font-size:14px; color:#999; }
    .pager a:hover{ color:#111; text-decoration:none; }

    .search-area{ display:flex; align-items:center; gap:8px; margin-top:18px; }
    .search-area select, .search-area input{
        height:30px; border:1px solid #d9d9d9; padding:0 8px; font-size:12px; outline:none; background:#fff;
    }
    .search-area select{ min-width:82px; }
    .search-area input[type="text"]{ width:240px; }
    .btn-search{
        height:30px; padding:0 16px;
        border:1px solid #2b2321; background:#2b2321; color:#fff; font-size:12px; cursor:pointer;
    }
    .btn-search:hover{ filter:brightness(1.05); }

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
                <c:forEach var="row" items="${qnaList}">
                    <tr class="${row.notice ? 'is-notice' : ''}">
                        <td class="col-no">${row.no}</td>

                        <td>
                            <!-- 상세보기 링크는 나중에 서블릿 붙일 때 변경 -->
                            <a href="#" title="${row.title}">
                                <span class="title-line">
                                    <c:if test="${row.reply}">
                                        <span class="badge-re">RE</span>
                                    </c:if>

                                    <span class="title-text">${row.title}</span>

                                    <c:if test="${row.hit}">
                                        <span class="badge-hit">HIT</span>
                                    </c:if>

                                    <c:if test="${row.secret}">
                                        <span class="lock">🔒</span>
                                    </c:if>
                                </span>
                            </a>
                        </td>

                        <td class="col-writer">${row.author}</td>
                        <td class="col-date">${row.date}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <div class="btn-row">
            <!-- 글쓰기 페이지는 나중에 만들면 됨 -->
            <button class="btn-write" type="button" onclick="alert('글쓰기 페이지는 추후 연결!');">글쓰기</button>
        </div>

        <div class="pager" aria-label="페이지 이동">
            <a class="arrow" href="#" aria-label="이전">&lsaquo;</a>

            <c:forEach var="p" begin="1" end="${totalPages}">
                <c:choose>
                    <c:when test="${p == currentPage}">
                        <span class="active">${p}</span>
                    </c:when>
                    <c:otherwise>
                        <a href="#">${p}</a>
                    </c:otherwise>
                </c:choose>
            </c:forEach>

            <a class="arrow" href="#" aria-label="다음">&rsaquo;</a>
        </div>

        <form class="search-area" method="get" action="qna_page.jsp">
            <select name="period">
                <option value="week">일주일</option>
                <option value="month">한달</option>
                <option value="all">전체</option>
            </select>

            <select name="searchType">
                <option value="title">제목</option>
                <option value="writer">작성자</option>
                <option value="title_writer">제목+작성자</option>
            </select>

            <input type="text" name="keyword" value="${param.keyword}" />
            <button type="submit" class="btn-search">찾기</button>
        </form>
    </div>
</div>
<jsp:include page="../footer.jsp"/>
</body>
</html>
