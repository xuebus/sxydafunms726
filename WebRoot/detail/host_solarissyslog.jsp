<%@page language="java" contentType="text/html;charset=gb2312" %>
<%@ include file="/include/globe.inc"%>
<%@ include file="/include/globeChinese.inc"%>


<%@page import="com.afunms.config.model.*"%>
<%@page import="com.afunms.config.dao.*"%>
<%@page import="com.afunms.topology.model.HostNode"%>
<%@page import="com.afunms.common.base.JspPage"%>
<%@page import="com.afunms.common.util.SysUtil"%>

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
<%@page import="com.afunms.event.model.Syslog"%>
<%@page import="com.afunms.detail.service.cpuInfo.CpuInfoService"%>
<%@page import="com.afunms.detail.service.diskInfo.DiskInfoService"%>
<%@page import="com.afunms.detail.service.OtherInfo.OtherInfoService"%>
<%@page import="com.afunms.detail.service.systemInfo.SystemInfoService"%>
<%@page import="com.afunms.detail.service.sysInfo.DiskPerfInfoService"%>
<%@page import="com.afunms.indicators.model.NodeDTO"%>
<%@page import="com.afunms.indicators.util.NodeUtil"%>
<%@page import="com.afunms.detail.service.interfaceInfo.InterfaceInfoService"%>
<%@page import="com.afunms.detail.service.systemInfo.SystemInfoService"%>
<%@page import="com.afunms.detail.service.pingInfo.PingInfoService"%>
<%@page import="com.afunms.detail.service.sysInfo.CpuPerfInfoService"%>
<%@page import="com.afunms.detail.service.memoryInfo.MemoryInfoService"%>
<%@page import="com.afunms.temp.dao.UserTempDao"%>
<%@page import="com.afunms.detail.service.configInfo.NetmediaConfigInfoService"%>

