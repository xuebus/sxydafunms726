<%@page language="java" contentType="text/html;charset=UTF-8"%>
<%@page import="com.afunms.topology.model.HostNode"%>
<%@page import="com.afunms.common.base.JspPage"%>
<%@page import="com.afunms.common.util.SysUtil"%>
<%@ include file="/include/globe.inc"%>
<%@page import="com.afunms.common.util.*" %>
<%@page import="com.afunms.monitor.item.*"%>
<%@page import="com.afunms.polling.node.*"%>
<%@page import="com.afunms.polling.*"%>
<%@page import="com.afunms.polling.impl.*"%>
<%@page import="com.afunms.polling.api.*"%>
<%@page import="com.afunms.topology.util.NodeHelper"%>
<%@page import="com.afunms.topology.dao.*"%>
<%@page import="com.afunms.monitor.item.base.MoidConstants"%>
<%@page import="org.jfree.data.general.DefaultPieDataset"%>
<%@ page import="com.afunms.polling.api.I_Portconfig"%>
<%@ page import="com.afunms.polling.om.Portconfig"%>
<%@ page import="com.afunms.polling.om.*"%>
<%@ page import="com.afunms.polling.impl.PortconfigManager"%>
<%@page import="com.afunms.report.jfree.ChartCreator"%>
<%@page import="com.afunms.config.model.PanelModel"%>
<%@page import="com.afunms.config.dao.*"%>
<%@page import="com.afunms.config.model.*"%>
<%@page import="com.afunms.initialize.ResourceCenter"%>
<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.File"%>
<%@page import="java.io.*"%>
<%@ page import="com.afunms.system.model.User"%>

<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="java.lang.*"%>
<%@page import="com.afunms.monitor.item.base.*"%>
<%@page import="com.afunms.monitor.executor.base.*"%>


<% 

  String rootPath = request.getContextPath(); 
  String id = request.getParameter("id");
  NetNodeCfgFileDao dao = new NetNodeCfgFileDao();
  NetNodeCfgFile cfgfile = (NetNodeCfgFile)dao.loadNetNodeCfgFile(Integer.parseInt(id)); 
  Host host = (Host)PollingEngine.getInstance().getNodeByIP(cfgfile.getIpaddress());
  String name = cfgfile.getName();
  StringBuffer fileContent = new StringBuffer();
			String filename = ResourceCenter.getInstance().getSysPath() + "/cfgfile/"+name;					
    			FileInputStream fis = new FileInputStream(filename);
			InputStreamReader isr=new InputStreamReader(fis);
			BufferedReader br=new BufferedReader(isr);
			String strLine = null;
	    		//¶쏄¼�
	    		while((strLine=br.readLine())!=null)
	    		{
	    			fileContent.append(strLine + "\n");
	    		}
	    		isr.close();
	    		fis.close();
	    		br.close();  
  
  java.text.SimpleDateFormat sdf0 = new java.text.SimpleDateFormat("yyyy-MM-dd"); 
  String nowtime = sdf0.format(new Date());
  User vo = (User)session.getAttribute(SessionConstant.CURRENT_USER);
  String username = vo.getName();	
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<script type="text/javascript" src="<%=rootPath%>/include/swfobject.js"></script>
<script language="JavaScript" type="text/javascript" src="<%=rootPath%>/include/navbar.js"></script>

<link href="<%=rootPath%>/resource/<%=com.afunms.common.util.CommonAppUtil.getSkinPath() %>css/global/global.css" rel="stylesheet" type="text/css"/>

<link rel="stylesheet" type="text/css" 	href="<%=rootPath%>/js/ext/lib/resources/css/ext-all.css" charset="utf-8" />
<script type="text/javascript" 	src="<%=rootPath%>/js/ext/lib/adapter/ext/ext-base.js" charset="utf-8"></script>
<script type="text/javascript" src="<%=rootPath%>/js/ext/lib/ext-all.js" charset="utf-8"></script>
<script type="text/javascript" src="<%=rootPath%>/js/ext/lib/locale/ext-lang-zh_CN.js" charset="utf-8"></script>
<script type="text/javascript" src="<%=rootPath%>/resource/js/page.js"></script> 

