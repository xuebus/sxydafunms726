<%@page language="java" contentType="text/html;charset=GB2312"%>
<%@page import="com.afunms.flex.networkTopology.NetworkMonitor"%>
<%@page import="org.apache.commons.collections.functors.WhileClosure"%>
<%@page import="org.apache.commons.lang.SystemUtils"%>
<%@page import="org.apache.commons.net.DefaultDatagramSocketFactory"%>
<%@ include file="/include/globe.inc"%>
<%@page import="com.afunms.topology.util.NodeHelper"%>
<%@page import="com.afunms.inform.util.SystemSnap"%>
<%@page import="com.afunms.topology.dao.ManageXmlDao"%>
<%@page import="com.afunms.topology.model.ManageXml"%>
<%@page import="com.afunms.common.util.SessionConstant"%>
<%@page import="com.afunms.system.model.User"%>
<%@page import="com.afunms.system.vo.EventVo"%>
<%@page import="java.util.*"%>
<%@page import="com.afunms.initialize.ResourceCenter"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.afunms.system.dao.FunctionDao"%>
<%@page import="com.afunms.system.model.Function"%>
<%@page import="com.afunms.home.role.dao.HomeRoleDao"%>
<%@page import="com.afunms.home.user.dao.HomeUserDao"%>
<%

System.out.println("====zzz==========================1=================================zz");
	Hashtable smallHashtable = (Hashtable) request.getAttribute("smallHashtable");
	User uservo = (User) session.getAttribute(SessionConstant.CURRENT_USER);
	Hashtable bigHashtable = (Hashtable) request.getAttribute("bigHashtable");
	System.out.println(bigHashtable);
	int lastOne = 0;//�Ƿ����һ��Ԫ��
	Enumeration RLKey = smallHashtable.elements();
	while (RLKey.hasMoreElements()) {
		String accRole = RLKey.nextElement().toString();
		if (accRole.equals("1")) {
			lastOne++;
		}
	}
	String rootPath = request.getContextPath();
	String menuTable = (String) request.getAttribute("menuTable");
	List list = null;
	Date c1 = new Date();
	String timeFormat = "MM-dd HH:mm:ss";
	java.text.SimpleDateFormat timeFormatter = new java.text.SimpleDateFormat(timeFormat);
	List networklist = (List) session.getAttribute("networklist");
	List hostlist = (List) session.getAttribute("hostlist");
	String hostsize = "0";
	if (hostlist != null && hostlist.size() > 0)
		hostsize = hostlist.size() + "";
	String dbsize = (String) session.getAttribute("dbsize");
	if (dbsize == null)
		dbsize = "0";
	String securesize = (String) session.getAttribute("securesize");
	if (securesize == null)
		securesize = "0";
	String storagesize = (String) session.getAttribute("storagesize");
	if (storagesize == null)
		storagesize = "0";
	String servicesize = (String) session.getAttribute("servicesize");
	if (servicesize == null)
		servicesize = "0";
	String midsize = (String) session.getAttribute("midsize");
	if (midsize == null)
		midsize = "0";
	String routesize = (String) session.getAttribute("routesize");
	if (routesize == null)
		routesize = "0";
	String switchsize = (String) session.getAttribute("switchsize");
	if (switchsize == null)
		switchsize = "0";
	ManageXmlDao dao = new ManageXmlDao();
	ManageXml vo = (ManageXml) dao.findByView("1", uservo.getBusinessids());
	dao.close();
	String topo_name = "������ͼ";
	String home_topo_view = "network.jsp";
	String zoom = "1";
	if (vo != null) {
		topo_name = vo.getTopoTitle();
		home_topo_view = vo.getXmlName();
		zoom = vo.getPercent() + "";
	}
	session.setAttribute(SessionConstant.HOME_TOPO_VIEW, home_topo_view);
	ManageXmlDao mxdao = new ManageXmlDao();
	ManageXml mxvo = (ManageXml) mxdao.findByBusView("1", uservo.getBusinessids());

	//�õ�ҵ��澯��Ϣ
	NetworkMonitor networkMonitor = new NetworkMonitor();
	Hashtable bussinessviewHash = networkMonitor.getBussinessviewHash();
	System.out.println("====zzz==========================2=================================zz");