<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="java.lang.*"%>
<%@page import="com.afunms.monitor.item.base.*"%>
<%@page import="com.afunms.monitor.executor.base.*"%>
<%
	String runmodel = PollingEngine.getCollectwebflag(); 
	String unixflag = (String)request.getAttribute("unixflag");
	if (unixflag == null)unixflag = "";
	String[] pingItem={"ResponseTime","LostPack"}; 
	String begindate="";
	String enddate="";

  	String tmp = request.getParameter("id"); 
	SimpleDateFormat sdf1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

	double cpuvalue = 0;
	String pingconavg ="0";
	String collecttime = "";
	String sysuptime = "";
	String sysservices = "";
	String sysdescr = "";
	
   	HostNodeDao hostdao = new HostNodeDao();
   	List hostlist = hostdao.loadHost();
   	
   	Host host = (Host)PollingEngine.getInstance().getNodeByID(Integer.parseInt(tmp)); 
   	String ipaddress = host.getIpAddress();
    String[] time = {"",""};
    DateE datemanager = new DateE();
    Calendar current = new GregorianCalendar();
    current.set(Calendar.MINUTE,59);
    current.set(Calendar.SECOND,59);
    time[1] = datemanager.getDateDetail(current);
    current.add(Calendar.HOUR_OF_DAY,-1);
    current.set(Calendar.MINUTE,0);
    current.set(Calendar.SECOND,0);
    time[0] = datemanager.getDateDetail(current);
    String starttime = time[0];
    String endtime = time[1];
       
    Nodeconfig nodeconfig = new Nodeconfig();
    String processornum = "";
  	String hostname = "";
  	String porcessors = "";
  	String sysname = "";
  	String SerialNumber = "";
 	String CSDVersion = "";
 	String mac = "";
    Vector cpuV = new Vector(); 
    Vector systemV = new Vector();
    Vector pingData = new Vector();
    try{
    	I_HostLastCollectData hostlastmanager=new HostLastCollectDataManager();
        if("0".equals(runmodel)){
			//�ɼ�������Ǽ���ģʽ
			Hashtable ipAllData = (Hashtable)ShareData.getSharedata().get(host.getIpAddress());
			cpuV = (Vector)ipAllData.get("cpu");
			systemV = (Vector)ipAllData.get("system");
			nodeconfig= (Nodeconfig)ipAllData.get("nodeconfig");
			pingData = (Vector)ShareData.getPingdata().get(host.getIpAddress());
		}else{
			//�ɼ�������Ƿ���ģʽ
			NodeUtil nodeUtil = new NodeUtil();
			NodeDTO nodedto = nodeUtil.creatNodeDTOByNode(host);
			//cpu
  			CpuInfoService cpuInfoService = new CpuInfoService(nodedto.getId()+"",nodedto.getType(),nodedto.getSubtype()); 
			cpuV = cpuInfoService.getCpuInfo();
			//�õ�ϵͳ����ʱ��
			SystemInfoService systemInfoService = new SystemInfoService(nodedto.getId()+"",nodedto.getType(),nodedto.getSubtype());
			systemV = systemInfoService.getSystemInfo();
			//nodeconfig
			NodeconfigDao nodeconfigDao = new NodeconfigDao();
			try{
				nodeconfig = nodeconfigDao.getByNodeID(nodedto.getId()+"");
			}catch(Exception e){
				e.printStackTrace();
			}finally{
				nodeconfigDao.close();
			}
			//ping
			PingInfoService pingInfoService = new PingInfoService(nodedto.getId()+"",nodedto.getType(),nodedto.getSubtype());
			pingData = pingInfoService.getPingInfo(); 
		}
		//if(ipAllData != null){
		//Vector cpuV = (Vector)ipAllData.get("cpu");
		if(cpuV != null && cpuV.size()>0){
			CPUcollectdata cpu = (CPUcollectdata)cpuV.get(0);
			if(cpu != null && cpu.getThevalue() != null){
				cpuvalue = new Double(cpu.getThevalue());
			}
		}
		//�õ�ϵͳ����ʱ��
		//Vector systemV = (Vector)ipAllData.get("system");
		if(systemV != null && systemV.size()>0){
			for(int i=0;i<systemV.size();i++){
				Systemcollectdata systemdata=(Systemcollectdata)systemV.get(i);
				if(systemdata.getSubentity().equalsIgnoreCase("sysUpTime")){
					sysuptime = systemdata.getThevalue();
				}
				if(systemdata.getSubentity().equalsIgnoreCase("sysServices")){
					sysservices = systemdata.getThevalue();
				}
				if(systemdata.getSubentity().equalsIgnoreCase("sysDescr")){
					sysdescr = systemdata.getThevalue();
				}
				if(systemdata.getSubentity().equalsIgnoreCase("SysName")){
					sysname = systemdata.getThevalue();
				}
			}
		}
		//}
		
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String time1 = sdf.format(new Date());
		String starttime1 = time1 + " 00:00:00";
		String totime1 = time1 + " 23:59:59";
		
		Hashtable ConnectUtilizationhash = new Hashtable();
		I_HostCollectData hostmanager=new HostCollectDataManager();
		try{
			ConnectUtilizationhash = hostmanager.getCategory(host.getIpAddress(),"Ping","ConnectUtilization",starttime1,totime1);
			if (ConnectUtilizationhash.get("avgpingcon")!=null){
				pingconavg = (String)ConnectUtilizationhash.get("avgpingcon");
				pingconavg = pingconavg.replace("%", "");
			}			
		}catch(Exception ex){
			ex.printStackTrace();
		}
		
		//Vector pingData = (Vector)ShareData.getPingdata().get(host.getIpAddress());
		if(pingData != null && pingData.size()>0){
			Pingcollectdata pingdata = (Pingcollectdata)pingData.get(0);
			Calendar tempCal = (Calendar)pingdata.getCollecttime();							
			Date cc = tempCal.getTime();
			collecttime = sdf1.format(cc);
		}
       	request.setAttribute("id", tmp);
       	request.setAttribute("ipaddress", host.getIpAddress());
		request.setAttribute("cpuvalue", cpuvalue);
		request.setAttribute("collecttime", collecttime);
		request.setAttribute("sysuptime", sysuptime);
		request.setAttribute("sysservices", sysservices);
		request.setAttribute("sysdescr", sysdescr);
		request.setAttribute("pingconavg", new Double(pingconavg));
		if(nodeconfig != null){
			mac = nodeconfig.getMac();
			processornum = nodeconfig.getNumberOfProcessors();
			CSDVersion = nodeconfig.getCSDVersion();
			hostname = nodeconfig.getHostname();
		}
		
	}catch(Exception e){
		e.printStackTrace();
	}
		
	String[] sysItem={"sysName","sysUpTime","sysContact","sysLocation","sysServices","sysDescr"};
	String[] sysItemch={"�豸��","�豸����ʱ��","�豸��ϵ","�豸λ��","�豸����","�豸����"};
	Hashtable hash = (Hashtable)request.getAttribute("hash");
	Hashtable hash1 = (Hashtable)request.getAttribute("hash1");

	double avgpingcon = (Double)request.getAttribute("pingconavg");
	int percent1 = Double.valueOf(avgpingcon).intValue();
	int percent2 = 100-percent1;
	int cpuper = Double.valueOf(cpuvalue).intValue();
  	String rootPath = request.getContextPath();  
  
  	String chart1 = null,chart2 = null,chart3 = null,responseTime = null;
  	DefaultPieDataset dpd = new DefaultPieDataset();
  	dpd.setValue("������",avgpingcon);
  	dpd.setValue("��������",100 - avgpingcon);
  	chart1 = ChartCreator.createPieChart(dpd,"",130,130);  
    chart2 = ChartCreator.createMeterChart(cpuvalue,"",120,120);   
    chart3 = ChartCreator.createMeterChart(40.0,"",120,120); 
    String startdate = (String)request.getAttribute("startdate");
	String todate = (String)request.getAttribute("todate");  
	
    SupperDao supperdao = new SupperDao();
   	Supper supper = null;
   	String suppername = "";
   	try{
   		supper = (Supper)supperdao.findByID(host.getSupperid()+"");
   		if(supper != null)suppername = supper.getSu_name()+"("+supper.getSu_dept()+")";
   	}catch(Exception e){
   		e.printStackTrace();
   	}finally{
   		supperdao.close();
   	} 
   	String ip = host.getIpAddress();
	String picip = CommonUtil.doip(ip);
	
    	//���ɵ���ƽ����ͨ��ͼ��
	CreatePiePicture _cpp = new CreatePiePicture();
	_cpp.createAvgPingPic(picip,avgpingcon); 
	
		 //����CPU�Ǳ���
	CreateMetersPic cmp = new CreateMetersPic();
	cmp.createCpuPic(picip,cpuper);	
