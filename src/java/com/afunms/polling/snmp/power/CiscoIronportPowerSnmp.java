package com.afunms.polling.snmp.power;

/*
 * @author yangjun@dhcc.com.cn
 *
 */

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Hashtable;
import java.util.List;
import java.util.Vector;

import com.afunms.common.util.ShareData;
import com.afunms.common.util.SnmpUtils;
import com.afunms.common.util.SysLogger;
import com.afunms.indicators.model.NodeGatherIndicators;
import com.afunms.monitor.executor.base.SnmpMonitor;
import com.afunms.monitor.item.base.MonitoredItem;
import com.afunms.polling.PollingEngine;
import com.afunms.polling.base.Node;
import com.afunms.polling.node.Host;
import com.afunms.polling.om.Interfacecollectdata;
import com.afunms.topology.model.HostNode;
import com.gatherResulttosql.NetDatatemppowerRtosql;
import com.gatherResulttosql.NetpowerResultTosql;


/**
 * @author Administrator
 *
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class CiscoIronportPowerSnmp extends SnmpMonitor {
	java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	/**
	 * 
	 */
	public CiscoIronportPowerSnmp() {
	}

	   public void collectData(Node node,MonitoredItem item){
		   
	   }
	   public void collectData(HostNode node){
		   
	   }
	/* (non-Javadoc)
	 * @see com.dhcc.webnms.host.snmp.AbstractSnmp#collectData()
	 */
	public Hashtable collect_Data(NodeGatherIndicators alarmIndicatorsNode) {
		Hashtable returnHash=new Hashtable();
		Vector powerVector=new Vector();
		Host node = (Host)PollingEngine.getInstance().getNodeByID(Integer.parseInt(alarmIndicatorsNode.getNodeid()));
		if(node == null)return null;
		try {
			Interfacecollectdata interfacedata = new Interfacecollectdata();
			Calendar date=Calendar.getInstance();
			Hashtable ipAllData = (Hashtable)ShareData.getSharedata().get(node.getIpAddress());
			if(ipAllData == null)ipAllData = new Hashtable();
			
			  try{
				  SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				  com.afunms.polling.base.Node snmpnode = (com.afunms.polling.base.Node)PollingEngine.getInstance().getNodeByIP(node.getIpAddress());
				  Date cc = date.getTime();
				  String time = sdf.format(cc);
				  snmpnode.setLastTime(time);
			  }catch(Exception e){
				  
			  }
			  try {
				  //-------------------------------------------------------------------------------------------��Դ start
//				  INTEGER {powerSupplyNotInstalled(1),
//					  powerSupplyHealthy(2),
//					  powerSupplyNoAC(3),
//					  powerSupplyFaulty(4)
//					  }
		   		  if(node.getSysOid().startsWith("1.3.6.1.4.1.15497.")){
		   			String[][] valueArray = null;
		   			String[] oids =                
						  new String[] {               
							"1.3.6.1.4.1.15497.1.1.1.8.1.4",//����
							"1.3.6.1.4.1.15497.1.1.1.8.1.2",//״̬
							"1.3.6.1.4.1.15497.1.1.1.8.1.1"//����
		   			};
		   			valueArray = SnmpUtils.getTemperatureTableData(node.getIpAddress(), node.getCommunity(), oids, node.getSnmpversion(), 3, 3000);
		   			int flag = 0;
					if(valueArray != null){
					   	  for(int i=0;i<valueArray.length;i++)
					   	  {
					   		String _value = valueArray[i][1];
					   		String index = valueArray[i][2];
					   		String desc = valueArray[i][0].replaceAll(",", "-").replaceAll(" ", "-");
//					   		int value=0;
//					   		try{
//					   			value=Integer.parseInt(_value);
//					   		}catch(Exception e){
//					   			
//					   		}
					   		//desc=index;
							flag = flag +1;
					   		List alist = new ArrayList();
					   		alist.add(index);
					   		alist.add(_value);
					   		alist.add(desc);
					   		//powerList.add(alist);				   		
					   		  interfacedata = new Interfacecollectdata();
					   		  interfacedata.setIpaddress(node.getIpAddress());
					   		  interfacedata.setCollecttime(date);
					   		  interfacedata.setCategory("Power");
					   		  interfacedata.setEntity(index);
					   		  interfacedata.setSubentity(desc);
					   		  interfacedata.setRestype("dynamic");
					   		  interfacedata.setUnit("");		
					   		  interfacedata.setThevalue(_value);
							  SysLogger.info(node.getIpAddress()+" index:"+index+"  ����:"+desc+" ��Դ״̬�� "+_value);
							  powerVector.addElement(interfacedata);		   		
					   	  }
					}
		   		  } 
				  //powerVector.add(powerList);
		   	  }
		   	  catch(Exception e)
		   	  {
		   	  }	   	  
		   	  //-------------------------------------------------------------------------------------------��Դ end
			}catch(Exception e){
			}
		
//		Hashtable ipAllData = (Hashtable)ShareData.getSharedata().get(node.getIpAddress());
//		if(ipAllData == null)ipAllData = new Hashtable();
//		ipAllData.put("power",powerVector);
//	    ShareData.getSharedata().put(node.getIpAddress(), ipAllData);
//	    returnHash.put("power", powerVector);
	    
		if (!(ShareData.getSharedata().containsKey(node.getIpAddress()))) {
			Hashtable ipAllData = new Hashtable();
			if (ipAllData == null) ipAllData = new Hashtable();
			if (powerVector != null && powerVector.size() > 0) ipAllData.put("power", powerVector);
				ShareData.getSharedata().put(node.getIpAddress(), ipAllData);
			} 
		else{
			if (powerVector != null && powerVector.size() > 0) ((Hashtable) ShareData.getSharedata().get(node.getIpAddress())) .put("power", powerVector);
		}	
	    returnHash.put("power",powerVector);
//	  �Ѳɼ��������sql
	    NetpowerResultTosql tosql=new NetpowerResultTosql();
	    tosql.CreateResultTosql(returnHash,node.getIpAddress());
	    NetDatatemppowerRtosql totempsql=new NetDatatemppowerRtosql();
	    totempsql.CreateResultTosql(returnHash, node);
	    return returnHash;
	}
}