%>

<%
	//Ĭ��ѡ����û���һ������ҵ����Ϊ��ת��treeBid

	//������ҵ����û��·�������Ҹ��û�û����һ������ҵ�񣬲���ת��
	User user = (User) session.getAttribute(SessionConstant.CURRENT_USER);
	String[] bids = user.getBusinessids().split(",");
	String defaultbid = "";
	for (String bid : bids) {
		if (bid != null && !bid.equals("")) {
			defaultbid = bid;
			break;
		}
	}
	System.out.println("====zzz==========================3=================================zz");
	//������ҵ����û��·�������Ҹ��û���һ������ҵ���д���·����������ҵ��id��ΪtreeBid,��ת��
	String treeBidRouter = defaultbid;
	String treeBidHost = defaultbid;
	String treeBidSwitch = defaultbid;
	String treeBidDb = defaultbid;
	String treeBidMid = defaultbid;
	String treeBidService = defaultbid;
	String treeBidSecu = defaultbid;
	Hashtable treeBidHash = (Hashtable) request.getAttribute("treeBidHash");
	if (treeBidHash != null) {
		if (treeBidHash.containsKey("treeBidRouter")) {
			treeBidRouter = (String) treeBidHash.get("treeBidRouter");
		}
		if (treeBidHash.containsKey("treeBidHost")) {
			treeBidHost = (String) treeBidHash.get("treeBidHost");
		}
		if (treeBidHash.containsKey("treeBidSwitch")) {
			treeBidSwitch = (String) treeBidHash.get("treeBidSwitch");
		}
		if (treeBidHash.containsKey("treeBidDb")) {
			treeBidDb = (String) treeBidHash.get("treeBidDb");
		}
		if (treeBidHash.containsKey("treeBidMid")) {
			treeBidMid = (String) treeBidHash.get("treeBidMid");
		}
		if (treeBidHash.containsKey("treeBidService")) {
			treeBidService = (String) treeBidHash.get("treeBidService");
		}
		if (treeBidHash.containsKey("treeBidSecu")) {
			treeBidSecu = (String) treeBidHash.get("treeBidSecu");
		}
	}

	System.out.println("====zzz==========================44=================================zz="+treeBidRouter);
	
	String routepath = "/perform.do?action=monitornodelist&flag=1&category=net_router&treeBid=" + treeBidRouter;
	String switchpath = "/perform.do?action=monitornodelist&flag=1&category=net_switch&treeBid=" + treeBidSwitch;
	String hostpath = "/perform.do?action=monitornodelist&flag=1&category=net_server&treeBid=" + treeBidHost;
	String dbpath = "/db.do?action=list&flag=1&treeBid=" + treeBidDb;
	String midpath = "/middleware.do?action=list&flag=1&category=middleware&treeBid=" + treeBidMid;
	String servicepath = "/service.do?action=list&flag=1&treeBid=" + treeBidService;
	String securepath = "/perform.do?action=monitornodelist&flag=1&category=safeequip&treeBid=" + treeBidSecu;

	//�洢����·(��ʱ����·����������)   �޲��Ի���<Taskδ���>
	String storagepath = "/perform.do?action=monitornodelist&flag=1&category=net_router&treeBid=" + treeBidRouter;
