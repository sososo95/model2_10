<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
    
<%--
<%@page import="com.model2.mvc.common.util.CommonUtil"%>
<%@ page import="java.util.*"  %>
<%@ page import="com.model2.mvc.service.domain.*" %>
<%@ page import="com.model2.mvc.common.*" %>


<%
	String title = null;
	String type = null;
	String window = null;

	if(request.getParameter("menu") != null){
		if(request.getParameter("menu").equals("search")){
	title = "상품 목록조회";
	type = "search";
	window = "/getProduct.do";
	System.out.println("상품 목록 조회 우선 이상없이 실행되었습니다.");
		} else {
	title = "상품 관리";
	type = "manage";
	window = "/updateProductView.do";
	System.out.println("업데이트 뷰쪽으로 우선 이상없이 실행되었습니다.");
		}
	}
	
	
	List<Product> list= (List<Product>)request.getAttribute("list");
	Page resultPage=(Page)request.getAttribute("resultPage");

	Search searchVO = (Search)request.getAttribute("search");
	
	String searchCondition = CommonUtil.null2str(searchVO.getSearchCondition());
	String searchKeyword = CommonUtil.null2str(searchVO.getSearchKeyword());
%>
--%>
<!DOCTYPE html>
<html>
<head>
<title>상품 목록조회</title>

<link rel="stylesheet" href="/css/admin.css" type="text/css">
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">

