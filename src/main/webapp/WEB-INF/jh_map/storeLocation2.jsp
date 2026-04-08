<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% String ctxPath = request.getContextPath(); %>

<jsp:include page="../header.jsp" />

<style type="text/css">
/* ✅ 제목 중앙 */
div#title{
  text-align:center;
  font-size:26px;
  font-weight:900;
  margin:20px 0 12px;
}

/* ✅ 탭 컨테이너 */
div#map_container{ width:100%; }

div#map_container > div#tab{
  width:100%;
  max-width:1200px;
  margin:0 auto;
  border:1px solid #ccc;
  background:#f1f1f1;
  border-radius:12px;
  overflow:hidden;
  display:flex;
}

div#tab > button{
  flex:1;
  border:none;
  outline:none;
  cursor:pointer;
  padding:14px 16px;
  font-size:17px;
  background:transparent;
}

.tab_active{
  background:navy !important;
  color:#fff !important;
}

/* ✅ 레이아웃 */
.storeLayout{
  width:100%;
  max-width:1200px;
  margin:14px auto 60px;
  display:flex;
  gap:18px;
  align-items:stretch;
}

/* 좌측 패널 */
.storePanel{
  flex:2;
  background:#fff;
  border:1px solid #eee;
  border-radius:14px;
  overflow:hidden;
  box-shadow:0 8px 20px rgba(0,0,0,.06);
}

.storePanel .imgBox{
  width:100%;
  aspect-ratio:4 / 3;
  background:#fafafa;
  overflow:hidden;
}
.storePanel .imgBox img{
  width:100%;
  height:100%;
  object-fit:cover;
  display:block;
}

.storePanel .body{ padding:14px 14px 18px; }
.storePanel .name{
  font-size:18px;
  font-weight:900;
  margin-bottom:6px;
}
.storePanel .addr{
  font-size:13px;
  color:#444;
  line-height:1.55;
  margin-bottom:12px;
}

.storePanel .meta{
  display:flex;
  flex-direction:column;
  gap:6px;
  font-size:13px;
  color:#222;
  margin-bottom:14px;
}
.storePanel .meta .label{
  display:inline-block;
  width:74px;
  color:#777;
  font-weight:700;
}

.storePanel .actions{ display:flex; gap:10px; }
.storePanel .reserveBtn{
  flex:1;
  height:44px;
  display:flex;
  align-items:center;
  justify-content:center;
  border-radius:10px;
  background:#111;
  color:#fff !important;
  font-weight:900;
  text-decoration:none;
}

/* 우측 지도 */
.mapArea{
  flex: 3;
  padding-right: 10px;
  display:flex;          /* ✅ map이 height:100% 먹게 */
}

/* ✅ 지도는 "패널 높이" 그대로 맞춤 (JS로 height px 세팅) */
div.mapArea > div.map{
  width: 100%;
  height: 100%;          /* ✅ storeLayout stretch 높이 */
  border-radius: 14px;
  overflow: hidden;
  border: 1px solid #eee;
  display:none;
}


