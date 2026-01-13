<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<script type="text/javascript">
  alert("${message}");

  var shouldClose = "${requestScope.popup_close}" === "true";
  var loc = "${loc}";

  if (shouldClose) {
    try {
      if (window.opener && !window.opener.closed) {
        // ✅ 부모창을 '수정된 상세 URL'로 이동 (새로고침보다 확실)
        window.opener.location.href = loc;
      }
    } catch (e) {}

    window.close();
  } else {
    location.href = loc;
  }
</script>
    