<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script type="text/javascript">

		//공백제거
		String.prototype.trim = function() {
		    return this.replace(/(^\s*)|(\s*$)/gi, "");
		}
	
		//무한스크롤
		var loading = false;
		var scrollPage = 1;
		var menu =  "${param.menu}";
		
		$(window).scroll(function() {
		   if ($(window).scrollTop() +5 >= $(document).height() - $(window).height() ) {
		   		if(!loading){
		   			scrollPage++;
		   			infinity();
		   		}
		   }
		});
		
		function infinity() {
			loading = true;
				$.ajax({
		            type     : 'POST',
		            url      : '/product/json/listProduct',
		            data     : JSON.stringify({
		            	page : scrollPage
		            }), // 다음 페이지 번호를 가지고 갑니다. 
		            dataType : 'json',
		            contentType: "application/json",
		            success : function(data) {
		            	var displayValue = "";
		            	data.forEach(function (el , index) {
		            		
		            		
		            		var code = "";
		            		if(el.tranCode != null){
		            			code = el.tranCode.trim();
		            		} 
		            		
		            		var id = "${sessionScope.user.userId}";
		            		var text = "";
		            				            		
		            		if( id == 'admin') {
		            			if( code == '' ){
			             			text = "판매중"     
		            			} else if (  code ==  '1' && menu == 'manage' )  {
		            				text = "구매완료" + "<a href='/purchase/updateTranCodeByProd?prodNo=" + el.prodNo + "&tranCode=2'>" + "배송하기" + "</a>"
		            			} else if ( code == '1' && menu != 'manage' ) {
		            				text = "구매완료"
		            			} else if ( code == '2' ) {
		            				text = "배송중"
		            			} else {
		            				text = "배송완료"
		            			}
		            		}
		            			
		            		if( id != 'admin') {
		            			if( code == '' ){
		            				text = "판매중"
		            			} else {
		            				text = "재고없음"
		            			}
		            		} 
		            		
		            		
		            		 displayValue += "<tr  class='ct_list_pop'><td align='center'><img src='/images/uploadFiles/"  
		            		 + el.fileName +  "' width='150' height='150' /></td><td></td><td align='center'>" 
		            		 + el.prodName + "<input type='hidden' value='" 
		            		 + el.prodNo + "' id='prodNoo'  /></td><td></td><td align='center'>" 
		            		+ el.price + "</td><td></td><td align='center'>" 
		            		+ el.manuDate + "</td><td></td><td align='left'>" + text + "</td></tr><td colspan='11' bgcolor='D6D7D6' height='1'></td>";	
		            		 		
		            		
		            	})		
		            	
		            	$( "#addlist" ).append(displayValue); 
		            	    	
		          		$( ".ct_list_pop td:nth-child(3)" ).css("color" , "blue");		
		        		$(".ct_list_pop:nth-child(4n+6)" ).css("background-color" , "whitesmoke");
		        		
		        		
		        		$( ".ct_list_pop td:nth-child(3)" ).on("click" , function() {
		        			
		        			if(menu == "manage"){
		    					self.location = "/product/updateProduct?prodNo=" + $(this).find("input").val();
		        			} else if (menu == "search"){
		        				self.location =  "/product/getProduct?prodNo=" + $(this).find("input").val();
		        			}
		    			});
		            	
		            	loading = false;
			   			
		            }
					
		        });
		}

		
		//auto complete
		$(function(){
			$('#searchKeyword').autocomplete(
			{
				source : function(request, response) { //source: 입력시 보일 목록
					
					var con = $("#searchCondition").val();
				     $.ajax({
				           url : "/product/json/autocomplete"   
				         , type : "POST"
				         , dataType: "JSON"
				         , data : {value: request.term, con}	// 검색 키워드
				         , success : function(data){ 	// 성공
				             response(
				                 $.map(data.autoList, function(item) {
				                	 if(con == 0){
					                	 return {
					                    	     label : item.PROD_NO  	// 목록에 표시되는 값
					                           , value : item.PROD_NO   		// 선택 시 input창에 표시되는 값
					                     };
				                     } else if (con == 1){
					                    	 return {
					                    	     label : item.PROD_NAME  	// 목록에 표시되는 값
					                           , value : item.PROD_NAME   		// 선택 시 input창에 표시되는 값
					                     }; 
				                     } else if (con == 2){
				                    	 return {
				                    	     label : item.PRICE  	// 목록에 표시되는 값
				                           , value : item.PRICE   		// 선택 시 input창에 표시되는 값
				                    	 };
				                     }
				                 })
				             );    //response
				         }
				         ,error : function(){ //실패
				             alert("오류가 발생했습니다.");
				         }
				     });
				}
				,focus : function(event, ui) { // 방향키로 자동완성단어 선택 가능하게 만들어줌	
						return false;
				}
				,minLength: 1// 최소 글자수
				,autoFocus : true // true == 첫 번째 항목에 자동으로 초점이 맞춰짐
				,delay: 100	//autocomplete 딜레이 시간(ms)
				,select : function(evt, ui) { 
			      	// 아이템 선택시 실행 ui.item 이 선택된 항목을 나타내는 객체, lavel/value/idx를 가짐
						//console.log(ui.item.label);
						//console.log(ui.item.idx);
				 }
			});
		})	
		

	function fncGetProductList(page, type){
		$("#page").val(page);
		$("#type").val(type);
		$("form").attr("method", "POST").attr("action", "/product/listProduct?menu=${param.menu}").submit();
	}

	
	$(function() {
		
		
		 $( "td.ct_btn01:contains('검색')" ).on("click" , function() {
	
			 fncGetProductList('${resultPage.page}','${param.menu}');
		});

		 	 
		$( ".ct_list_pop td:nth-child(3)" ).on("click" , function() {
				self.location ="${param.menu == 'manage'? "/product/updateProduct?prodNo=" : "/product/getProduct?prodNo="}" + $(this).find("input").val();
		});
		
				
		$( ".ct_list_pop td:nth-child(3)" ).css("color" , "blue");
		$(".ct_list_pop:nth-child(4n+6)" ).css("background-color" , "whitesmoke");
	
	});	

</script>
</head>

<body bgcolor="#ffffff" text="#000000">

<div style="width:98%; margin-left:10px;">

<form name="detailForm" >

<table width="100%" height="37" border="0" cellpadding="0"	cellspacing="0">
	<tr>
		<td width="15" height="37">
			<img src="/images/ct_ttl_img01.gif" width="15" height="37"/>
		</td>
		<td background="/images/ct_ttl_img02.gif" width="100%" style="padding-left:10px;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="93%" class="ct_ttl01">
					
						${ param.menu == 'manage' ? "상품 관리" : "상품 목록조회" }
		
					</td>
				</tr>
			</table>
		</td>
		<td width="12" height="37">
			<img src="/images/ct_ttl_img03.gif" width="12" height="37"/>
		</td>
	</tr>
</table>


