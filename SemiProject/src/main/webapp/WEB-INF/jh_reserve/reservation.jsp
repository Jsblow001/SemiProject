<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% String ctxPath = request.getContextPath(); %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>방문 예약</title>
<script src="<%=ctxPath%>/js/jquery-3.7.1.min.js"></script>

<style>
/* =========================
   Reservation Page Namespace
   (공용 CSS 충돌 방지: .rs 안에서만 스타일 적용)
   ========================= */
.rs { font-family: Arial,"Noto Sans KR",sans-serif; color:#111; background:#fff; }
.rs * { box-sizing: border-box; }
.rs a { color: inherit; text-decoration: none; }

.rs-wrap { max-width: 980px; margin: 22px auto; padding: 0 16px; }
.rs-title { font-size: 22px; font-weight: 900; margin: 0 0 6px; }
.rs-sub { color:#666; font-size: 13px; margin-bottom: 14px; }

.rs-stepbar { display:flex; gap:10px; flex-wrap:wrap; margin: 12px 0 14px; }
.rs-chip {
  border:1px solid #ddd; border-radius:999px; padding:8px 12px;
  font-weight:800; font-size:13px; background:#fafafa;
}
.rs-chip.on { background:#111; color:#fff; border-color:#111; }

.rs-card {
  border:1px solid #e5e5e5; border-radius:14px; padding:16px; margin-top:12px;
}
.rs-row { margin: 12px 0; }
.rs-label { display:block; font-weight: 900; margin-bottom: 6px; }
.rs-input, .rs select, .rs textarea {
  width:100%; padding:10px 12px; border:1px solid #ddd; border-radius:10px;
  background:#fff; color:#111;
}
.rs textarea { min-height: 120px; resize: vertical; }
.rs-muted { color:#666; font-size: 13px; }

.rs-btns { display:flex; gap:10px; flex-wrap:wrap; margin-top:14px; align-items:center; }
.rs-btn {
  border:1px solid #ccc; background:#fff; border-radius:10px;
  padding:10px 14px; font-weight:900; cursor:pointer;
}
.rs-btn.primary { background:#111; color:#fff; border-color:#111; }
.rs-btn:disabled { opacity:.45; cursor:not-allowed; }

.rs-err { color:#c62828; font-weight: 900; display:none; margin-top: 10px; }

.rs-summary {
  border:1px dashed #ddd; border-radius:12px; padding:12px; background:#fafafa;
}
.rs-okbox {
  border:1px solid #d6ead6; background:#f3fff3; border-radius:12px; padding:14px;
}

/* ========== Slot Grid ========== */
#rsTimeGrid{
  display:grid;
  grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
  gap:10px;
  margin-top:10px;
}

/* slot은 div로 (button 공용 CSS 영향 제거) */
#rsTimeGrid .rs-slot{
  display:flex;
  flex-direction:column;
  align-items:center;
  justify-content:center;
  gap:4px;

  width:100%;
  min-height:56px;

  padding:10px 12px;
  border:1px solid #ddd;
  border-radius:14px;

  background:#fff !important;
  color:#111 !important;

  cursor:pointer;
  user-select:none;
  text-align:center;

  font-size:14px;
  line-height:1.2;

  /* 공용 CSS에서 filter/opacity 건드리는 경우 방지 */
  opacity:1 !important;
  filter:none !important;
}

#rsTimeGrid .rs-slot .rs-range{ font-size:12px; color:#666 !important; font-weight:800; }
#rsTimeGrid .rs-slot .rs-start{ font-size:15px; font-weight:900; }

/* 선택된 시작 슬롯 */
#rsTimeGrid .rs-slot.is-on{
  background:#111 !important;
  border-color:#111 !important;
  color:#fff !important;
}
#rsTimeGrid .rs-slot.is-on .rs-range{ color:#eaeaea !important; }

/* 60분 예약의 다음 슬롯(표시 가능할 때만) */
#rsTimeGrid .rs-slot.is-next{
  background:#333 !important;
  border-color:#333 !important;
  color:#fff !important;
  opacity:.75 !important;
}
#rsTimeGrid .rs-slot.is-next .rs-range{ color:#eaeaea !important; }

/* 키보드 포커스 */
#rsTimeGrid .rs-slot:focus{ outline: 3px solid rgba(0,0,0,.15); outline-offset: 2px; }
</style>
</head>

<body class="rs">
<div class="rs-wrap">

  <h2 class="rs-title">안경원 방문예약</h2>
  <div class="rs-sub">영업시간 11:00~20:00 · 30분 단위 예약 · A/S 30분 · 맞춤 60분</div>

  <div class="rs-stepbar">
    <div class="rs-chip on" id="rsChip1">1. 매장</div>
    <div class="rs-chip" id="rsChip2">2. 사유/시간</div>
    <div class="rs-chip" id="rsChip3">3. 정보입력</div>
  </div>

  <!-- STEP 1 -->
  <div class="rs-card" id="rsStep1">
    <div class="rs-row">
      <label class="rs-label">매장 선택</label>
      <select id="rsStoreId" class="rs-input">
        <option value="">선택하세요</option>
        <option value="1">매장1</option>
        <option value="2">매장2</option>
        <option value="3">매장3</option>
      </select>
      <div class="rs-muted" style="margin-top:6px;">* 매장명은 나중에 DB(tbl_store)에서 불러오도록 바꿔도 됨</div>
    </div>

    <div class="rs-btns">
      <button type="button" class="rs-btn primary" id="rsToStep2">다음</button>
    </div>
    <div class="rs-err" id="rsErr1"></div>
  </div>

  <!-- STEP 2 -->
  <div class="rs-card" id="rsStep2" style="display:none;">
    <div class="rs-row">
      <label class="rs-label">예약 이유</label>
      <div style="display:flex; gap:12px; flex-wrap:wrap;">
        <label><input type="radio" name="rsReason" value="VISION" checked> 시력검사(30분)</label>
        <label><input type="radio" name="rsReason" value="FITTING"> 안경맞춤(60분)</label>
        <label><input type="radio" name="rsReason" value="AS"> A/S(30분)</label>
      </div>
    </div>

    <div class="rs-row">
      <label class="rs-label">날짜 선택</label>
      <input type="date" id="rsDate" class="rs-input" />
      <div class="rs-muted" style="margin-top:6px;">* 해당 날짜의 “가능 시간”을 조회합니다.</div>
    </div>

    <div class="rs-row">
      <label class="rs-label">가능 시간 선택</label>
      <div class="rs-btns">
        <button type="button" class="rs-btn" id="rsFetchSlots">가능 시간 조회</button>
        <span class="rs-muted" id="rsSlotHint"></span>
      </div>

      <div id="rsTimeGrid"></div>
    </div>

    <div class="rs-row">
      <label class="rs-label">직원에게 남길 메시지(선택)</label>
      <textarea id="rsMessage" class="rs-input" placeholder="예) 아이가 함께 방문합니다 / 특정 프레임을 보고 싶습니다 / 증상이 있습니다 등"></textarea>
    </div>

    <div class="rs-row rs-summary">
      <div><strong>선택 요약</strong></div>
      <div class="rs-muted" id="rsSummary2">아직 시간 선택 전입니다.</div>
    </div>

    <div class="rs-btns">
      <button type="button" class="rs-btn" id="rsBack1">이전</button>
      <button type="button" class="rs-btn primary" id="rsToStep3">다음</button>
    </div>
    <div class="rs-err" id="rsErr2"></div>
  </div>

  <!-- STEP 3 -->
  <div class="rs-card" id="rsStep3" style="display:none;">
    <div class="rs-row">
      <label class="rs-label">이름(필수)</label>
      <input type="text" id="rsGuestName" class="rs-input" value="${prefillName}" placeholder="홍길동" />
    </div>

    <div class="rs-row">
      <label class="rs-label">연락처(필수)</label>
      <input type="text" id="rsGuestPhone" class="rs-input" value="${prefillMobile}" placeholder="010-1234-5678" />
      <div class="rs-muted" style="margin-top:6px;">* 하이픈은 자동 제거됩니다.</div>
    </div>

    <div class="rs-row rs-summary">
      <div><strong>예약 정보 확인</strong></div>
      <div class="rs-muted" id="rsSummary3"></div>
    </div>

    <div class="rs-btns">
      <button type="button" class="rs-btn" id="rsBack2">이전</button>
      <button type="button" class="rs-btn primary" id="rsSubmit">예약 확정</button>
    </div>
    <div class="rs-err" id="rsErr3"></div>

    <div class="rs-card" id="rsResultBox" style="display:none; margin-top:14px;">
      <div class="rs-okbox" id="rsOkBox" style="display:none;"></div>
      <div class="rs-err" id="rsFailBox" style="display:none;"></div>
      <div class="rs-btns" style="margin-top:12px;">
        <button type="button" class="rs-btn" id="rsGoMain">메인으로</button>
        <a class="rs-btn" href="<%=ctxPath%>/myReservations.sp">내 예약 보기(회원)</a>
      </div>
    </div>
  </div>

</div>

<script>
/* =========================
   State
   ========================= */
const rsState = {
  storeId: "",
  reason: "VISION",
  date: "",
  durationMin: 30,
  startTime: "",
  message: "",
  // 슬롯 연속 체크용 (서버가 start만 줘도 판단 가능)
  availableSet: new Set()
};

$(function(){
  // 날짜 기본값: 오늘
  const d = new Date();
  const yyyy = d.getFullYear();
  const mm = String(d.getMonth()+1).padStart(2,'0');
  const dd = String(d.getDate()).padStart(2,'0');
  $("#rsDate").val(yyyy + "-" + mm + "-" + dd);

  rsState.date = $("#rsDate").val();

  $("#rsToStep2").on("click", function(){
    rsHideErr();
    const storeId = $("#rsStoreId").val();
    if(!storeId){
      rsShowErr("#rsErr1", "매장을 선택해주세요.");
      return;
    }
    rsState.storeId = storeId;
    rsGoStep(2);
  });

  $("#rsBack1").on("click", function(){ rsHideErr(); rsGoStep(1); });

  $("input[name='rsReason']").on("change", function(){
    rsState.reason = $("input[name='rsReason']:checked").val();
    rsState.durationMin = (rsState.reason === "FITTING") ? 60 : 30;

    rsClearSlotSelection();
    rsState.startTime = "";
    $("#rsTimeGrid").empty();
    $("#rsSlotHint").text("");
    rsUpdateSummary2();
  });

  $("#rsDate").on("change", function(){
    rsState.date = $("#rsDate").val();
    rsClearSlotSelection();
    rsState.startTime = "";
    $("#rsTimeGrid").empty();
    rsUpdateSummary2();
  });

  $("#rsFetchSlots").on("click", rsFetchSlots);

  $("#rsToStep3").on("click", function(){
    rsHideErr();
    if(!rsState.date){
      rsShowErr("#rsErr2", "날짜를 선택해주세요.");
      return;
    }
    if(!rsState.startTime){
      rsShowErr("#rsErr2", "시간을 선택해주세요.");
      return;
    }
    rsState.message = $("#rsMessage").val() || "";
    rsUpdateSummary3();
    rsGoStep(3);
  });

  $("#rsBack2").on("click", function(){ rsHideErr(); rsGoStep(2); });

  $("#rsSubmit").on("click", rsSubmitReservation);
  
  $("#rsGoMain").on("click", function(){
	  const go = "<%=ctxPath%>/index.sp";
	
	  // ✅ iframe(모달)로 열린 경우: 부모에게 "닫고 메인 새로고침" 요청
	  try{
	    if(window.parent && window.parent !== window && window.parent.closeReservationModal){
	      window.parent.closeReservationModal({ reloadMain:true, goUrl: go });
	      return;
	    }
	  }catch(e){}
	
	  // ✅ 혹시 단독 페이지로 열렸다면 그냥 이동
	  location.href = go + "?_=" + Date.now();
   });


  rsUpdateSummary2();
  
  //슬롯 클릭 (이벤트 위임: 동적 생성된 슬롯도 항상 잡힘)
  $("#rsTimeGrid")
    .off("click", ".rs-slot")
    .on("click", ".rs-slot", function(e){
      e.preventDefault();
      const t = $(this).attr("data-time");
      rsSelectSlot(t);
    });

  // 키보드 선택(Enter/Space)
  $("#rsTimeGrid")
    .off("keydown", ".rs-slot")
    .on("keydown", ".rs-slot", function(e){
      if(e.key === "Enter" || e.key === " "){
        e.preventDefault();
        const t = $(this).attr("data-time");
        rsSelectSlot(t);
      }
    });

}); // end of $(function(){

/* =========================
   Step / UI helpers
   ========================= */
function rsGoStep(n){
  $("#rsStep1,#rsStep2,#rsStep3").hide();
  $("#rsChip1,#rsChip2,#rsChip3").removeClass("on");
  $("#rsResultBox").hide();
  $("#rsOkBox,#rsFailBox").hide();

  if(n===1){ $("#rsStep1").show(); $("#rsChip1").addClass("on"); }
  if(n===2){ $("#rsStep2").show(); $("#rsChip2").addClass("on"); rsUpdateSummary2(); }
  if(n===3){ $("#rsStep3").show(); $("#rsChip3").addClass("on"); rsUpdateSummary3(); }
}

function rsHideErr(){
  $("#rsErr1,#rsErr2,#rsErr3").hide().text("");
  $("#rsFailBox").hide().text("");
}

function rsShowErr(sel, msg){
  $(sel).text(msg).show();
}

function rsStoreText(id){
  if(id==="1") return "매장1";
  if(id==="2") return "매장2";
  if(id==="3") return "매장3";
  return "매장";
}

function rsReasonText(r){
  if(r==="FITTING") return "안경맞춤";
  if(r==="AS") return "A/S";
  return "시력검사";
}

function rsUpdateSummary2(){
  const reasonLabel = rsReasonText(rsState.reason);

  if(rsState.startTime){
    const endTime = rsCalcEndTime(rsState.startTime, rsState.durationMin);
    $("#rsSummary2").text(
 		  rsStoreText(rsState.storeId) + " / " +
 		  rsState.date + " " + rsState.startTime + " ~ " + endTime + " / " +
 		  reasonLabel + " (" + rsState.durationMin + "분)"
 		);
   } 

}

function rsUpdateSummary3(){
  const reasonLabel = rsReasonText(rsState.reason);
  const endTime = rsState.startTime ? rsCalcEndTime(rsState.startTime, rsState.durationMin) : "";
  let text =
	  rsStoreText(rsState.storeId) + " / " +
	  rsState.date + " " +
	  rsState.startTime + (endTime ? (" ~ " + endTime) : "") + " / " +
	  reasonLabel + " (" + rsState.durationMin + "분)\n";

	text += (rsState.message && rsState.message.trim())
	  ? ("메시지: " + rsState.message)
	  : "메시지: 없음";

  $("#rsSummary3").text(text);
}

/* =========================
   Slots
   ========================= */
function rsFetchSlots(){
  rsHideErr();

  rsState.reason = $("input[name='rsReason']:checked").val();
  rsState.durationMin = (rsState.reason === "FITTING") ? 60 : 30;
  rsState.date = $("#rsDate").val();

  if(!rsState.date){
    rsShowErr("#rsErr2", "날짜를 선택해주세요.");
    return;
  }

  $("#rsSlotHint").text("조회 중...");
  $("#rsTimeGrid").empty();
  rsClearSlotSelection();
  rsState.startTime = "";
  rsUpdateSummary2();

  $.get("<%=ctxPath%>/api/reservationSlots.sp", {
    storeId: rsState.storeId,
    date: rsState.date,
    reason: rsState.reason
  }).done(function(res){
    const data = (typeof res === "string") ? JSON.parse(res) : res;

    if(!data.ok){
      $("#rsSlotHint").text("");
      rsShowErr("#rsErr2", data.message || "슬롯 조회 실패");
      return;
    }

    // normalize: "15:30" 형태만 남기기
    const raw = data.availableStarts || [];
    const times = raw
      .map(x => (""+x).trim())
      .map(s => {
        const m = s.match(/^(\d{1,2}):(\d{2})/);
        if(!m) return "";
        const hh = String(parseInt(m[1],10)).padStart(2,"0");
        const mm = m[2];
        return hh + ":" + mm;

      })
      .filter(s => s.length > 0);

    rsState.availableSet = new Set(times);

    if(times.length === 0){
      $("#rsSlotHint").text("가능한 시간이 없습니다.");
      return;
    }

    $("#rsSlotHint").text(`가능 ${times.length}개`);

    times.forEach(function(start){
   	  const slotEnd = rsCalcEndTime(start, 30);

   	  const $slot = $("<div>", {
   	    "class": "rs-slot",
   	    "data-time": start,
   	    "role": "button",
   	    "tabindex": 0,
   	    "aria-label": "예약시간 " + start
   	  });

   	  $slot.append($("<div>", { "class": "rs-range", text: start + " ~ " + slotEnd }));
   	  $slot.append($("<div>", { "class": "rs-start", text: start }));

   	  $("#rsTimeGrid").append($slot);
   	});


  }).fail(function(){
    $("#rsSlotHint").text("");
    rsShowErr("#rsErr2", "통신 실패");
  });
}

function rsClearSlotSelection(){
  $("#rsTimeGrid .rs-slot").removeClass("is-on is-next");
}

function rsSelectSlot(startHHMM){
  rsHideErr();

  // ✅ 같은 슬롯을 다시 누르면 "선택 해제" (원하면 이 기능 빼도 됨)
  if(rsState.startTime === startHHMM){
    rsClearSlotSelection();
    rsState.startTime = "";
    rsUpdateSummary2();
    return;
  }

  rsClearSlotSelection();

  const $start = $("#rsTimeGrid .rs-slot[data-time=\"" + startHHMM + "\"]");
  if(!$start.length) return;


  if(rsState.durationMin === 60){
    const nextHHMM = rsCalcEndTime(startHHMM, 30);

    // ✅ 연속 슬롯 가능 여부는 Set으로 판단 (버튼 DOM 존재 여부에 의존하지 않음)
    if(!rsState.availableSet.has(nextHHMM)){
      rsShowErr("#rsErr2", "안경맞춤(60분)은 연속 2슬롯이 필요합니다. 다른 시간을 선택해주세요.");
      rsState.startTime = "";
      rsUpdateSummary2();
      return;
    }

    $start.addClass("is-on");

    // 화면에 다음 슬롯이 렌더링되어 있으면 강조 표시도 해줌
    const $next = $(`#rsTimeGrid .rs-slot[data-time='${nextHHMM}']`);
    if($next.length) $next.addClass("is-next");
  } else {
    $start.addClass("is-on");
  }

  rsState.startTime = startHHMM;
  rsUpdateSummary2();
}

function rsCalcEndTime(hhmm, addMin){
  const s = (hhmm || "").trim();
  const m = s.match(/^(\d{1,2}):(\d{2})/);
  if(!m) return "";

  let h = parseInt(m[1], 10);
  let mm = parseInt(m[2], 10);
  if(isNaN(h) || isNaN(mm)) return "";

  let total = h * 60 + mm + addMin;
  total = ((total % 1440) + 1440) % 1440;

  const nh = Math.floor(total / 60);
  const nm = total % 60;

  return String(nh).padStart(2,"0") + ":" + String(nm).padStart(2,"0");
}

/* =========================
   Submit
   ========================= */
function rsSubmitReservation(){
  rsHideErr();

  const guestName = ($("#rsGuestName").val() || "").trim();
  const guestPhone = ($("#rsGuestPhone").val() || "").replace(/[^0-9]/g,"");

  if(!guestName){
    rsShowErr("#rsErr3", "이름을 입력해주세요.");
    return;
  }
  if(!guestPhone){
    rsShowErr("#rsErr3", "연락처를 입력해주세요.");
    return;
  }
  if(!rsState.storeId || !rsState.date || !rsState.startTime){
    rsShowErr("#rsErr3", "예약 정보가 올바르지 않습니다. 이전 단계로 돌아가 다시 선택해주세요.");
    return;
  }

  $("#rsSubmit").prop("disabled", true);

  $.post("<%=ctxPath%>/api/reservations.sp", {
    storeId: rsState.storeId,
    reason: rsState.reason,
    date: rsState.date,
    startTime: rsState.startTime,
    guestName: guestName,
    guestPhone: guestPhone,
    message: rsState.message
  }).done(function(res){
    const data = (typeof res === "string") ? JSON.parse(res) : res;

    $("#rsResultBox").show();

    if(data.ok){
      const endTime = rsCalcEndTime(rsState.startTime, rsState.durationMin);
      $("#rsOkBox").show().html(
        "<div><strong>예약 확정 완료</strong></div>" +
        "<div style='margin-top:6px;'>" +
          rsStoreText(rsState.storeId) + " / " +
          rsState.date + " " + rsState.startTime + " ~ " + endTime + " / " +
          rsReasonText(rsState.reason) + " (" + rsState.durationMin + "분)" +
        "</div>"
      );
      $("#rsFailBox").hide();
    } else {
      $("#rsFailBox").show().text(data.message || "예약 실패");
      $("#rsOkBox").hide();
    }

  }).fail(function(){
    $("#rsResultBox").show();
    $("#rsFailBox").show().text("통신 실패");
    $("#rsOkBox").hide();
  }).always(function(){
    $("#rsSubmit").prop("disabled", false);
  });
}
</script>
</body>
</html>
