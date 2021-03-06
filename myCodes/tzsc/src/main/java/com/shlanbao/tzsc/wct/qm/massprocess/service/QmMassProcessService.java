package com.shlanbao.tzsc.wct.qm.massprocess.service;

import com.shlanbao.tzsc.base.model.DataGrid;
import com.shlanbao.tzsc.base.model.PageParams;
import com.shlanbao.tzsc.wct.qm.massprocess.beans.QmMassProcessBean;
import com.shlanbao.tzsc.wct.sys.login.beans.LoginBean;
/**
 * 过程自检记录接口
 * <li>@author luther.zhang
 * <li>@create 2015-03-18
 */
public interface QmMassProcessService {
	/**
	 * 查询
	 */
	DataGrid queryList(QmMassProcessBean bean,PageParams pageParams) throws Exception;

	/**
	 * 首检记录 新增修改
	 * @param checkBean
	 * @param firstBean	
	 * @param login		自检人登录信息	
	 * @throws Exception
	 */
	void editBean(QmMassProcessBean[] checkBean,QmMassProcessBean[] processBean,LoginBean login) throws Exception;
	/**
	 * 删除
	 * @author luther.zhang
	 * @create 2014-12-25
	 * @param id
	 */
	void deleteByIds(String id) throws Exception;
	
}
