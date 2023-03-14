<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--@ page import="com.model2.mvc.service.domain.*" --%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>


<%--

	Purchase pur = (Purchase) request.getAttribute("pur");
	
--%>

<html>
<head>
<title>Insert title here</title>

<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
<script type="text/javascript">
	
	$(function() {
		
		$("form").attr("method", "POST").attr("action", "/purchase/updatePurchase?tranNo=0");
		
	});
	
</script>

</head>

<body>

<form name="updatePurchase">

다음과 같이 구매가 되었습니다.

<table border=1>
	<tr>
		<td>물품번호</td>
		
		<td>${pur.purchaseProd.prodNo}</td>
		<td></td>
	</tr>
	<tr>
		<td>구매자아이디</td>
		<td>${pur.buyer.userId}</td>
		<td></td>
	</tr>
	<tr>
		<td>구매방법</td>
		<td>
		
			${pur.paymentOption eq '1' ? "현금구매" : "신용구매" }
		
		</td>
		<td></td>
	</tr>
	<tr>
		<td>구매자이름</td>
		<td>${pur.receiverName}</td>
		<td></td>
	</tr>
	<tr>
		<td>구매자연락처</td>
		<td>${pur.receiverPhone}</td>
		<td></td>
	</tr>
	<tr>
		<td>구매자주소</td>
		<td>${pur.divyAddr}</td>
		<td></td>
	</tr>
		<tr>
		<td>구매요청사항</td>
		<td>${pur.divyRequest}</td>
		<td></td> 
	</tr>
	<tr>
		<td>배송희망일자</td>
		<td>${pur.divyDate}</td>
		<td></td>
	</tr>
</table>
</form>

</body>
</html>