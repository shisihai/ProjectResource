package com.shlanbao.tzsc.pms.equ.resume.service;

import com.shlanbao.tzsc.base.model.DataGrid;
import com.shlanbao.tzsc.base.model.PageParams;
import com.shlanbao.tzsc.pms.equ.resume.beans.EqmSurveyBean;

public interface EqmSurveyServiceI {
	/**
	 * 删除
	 * @param id
	 * @throws Exception
	 */
	public void deleteById(String id) throws Exception;
	/**
	 * 根据主键ID查询信息
	 * @param id
	 * @return
	 * @throws Exception
	 */
	public EqmSurveyBean getById(String id) throws Exception;
	/**
	 * 添加 或 修改
	 * @param bean
	 * @param userId
	 * @throws Exception
	 */
	public void addOrEditBean(String eqmResumeId ,EqmSurveyBean[] bean,String userId) throws Exception;
	/**
	 * 分页查询
	 * @param bean
	 * @param pageParams
	 * @return
	 * @throws Exception
	 */
	public DataGrid queryList(EqmSurveyBean bean,PageParams pageParams) throws Exception;
}
