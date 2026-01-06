<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<script type="text/javascript">

 //	alert("${requestScope.message}"); // 메시지 출력해주기
	alert("${message}");              // 메시지 출력해주기
	
	
    
    if (${not empty requestScope.popup_close && requestScope.popup_close == true}) {
        opener.history.go(0);  // 부모창 새로고침
        self.close();          // 팝업 닫기
    } else {
        location.href = "${loc}";
    }


</script>    