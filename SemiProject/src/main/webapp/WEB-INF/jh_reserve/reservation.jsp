<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% String ctxPath = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>방문 예약</title>
<script src="<%=ctxPath%>/js/jquery-3.7.1.min.js"></script>
<style>
  body{margin:0;font-family:Arial,"Noto Sans KR",sans-serif;background:#fff;color:#111;}
  .wrap{max-width:980px;margin:22px auto;padding:0 16px;}
  .stepbar{display:flex;gap:10px;margin-bottom:14px;flex-wrap:wrap;}
  .chip{border:1px solid #ddd;border-radius:999px;padding:8px 12px;font-weight:700;font-size:13px;background:#fafafa;}
  .chip.on{background:#111;color:#fff;border-color:#111;}
  .card{border:1px solid #e5e5e5;border-radius:14px;padding:16px;margin-top:12px;}
  .row{margin:12px 0;}
  .label{display:block;font-weight:800;margin-bottom:6px;}
  .input, select, textarea{width:100%;box-sizing:border-box;padding:10px 12px;border:1px solid #ddd;border-radius:10px;}
  textarea{min-height:120px;resize:vertical;}
  .btns{display:flex;gap:10px;flex-wrap:wrap;margin-top:14px;}
  .btn{border:1px solid #ccc;background:#fff;border-radius:10px;padding:10px 14px;font-weight:800;cursor:pointer;}
  .btn.primary{background:#111;color:#fff;border-color:#111;}
  .btn:disabled{opacity:.45;cursor:not-allowed;}
  .muted{color:#666;font-size:13px;}
  .grid{display:flex;flex-wrap:wrap;gap:10px;margin-top:10px;}
  .tbtn{border:1px solid #ddd;border-radius:999px;padding:8px 12px;background:#fff;cursor:pointer;font-weight:700;}
  .tbtn.on{background:#111;color:#fff;border-color:#111;}
  .summary{border:1px dashed #ddd;border-radius:12px;padding:12px;background:#fafafa;}
  .okbox{border:1px solid #d6ead6;background:#f3fff3;border-radius:12px;padding:14px;}
  .err{color:#c62828;font-weight:800;}
</style>
</head>
<body>
<div class="wrap">
  <h2>안경원 방문예약</h2>
  <div class="muted">영업시간 11:00~20:00 · 30분 단위 예약 · A/S 30분 · 맞춤 60분</div>

  <div class="stepbar">
    <div class="chip on" id="chip1">1. 매장</div>
    <div class="chip" id="chip2">2. 사유/시간</div>
    <div class="chip" id="chip3">3. 정보입력</div>
  </div>

  <!-- STEP 1 -->
  <div class="card" id="step1">
    <div class="row">
      <label class="label">매장 선택</label>
      <select id="storeId" class="input">
        <option value="">선택하세요</option>
        <option value="1">매장1</option>
        <option value="2">매장2</option>
        <option value="3">매장3</option>
      </select>
      <div class="muted" style="margin-top:6px;">* 매장명은 나중에 DB(tbl_store)에서 불러오도록 바꿔도 됨</div>
    </div>

    <div class="btns">
      <button class="btn primary" id="toStep2">다음</button>
    </div>
    <div class="err" id="err1" style="display:none;margin-top:10px;"></div>
  </div>

  <!-- STEP 2 -->
  <div class="card" id="step2" style="display:none;">
    <div class="row">
      <label class="label">예약 이유</label>
      <div style="display:flex;gap:12px;flex-wrap:wrap;">
        <label><input type="radio" name="reason" value="VISION" checked> 시력검사(30분)</label>
        <label><input type="radio" name="reason" value="FITTING"> 안경맞춤(60분)</label>
        <label><input type="radio" name="reason" value="AS"> A/S(30분)</label>
      </div>
    </div>

    <div class="row">
      <label class="label">날짜 선택</label>
      <input type="date" id="date" class="input" />
      <div class="muted" style="margin-top:6px;">* 해당 날짜의 “가능 시간”을 조회합니다.</div>
    </div>

    <div class="row">
      <label class="label">가능 시간 선택</label>
      <div class="btns">
        <button class="btn" id="btnFetchSlots">가능 시간 조회</button>
        <span class="muted" id="slotHint"></span>
      </div>
      <div class="grid" id="timeGrid"></div>
    </div>

    <div class="row">
      <label class="label">직원에게 남길 메시지(선택)</label>
      <textarea id="message" class="input" placeholder="예) 아이가 함께 방문합니다 / 특정 프레임을 보고 싶습니다 / 증상이 있습니다 등"></textarea>
    </div>

    <div class="row summary" id="summary2">
      <div><strong>선택 요약</strong></div>
      <div class="muted" id="summaryText">아직 시간 선택 전입니다.</div>
    </div>

    <div class="btns">
      <button class="btn" id="back1">이전</button>
      <button class="btn primary" id="toStep3">다음</button>
    </div>
    <div class="err" id="err2" style="display:none;margin-top:10px;"></div>
  </div>

  <!-- STEP 3 -->
  <div class="card" id="step3" style="display:none;">
    <div class="row">
      <label class="label">이름(필수)</label>
      <input type="text" id="guestName" class="input" placeholder="홍길동" />
    </div>

    <div class="row">
      <label class="label">연락처(필수)</label>
      <input type="text" id="guestPhone" class="input" placeholder="010-1234-5678" />
      <div class="muted" style="margin-top:6px;">* 하이픈은 자동 제거됩니다.</div>
    </div>

    <div class="row summary">
      <div><strong>예약 정보 확인</strong></div>
      <div class="muted" id="summaryText3"></div>
    </div>

    <div class="btns">
      <button class="btn" id="back2">이전</button>
      <button class="btn primary" id="btnSubmit">예약 확정</button>
    </div>
    <div class="err" id="err3" style="display:none;margin-top:10px;"></div>

    <div class="card" id="resultBox" style="display:none;margin-top:14px;">
      <div class="okbox" id="okBox" style="display:none;"></div>
      <div class="err" id="failBox" style="display:none;"></div>
      <div class="btns" style="margin-top:12px;">
        <a class="btn" href="<%=ctxPath%>/index.sp">메인으로</a>
        <a class="btn" href="<%=ctxPath%>/myReservations.sp">내 예약 보기(회원)</a>
      </div>
    </div>
  </div>

</div>

<script>
  // 상태
  const state = {
    storeId: "",
    reason: "VISION",
    date: "",
    startTime: "",
    durationMin: 30,
    message: ""
  };

  $(function(){
    // 날짜 기본값: 오늘
    const t = new Date();
    const yyyy = t.getFullYear();
    const mm = String(t.getMonth()+1).padStart(2,'0');
    const dd = String(t.getDate()).padStart(2,'0');
    $("#date").val(yyyy + "-" + mm + "-" + dd);
    state.date = $("#date").val();

    // Step 이동
    $("#toStep2").on("click", function(){
      hideErr();
      const storeId = $("#storeId").val();
      if(!storeId){
        showErr("#err1","매장을 선택해주세요.");
        return;
      }
      state.storeId = storeId;
      goStep(2);
    });

    $("#back1").on("click", function(){ hideErr(); goStep(1); });

    $("input[name='reason']").on("change", function(){
      state.reason = $("input[name='reason']:checked").val();
      state.durationMin = (state.reason === "FITTING") ? 60 : 30;
      updateSummary2();
    });

    $("#date").on("change", function(){
      state.date = $("#date").val();
      state.startTime = "";
      $("#timeGrid").empty();
      updateSummary2();
    });

    $("#btnFetchSlots").on("click", fetchSlots);

    $("#toStep3").on("click", function(){
      hideErr();
      if(!state.date){
        showErr("#err2","날짜를 선택해주세요.");
        return;
      }
      if(!state.startTime){
        showErr("#err2","시간을 선택해주세요.");
        return;
      }
      state.message = $("#message").val() || "";
      updateSummary3();
      goStep(3);
    });

    $("#back2").on("click", function(){ hideErr(); goStep(2); });

    $("#btnSubmit").on("click", submitReservation);
  });

  function goStep(n){
    $("#step1,#step2,#step3").hide();
    $("#chip1,#chip2,#chip3").removeClass("on");
    $("#resultBox").hide();
    $("#okBox,#failBox").hide();

    if(n===1){ $("#step1").show(); $("#chip1").addClass("on"); }
    if(n===2){ $("#step2").show(); $("#chip2").addClass("on"); updateSummary2(); }
    if(n===3){ $("#step3").show(); $("#chip3").addClass("on"); updateSummary3(); }
  }

  function hideErr(){
    $("#err1,#err2,#err3").hide().text("");
  }

  function showErr(sel, msg){
    $(sel).text(msg).show();
  }

  function fetchSlots(){
    hideErr();
    state.reason = $("input[name='reason']:checked").val();
    state.durationMin = (state.reason === "FITTING") ? 60 : 30;
    state.date = $("#date").val();

    if(!state.date){
      showErr("#err2","날짜를 선택해주세요.");
      return;
    }

    $("#slotHint").text("조회 중...");
    $("#timeGrid").empty();
    state.startTime = "";
    updateSummary2();

    $.get("<%=ctxPath%>/api/reservationSlots.sp", {
      storeId: state.storeId,
      date: state.date,
      reason: state.reason
    }).done(function(res){
      const data = (typeof res === "string") ? JSON.parse(res) : res;
      if(!data.ok){
        $("#slotHint").text("");
        showErr("#err2", data.message || "슬롯 조회 실패");
        return;
      }

      const arr = data.availableStarts || [];
      if(arr.length === 0){
        $("#slotHint").text("가능한 시간이 없습니다.");
        return;
      }

      $("#slotHint").text(`가능 ${arr.length}개`);
      arr.forEach(t => {
        const $b = $(`<button type="button" class="tbtn">${t}</button>`);
        $b.on("click", function(){
          $(".tbtn").removeClass("on");
          $(this).addClass("on");
          state.startTime = t;
          updateSummary2();
        });
        $("#timeGrid").append($b);
      });

    }).fail(function(){
      $("#slotHint").text("");
      showErr("#err2","통신 실패");
    });
  }

  function updateSummary2(){
	  const reasonLabel = reasonText(state.reason);

	  let msg = "";
	  if(state.startTime){
	    msg = storeText(state.storeId) + " / " + state.date + " " + state.startTime + " / " + reasonLabel + " (" + state.durationMin + "분)";
	  } else {
	    msg = storeText(state.storeId) + " / " + (state.date || "(날짜 미선택)") + " / " + reasonLabel + " (" + state.durationMin + "분) / 시간 미선택";
	  }

	  $("#summaryText").text(msg);
	}


  function updateSummary3(){
	  const reasonLabel = reasonText(state.reason);

	  let text = storeText(state.storeId) + " / " + state.date + " " + state.startTime + " / " + reasonLabel + " (" + state.durationMin + "분)\n";
	  if(state.message && state.message.trim().length>0){
	    text += "메시지: " + state.message;
	  } else {
	    text += "메시지: 없음";
	  }
	  $("#summaryText3").text(text);
	}


  function submitReservation(){
    hideErr();

    const guestName = ($("#guestName").val() || "").trim();
    let guestPhone = ($("#guestPhone").val() || "").replace(/[^0-9]/g,"");

    if(!guestName){
      showErr("#err3","이름을 입력해주세요.");
      return;
    }
    if(!guestPhone){
      showErr("#err3","연락처를 입력해주세요.");
      return;
    }
    if(!state.storeId || !state.date || !state.startTime){
      showErr("#err3","예약 정보가 올바르지 않습니다. 이전 단계로 돌아가 다시 선택해주세요.");
      return;
    }

    $("#btnSubmit").prop("disabled", true);

    $.post("<%=ctxPath%>/api/reservations.sp", {
      storeId: state.storeId,
      reason: state.reason,
      date: state.date,
      startTime: state.startTime,
      guestName: guestName,
      guestPhone: guestPhone,
      message: state.message
    }).done(function(res){
      const data = (typeof res === "string") ? JSON.parse(res) : res;

      $("#resultBox").show();

      if(data.ok){
    	  $("#okBox").show().html(
			  "<div><strong>예약 확정 완료</strong></div>" +
			  "<div style='margin-top:6px;'>" +
			    storeText(state.storeId) + " / " +
			    state.date + " " + state.startTime + " / " +
			    reasonText(state.reason) + " (" + state.durationMin + "분)" +
			  "</div>"
			);

      } else {
        $("#failBox").show().text(data.message || "예약 실패");
      }

    }).fail(function(){
      $("#resultBox").show();
      $("#failBox").show().text("통신 실패");
    }).always(function(){
      $("#btnSubmit").prop("disabled", false);
    });
  }

  function storeText(id){
    if(id==="1") return "매장1";
    if(id==="2") return "매장2";
    if(id==="3") return "매장3";
    return "매장";
  }
  function reasonText(r){
    if(r==="FITTING") return "안경맞춤";
    if(r==="AS") return "A/S";
    return "시력검사";
  }
</script>
</body>
</html>