<script language="javascript">	

  Ext.onReady(function()
{  

setTimeout(function(){
	        Ext.get('loading').remove();
	        Ext.get('loading-mask').fadeOut({remove:true});
	    }, 250);
	
 Ext.get("process").on("click",function(){
  
  Ext.MessageBox.wait('˽¾ݼԔٖУ¬ȫʔº񬬠');   
  mainForm.action = "<%=rootPath%>/cfgfile.do?action=getcfgfile&ipaddress=<%=host.getIpAddress()%>";
  mainForm.submit();
 });
 
  Ext.get("process1").on("click",function(){
  
  Ext.MessageBox.wait('˽¾ݼԔٖУ¬ȫʔº񬬠');   
  mainForm.action = "<%=rootPath%>/cfgfile.do?action=nodelist&ipaddress=<%=host.getIpAddress()%>";
  mainForm.submit();
 });	
	
});

  function doQuery()
  {  
     if(mainForm.key.value=="")
     {
     	alert("ȫˤɫ²ꑯ͵¼�     	return false;
     }
     mainForm.action = "<%=rootPath%>/network.do?action=find";
     mainForm.submit();
  }
  
    function toGetConfigFile()
  {
        msg.style.display="block";
        mainForm.action = "<%=rootPath%>/cfgfile.do?action=getcfgfile&ipaddress=<%=host.getIpAddress()%>";
        mainForm.submit();
  }
  
  function doChange()
  {
     if(mainForm.view_type.value==1)
        window.location = "<%=rootPath%>/topology/network/index.jsp";
     else
        window.location = "<%=rootPath%>/topology/network/port.jsp";
  }

  function toAdd()
  {
      mainForm.action = "<%=rootPath%>/network.do?action=ready_add";
      mainForm.submit();
  }
  
//ͭ¼Ӳ˵¥	
function initmenu()
{
	var idpattern=new RegExp("^menu");
	var menupattern=new RegExp("child$");
	var tds = document.getElementsByTagName("div");
	for(var i=0,j=tds.length;i<j;i++){
		var td = tds[i];
		if(idpattern.test(td.id)&&!menupattern.test(td.id)){					
			menu =new Menu(td.id,td.id+"child",'dtu','100',show,my_on,my_off);
			menu.init();		
		}
	}
	setClass();
}

</script>
<script language="JavaScript">

	//¹«¹²±偿
	var node="";
	var ipaddress="";
	var operate="";
	/**
	*¸�ɫµédДʾԒ¼�
	*/
	function showMenu(id,nodeid,ip)
	{	
		ipaddress=ip;
		node=nodeid;
		//operate=oper;
	    if("" == id)
	    {
	        popMenu(itemMenu,100,"100");
	    }
	    else
	    {
	        popMenu(itemMenu,100,"1111");
	    }
	    event.returnValue=false;
	    event.cancelBubble=true;
	    return false;
	}
	/**
	*Дʾµ¯³�¥
	*menuDiv:Ԓ¼�ńۈۍ
	*width:ѐДʾµĿ���
	*rowControlString:ѐ¿ٖǗַ�0±²»Дʾ£¬1±Дʾ£¬ɧ¡°101¡±£¬ղ±µر¡¢3ѐДʾ£¬µزѐ²»Дʾ
	*/
	function popMenu(menuDiv,width,rowControlString)
	{
	    //´´½¨µ¯³�¥
	    var pop=window.createPopup();
	    //ʨ׃µ¯³�¥µńۈۍ
	    pop.document.body.innerHTML=menuDiv.innerHTML;
	    var rowObjs=pop.document.body.all[0].rows;
	    //»񶃵¯³�¥µŐъ�  var rowCount=rowObjs.length;
	    //alert("rowCount==>"+rowCount+",rowControlString==>"+rowControlString);
	    //ѭ»·ʨ׃ÿѐµŊ�
	    for(var i=0;i<rowObjs.length;i++)
	    {
	        //ɧ¹�¸Đв»Дʾ£¬ղѐ˽¼�
	        var hide=rowControlString.charAt(i)!='1';
	        if(hide){
	            rowCount--;
	        }
	        //ʨ׃ˇ·򐕊¾¸Đ΍
	        rowObjs[i].style.display=(hide)?"none":"";
	        //ʨ׃˳±껬ɫ¸Đъ±µŐ§¹�       rowObjs[i].cells[0].onmouseover=function()
	        {
	            this.style.background="#397DBD";
	            this.style.color="white";
	        }
	        //ʨ׃˳±껬³�ъ±µŐ§¹�       rowObjs[i].cells[0].onmouseout=function(){
	            this.style.background="#F1F1F1";
	            this.style.color="black";
	        }
	    }
	    //ǁ±β˵¥µĲ˵¥
	    pop.document.oncontextmenu=function()
	    {
	            return false; 
	    }
	    //ѡձԒ¼�Œ»Юº󣬲˵¥Ӿ²֍
	    pop.document.onclick=function()
	    {
	        pop.hide();
	    }
	    //Дʾ²˵¥
	    pop.show(event.clientX-1,event.clientY,width,rowCount*25,document.body);
	    return true;
	}
	
