<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    // ============================================================
    // 1) 서블릿/DB 없이 "더미데이터"만으로 noticeList 세팅
    //    - EL이 안정적으로 읽도록 List<Map> 사용
    // ============================================================
    if (request.getAttribute("noticeList") == null) {

        java.util.List<java.util.Map<String, Object>> list = new java.util.ArrayList<>();
        java.util.Map<String, Object> r;

        // 최상단 공지(고정 공지 느낌)
        r = new java.util.HashMap<>();
        r.put("no", "공지");
        r.put("notice", true);      // 배경 강조
        r.put("title", "[NOTICE] 카린 온라인몰 회원혜택 안내 [16]");
        r.put("author", "카린선글라스");
        r.put("date", "20-04-01");
        r.put("views", 57148);
        list.add(r);

        // 일반 공지/이벤트 (원하는 만큼 추가)
        r = new java.util.HashMap<>();
        r.put("no", 17);
        r.put("notice", false);
        r.put("title", "[EVENT] A Small Holiday Delight (12.6 - 12.26)");
        r.put("author", "카린");
        r.put("date", "25-12-03");
        r.put("views", 1567);
        list.add(r);

        r = new java.util.HashMap<>();
        r.put("no", 16);
        r.put("notice", false);
        r.put("title", "[종료][EVENT] Archive Week: Collaboration (11.10 - 11.16)");
        r.put("author", "카린");
        r.put("date", "25-11-07");
        r.put("views", 1447);
        list.add(r);

        r = new java.util.HashMap<>();
        r.put("no", 15);
        r.put("notice", false);
        r.put("title", "[종료][EVENT] WELCOME BACK Moment (10.24 - 11.9)");
        r.put("author", "카린");
        r.put("date", "25-10-22");
        r.put("views", 1221);
        list.add(r);

        r = new java.util.HashMap<>();
        r.put("no", 14);
        r.put("notice", false);
        r.put("title", "[종료][EVENT] a Soft Metamorphosis (9.23 - 10.12)");
        r.put("author", "카린");
        r.put("date", "25-09-19");
        r.put("views", 901);
        list.add(r);

        r = new java.util.HashMap<>();
        r.put("no", 13);
        r.put("notice", false);
        r.put("title", "[종료][EVENT] Special Gift Promotion (9.3 - 9.14)");
        r.put("author", "카린");
        r.put("date", "25-09-02");
        r.put("views", 758);
        list.add(r);

        // request에 세팅
        request.setAttribute("noticeList", list);

        // ============================================================
        // 2) 페이지네이션 더미 값
        // ============================================================
        request.setAttribute("currentPage", 1);
        request.setAttribute("totalPages", 2);
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Notice</title>

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
    .col-views{ width:110px; text-align:left; }

    .is-notice td{ background:#fafafa; }

    .title-line{
        display:inline-flex; align-items:center; gap:8px;
        min-width:0; max-width:100%;
    }
    .title-text{ min-width:0; overflow:hidden; white-space:nowrap; text-overflow:ellipsis; }

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
        .col-views{ width:70px; }
        .search-area{ flex-wrap:wrap; }
        .search-area input[type="text"]{ width:100%; max-width:360px; }
    }
</style>
</head>

<body>
<jsp:include page="../header.jsp"/>
<div class="page-wrap">
    <div class="inner">
        <div class="page-title">Notice</div>
        <div class="title-rule"></div>

        <table class="board-table" aria-label="공지 목록">
            <thead>
                <tr>
                    <th class="col-no">번호</th>
                    <th>제목</th>
                    <th class="col-writer">작성자</th>
                    <th class="col-date">작성일</th>
                    <th class="col-views">조회</th>
                </tr>
            </thead>

            <tbody>
                <c:forEach var="row" items="${noticeList}">
                    <tr class="${row.notice ? 'is-notice' : ''}">
                        <td class="col-no">${row.no}</td>

                        <td>
                            <!-- 상세보기 링크는 나중에 서블릿 붙일 때 변경 -->
                            <a href="#" title="${row.title}">
                                <span class="title-line">
                                    <span class="title-text">${row.title}</span>
                                </span>
                            </a>
                        </td>

                        <td class="col-writer">${row.author}</td>
                        <td class="col-date">${row.date}</td>
                        <td class="col-views">${row.views}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

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

        <form class="search-area" method="get" action="notice_page.jsp">
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
