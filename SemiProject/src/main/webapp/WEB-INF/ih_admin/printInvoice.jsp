<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>운송장 출력</title>
<style>
    body { font-family: 'Malgun Gothic', sans-serif; margin: 0; padding: 0; }
    .print-container { width: 400px; border: 2px solid #333; margin: 10px; padding: 20px; }
    .title { font-size: 24px; font-weight: bold; text-align: center; border-bottom: 2px solid #333; padding-bottom: 10px; }
    .section { margin-top: 15px; border-bottom: 1px solid #eee; padding-bottom: 10px; }
    .label { font-size: 12px; color: #666; }
    .content { font-size: 16px; font-weight: bold; margin-top: 3px; }
    .item-table { width: 100%; border-collapse: collapse; margin-top: 15px; }
    .item-table th, .item-table td { border: 1px solid #ccc; font-size: 13px; padding: 5px; text-align: center; }
    .item-table th { background: #f4f4f4; }
    
    @media print {
        .no-print { display: none; }
    }
</style>
</head>
<body onload="window.print();"> <div class="print-container">
        <div class="title">배송 운송장</div>
        
        <div class="section">
            <div class="label">보내는 분</div>
            <div class="content">쌍용 6반 1조 (02-1234-5678)</div>
        </div>
        
        <div class="section">
            <div class="label">받는 분 (수령인)</div>
            <div class="content">${orderInfo.name}</div>
            <div class="label" style="margin-top:5px;">주소</div>
            <div class="content" style="font-size:14px;">${orderInfo.postcode} <br> ${orderInfo.address} ${orderInfo.detailaddress}</div>
            <div class="label" style="margin-top:5px;">연락처</div>
            <div class="content">${orderInfo.mobile}</div>
        </div>

        <table class="item-table">
            <thead>
                <tr>
                    <th>상품명</th>
                    <th>수량</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="item" items="${detailList}">
                    <tr>
                        <td style="text-align: left;">${item.pname}</td>
                        <td>${item.odrqty}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        
        <div style="margin-top: 20px; text-align: center;">
            <div class="label">주문번호: ${orderInfo.odrcode}</div>
        </div>
    </div>

    <div class="no-print" style="margin: 20px;">
        <button onclick="window.print()">인쇄</button>
        <button onclick="window.close()">창 닫기</button>
    </div>

</body>
</html>

<script>


</script>