</script>
</head>
<body id="body" class="body" onload="initmenu();">
<form method="post" name="mainForm">
<input type=hidden name="orderflag">
<input type=hidden name="id">
<%
  	java.text.SimpleDateFormat _sdf = new java.text.SimpleDateFormat("MM-dd HH:mm");
  	Date cc = cfgfile.getRecordtime().getTime();
  	String rtime1 = _sdf.format(cc);
%>
<table id="body-container" class="body-container">
			<tr>
				<td class="td-container-main">
					<table id="container-main" class="container-main">
						
									<tr>
									<td align="center" valign=top>
																<table width="98%" style="width:98%" cellpadding="0" cellspacing="0" algin="center">
			<tr>
				<td background="<%=rootPath%>/common/images/right_t_02.jpg" width="100%"><table width="100%" cellspacing="0" cellpadding="0">
                  <tr>
                    <td align="left"><img src="<%=rootPath%>/common/images/right_t_01.jpg" width="5" height="29" /></td>
                    <td class="layout_title">&nbsp;设备配置文件<%=host.getAlias()%>(<%=host.getIpAddress()%>) >> <%=name%></td>
                    <td align="right"><img src="<%=rootPath%>/common/images/right_t_03.jpg" width="5" height="29" /></td>
                  </tr>
              </table>
			  </td>
			  </tr>
									
        						
															<tr>
								                                 <td colspan="2">
									                             <table cellspacing="1" cellpadding="0" width="100%" >
	<tr>
		<td><textarea name="report_content" rows="30" cols="110" readonly><%=fileContent.toString()%></textarea></td>
	</tr>
	<tr bgcolor="#F1F1F1" height=25>
		<td><br>&nbsp;&nbsp;采集日期：<%=rtime1%><br></td>
	</tr>	
		
     	<tr bgcolor="#F1F1F1"><td align=center colspan=2>
     		<br><input type=reset class="formStylebutton" style="width:70" value="关闭窗口" onclick="window.close()">
     		<br></td>
     	</tr>
									                             
									                             
									                             
									                             
									                             
	  									                            
																	</table>
																</td>
															</tr>
															<tr>
              <td background="<%=rootPath%>/common/images/right_b_02.jpg" ><table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td align="left" valign="bottom"><img src="<%=rootPath%>/common/images/right_b_01.jpg" width="5" height="12" /></td>
                    <td></td>
                    <td align="right" valign="bottom"><img src="<%=rootPath%>/common/images/right_b_03.jpg" width="5" height="12" /></td>
                  </tr>
              </table></td>
            </tr>	
												</table>
												</td>
                        									</tr>
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