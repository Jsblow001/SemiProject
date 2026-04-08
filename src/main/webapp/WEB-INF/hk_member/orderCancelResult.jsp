<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>처리결과</title>
</head>

<script>
alert("${msg}");
opener.location.reload();
window.close();
</script>

