<%@ page contentType="text/html; charset=EUC-KR" %>
<%@ page pageEncoding="EUC-KR"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>

<head>
	<meta charset="EUC-KR">
	<title>ȸ�� ��� ��ȸ</title>
	
	<link rel="stylesheet" href="/css/admin.css" type="text/css">
	<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
	<!-- CDN(Content Delivery Network) ȣ��Ʈ ��� -->
	<script src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
	<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
	<script type="text/javascript">
	
		
		//���ѽ�ũ��
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
	                }), // ���� ������ ��ȣ�� ������ ����� ������ ���ϴ�.
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
          																+"���̵� : "+JSONData.userId+"<br/>"
          																+"��  �� : "+JSONData.userName+"<br/>"
          																+"�̸��� : "+JSONData.email+"<br/>"
          																+"ROLE : "+JSONData.role+"<br/>"
          																+"����� : "+JSONData.regDateString+"<br/>"
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
		
		
		// �˻� / page �ΰ��� ��� ��� Form ������ ���� JavaScrpt �̿�  
		function fncGetUserList(page) {
			$("#page").val(page)
			$("form").attr("method" , "POST").attr("action" , "/user/listUser").submit();
		}
		
		//auto complete
		$(function(){
			$('#searchKeyword').autocomplete(
			{
				source : function(request, response) { //source: �Է½� ���� ���
					
					var con = $("#searchCondition").val();
				     $.ajax({
				           url : "/user/json/autocomplete"   
				         , type : "POST"
				         , dataType: "JSON"
				         , data : {value: request.term, con}	// �˻� Ű����
				         , success : function(data){ 	// ����
				             response(
				                 $.map(data.autoList, function(item) {
				                	 if(con == 0){
					                	 return {
					                    	     label : item.USER_ID  	// ��Ͽ� ǥ�õǴ� ��
					                           , value : item.USER_ID   		// ���� �� inputâ�� ǥ�õǴ� ��
					                     };
				                     } else if (con == 1){
					                    	 return {
					                    	     label : item.USER_NAME  	// ��Ͽ� ǥ�õǴ� ��
					                           , value : item.USER_NAME   		// ���� �� inputâ�� ǥ�õǴ� ��
					                     };
				                     }
				                 })
				             );    //response
				         }
				         ,error : function(){ //����
				             alert("������ �߻��߽��ϴ�.");
				         }
				     });
				}
				,focus : function(event, ui) { // ����Ű�� �ڵ��ϼ��ܾ� ���� �����ϰ� �������	
						return false;
				}
				,minLength: 1// �ּ� ���ڼ�
				,autoFocus : true // true == ù ��° �׸� �ڵ����� ������ ������
				,delay: 100	//autocomplete ������ �ð�(ms)
				,select : function(evt, ui) { 
			      	// ������ ���ý� ���� ui.item �� ���õ� �׸��� ��Ÿ���� ��ü, lavel/value/idx�� ����
						//console.log(ui.item.label);
						//console.log(ui.item.idx);
				 }
			});
		})
		
		
		//==>"�˻�" ,  userId link  Event ���� �� ó��
		 $(function() {
			 
			 $( "td.ct_btn01:contains('�˻�')" ).on("click" , function() {
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
																+"���̵� : "+JSONData.userId+"<br/>"
																+"��  �� : "+JSONData.userName+"<br/>"
																+"�̸��� : "+JSONData.email+"<br/>"
																+"ROLE : "+JSONData.role+"<br/>"
																+"����� : "+JSONData.regDateString+"<br/>"
																+"</h3>";
																
									$("h3").remove();
									$( "#"+userId+"" ).html(displayValue);
								}
						});
			});
			
			//==> userId LINK Event End User ���� ���ϼ� �ֵ��� 
			$( ".ct_list_pop td:nth-child(3)" ).css("color" , "red");
			$("h7").css("color" , "red");
			
			//==> �Ʒ��� ���� ������ ������ ??
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
					<td width="93%" class="ct_ttl01">ȸ�� �����ȸ</td>
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
				<option value="0"  ${ ! empty search.searchCondition && search.searchCondition==0 ? "selected" : "" }>ȸ��ID</option>
				<option value="1"  ${ ! empty search.searchCondition && search.searchCondition==1 ? "selected" : "" }>ȸ����</option>
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
						�˻�
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
			��ü  ${resultPage.totalCount } �Ǽ�, ���� ${resultPage.page}  ������
		</td>
	</tr>
	<tr>
		<td class="ct_list_b" width="100">No</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">
			ȸ��ID<br>
			<h7 >(id click:������)</h7>
		</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b" width="150">ȸ����</td>
		<td class="ct_line02"></td>
		<td class="ct_list_b">�̸���</td>		
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
			<!-- //////////////////////////// �߰� , ����� �κ� /////////////////////////////
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