%>
<%String menuTable = (String)request.getAttribute("menuTable");%>
<html>
<head>


<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<script type="text/javascript" src="<%=rootPath%>/include/swfobject.js"></script>
<script language="JavaScript" type="text/javascript" src="<%=rootPath%>/include/navbar.js"></script>

<link href="<%=rootPath%>/resource/<%=com.afunms.common.util.CommonAppUtil.getSkinPath() %>css/global/global.css" rel="stylesheet" type="text/css"/>
<link rel="stylesheet" type="text/css" 	href="<%=rootPath%>/js/ext/lib/resources/css/ext-all.css" charset="utf-8" />
<link rel="stylesheet" type="text/css" href="<%=rootPath%>/js/ext/css/common.css" charset="utf-8"/>
<script type="text/javascript" 	src="<%=rootPath%>/js/ext/lib/adapter/ext/ext-base.js" charset="utf-8"></script>
<script type="text/javascript" src="<%=rootPath%>/js/ext/lib/ext-all.js" charset="utf-8"></script>
<script type="text/javascript" src="<%=rootPath%>/js/ext/lib/locale/ext-lang-zh_CN.js" charset="utf-8"></script>
<script type="text/javascript" src="<%=rootPath%>/resource/js/page.js"></script> 

<script language="JavaScript" src="<%=rootPath%>/include/date.js"></script> 
<script type="text/javascript" src="<%=rootPath%>/resource/js/jquery-1.4.2.min.js"></script>
<script>
function createQueryString(){
		var user_name = encodeURI($("#user_name").val());
		var passwd = encodeURI($("#passwd").val());
		var queryString = {userName:user_name,passwd:passwd};
		return queryString;
	}