%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
    	<meta http-equiv="X-UA-Compatible" content="IE=edge">
   		 <meta name="viewport" content="width=device-width, initial-scale=1">
		<link href="<%=rootPath%>/resource/<%=com.afunms.common.util.CommonAppUtil.getSkinPath()%>css/home_tabs.css" rel="stylesheet" type="text/css" />
		<!-- ѡ�ʽ�л���ģ��ʹ�� -->
		<link rel="stylesheet" href="<%=rootPath%>/resource/bootstrap/css/bootstrap.min.css">
		<script language="JavaScript" type="text/javascript" src="<%=rootPath%>/include/navbar.js"></script>
		<script type="text/javascript" src="<%=rootPath%>/include/swfobject.js"></script>
		<!--<script type="text/javascript" src="<%=rootPath%>/resource/xml/flush/amcolumn/swfobject.js"></script>  -->
		<!-- <link rel="stylesheet" type="text/css" href="<%=rootPath%>/application/environment/resource/ext3.1/resources/css/ext-all.css" /> -->
		<!-- GC -->
		<!-- LIBS -->
		<script type="text/javascript" src="<%=rootPath%>/application/environment/resource/ext3.1/adapter/ext/ext-base.js"></script>
		<!-- ENDLIBS -->
		<script type="text/javascript" src="<%=rootPath%>/application/environment/resource/ext3.1/ext-all.js"></script>
		<script type="text/javascript" src="<%=rootPath%>/application/environment/resource/ext3.1/examples/ux/ProgressBarPager.js"></script>
		<script type="text/javascript" src="<%=rootPath%>/application/environment/resource/ext3.1/examples/ux/PanelResizer.js"></script>
		<script type="text/javascript" src="<%=rootPath%>/application/environment/resource/ext3.1/examples/ux/PagingMemoryProxy.js"></script>
		<!-- EXT�����ص���Դ��ǩҳhome.js  css��ʽ�޸� -->
		<style type="text/css">
body {
	background: url(images/bg.jpg)
}

