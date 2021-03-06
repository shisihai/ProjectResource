package com.shlanbao.tzsc.data.runtime;

import java.util.List;

import org.apache.log4j.Logger;
import org.apache.mina.core.service.IoHandlerAdapter;
import org.apache.mina.core.session.IoSession;
/**
 * 收据接收处理器
 * @author Leejean
 * @create 2015年1月6日上午9:48:58
 */
public class DataReceiveHandler extends IoHandlerAdapter {

	protected Logger log = Logger.getLogger(this.getClass());
	private List<String> validIPs;
	private static DataReceiveBusiness business = DataReceiveBusiness.getInstance();
	
	@Override
	public void exceptionCaught(IoSession session, Throwable cause)
			throws Exception {
		log.error("Socket连接异常  ip:"+session.getRemoteAddress().toString().split(":")[0].substring(1),cause);
	}

	@Override
	public void messageReceived(IoSession session, Object message)
			throws Exception {
		log.info("接收到客户端数据:" + session.getRemoteAddress());
		String ip = session.getRemoteAddress().toString().split(":")[0].substring(1);
		if(!business.checkIp(validIPs, ip)){
			log.error("来自 " + ip + "的Socket连接地址非法");
		} else
		{
			//log.error("来自 " + ip + "的Socket连接地址");
			business.updateDataSnapshot(message);
		}
	}

	@Override
	public void sessionClosed(IoSession session) throws Exception {
		log.info("来自" + session.getRemoteAddress() + "的Socket连接已关闭");
		String ip = session.getRemoteAddress().toString().split(":")[0].substring(1);
		//检测IP是否合法
		if(!business.checkIp(validIPs, ip)){
			log.error("来自 " + ip + "的Socket连接地址非法");
		} 
	}

	@Override
	public void sessionOpened(IoSession session) throws Exception {
		log.info("有新的连接:" + session.getRemoteAddress());
		String ip = session.getRemoteAddress().toString().split(":")[0].substring(1);
		if(!business.checkIp(validIPs, ip)){
			log.error("来自 " + ip + "的Socket连接地址非法");
		}
	}
	public List<String> getValidIPs() {
		return validIPs;
	}
	public void setValidIPs(List<String> validIPs) {
		this.validIPs = validIPs;
	}

}
