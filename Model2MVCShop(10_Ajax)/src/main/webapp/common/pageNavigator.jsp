<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page contentType="text/html; charset=euc-kr"%>


<c:choose>
	<c:when test="${ window == 'user' }">
		<c:if test="${ resultPage.page <= resultPage.pageUnit }">

		</c:if>
		<c:if test="${ resultPage.page > resultPage.pageUnit }">
			<a
				href="javascript:fncGetUserList('${ resultPage.endUnitPage-resultPage.pageUnit}');">
				<< 이전 &nbsp </a>
		</c:if>

		<c:forEach var="i" begin="${resultPage.beginUnitPage}"
			end="${resultPage.endUnitPage}" step="1">
			<a href="javascript:fncGetUserList('${ i }');">${ i }</a>
		</c:forEach>

		<c:if test="${ resultPage.endUnitPage >= resultPage.maxPage }">

		</c:if>
		<c:if test="${ resultPage.endUnitPage < resultPage.maxPage }">
			<a href="javascript:fncGetUserList('${resultPage.endUnitPage+1}');">
				&nbsp 이후 >></a>
		</c:if>
	</c:when>
	<c:when test="${ window == 'product' }">
		<c:if test="${resultPage.page <= resultPage.pageUnit }">

		</c:if>
		<c:if test="${resultPage.page > resultPage.pageUnit }">
			<a
				href="javascript:fncGetProductList('${ resultPage.endUnitPage-resultPage.pageUnit}', '${param.menu}');">
				<< 이전 &nbsp</a>
		</c:if>

		<c:forEach var="i" begin="${resultPage.beginUnitPage}"
			end="${resultPage.endUnitPage}" step="1">
			<a href="javascript:fncGetProductList('${ i }', '${param.menu}');">${ i }</a>
		</c:forEach>

		<c:if test="${ resultPage.endUnitPage >= resultPage.maxPage }">

		</c:if>
		<c:if test="${ resultPage.endUnitPage < resultPage.maxPage }">
			<a
				href="javascript:fncGetProductList('${resultPage.endUnitPage+1}', '${param.menu}');">
				&nbsp 이후 >></a>
		</c:if>
	</c:when>
</c:choose>
