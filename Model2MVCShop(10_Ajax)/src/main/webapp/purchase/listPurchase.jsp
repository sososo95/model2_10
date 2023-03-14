<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%--@page import="com.model2.mvc.common.util.CommonUtil"--%>
<%--@ page import="com.model2.mvc.service.domain.*" --%>
<%--@page import="java.util.ArrayList"--%>
<%--@ page import="java.util.*"  --%>
<%--@page import="com.model2.mvc.common.*"--%>
<%--@page import="java.util.HashMap"--%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>

<%--

	List<Purchase> list = (List<Purchase>)request.getAttribute("list");
	Page resultPage=(Page)request.getAttribute("resultPage");
	Search searchVO = (Search)request.getAttribute("search");
		
--%>

<html>
<head>
<title>구매 목록조회</title>

<link rel="stylesheet" href="/css/admin.css" type="text/css">

<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
<script type="text/javascript">


	$(function() {
		

		$( ".ct_list_pop .ct_prodNo" ).on("click" , function() {
			self.location = "/purchase/getPurchase?prodNo=" + $(this).find("input").val();
		});
		
		$( ".ct_list_pop td:nth-child(3)" ).on("click" , function() {
			self.location = "/user/getUser?userId=" + $(this).find("input").val();
		});
		
		$( ".ct_list_pop, .ct_user" ).css("color" , "green");
					
		$(".ct_list_pop:nth-child(4n+6)" ).css("background-color" , "whitesmoke");
	
	});	


</script>

<body bgcolor="#ffffff" text="#000000">

<div style="width: 98%; margin-left: 10px;">

<form name="detailForm">