<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>
		
		<td align="right">
			<select name="searchCondition" id="searchCondition" class="ct_input_g" style="width:80px">

				<option value="0" ${param.searchCondition == '0' ? "selected" : ""} >상품번호</option>
				<option value="1" ${param.searchCondition == '1' ? "selected" : ""} >상품명</option>
				<option value="2" ${param.searchCondition == '2' ? "selected" : ""} >상품가격</option>

			</select>
			<input type="text" name="searchKeyword" id="searchKeyword" value="${param.searchKeyword}" class="ct_input_g" style="width:200px; height:19px" />
		</td>
	
		
		<td align="right" width="70">
			<table border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="17" height="23">
						<img src="/images/ct_btnbg01.gif" width="17" height="23">
					</td>
					<td background="/images/ct_btnbg02.gif" class="ct_btn01" style="padding-top:3px;">
						<!--  <a href="javascript:fncGetProductList('${resultPage.page}','${param.menu}');">검색</a>-->
						검색
					</td>
					<td width="14" height="23">
						<img src="/images/ct_btnbg03.gif" width="14" height="23">
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>


<table width="100%" border="0" cellspacing="0" cellpadding="0" id="addlist" style="margin-top:10px;">
	<tr>
		<td colspan="11" >전체  ${resultPage.totalCount} 건수, 현재 ${resultPage.page} 페이지</td>
	</tr>
	<tr>
		<td class="ct_list_b" width="100">No</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">상품명</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">가격</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">등록일</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">현재상태</td>		
	</tr>
	
	<tr>
		<td colspan="11" bgcolor="808285" height="1"></td>
	</tr>

	<c:forEach var= "i" items="${list}">
		<c:set var="num" value="${ num+1 }" />
		<tr class="ct_list_pop">
			<td align="center"><img src="/images/uploadFiles/${i.fileName}" width="150" height="150" /></td>
			<td></td>
			<td align="center">
			
			<c:choose>
			 <%-- <% if(productvo.getProTranCode() == null || productvo.getProTranCode().trim().equals("0")){ --%>
				<c:when test = "${ fn:trim(i.tranCode) eq '' }" >
					<!-- <a href="${param.menu == 'manage'?"/product/updateProduct?":"/product/getProduct?"}&prodNo=${i.prodNo}">${i.prodName}</a> -->
						${i.prodName}  <input type="hidden" value="${i.prodNo}" id="prodNo"  />
				</c:when>
				 <c:otherwise>
				 	${i.prodName} <input type="hidden" value="${i.prodNo}" id="prodNo"  />
				 </c:otherwise>
			</c:choose>
				
						
			</td>
			<td></td>
			<td align="center">${i.price}</td>
			<td></td>
			<td align="center">${i.regDate}
			</td>
			<td></td>
			<td align="left">
		

					
					<c:if test = "${ sessionScope.user.userId eq 'admin'}" >
						<c:choose>
							<c:when test = "${ fn:trim(i.tranCode) eq '' }">
								판매중
							</c:when>
							<c:when test = "${ fn:trim(i.tranCode) eq '1' and (param.menu == 'manage')}" >
								구매완료 <a href="/purchase/updateTranCodeByProd?prodNo=${i.prodNo}&tranCode=2">배송하기</a>
							</c:when>
							<c:when test = "${ fn:trim(i.tranCode) eq '1' and (param.menu != 'manage')}" >
								구매완료
							</c:when>
							<c:when test = "${ fn:trim(i.tranCode) eq '2' }" >
								배송중
							</c:when>
							<c:otherwise>
							 	배송완료
							 </c:otherwise>
						</c:choose>
					</c:if>
					

					<c:if test = "${sessionScope.user.userId ne 'admin'}" >
						<c:choose>
							<c:when test = "${ fn:trim(i.tranCode) eq '' }">
								판매중
							</c:when>
							<c:otherwise>
							 	재고없음
							 </c:otherwise>
						</c:choose>
					</c:if>
					
		
			</td>			
		</tr>
		
		<tr>
			<td colspan="11" bgcolor="D6D7D6" height="1"></td>
		</tr>
	</c:forEach>
</table>


<table width="100%" border="0" cellspacing="0" cellpadding="0" style="margin-top:10px;">
	<tr>
		<td align="center">
		
		<input type="hidden" id="page" name="page" value=""/>
		<input type="hidden" id="type" name="type" value=""/>
		<jsp:include page="../common/pageNavigator.jsp"/>	
		
    	</td>
	</tr>
</table>
<!--  페이지 Navigator 끝 -->


</form>

</div>
</body>
</html>
