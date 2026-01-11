<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
  String ctxPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>예약 스케줄(관리자)</title>
<script src="<%=ctxPath%>/js/jquery-3.7.1.min.js"></script>
<style>
  .wrap{max-width:1100px;margin:24px auto;padding:0 16px;}
  .top{display:flex;gap:12px;align-items:center;flex-wrap:wrap;margin-bottom:14px;}
  .grid{border:1px solid #ddd;border-radius:10px;overflow:hidden;}
  .row{display:grid;grid-template-columns:120px 1fr;border-top:1px solid #eee;min-height:52px;}
  .row:first-child{border-top:none;}
  .time{padding:12px;background:#fafafa;border-right:1px solid #eee;font-weight:700;}
  .cell{padding:8px 12px;display:flex;align-items:center;gap:10px;flex-wrap:wrap;}
  .badge{display:inline-flex;align-items:center;gap:8px;border:1px solid #ddd;border-radius:999px;padding:6px 10px;font-size:13px;}
  .b-res{background:#f3f7ff;}
  .b-block{background:#fff3f3;}
  .btn{border:1px solid #ccc;background:#fff;border-radius:8px;padding:6px 10px;cursor:pointer;}
  .btn:hover{background:#f6f6f6;}
  .muted{color:#666;font-size:13px;}
</style>
</head>
<body>
<div class="wrap">
  <h2>예약 스케줄(관리자)</h2>

  <div class="top">
    <label>매장</label>
    <select id="storeId">
      <option value="1">매장1</option>
      <option value="2">매장2</option>
      <option value="3">매장3</option>
    </select>

    <label>날짜</label>
    <input type="date" id="date" />

    <button class="btn" id="btnRefresh">새로고침</button>
    <span class="muted" id="statusText"></span>
  </div>

  <div class="grid" id="timeGrid"></div>
</div>

<script>
  const OPEN = "11:00";
  const CLOSE = "20:00";
  const POLL_MS = 3000;
  let timer = null;

  $(function(){
    // 오늘 날짜 기본
    const today = new Date();
    const yyyy = today.getFullYear();
    const mm = String(today.getMonth()+1).padStart(2,'0');
    const dd = String(today.getDate()).padStart(2,'0');
    $("#date").val(`${yyyy}-${mm}-${dd}`);

    buildGrid();
    fetchAndRender();
    timer = setInterval(fetchAndRender, POLL_MS);

    $("#btnRefresh, #storeId, #date").on("change click", function(){
      fetchAndRender();
    });

    // 빈칸 클릭하면 막기(30분)
    $("#timeGrid").on("click", ".cell[data-empty='1']", function(){
      const storeId = $("#storeId").val();
      const date = $("#date").val();
      const startTime = $(this).data("time"); // HH:mm

      if(!confirm(`${date} ${startTime} ~ (30분) 막기 처리할까요?`)) return;

      $.post("<%=ctxPath%>/admin/blockSlot.sp", {
        storeId, date, startTime,
        durationMin: 30,
        memo: "관리자 막기"
      }).done(function(res){
        const data = (typeof res === "string") ? JSON.parse(res) : res;
        if(data.ok) fetchAndRender();
        else alert(data.message || "막기 실패");
      });
    });

    // 막기 해제
    $("#timeGrid").on("click", ".btn-unblock", function(e){
      e.stopPropagation();
      const blockId = $(this).data("blockid");
      if(!confirm("막기를 해제할까요?")) return;

      $.post("<%=ctxPath%>/admin/unblockSlot.sp", { blockId })
        .done(function(res){
          const data = (typeof res === "string") ? JSON.parse(res) : res;
          if(data.ok) fetchAndRender();
          else alert(data.message || "해제 실패");
        });
    });

    // 문자 보내기(예약)
    $("#timeGrid").on("click", ".btn-sms", function(e){
      e.stopPropagation();
      const phone = $(this).data("phone");
      const name = $(this).data("name");
      const msg = prompt(`${name}(${phone})에게 보낼 문자를 입력하세요`);
      if(msg == null) return;

      // 너가 이미 가진 AdminMemberSmsSend 활용
      $.post("<%=ctxPath%>/adminMemberSmsSend.sp", {
        mobile: phone,
        smsContent: msg
      }).done(function(res){
        const data = (typeof res === "string") ? JSON.parse(res) : res;
        alert("전송 결과: " + JSON.stringify(data));
      });
    });
    
    // 메모 버튼 클릭시 이벤트
    $("#timeGrid").on("click", ".btn-note", function(e){
   	  e.stopPropagation();
   	  const memo = $(this).data("memo");
   	  alert("예약 메모:\n\n" + memo);
   	});

  });

  function buildGrid(){
    const grid = $("#timeGrid");
    grid.empty();

    const times = makeTimes(OPEN, CLOSE, 30); // 11:00~19:30 시작
    times.forEach(t => {
      const row = $(`
        <div class="row">
          <div class="time">${t}</div>
          <div class="cell" data-time="${t}" data-empty="1">
            <span class="muted">비어있음(클릭하면 30분 막기)</span>
          </div>
        </div>
      `);
      grid.append(row);
    });
  }

  function fetchAndRender(){
    const storeId = $("#storeId").val();
    const date = $("#date").val();
    $("#statusText").text("불러오는 중...");

    $.get("<%=ctxPath%>/admin/scheduleBoard.sp", { storeId, date })
      .done(function(res){
        const data = (typeof res === "string") ? JSON.parse(res) : res;
        if(!data.ok){
          $("#statusText").text(data.message || "조회 실패");
          return;
        }
        $("#statusText").text(`업데이트: ${new Date().toLocaleTimeString()}`);
        renderEvents(data.events || []);
      })
      .fail(function(){
        $("#statusText").text("통신 실패");
      });
  }

  function renderEvents(events){
    // 그리드 초기화(비어있음 상태로)
    $("#timeGrid .cell").each(function(){
      $(this).attr("data-empty","1").html(`<span class="muted">비어있음(클릭하면 30분 막기)</span>`);
    });

    // 이벤트를 30분 단위 슬롯에 매핑해서 표시
    events.forEach(ev => {
      const start = ev.startAt.substring(11,16); // HH:mm
      const end = ev.endAt.substring(11,16);     // HH:mm
      const slots = makeTimes(start, end, 30);   // 시작 포함, 종료 직전까지

      slots.forEach(t => {
        const cell = $("#timeGrid .cell[data-time='"+t+"']");
        if(cell.length === 0) return;
        cell.attr("data-empty","0");

        if(ev.type === "BLOCK"){
          cell.html(`
            <span class="badge b-block">
              🔒 막기 ${start}~${end} ${ev.memo ? ("- "+escapeHtml(ev.memo)) : ""}
              <button class="btn btn-unblock" data-blockid="${ev.id}">해제</button>
            </span>
          `);
        } else {
        	  const label = `${ev.reason} ${start}~${end} / ${escapeHtml(ev.name)} (${escapeHtml(ev.phone)})`;

        	  const memo = (ev.message && ev.message.trim().length>0) ? ev.message : (ev.memo || "");
        	  const hasMemo = memo && memo.trim().length > 0;

        	  cell.html(`
        	    <span class="badge b-res" title="${hasMemo ? escapeHtml(memo) : ''}">
        	      ✅ ${label}
        	      ${hasMemo ? `<button class="btn btn-note" data-memo="${escapeHtml(memo)}">메모</button>` : ``}
        	      <button class="btn btn-sms" data-phone="${ev.phone}" data-name="${ev.name}">문자</button>
        	    </span>
        	  `);
        	}
      });
    });
  }

  function makeTimes(startHHmm, endHHmm, stepMin){
    // endHHmm은 "끝 시각" (그 직전 슬롯까지)
    const [sh, sm] = startHHmm.split(":").map(Number);
    const [eh, em] = endHHmm.split(":").map(Number);

    let cur = sh*60+sm;
    const end = eh*60+em;

    const out = [];
    while(cur < end){
      const h = String(Math.floor(cur/60)).padStart(2,'0');
      const m = String(cur%60).padStart(2,'0');
      out.push(`${h}:${m}`);
      cur += stepMin;
    }
    return out;
  }

  function escapeHtml(s){
    if(!s) return "";
    return String(s)
      .replaceAll("&","&amp;")
      .replaceAll("<","&lt;")
      .replaceAll(">","&gt;")
      .replaceAll('"',"&quot;")
      .replaceAll("'","&#039;");
  }
  
</script>
</body>
</html>
