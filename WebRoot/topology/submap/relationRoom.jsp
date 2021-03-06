<%@page language="java" contentType="text/html;charset=GB2312"%>
<%@page import="java.util.List"%>
<%@page import="com.afunms.common.base.JspPage"%>
<%@page import="com.afunms.system.model.User"%>
<%@page import="com.afunms.cabinet.model.EqpRoom"%>
<%@page import="com.afunms.common.util.SessionConstant"%>
<%@ include file="/include/globe.inc"%>
<%
   User current_user = (User)session.getAttribute(SessionConstant.CURRENT_USER);
   System.out.println(current_user.getBusinessids());
   String bids[] = current_user.getBusinessids().split(",");
  List list = (List)request.getAttribute("list");
  int rc = list.size();
  String rootPath = request.getContextPath();
  String nodeId = (String)request.getAttribute("nodeId");
  String category = (String)request.getAttribute("category");
  String mapId = (String)request.getAttribute("mapId");
%>
<html>
<head>
<title>关联机房</title>
<base target="_self">
<link href="<%=rootPath%>/resource/css/global/global.css" rel="stylesheet" type="text/css"/>
<script type="text/javascript" src="<%=rootPath%>/resource/js/page.js"></script> 

<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<meta http-equiv="Pragma" content="no-cache">
<LINK href="<%=rootPath%>/resource/css/itsm_style.css" type="text/css" rel="stylesheet">
<link href="<%=rootPath%>/resource/css/detail.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="<%=rootPath%>/resource/css/style.css" type="text/css">
<link href="<%=rootPath%>/include/mainstyle.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/javascript">
function save()//关联机房
{
    var args = window.dialogArguments;
	mainForm.action = "<%=rootPath%>/submapRoom.do?action=save_relation_node&xml="+args.fatherXML;
    mainForm.submit();
    alert("关联成功!");
	window.close();
	args.location.reload();
}
  
function cancel()
{
    var args = window.dialogArguments;
    mainForm.action = "<%=rootPath%>/submapRoom.do?action=cancel_relation_node&xml="+args.fatherXML;
    mainForm.submit();
    alert("取消成功!");
	window.close();
	args.location.reload();
}

</script>
</head>
<BODY  id="body" class="body">
<form method="post" name="mainForm" id="mainForm">
<input type=hidden name="mapId" id="mapId" value="<%=mapId%>">
<input type=hidden name="nodeId" id="nodeid" value="<%=nodeId%>">
<input type=hidden name="category" value="<%=category%>">
<table width="90%" cellpadding="6" cellspacing="6">
	<tr>
		<td class="td-container-main">
			<table id="body-container" class="body-container" cellpadding="1" cellspacing="5">
				<tr>
					<td class="td-container-main-content">
						<table id="container-main-content" class="container-main-content">
							<tr> <td>
								<table id="content-header" class="content-header">
									<tr>
					                	<td align="left" width="5"><img src="<%=rootPath%>/common/images/right_t_01.jpg" width="5" height="29" /></td>
					                	<td class="content-title"> <b>关联机房</b></td>
					                    <td align="right"><img src="<%=rootPath%>/common/images/right_t_03.jpg" width="5" height="29" /></td>
					       			</tr>
					        	</table>
							</td>
							</tr>
						    <tr>
							    <td>
				                   <input type="hidden" name="intMultibox">	
				                   <table id="content-body" class="content-body">
					                   <tr>
						               <td>
						               <table cellspacing="1" cellpadding="1" width="100%" border="1" bordercolor="#ffeeee">
						                   <tr class="microsoftLook0" height=28>
				                           <th align='center' width='15%'>序号</th>				
				                           <th align='center' width='85%'>机房名</th>
				                           </tr>
											<%
											    for(int i=0;i<rc;i++){
											       	EqpRoom vo = (EqpRoom)list.get(i);
											       	
												
										   %>
				                              <tr <%=onmouseoverstyle%> class="microsoftLook">
				   	                       <td  align='center'><INPUT type="radio" class=noborder name=radio value="<%=vo.getId()%>" class=noborder checked>
				   	                       	<font color='blue'><%=i+1%></font>
				   	                       </td>    	 	
				   	                       <td  align='center'><%=vo.getName()%></td>			
				                           </tr>
											<%
											   } 
											%>				
						               </table>
						               </td>
					                   </tr>
					                   <tr><td height="20">
						     </td>
						    </tr>
					                    <tr><td>
										    <table height="60"><tr>
											    <td nowrap colspan="20" align=center>
													<input type="button" value="确定" style="width:50" class="formStylebutton" onclick="save()">
													<input type="button" value="取消关联" style="width:80" class="formStylebutton" onclick="cancel();">
													<input type="button" value="关闭" style="width:50" class="formStylebutton" onclick="window.close();">
										       </td>
										   </tr></table>
										    </td>
										    </tr> 
										    <tr><td height="20">
						     </td>
						    </tr>
						    
						                   					               	
				                   </table>
				                </td>
						    </tr>
						    <tr><td height="20">
						     </td>
						    </tr>
						   <tr><td height="30">
						     </td> 						    
					    </table>
		            </td>
                 </tr>                   
            </table>
        </td>
    </tr>
    	
</table>
</form>		
</BODY>
</HTML>
