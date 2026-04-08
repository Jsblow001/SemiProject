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
  .time{padding:12px 12px 12px 25px;background:#fafafa;border-right:1px solid #eee;font-weight:700;}
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
<jsp:include page="../../header2.jsp"/>
<div class="wrap">
  <h2>예약 스케줄(관리자)</h2>

  <div class="top">
    <label>매장</label>
    <select id="storeId">
      <option value="1">SISEON 도산점</option>
      <option value="2">SISEON 압구정점</option>
      <option value="3">SISEON 홍대점</option>
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
  const EMPTY_TEXT = "비어있음(클릭하면 30분 막기)";
  let timer = null;

  $(function(){
    // 오늘 날짜 기본
    const today = new Date();
    const yyyy = today.getFullYear();
    const mm = String(today.getMonth()+1).padStart(2,'0');
    const dd = String(today.getDate()).padStart(2,'0');
    $("#date").val(yyyy + "-" + mm + "-" + dd);

    buildGrid();
    fetchAndRender();
    timer = setInterval(fetchAndRender, POLL_MS);

    $("#btnRefresh, #storeId, #date").on("change click", function(){
      fetchAndRender();
    });

 	// ✅ 문자 보내기(예약) - 중복 바인딩 방지 버전
    $("#timeGrid")
      .off("click", ".btn-sms")           // ✅ 기존 중복 핸들러 제거
      .on("click", ".btn-sms", function(e){
        e.stopPropagation();

        const storeId = $("#storeId").val();
        const reservationId = $(this).data("reservationid");
        const phone = $(this).data("phone");
        const name = $(this).data("name");

        const msg = prompt(name + "(" + phone + ")에게 보낼 문자를 입력하세요");
        if(msg == null) return;

        // ✅ 중복 전송 방지(연타/중복핸들러 안전장치)
        const $btn = $(this);
        if($btn.data("sending") === 1) return;
        $btn.data("sending", 1);

        $.ajax({
          url: "<%=ctxPath%>/adminSendSms.sp",
          type: "POST",
          dataType: "json",              // ✅ JSON.parse 제거
          data: {
            reservationId: reservationId,
            storeId: storeId,
            toPhone: phone,
            smsType: "ADMIN",
            content: msg
          }
        })
        .done(function(data){
          alert(data.message || (data.ok ? "전송 완료" : "전송 실패"));
        })
        .fail(function(xhr){
          console.log("SMS FAIL", xhr.status, xhr.responseText);
          alert("문자 전송 요청 실패: " + xhr.status);
        })
        .always(function(){
          $btn.data("sending", 0);
        });
      }); // end of $("#timeGrid")
      
      $("#timeGrid").off("click", ".cell").on("click", ".cell", function () {
    	  // 이미 예약/막기 있는 칸이면 막기 X (비어있는 칸만 막기)
    	  if ($(this).attr("data-empty") !== "1") return;

    	  var storeId = $("#storeId").val();
    	  var date = $("#date").val();
    	  var startTime = $(this).attr("data-time");
    	  var endTime = addMin(startTime, 30);

    	  var memo = prompt(
    	    date + " " + startTime + "~" + endTime + "\n막기 메모(선택)"
    	  );
    	  if (memo == null) return; // 취소

    	  $.ajax({
    	    url: "<%=ctxPath%>/admin/blockSlot.sp",   
    	    type: "POST",
    	    dataType: "json",
    	    data: {
    	      storeId: storeId,
    	      date: date,
    	      startTime: startTime,
    	      durationMin: 30,
    	      memo: memo
    	    }
    	  })
    	  .done(function (data) {
    	    if (data.ok) {
    	      fetchAndRender();
    	    } else {
    	      alert(data.message || "막기 실패");
    	    }
    	  })
    	  .fail(function (xhr) {
    	    console.log("BLOCK FAIL", xhr.status, xhr.responseText);
    	    alert("막기 요청 실패: " + xhr.status);
    	  });
    	});



    // 막기 해제
    $("#timeGrid").on("click", ".btn-unblock", function(e){
      e.stopPropagation();
      const blockId = $(this).data("blockid");
      if(!confirm("막기를 해제할까요?")) return;

      $.post("<%=ctxPath%>/admin/unblockSlot.sp", { blockId: blockId })
        .done(function(res){
          const data = (typeof res === "string") ? JSON.parse(res) : res;
          if(data.ok) fetchAndRender();
          else alert(data.message || "해제 실패");
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
    for(let i=0; i<times.length; i++){
      const t = times[i];

      const $row = $("<div>").addClass("row");
      const $time = $("<div>").addClass("time").text(t);
      const $cell = $("<div>")
        .addClass("cell")
        .attr("data-time", t)
        .attr("data-empty", "1")
        .append($("<span>").addClass("muted").text(EMPTY_TEXT));

      $row.append($time).append($cell);
      grid.append($row);
    }
  }
  
  function addMin(hhmm, add) {
	  var p = String(hhmm).split(":");
	  var h = Number(p[0]);
	  var m = Number(p[1]);
	  var total = h * 60 + m + add;

	  total = (total % 1440 + 1440) % 1440;

	  var nh = String(Math.floor(total / 60)).padStart(2, "0");
	  var nm = String(total % 60).padStart(2, "0");

	  return nh + ":" + nm;
	}


  function fetchAndRender(){
    const storeId = $("#storeId").val();
    const date = $("#date").val();
    $("#statusText").text("불러오는 중...");

    $.get("<%=ctxPath%>/admin/scheduleBoard.sp", { storeId: storeId, date: date })
      .done(function(res){
        const data = (typeof res === "string") ? JSON.parse(res) : res;
        if(!data.ok){
          $("#statusText").text(data.message || "조회 실패");
          return;
        }
        $("#statusText").text("업데이트: " + new Date().toLocaleTimeString());
        renderEvents(data.events || []);
      })
      .fail(function(){
        $("#statusText").text("통신 실패");
      });
  }

  function setEmptyCell($cell){
    $cell.attr("data-empty","1").empty()
      .append($("<span>").addClass("muted").text(EMPTY_TEXT));
  }

  function renderEvents(events){
    // 그리드 초기화(비어있음 상태로)
    $("#timeGrid .cell").each(function(){
      setEmptyCell($(this));
    });

    // 이벤트를 30분 단위 슬롯에 매핑해서 표시
    for(let i=0; i<events.length; i++){
      const ev = events[i];

      const start = ev.startAt ? ev.startAt.substring(11,16) : "";
      const end   = ev.endAt ? ev.endAt.substring(11,16) : "";

      if(!start || !end) continue;

      const slots = makeTimes(start, end, 30); // 시작 포함, 종료 직전까지

      for(let k=0; k<slots.length; k++){
        const t = slots[k];
        const $cell = $("#timeGrid .cell[data-time='" + t + "']");
        if($cell.length === 0) continue;

        $cell.attr("data-empty","0").empty();

        if(ev.type === "BLOCK"){
          const $badge = $("<span>").addClass("badge b-block");

          // 🔒 막기 11:00~11:30 - memo
          const memoText = (ev.memo && String(ev.memo).trim().length > 0) ? (" - " + ev.memo) : "";
          $badge.append(document.createTextNode("🔒 막기 " + start + "~" + end + memoText));

          const $btn = $("<button>")
            .addClass("btn btn-unblock")
            .text("해제")
            .data("blockid", ev.id);

          $badge.append($btn);
          $cell.append($badge);

        } else {
          const reason = ev.reason ? String(ev.reason) : "예약";
          const name = ev.name ? String(ev.name) : "";
          const phone = ev.phone ? String(ev.phone) : "";

          const label = reason + " " + start + "~" + end + " / " + name + " (" + phone + ")";

          const memo = (ev.message && String(ev.message).trim().length>0)
                        ? String(ev.message)
                        : (ev.memo ? String(ev.memo) : "");
          const hasMemo = memo && memo.trim().length > 0;

          const $badge = $("<span>").addClass("badge b-res");
          if(hasMemo) $badge.attr("title", memo);

          $badge.append(document.createTextNode("✅ " + label));

          if(hasMemo){
            const $btnNote = $("<button>")
              .addClass("btn btn-note")
              .text("메모")
              .data("memo", memo);
            $badge.append($btnNote);
          }

          const $btnSms = $("<button>")
          .addClass("btn btn-sms")
          .text("문자")
          .data("phone", phone)
          .data("name", name)
          .data("reservationid", ev.id); // ✅ 예약 PK(=reservation_id)

          $badge.append($btnSms);
          $cell.append($badge);
        }
      }
    }
  }

  function makeTimes(startHHmm, endHHmm, stepMin){
    const s = String(startHHmm).split(":");
    const e = String(endHHmm).split(":");
    const sh = Number(s[0]), sm = Number(s[1]);
    const eh = Number(e[0]), em = Number(e[1]);

    let cur = sh*60 + sm;
    const end = eh*60 + em;

    const out = [];
    while(cur < end){
      const h = String(Math.floor(cur/60)).padStart(2,'0');
      const m = String(cur%60).padStart(2,'0');
      out.push(h + ":" + m);
      cur += stepMin;
    }
    return out;
  }
</script>
<jsp:include page="../../footer2.jsp"/>
</body>
</html>