<table width="100%" height="37" border="0" cellpadding="0"	cellspacing="0">
	<tr>
		<td width="15" height="37"><img src="/images/ct_ttl_img01.gif"width="15" height="37"></td>
		<td background="/images/ct_ttl_img02.gif" width="100%" style="padding-left: 10px;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="93%" class="ct_ttl01">구매 목록조회</td>
				</tr>
			</table>
		</td>
		<td width="12" height="37"><img src="/images/ct_ttl_img03.gif"	width="12" height="37"></td>
	</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0"	style="margin-top: 10px;">
	<tr>
		<td colspan="11">전체 ${resultPage.totalCount} 건수, 현재 ${resultPage.page} 페이지</td>
	</tr>
	<tr>
		<td class="ct_list_b" width="100">상품번호(조회)</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">회원ID</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">회원명</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">전화번호</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">배송현황</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">정보수정</td>
	</tr>
	<tr>
		<td colspan="11" bgcolor="808285" height="1"></td>
	</tr>

	
	<c:forEach var= "i" items="${list}">
		<c:set var="num" value="${ num+1 }" />
		
	<tr class="ct_list_pop">
		
		

			<c:choose>
				<c:when test = "${ fn:trim(i.tranCode) eq '' }" >
					<td align="center" class="ct_prodNo">
						<!-- <a href="/purchase/getPurchase?prodNo=${i.purchaseProd.prodNo}">${i.purchaseProd.prodNo}</a>-->
						${i.purchaseProd.prodNo} <input type="hidden" value="${i.purchaseProd.prodNo}" id="tranCode_1" />
					</td>
				</c:when>
				<c:when test = "${ fn:trim(i.tranCode) eq '1' }" >	
					<td align="center" class="ct_prodNo">
						<!--  <a href="/purchase/getPurchase?prodNo=${i.purchaseProd.prodNo}">${i.purchaseProd.prodNo}</a>-->
						${i.purchaseProd.prodNo} <input type="hidden" value="${i.purchaseProd.prodNo}" id="tranCode_1" />
					</td>
				</c:when>
				<c:otherwise>
					<td align="center">
						${i.purchaseProd.prodNo}(불가)
					</td>
				</c:otherwise>
			</c:choose>
			
			
		
		<td></td>
		<td align="left" class="ct_user">
			<!--  <a href="/user/getUser?userId=${i.buyer.userId}">${i.buyer.userId}</a> -->
			${i.buyer.userId} <input type="hidden" value="${i.buyer.userId}" id="prodNo"  />
		</td>
		<td></td>
		<td align="left">${i.receiverName}</td>
		<td></td>
		<td align="left">${i.receiverPhone}</td>
		<td></td>
		<td align="left">
		
			<c:choose>
				<c:when test = "${ fn:trim(i.tranCode) eq '' }" >
					
				</c:when>
				<c:when test = "${ fn:trim(i.tranCode) eq '1' }" >
					구매완료
				</c:when>
				<c:when test = "${ fn:trim(i.tranCode) eq '2' }" >
					배송중
				</c:when>
				<c:when test = "${ fn:trim(i.tranCode) eq '3' }" >
					배송완료
				</c:when>
				<c:otherwise>
					
				</c:otherwise>
			</c:choose>
		
		
		</td>
		<td></td>
		<td align="left">
		
			<c:choose>
				<c:when test = "${ fn:trim(i.tranCode) eq '' }" >
					
				</c:when>
				<c:when test = "${ fn:trim(i.tranCode) eq '1' }" >
					배송준비중
				</c:when>
				<c:when test = "${ fn:trim(i.tranCode) eq '2' }" >
					<input type="hidden" id="tranCode_3" />
					<a href="/purchase/updateTranCode?tranNo=${i.tranNo}&tranCode=3">물건도착</a> 
				</c:when>
				<c:otherwise>
					
				</c:otherwise>
			</c:choose>
		
	
		</td>
	</tr>
	<tr>
		<td colspan="11" bgcolor="D6D7D6" height="1"></td>
	</tr>
			
	</c:forEach>	
		
	<%-- <%
	for(int i=0; i<list.size(); i++) {
		Purchase purchasevo = list.get(i);
	%>
	
	<tr class="ct_list_pop">
		<td align="center">
		

			<% if(purchasevo.getTranCode() == null || purchasevo.getTranCode().trim().equals("0")){ %>
				<a href="/getPurchase.do?prodNo=<%= purchasevo.getPurchaseProd().getProdNo() %>"><%= purchasevo.getPurchaseProd().getProdNo()%></a>
			<% } else if(purchasevo.getTranCode() == null || purchasevo.getTranCode().trim().equals("1")) { %>
				<a href="/getPurchase.do?prodNo=<%= purchasevo.getPurchaseProd().getProdNo() %>"><%= purchasevo.getPurchaseProd().getProdNo() %></a>
			<% } else {%>
				<%= purchasevo.getPurchaseProd().getProdNo() %>
			<% }  %>
			
			
		</td>
		<td></td>
		<td align="left">
			<a href="/getUser.do?userId=<%= purchasevo.getBuyer().getUserId() %>"><%= purchasevo.getBuyer().getUserId() %></a>
		</td>
		<td></td>
		<td align="left"><%= purchasevo.getReceiverName() %></td>
		<td></td>
		<td align="left"><%= purchasevo.getReceiverPhone() %></td>
		<td></td>
		<td align="left">
			<% if(purchasevo.getTranCode() == null || purchasevo.getTranCode().trim().equals("0")){ %>
				
			<% } else if(purchasevo.getTranCode().trim().equals("1")){ %>
				구매완료 
			<% } else if(purchasevo.getTranCode().trim().equals("2")){ %>
				배송중
			<% } else if(purchasevo.getTranCode().trim().equals("3")){ %>
				배송완료
			<% } else { %>
			
			<% } %>
		</td>
		<td></td>
		<td align="left">
			<% if(purchasevo.getTranCode() == null || purchasevo.getTranCode().trim().equals("0")){ %>
				
			<% } else if(purchasevo.getTranCode().trim().equals("1")){ %>
				배송준비중
			<% } else if(purchasevo.getTranCode().trim().equals("2")){ %>
				<a href="/updateTranCode.do?tranNo=<%=purchasevo.getTranNo()%>&tranCode=3">물건도착</a> 
			<% } else {%>
				
			<% } %>
		</td>
	</tr>
	<tr>
		<td colspan="11" bgcolor="D6D7D6" height="1"></td>
	</tr>
	<% } %> --%>
	
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top: 10px;">
	<tr>
		<td align="center">
		 	
		 	<c:if test = "${resultPage.page <= resultPage.pageUnit }" >
		 	
		 	</c:if>
		 	<c:if test="${ resultPage.page > resultPage.pageUnit }">
					<a href="/purchase/listPurchase?page=${resultPage.endUnitPage - resultPage.pageUnit}"><< 이전 &nbsp</a>
			</c:if>
				
			<c:forEach var="i"  begin="${resultPage.beginUnitPage}" end="${resultPage.endUnitPage}" step="1">
				<a href="/purchase/listPurchase?page=${i}">${i}</a>
			</c:forEach>
				
			<c:if test="${ resultPage.endUnitPage >= resultPage.maxPage }">
					
			</c:if>
			<c:if test="${ resultPage.endUnitPage < resultPage.maxPage }">
					<a href="/purchase/listPurchase?page=${resultPage.endUnitPage+1}"> &nbsp 이후 >></a>
			</c:if>
		 		 		
		</td>
	</tr>
</table>

<!--  페이지 Navigator 끝 -->
</form>

</div>

</body>
</html>