</style>
		<script type="text/javascript" src="<%=rootPath%>/js/home.js"></script>
		<script type="text/javascript" src="<%=rootPath%>/js/eventList.js"></script>
		<script type="text/javascript">window.setInterval(panelevent_var('<%=rootPath%>'),1000);</script>

		<script type="text/javascript">
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
		
		}
	</script>

		<script type="text/javascript">
		
		function hideMenu(){
			var element = document.getElementById("container-menu-bar").parentElement;
			var display = element.style.display;
			if(display == "inline"){
				hideMenuBar();
			}else{
				showMenuBar();
			}
			//ˢ��tabpanel�Ŀ���
			var tr_width = Ext.get("keybusiness_tr").getWidth()-1;
			Ext.get('tab_list_tr').setWidth(tr_width);
			Ext.get('tab_list').setWidth(tr_width);
			Ext.get('devicexn').setWidth(tr_width);
		}
		
		function showMenuBar(){
			var element = document.getElementById("container-menu-bar").parentElement;
			element.style.display = "inline";
		}
		
		function hideMenuBar(){
			var element = document.getElementById("container-menu-bar").parentElement;
			element.style.display = "none";
		}
		var fatherXML = "<%=home_topo_view%>";
		function redirectUrl(){
			if(fatherXML=="network.jsp"){
			    window.open('<%=rootPath%>/topology/network/index.jsp','window', 'toolbar=no,height=screen.height,width=screen.width,scrollbars=no,center=yes,resizable=yes');
		} else {
		    window.open('<%=rootPath%>/topology/submap/index.jsp?submapXml='+fatherXML,'window', 'toolbar=no,height=screen.height,width=screen.width,scrollbars=no,center=yes,resizable=yes');
			}
		}
	</script>

	</head>
	<body id="body" class="body" onLoad="parent.topFrame.location.reload();initmenu();hideMenuBar();">


	<%
			if (smallHashtable.get("�豸����").equals(1)) {
		%>

	<!-- �豸����ģ�� -->
	<div id="device_module" title="�豸����">
		<table width=100% height="100%" border="0" align='center'>
																			<tr valign="top">
																				<td>
																					<table id="content-header" class="content-header">
																						<tr>
																							<td class="content-title" align='center' height="29" style="text-align: center;">
																								<b>�豸����</b>
																							</td>
																						<tr>
																					</table>
																				</td>
																			</tr>
																			<tr>
																				<td width="100%">
																					<table width="100%">
																						<tr>
																							<td align="center">
																								<img src="<%=rootPath%>/resource/<%=NodeHelper.getSnapStatusImage(SystemSnap.getRouterStatus(), 1)%>">
																								<br>
																								<a href="#" onClick="showTree('<%=routepath%>');">·����(<%=routesize%>)</a>
																							</td>
																							<td align="center">
																								<img src="<%=rootPath%>/resource/<%=NodeHelper.getSnapStatusImage(SystemSnap.getSwitchStatus(), 2)%>">
																								<br>
																								<a href="#" onClick="showTree('<%=switchpath%>');">������(<%=switchsize%>)</a>
																							</td>
																							<td align="center">
																								<img src="<%=rootPath%>/resource/<%=NodeHelper.getSnapStatusImage(SystemSnap.getServerStatus(), 3)%>">
																								<br>
																								<a href="#" onClick="showTree('<%=hostpath%>');">������(<%=hostsize%>)</a>
																							</td>
																							<td align="center">
																								<img src="<%=rootPath%>/resource/<%=NodeHelper.getSnapStatusImage(SystemSnap.getDbStatus(), 4)%>">
																								<br>
																								<a href="#" onClick="showTree('<%=dbpath%>');">���ݿ�(<%=dbsize%>)</a>
																							</td>
																						</tr>
																						<tr>
																							<td>
																								<div style="height: 50px;"></div>
																							</td>
																						</tr>
																						<tr>
																							<td align="center">
																								<img src="<%=rootPath%>/resource/<%=NodeHelper.getSnapStatusImage(SystemSnap.getMiddleStatus(), 5)%>">
																								<br>
																								<a href="#" onClick="showTree('<%=midpath%>');">�м��(<%=midsize%>)</a>
																							</td>
																							<td align="center">
																								<img src="<%=rootPath%>/resource/<%=NodeHelper.getSnapStatusImage(SystemSnap.getServiceStatus(), 6)%>">
																								<br>
																								<!--<img src="<%=rootPath%>/resource/image/service.gif" ><br>-->
																								<a href="#" onClick="showTree('<%=servicepath%>');">����(<%=servicesize%>)</a>
																							</td>
																							<td align="center">
																								<img src="<%=rootPath%>/resource/<%=NodeHelper.getSnapStatusImage(SystemSnap.getFirewallStatus(), 7)%>">
																								<!--<img src="<%=rootPath%>/resource/image/topo/firewall/firewall.gif">-->
																								<br>
																								<a href="#" onClick="showTree('<%=securepath%>');">��ȫ(<%=securesize%>)</a>
																							</td>
																							<td align="center" bgcolor=#ffffff>
																								<img src="<%=rootPath%>/resource/image/topo/storage.gif">
																								<br>
																								<a href="#" onClick="showTree('<%=storagepath%>');">�洢(<%=storagesize%>)</a>
																							</td>
																						</tr>
																						<tr>
																							<td>
																								<div style="height: 20px;"></div>
																							</td>
																						</tr>
																					</table>
																				<td>
																			</tr>
																			<tr valign="bottom">
																				<td>

																				</td>
																			</tr>
																		</table>
		</div>
		<%
			}
		%>
		
		
		<!-- End �豸����ģ�� -->

	<%
			if (smallHashtable.get("��������ͼ").equals(1)) {
		%>
	<!-- �����豸����ͼģ�� -->
	<div id="topology_module" title="��������ͼ">
			
			<table width=100% height="100%" border="0" align='center'>
																			<tr>
																				<td align='center' height="24">
																					<table id="content-header" class="content-header">
																						<tr>
																							<td align='center' height="29" class="content-title" style="text-align: center;">
																								<b>��������ͼ-<%=topo_name%></b>
																							</td>
																						<tr>
																					</table>
																				</td>
																			</tr>
																			<tr>
																				<td align='center'>
																					<iframe name="topo_Frame" src="<%=rootPath%>/topology/network/h_showMap.jsp?zoom=<%=zoom%>" width="99%" height="99%" scrolling="No" frameborder="0" noresize></iframe>
																				</td>
																			</tr>
																			<tr valign="bottom" style="height: 4px;">
																				<td>
																					<table id="content-footer" class="content-footer">
																						<tr>
																							<td>

																							</td>
																						</tr>
																					</table>
																				</td>
																			</tr>
																		</table>
			
			</div>															
			<!-- end �����豸����ͼģ�� -->																		
		<%
			}
		%>

	<%
		if (smallHashtable.get("�豸����").equals(1)) {
	%>
	<!-- ���� -->								
		<div title="����">

		<table width=100% height="100%" border="0" align='center'>
			<tr>
				<td id='devicexn_title' align='center' height="24">
					<table id="content-header" class="content-header">
						<tr>
							<td align='center' height="29" class="content-title"
								style="text-align: center;"><b>����</b></td>
						<tr>
					</table>
				</td>
			</tr>
			<tr id="tab_list_tr">
				<td>
					<!-- EXT������TAB ���home.js�ļ� --> <!-- ���ص���ԴTabҳ -->
					<div id="tab_list" style="width: 100%;"></div>
				</td>
			</tr>
			<tr valign="bottom">
				<td></td>
			</tr>
		</table>
	</div>
	<!--End ���� -->		
	<% 
		}
	%>
	<%
		//�ڶ�����ʾ��ʼ
		if (smallHashtable.get("�ؼ�ҵ��").equals(1)) {
			
	%>
	<!-- ���¸澯 -->
	<div title="���¸澯">
		<table width=100% height="100%" border="0" align='center'>
			<tr valign="top" id="keybusiness_tr">
				<td>
					<table id="content-header" class="content-header">
						<tr>
							<td align='center' height="29" class="content-title"
								style="text-align: center;"><b>���¸澯</b></td>
						<tr>
					</table>
				</td>
			</tr>
			<tr>
				<td align="left">

					<div id="event_list" style="width: 100%;"></div>
				</td>
			</tr>


		</table>
	</div>
	<!--End ���¸澯 -->
	<%
		}
	%>
	<script type="text/javascript">
			//Ext.onReady(tabpanel_var('<%=rootPath%>'));
		/* Ext.onReady(function(){panelevent_var('<%=rootPath%>');tabpanel_var('<%=rootPath%>
			')
			});
*/
			//����һ��JavaScript��replaceAll����  ���÷�������ͻ����������֧�֣�
			//String.prototype.replaceAll  = function(s1,s2){    
			//  	return this.replace(new RegExp(s1,"gm"),s2);   
			//} 

			/**
			 *��ת������ҳ��
			 */
			function showTree(rightFramePath) {
				//�����ں�andת��һ��  
				//rightFramePath = rightFramePath.replaceAll("&","-and-");
				//rightFramePath = rightFramePath.replaceAll("=","-equals-");
				//ʹ��ѭ���������ں�andת��һ��  
				/* while (rightFramePath.indexOf("&") != -1) {
					rightFramePath = rightFramePath.replace("&", "-and-");
				}
				while (rightFramePath.indexOf("=") != -1) {
					rightFramePath = rightFramePath.replace("=", "-equals-");
				} */
				rightFramePath = window.encodeURIComponent(rightFramePath);
				window.location.href = "<%=rootPath%>/performance/index.jsp?flag=1&rightFramePath="+rightFramePath;
			}
		</script>
		<!-- jQuery�ļ��������bootstrap.min.js ֮ǰ���� -->
		<script src="<%=rootPath%>/resource/js/jquery-1.4.2.min.js"></script>
		
		<!-- ���µ� Bootstrap ���� JavaScript �ļ� -->
		<script src="<%=rootPath%>/resource/bootstrap/js/bootstrap.min.js"></script>
		<script type="text/javascript">
			$(document).ready(function() {
				//ʼ���ڼ��غ���ʾ��һ��ģ����ͼ
				$('body > div:gt(0)').hide();
				//����ģ����ͼ�ı������ѡ�
				var $tabsContainer = $('<ul id="moduleViewNav" class="nav nav-tabs"></ul>').prependTo('body');
			

		
				$('body > div').each(function(index, el) {
				
					var $tab = $('<li role="presentation"><a href="#">'+$(this).attr('title')+'</a></li>').appendTo($tabsContainer);
					if(index == 0){
						$tab.addClass('active');//���غ�Ӧʹ��һ��ѡ������������ѡ���Ҫ������
					}
					//��������ģ����ͼ������ͬʱ�������ѡ���Ӧ��ģ����ͼ
					var $moduleDiv = $(el);
					$tab.click(function(event) {
						var $activitatingTab = $(this);
						$activitatingTab.parent().find('li').each(function(index, el) {
							var $activitatedTab = $(this);
							
							if ($activitatedTab.hasClass('active')) {
								$activitatedTab.removeClass('active').data('moduleView').fadeOut('fast',function(){
									
									$activitatingTab.addClass('active')
									.data('moduleView').fadeIn('slow');
								});
							}
						});
						
					}).data('moduleView', $moduleDiv);
				});
				
			});
		</script>
	</body>
</html>