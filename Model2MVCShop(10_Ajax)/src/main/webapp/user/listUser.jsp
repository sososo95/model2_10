<%@ page contentType="text/html; charset=EUC-KR" %>
<%@ page pageEncoding="EUC-KR"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>

<head>
	<meta charset="EUC-KR">
	<title>회원 목록 조회</title>
	
	<link rel="stylesheet" href="/css/admin.css" type="text/css">
	<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
	<!-- CDN(Content Delivery Network) 호스트 사용 -->
	<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
	<script type="text/javascript">
	
		
		//무한스크롤
		var loading = false;
		var scrollPage = 1;
		
		$(window).scroll(function() {
		   if ($(window).scrollTop() == $(document).height() - $(window).height()) {
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
	                url      : '/user/json/listUser',
	                data     : JSON.stringify({
	                	page : scrollPage  
	                }), // 다음 페이지 번호와 페이지 사이즈를 가지고 갑니다.
	                dataType : 'json',
	                contentType: "application/json",
	                success : function(data) {
	                	
	                	var displayValue = "";
	                	data.forEach(function (el , index) {
	                		displayValue += "<tr class='ct_list_pop'>"
	                		+	"<td align='center' height='100'>" + index + "</td><td></td><td>" + el.userId + "</td><td></td>"
	                		+ "<td>" + el.userName + "</td><td></td><td>" + el.email + "</td><td></td></tr><tr><td id='" + el.userId + "' colspan='11' bgcolor='D6D7D6' height='1'></td></tr>";   
	                				
	                	})	
	    
	                	$( "#addlist" ).append(displayValue);

	                	$( ".ct_list_pop td:nth-child(3)" ).on("click" , function() {
          					var userId = $(this).text().trim();
          					
          					$.ajax( 
          							{
          								url : "/user/json/getUser/"+userId ,
          								method : "GET" ,
          								dataType : "json" ,
          								headers : {
          									"Accept" : "application/json",
          									"Content-Type" : "application/json"
          								},      
          								success : function(JSONData , status) {
          									var displayValue = "<h3>"
          																+"아이디 : "+JSONData.userId+"<br/>"
          																+"이  름 : "+JSONData.userName+"<br/>"
          																+"이메일 : "+JSONData.email+"<br/>"
          																+"ROLE : "+JSONData.role+"<br/>"
          																+"등록일 : "+JSONData.regDateString+"<br/>"
          																+"</h3>";
          																
          									$("h3").remove();
          									$( "#"+userId+"" ).html(displayValue);
          								}
          						});
          					
          			});
          			

	                $( ".ct_list_pop td:nth-child(3)" ).css("color" , "red");          			
          			$(".ct_list_pop:nth-child(4n+6)" ).css("background-color" , "whitesmoke");
	                
          			loading = false;
	                }
							
					
	            });
		}
		
		
		// 검색 / page 두가지 경우 모두 Form 전송을 위해 JavaScrpt 이용  
		function fncGetUserList(page) {
			$("#page").val(page)
			$("form").attr("method" , "POST").attr("action" , "/user/listUser").submit();
		}
		
		//auto complete
		$(function(){
			$('#searchKeyword').autocomplete(
			{
				source : function(request, response) { //source: 입력시 보일 목록
					
					var con = $("#searchCondition").val();
				     $.ajax({
				           url : "/user/json/autocomplete"   
				         , type : "POST"
				         , dataType: "JSON"
				         , data : {value: request.term, con}	// 검색 키워드
				         , success : function(data){ 	// 성공
				             response(
				                 $.map(data.autoList, function(item) {
				                	 if(con == 0){
					                	 return {
					                    	     label : item.USER_ID  	// 목록에 표시되는 값
					                           , value : item.USER_ID   		// 선택 시 input창에 표시되는 값
					                     };
				                     } else if (con == 1){
					                    	 return {
					                    	     label : item.USER_NAME  	// 목록에 표시되는 값
					                           , value : item.USER_NAME   		// 선택 시 input창에 표시되는 값
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
		
		
		//==>"검색" ,  userId link  Event 연결 및 처리
		 $(function() {
			 
			 $( "td.ct_btn01:contains('검색')" ).on("click" , function() {
				fncGetUserList('${resultPage.page}');
			});
			

			$( ".ct_list_pop td:nth-child(3)" ).on("click" , function() {
	
					var userId = $(this).text().trim();
					$.ajax( 
							{
								url : "/user/json/getUser/"+userId ,
								method : "GET" ,
								dataType : "json" ,
								headers : {
									"Accept" : "application/json",
									"Content-Type" : "application/json"
								},      
								success : function(JSONData , status) {

									var displayValue = "<h3>"
																+"아이디 : "+JSONData.userId+"<br/>"
																+"이  름 : "+JSONData.userName+"<br/>"
																+"이메일 : "+JSONData.email+"<br/>"
																+"ROLE : "+JSONData.role+"<br/>"
																+"등록일 : "+JSONData.regDateString+"<br/>"
																+"</h3>";
																
									$("h3").remove();
									$( "#"+userId+"" ).html(displayValue);
								}
						});
			});
			
			//==> userId LINK Event End User 에게 보일수 있도록 
			$( ".ct_list_pop td:nth-child(3)" ).css("color" , "red");
			$("h7").css("color" , "red");
			
			//==> 아래와 같이 정의한 이유는 ??
			$(".ct_list_pop:nth-child(4n+6)" ).css("background-color" , "whitesmoke");
		});	
		
	</script>		
	
</head>

<body bgcolor="#ffffff" text="#000000">

<div style="width:98%; margin-left:10px;">

<form name="detailForm">

<table width="100%" height="37" border="0" cellpadding="0"	cellspacing="0">
	<tr>
		<td width="15" height="37">
			<img src="/images/ct_ttl_img01.gif" width="15" height="37" />
		</td>
		<td background="/images/ct_ttl_img02.gif" width="100%" style="padding-left:10px;">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="93%" class="ct_ttl01">회원 목록조회</td>
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
				<option value="0"  ${ ! empty search.searchCondition && search.searchCondition==0 ? "selected" : "" }>회원ID</option>
				<option value="1"  ${ ! empty search.searchCondition && search.searchCondition==1 ? "selected" : "" }>회원명</option>
			</select>
			<input type="text" name="searchKeyword"  id="searchKeyword"
						value="${! empty search.searchKeyword ? search.searchKeyword : ""}"  
						class="ct_input_g" style="width:200px; height:20px" > 
		</td>
		<td align="right" width="70">
			<table border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td width="17" height="23"><img src="/images/ct_btnbg01.gif" width="17" height="23"></td>
					<td background="/images/ct_btnbg02.gif" class="ct_btn01" style="padding-top:3px;">
						검색
					</td>
					<td width="14" height="23"><img src="/images/ct_btnbg03.gif" width="14" height="23"></td>
				</tr>
			</table>
		</td>
	</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="0" id="addlist"  style="margin-top:10px;">
	<tr>
		<td colspan="11" >
			전체  ${resultPage.totalCount } 건수, 현재 ${resultPage.page}  페이지
		</td>
	</tr>
	<tr>
		<td class="ct_list_b" width="100">No</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">
			회원ID<br>
			<h7 >(id click:상세정보)</h7>
		</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">회원명</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">이메일</td>		
	</tr>
	<tr>
		<td colspan="11" bgcolor="808285" height="1"></td>
	</tr>
		
	<c:set var="i" value="0" />
	<c:forEach var="user" items="${list}">
		<c:set var="i" value="${ i+1 }" />
		<tr class="ct_list_pop">
			<td align="center" height="100">${ i }</td>
			<td></td>
			<td align="left">${user.userId}</td>
			<td></td>
			<td align="left">${user.userName}</td>
			<td></td>
			<td align="left">${user.email}
			</td>
		</tr>
		<tr>
			<!-- //////////////////////////// 추가 , 변경된 부분 /////////////////////////////
			<td colspan="11" bgcolor="D6D7D6" height="1"></td>
			////////////////////////////////////////////////////////////////////////////////////////////  -->
			<td id="${user.userId}" colspan="11" bgcolor="D6D7D6" height="1"></td>
		</tr>

	</c:forEach>
</table>


<!-- PageNavigation Start... -->
<table width="100%" border="0" cellspacing="0" cellpadding="0"	style="margin-top:10px;">
	<tr>
		<td align="center">
		   <input type="hidden" id="page" name="page" value=""/>
	
			<jsp:include page="../common/pageNavigator.jsp"/>	
			
    	</td>
	</tr>
</table>
<!-- PageNavigation End... -->

</form>
</div>

</body>

</html>