function gzmajax(){
$.ajax({
			type:"GET",
			dataType:"json",
			url:"<%=rootPath%>/serverAjaxManager.ajax?action=ajaxUpdate_availability&tmp=<%=tmp%>&nowtime="+(new Date()),
			success:function(data){
				  $("#pingavg").attr({ src: "<%=rootPath%>/resource/image/jfreechart/reportimg/<%=picip%>pingavg.png?nowtime="+(new Date()), alt: "ƽ����ͨ��" });
				$("#cpu").attr({ src: "<%=rootPath%>/resource/image/jfreechart/reportimg/<%=picip%>cpu.png?nowtime="+(new Date()), alt: "��ǰCPU������" }); 
			
			}
		});
}
$(document).ready(function(){
	//$("#testbtn").bind("click",function(){
	//	gzmajax();
	//});
setInterval(gzmajax,60000);
});
</script>
<script language="javascript">	
  
  Ext.onReady(function()
{  

setTimeout(function(){
	        Ext.get('loading').remove();
	        Ext.get('loading-mask').fadeOut({remove:true});
	    }, 250);
	
	
	
});

  function doQuery()
  {  
     if(mainForm.key.value=="")
     {
     	alert("�������ѯ����");
     	return false;
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
  
function changeOrder(para){
  	location.href="<%=rootPath%>/topology/network/networkview.jsp?id=<%=tmp%>&ipaddress=<%=host.getIpAddress()%>&orderflag="+para;
} 
function openwin3(operate,index,ifname) 
{	
        mainForm.action = "<%=rootPath%>/cfgfile.do?action=getcfgfile&ipaddress=<%=host.getIpAddress()%>";
        mainForm.submit();
        window.open ("<%=rootPath%>/monitor.do?action="+operate+"&id=<%=tmp%>&ipaddress=<%=host.getIpAddress()%>&ifindex="+index+"&ifname="+ifname, "newwindow", "height=500, width=600, toolbar= no, menubar=no, scrollbars=yes, resizable=yes, location=yes, status=yes") 
} 
  
// ȫ���ۿ�
function gotoFullScreen() {
	parent.mainFrame.resetProcDlg();
	var status = "toolbar=no,height="+ window.screen.height + ",";
	status += "width=" + (window.screen.width-8) + ",scrollbars=no";
	status += "screenX=0,screenY=0";
	window.open("topology/network/index.jsp", "fullScreenWindow", status);
	parent.mainFrame.zoomProcDlg("out");
}
  function query()
  {  
     mainForm.id.value = <%=tmp%>;
     mainForm.action = "<%=rootPath%>/monitor.do?action=hostsyslog";
     mainForm.submit();
  }
function CreateWindow(urlstr)
{
msgWindow=window.open(urlstr,"protypeWindow","toolbar=no,width=500,height=400,directories=no,status=no,scrollbars=yes,menubar=no")
}
</script>
<script language="JavaScript" type="text/JavaScript">
var show = true;
var hide = false;
//�޸Ĳ˵������¼�ͷ����
function my_on(head,body)
{
	var tag_a;
	for(var i=0;i<head.childNodes.length;i++)
	{
		if (head.childNodes[i].nodeName=="A")
		{
			tag_a=head.childNodes[i];
			break;
		}
	}
	tag_a.className="on";
}
function my_off(head,body)
{
	var tag_a;
	for(var i=0;i<head.childNodes.length;i++)
	{
		if (head.childNodes[i].nodeName=="A")
		{
			tag_a=head.childNodes[i];
			break;
		}
	}
	tag_a.className="off";
}

//���Ӳ˵�	
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

function setClass(){
	document.getElementById('sunDetailTitle-5').className='detail-data-title';
	document.getElementById('sunDetailTitle-5').onmouseover="this.className='detail-data-title'";
	document.getElementById('sunDetailTitle-5').onmouseout="this.className='detail-data-title'";
}

function refer(action){
		document.getElementById("id").value="<%=tmp%>";
		var mainForm = document.getElementById("mainForm");
		mainForm.action = '<%=rootPath%>' + action;
		mainForm.submit();
}

//�����豸��ip��ַ
function modifyIpAliasajax(ipaddress){
	var t = document.getElementById('ipalias'+ipaddress);
	var ipalias = t.options[t.selectedIndex].text;//��ȡ�������ֵ
	$.ajax({
			type:"GET",
			dataType:"json",
			url:"<%=rootPath%>/networkDeviceAjaxManager.ajax?action=modifyIpAlias&ipaddress="+ipaddress+"&ipalias="+ipalias,
			success:function(data){
				window.alert("�޸ĳɹ���");
			}
		});
}
$(document).ready(function(){
	//$("#testbtn").bind("click",function(){
	//	gzmajax();
	//});
//setInterval(modifyIpAliasajax,60000);
});
</script>


</head>

<body id="body" class="body" onload="initmenu();">
	<IFRAME frameBorder=0 id=CalFrame marginHeight=0 marginWidth=0 scrolling=no src="<%=rootPath%>/include/calendar.htm"
		style="DISPLAY: none; HEIGHT: 194px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100"></IFRAME>  
	<form id="mainForm" method="post" name="mainForm">
		<input type=hidden name="orderflag">
		<input type=hidden name="id">
		<table id="body-container" class="body-container">
			<tr>
				<td class="td-container-menu-bar">
					<table id="container-menu-bar" class="container-menu-bar">
						<tr>
							<td>
								<%=menuTable%>
							</td>
						</tr>
					</table>
				</td>
				<td class="td-container-main">
					<table id="container-main" class="container-main">
						<tr>
							<td class="td-container-main-detail" width=85%>
								<table id="container-main-detail" class="container-main-detail">
									<tr>
										<td>
											<jsp:include page="/topology/includejsp/systeminfo_hostsolaris.jsp">
												<jsp:param name="rootPath" value="<%=rootPath%>" />
												<jsp:param name="tmp" value="<%=tmp%>" />
												<jsp:param name="picip" value="<%=picip%>" />
												<jsp:param name="hostname" value="<%=hostname%>" />
												<jsp:param name="sysname" value="<%=sysname%>" />
												<jsp:param name="CSDVersion" value="<%=CSDVersion%>" />
												<jsp:param name="processornum" value="<%=processornum%>" />
												<jsp:param name="collecttime" value="<%=collecttime%>" />
												<jsp:param name="sysuptime" value="<%=sysuptime%>" />
												<jsp:param name="mac" value="<%=mac%>" />
											</jsp:include>
										</td>
									</tr>
									<tr>
										<td>
											<table id="detail-data" class="detail-data">
												<tr>
													<td class="detail-data-header"><%=sunDetailTitleTable%></td>
												</tr>
												<tr>
													<td>
														<table class="detail-data-body">
															<tr>
																<td>
																	<table width="100%" border="0" cellpadding="0" cellspacing="0">
																		<tr>
																			<td colspan=5 bgcolor="#ECECEC" height="28">
																				&nbsp;&nbsp;&nbsp;&nbsp;��ʼ����
																				<input type="text" name="startdate" value="<%=startdate%>" size="10">
																				<a onclick="event.cancelBubble=true;" href="javascript:ShowCalendar(document.forms[0].imageCalendar1,document.forms[0].startdate,null,0,330)">
																					<img id=imageCalendar1 width=34 height=21 src="<%=rootPath%>/include/calendar/button.gif" border=0"> </a> ��ֹ����
																				<input type="text" name="todate" value="<%=todate%>" size="10" />
																				<a onclick="event.cancelBubble=true;" href="javascript:ShowCalendar(document.forms[0].imageCalendar2,document.forms[0].todate,null,0,330)">
																					<img id=imageCalendar2 width=34 height=21 src="<%=rootPath%>/include/calendar/button.gif" border=0"> </a> ��־�ȼ�
																				<select name="priorityname">
																					<option value="all">
																						all
																					</option>
																					<option value="panic">
																						panic
																					</option>
																					<option value="alert">
																						alert
																					</option>
																					<option value="critical">
																						critical
																					</option>
																					<option value="error">
																						error
																					</option>
																					<option value="warning">
																						warning
																					</option>
																					<option value="notice">
																						notice
																					</option>
																					<option value="info">
																						info
																					</option>
																					<option value="debug">
																						debug
																					</option>
																				</select>
		
																				<input type="button" name="submitss" value="��ѯ" onclick="query()">
																				&nbsp;&nbsp;
																				<%
																					if (unixflag.equals("1")) {
																				%>
																				<input type="button" name="submitss" value="��½�û���Ϣ" onclick=openwin( "showusersyslog",'<%=host.getIpAddress()%>') target="_blank">
																				<%
																					}
																				%>
																			</td>
																		</tr>
		
																		<tr>
																			<td>
																				<table cellSpacing="0" cellPadding="0" border=0>
																					<tr class="firsttr">
																						<td class="detail-data-body-title">
																							&nbsp;
																						</td>
																						<td width="10%" class="detail-data-body-title">
																							<strong>����</strong>
																						</td>
																						<td width="10%" class="detail-data-body-title">
																							<strong>����</strong>
																						</td>
																						<td class="detail-data-body-title">
																							<strong>��Դ</strong>
																						</td>
																						<td class="detail-data-body-title">
																							<strong>����</strong>
																						</td>
																						<td class="detail-data-body-title">
																							<strong>�¼�</strong>
																						</td>
																						<td class="detail-data-body-title">
																							<strong>�û�</strong>
																						</td>
																						<td class="detail-data-body-title">
																							<strong>�����</strong>
																						</td>
																						<td width="10%" class="detail-data-body-title">
																							<strong>�鿴</strong>
																						</td>
																					</tr>
																					<%
																						int index = 0;
																						java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat(
																								"MM-dd HH:mm");
																						List list = (List) request.getAttribute("list");
																						if (list == null)
																							list = new ArrayList();
																						for (int i = 0; i < list.size(); i++) {
																							index++;
																							Syslog syslog = (Syslog) list.get(i);
																							Date cc = syslog.getRecordtime().getTime();
																							int priority = syslog.getPriority();
																							String processName = syslog.getProcessname();
																							String priorityName = syslog.getPriorityName();
																							int eventid = syslog.getEventid();
																							//String hostname = syslog.getHostname();  
																							String bak = syslog.getUsername();
																							String ctime = sdf.format(cc);
																					%>
		
																					<tr bgcolor="#FFFFFF" <%=onmouseoverstyle%>>
		
																						<td class="detail-data-body-list">
																							&nbsp;<%=index%></td>
																						<td class="detail-data-body-list">
																							<%=priorityName%></td>
																						<td class="detail-data-body-list">
																							<%=ctime%>&nbsp;
																						</td>
																						<td class="detail-data-body-list">
																							<%=processName%></td>
																						<td class="detail-data-body-list">
																							<%=processName%></td>
																						<td class="detail-data-body-list">
																							<%=eventid%></td>
																						<td class="detail-data-body-list">
																							<%=bak%></td>
																						<td class="detail-data-body-list">
																							<%=hostname%></td>
																						<td class="detail-data-body-list">
																							<input type="button" value="��ϸ��Ϣ" class="button" onclick="javascript:return CreateWindow('<%=rootPath%>/monitor.do?action=hostsyslogdetail&id=<%=syslog.getId()%>&ipaddress=<%=syslog.getIpaddress()%>')">
																						</td>
																					</tr>
																					<%
																						}
																					%>
																				</table>
																			</td>
																		</tr>
																	</table>
																</td>
															</tr>
														</table>
													</td>
											</table>
										</td> 	
									</tr>
								</table>
							</td>
							<td class="td-container-main-tool" width=15%>
								<jsp:include page="/include/toolbar.jsp">
									<jsp:param value="<%=host.getIpAddress()%>" name="ipaddress" />
									<jsp:param value="<%=host.getSysOid()%>" name="sys_oid" />
									<jsp:param value="<%=tmp%>" name="tmp" />
									<jsp:param value="host" name="category" />
									<jsp:param value="solaris" name="subtype" />
								</jsp:include>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</form>
</BODY>
</HTML>