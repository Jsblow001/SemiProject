<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String ctxPath = request.getContextPath(); %>
<%
  String q = request.getParameter("q");
  if(q == null) q = "";
  q = q.trim();
%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8" />
  <title>검색 결과</title>

  <link href="<%=ctxPath%>/css/style.css" rel="stylesheet" />
  <script src="<%=ctxPath%>/js/jquery-3.7.1.min.js"></script>

  <style>
    .sr-wrap{max-width:1100px;margin:30px auto;padding:0 16px;}
    .sr-top{display:flex;align-items:flex-end;justify-content:space-between;gap:12px;margin-bottom:14px;}
    .sr-title{font-size:22px;font-weight:700;margin:0;}
    .sr-q{color:#666;font-size:14px;}
    .sr-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:14px;}
    @media (max-width: 992px){ .sr-grid{grid-template-columns:repeat(3,1fr);} }
    @media (max-width: 768px){ .sr-grid{grid-template-columns:repeat(2,1fr);} }
    @media (max-width: 480px){ .sr-grid{grid-template-columns:repeat(1,1fr);} }

    .sr-card{border:1px solid #eee;border-radius:14px;overflow:hidden;background:#fff;text-decoration:none;color:inherit;}
    .sr-thumb{width:100%;height:180px;object-fit:cover;display:block;background:#f6f6f6;}
    .sr-body{padding:12px;}
    .sr-name{font-weight:700;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;}
    .sr-price{margin-top:6px;color:#555;font-size:14px;}
    .sr-badges{margin-top:8px;display:flex;gap:6px;flex-wrap:wrap;}
    .sr-badge{font-size:12px;padding:3px 8px;border-radius:999px;background:#f2f2f2;color:#444;}

    .sr-empty{padding:30px 0;color:#777;}
    .sr-bar{display:flex;gap:10px;align-items:center;margin:12px 0 18px;}
    .sr-bar input{max-width:420px;}

    .sr-more-wrap{display:flex;justify-content:center;margin:18px 0 40px;}
    .sr-more{min-width:220px;}
  </style>
</head>
<body>

  <jsp:include page="header.jsp"/> 

  <div class="sr-wrap">
    <div class="sr-top">
      <h2 class="sr-title">검색 결과</h2>
      <div class="sr-q">검색어: <b><c:out value="${param.q}"/></b></div>
    </div>

    <!-- 페이지 내 재검색 -->
    <div class="sr-bar">
      <input id="qInput" class="form-control" type="text" value="<%= q %>" placeholder="검색어를 입력하세요" />
      <button id="btnSearch" class="btn btn-primary" type="button">검색</button>
    </div>

    <div id="resultInfo" class="sr-q"></div>
    <div id="resultGrid" class="sr-grid"></div>
    <div id="emptyMsg" class="sr-empty" style="display:none;"></div>

    <div class="sr-more-wrap">
      <button id="btnMore" class="btn btn-outline-primary sr-more" type="button" style="display:none;">더보기</button>
    </div>
  </div>

  <jsp:include page="footer.jsp"/>

<script>
(function(){
  const ctx = "<%=ctxPath%>";
  const $grid  = $("#resultGrid");
  const $info  = $("#resultInfo");
  const $empty = $("#emptyMsg");
  const $qInput= $("#qInput");
  const $btnMore = $("#btnMore");

  let currentQ = "";
  let offset = 0;
  const size = 12;
  let loading = false;
  let ended = false;

  function escapeHtml(s){
    return String(s ?? "")
      .replaceAll("&", "&amp;")
      .replaceAll("<", "&lt;")
      .replaceAll(">", "&gt;")
      .replaceAll('"', "&quot;")
      .replaceAll("'", "&#39;");
  }

  function fmtPrice(n){
    try { return Number(n).toLocaleString() + "원"; }
    catch(e){ return (n ?? "") + "원"; }
  }

  function buildBadges(it){
	  const cname = (it.category_name || "").trim();
	  const sname = (it.spec_name || "").trim();
	
	  let b = "";
	  if(cname) b += '<span class="sr-badge">' + escapeHtml(cname) + '</span>';
	  if(sname) b += '<span class="sr-badge">' + escapeHtml(sname) + '</span>';
	
	  return b ? '<div class="sr-badges">' + b + '</div>' : "";
	}


  function appendCards(list){
	  let html = "";
	  list.forEach(it => {
	    const imgFile = (it.pimage1 && String(it.pimage1).trim()) ? String(it.pimage1).trim() : "";
	    const img = imgFile ? (ctx + "/img/" + imgFile) : (ctx + "/img/glasses/product_1.png");

	    const detailUrl = ctx + "/product/productDetail.sp?product_id=" + encodeURIComponent(it.pnum);

	    html += ''
	      + '<a class="sr-card" href="' + detailUrl + '">'
	      +   '<img class="sr-thumb" src="' + img + '" alt="">'
	      +   '<div class="sr-body">'
	      +     '<div class="sr-name">' + escapeHtml(it.pname) + '</div>'
	      +     '<div class="sr-price">' + fmtPrice(it.price) + '</div>'
	      +     buildBadges(it)
	      +   '</div>'
	      + '</a>';
	  });
	  $grid.append(html);
	}


  function resetUI(){
    $grid.empty();
    $empty.hide().text("");
    $info.text("");
    $btnMore.hide();
    offset = 0;
    ended = false;
  }

  function setInfo(){
    if(!currentQ) { $info.text(""); return; }
    $info.text("검색어: " + currentQ);
  }

  function search(q, isMore){
    q = (q || "").trim();
    if(q.length < 2){
      resetUI();
      $empty.text("검색어는 2글자 이상 입력해주세요.").show();
      return;
    }

    if(loading) return;
    loading = true;

    if(!isMore){
      currentQ = q;
      resetUI();
      setInfo();
    }

    $.ajax({
      url: ctx + "/product/search.sp",  // ✅ JSON 컨트롤러
      data: { q: currentQ, offset: offset, size: size },
      dataType: "json",
      success: function(list){
        list = list || [];

        if(!isMore && list.length === 0){
          $empty.text("검색 결과가 없습니다.").show();
          ended = true;
          $btnMore.hide();
          return;
        }

        appendCards(list);

        // 다음 페이지 준비
        offset += list.length;

        // size보다 적게 왔으면 끝
        if(list.length < size){
          ended = true;
          $btnMore.hide();
        } else {
          ended = false;
          $btnMore.show();
        }
      },
      error: function(){
        if(!isMore){
          resetUI();
          $empty.text("검색 중 오류가 발생했습니다.").show();
        }
      },
      complete: function(){
        loading = false;
      }
    });
  }

  // 첫 진입 검색
  search($qInput.val(), false);

  // 버튼 검색
  $("#btnSearch").on("click", function(){
    search($qInput.val(), false);
  });

  // 엔터 검색
  $qInput.on("keydown", function(e){
    if(e.key === "Enter"){
      e.preventDefault();
      search($qInput.val(), false);
    }
  });

  // 더보기
  $btnMore.on("click", function(){
    if(ended) return;
    search(currentQ, true);
  });

})();
</script>

</body>
</html>