/* (기존 인포윈도우 스타일 유지) */
div.mycontent{ width:300px; padding:5px 3px; }
div.mycontent>.title{
  font-size:12pt; font-weight:bold;
  background:#d95050; color:#fff;
}
div.mycontent>.title>a{ text-decoration:none; color:#fff; }
div.mycontent>.desc{
  padding:10px 0 0 0;
  color:#000; font-weight:normal; font-size:9pt;
}
div.mycontent>.desc>img{ width:50px; height:50px; }

/* 모바일 */
@media(max-width:980px){
  .storeLayout{ flex-direction:column; }
  .mapArea{ padding-right:0; }
  div.mapArea > div.map{
    aspect-ratio:16 / 10;
    min-height:380px;
  }
}
</style>

<div id="title">매장 오시는 길</div>
<div id="map_container"></div>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=1b3a5f30148ffec815062b399c969515"></script>

<script type="text/javascript">
$(document).ready(function(){

  window.storeJson = [];
  window.arr_mapobj = [];

  // ✅ 탭 클릭(이벤트 위임)
  $(document).on("click", "div#tab > button", function(){
    var index = $("div#tab > button").index($(this));
    activateStore(index);
  });

  $.ajax({
    url: "<%=ctxPath%>/storeLocationJSON.sp",
    async: false,
    dataType: "json",
    success: function(json){

      window.storeJson = json;

      // ✅ HTML 만들기 (템플릿리터럴 금지)
      var v_html = "";

      v_html += '<p style="width:100%; max-width:1200px; margin:0 auto 8px; color:#666;">';
     
      v_html += '</p>';

      v_html += '<div id="tab">';
      for(var i=0; i<json.length; i++){
        v_html += '<button type="button">' + json[i].storename + '</button>';
      }
      v_html += '</div>';

      v_html += '<div class="storeLayout">';

      // 좌측 패널
      v_html += '  <div class="storePanel" id="storePanel">';
      v_html += '    <div class="imgBox">';
      v_html += '      <img id="storeImg" src="" alt="매장 이미지">';
      v_html += '    </div>';
      v_html += '    <div class="body">';
      v_html += '      <div class="name" id="storeName"></div>';
      v_html += '      <div class="addr" id="storeAddr"></div>';
      v_html += '      <div class="meta">';
      v_html += '        <div><span class="label">매장번호</span> <span id="storeTel">-</span></div>';
      v_html += '        <div><span class="label">영업시간</span> <span id="storeHours">-</span></div>';
      v_html += '      </div>';
      v_html += '      <div class="actions">';
      v_html += '        <a id="reserveBtn" class="reserveBtn" href="#">예약 바로가기</a>';
      v_html += '      </div>';
      v_html += '    </div>';
      v_html += '  </div>';

      // 우측 지도
      v_html += '  <div class="mapArea">';
      for(var j=0; j<json.length; j++){
        v_html += '<div class="map" id="map' + j + '"></div>';
      }
      v_html += '  </div>';

      v_html += '</div>';

      $("#map_container").html(v_html);

      // ✅ 지도 DOM 확보
      var arr_mapContainer = [];
      for(var k=0; k<json.length; k++){
        arr_mapContainer.push(document.getElementById("map" + k));
      }

      // ✅ 첫 지도는 먼저 보여주고 생성(중요!)
      $("#map0").show();

      // ✅ 지도 객체 생성
      var arr_mapobj = [];
      for(var m=0; m<json.length; m++){
        var opt = {
          center: new kakao.maps.LatLng(json[m].lat, json[m].lng),
          level: 4
        };

        var mapobj = new kakao.maps.Map(arr_mapContainer[m], opt);

        // 컨트롤
        var mapTypeControl = new kakao.maps.MapTypeControl();
        var zoomControl = new kakao.maps.ZoomControl();
        mapobj.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
        mapobj.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

        arr_mapobj.push(mapobj);
      }

      window.arr_mapobj = arr_mapobj;

      // ✅ 마커 + 인포윈도우
      for(var n=0; n<json.length; n++){
        var latlng = new kakao.maps.LatLng(json[n].lat, json[n].lng);

        var marker = new kakao.maps.Marker({
          map: arr_mapobj[n],
          position: latlng
        });

        var html_content = ""
          + "<div class='mycontent'>"
          + "  <div class='title'>"
          + "    <a href='" + json[n].storeurl + "' target='_blank'><strong>" + json[n].storename + "</strong></a>"
          + "  </div>"
          + "  <div class='desc'>"
          + "    <img src='<%=ctxPath%>/img/" + json[n].storeimg + "'>"
          + "    <span class='address'>" + json[n].storeaddress + "</span>"
          + "  </div>"
          + "</div>";

        var infowindow = new kakao.maps.InfoWindow({
          content: html_content,
          removable: true
        });

        (function(mapobj, marker, infowindow, idx){
          kakao.maps.event.addListener(marker, "mouseover", function(){
            infowindow.open(mapobj, marker);
          });
          kakao.maps.event.addListener(marker, "mouseout", function(){
            infowindow.close();
          });
          // ✅ 마커 클릭하면 해당 탭으로 이동 (선택 UX)
          kakao.maps.event.addListener(marker, "click", function(){
            $("div#tab > button").eq(idx).trigger("click");
          });
        })(arr_mapobj[n], marker, infowindow, n);
      }

      // ✅ 첫 진입: 무조건 도산(0번)
      activateStore(0);
    },
    error: function(request, status, error){
      alert("code: "+request.status+"\nmessage: "+request.responseText+"\nerror: "+error);
    }
  });

}); // end ready


function activateStore(index){
  // 지도 show/hide
  $("div.mapArea > div.map").hide();
  $("#map" + index).show();

  // 탭 active
  $("div#tab > button").removeClass("tab_active");
  $("div#tab > button").eq(index).addClass("tab_active");

  // 패널 갱신
  renderStorePanel(window.storeJson[index]);

  // ✅ display:none → block 된 지도는 relayout 필수
  if(window.arr_mapobj && window.arr_mapobj[index]){
    window.arr_mapobj[index].relayout();
    window.arr_mapobj[index].setCenter(
      new kakao.maps.LatLng(window.storeJson[index].lat, window.storeJson[index].lng)
    );
  }
}


function renderStorePanel(item){
  var ctx = "<%=request.getContextPath()%>";

  $("#storeImg").attr("src", ctx + "/img/" + item.storeimg);
  $("#storeName").text(item.storename);
  $("#storeAddr").text(item.storeaddress);

  $("#storeTel").text(item.tel ? item.tel : "-");
  $("#storeHours").text(item.hours ? item.hours : "-");

  var ru = item.reserveUrl ? item.reserveUrl : "";
  
  if(ru.startsWith("/")){
    ru = ctx + ru;
  } else if(ru){
    ru = ctx + "/" + ru;
  }

  $("#reserveBtn").attr("href", ru ? ru : "#");
}
</script>

<jsp:include page="../footer.jsp" />
