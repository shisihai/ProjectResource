<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript" src="${pageContext.request.contextPath }/pms/pub/combobox/comboboxUtil.js" charset="utf-8"></script>
<!-- 增加轮保计划 -->
<script type="text/javascript">
	$(function() {
		$.loadComboboxData($("#eqp_category"),"EQPCATEGORY",false);
		$.loadComboboxData($("#shiftId"),"SHIFT",false);
		$.loadComboboxData($("#matId"),"MATPROD",false);
		//根据设备类型加载设备机型，根据设备机型加载设备润滑点
		$("#eqp_category").combobox({
			onChange:function(newValue,oldValue){
				if(newValue!=null&&newValue!=""){
					//加载设备机型
					$("#eqp_typeId").combobox({  
					    url:"${pageContext.request.contextPath}/pms/md/eqptype/queryMdEqpTypeByCid.do?id="+newValue,
					    valueField:'id',  
					    textField:'name',
					    onChange:function(nvalue,ovalue){
					    	//加载设备保养规则
					    	$("#ruleId").combobox({  
							    url:"${pageContext.request.contextPath}/pms/md/eqptypeChild/getPaulbyEqpType.do?type=lb&eqpTypeId="+nvalue,
							    valueField:'secId',  
							    textField:'secName',
							    onHidePanel:function(){
							    	var typeName=$("#ruleId").combobox("getText");
							    	$("#ruleName").val(typeName);
							    }
							});
					    },
					    onHidePanel:function(){
					    	var typeName=$("#eqp_typeId").combobox("getText");
					    	$("#eqp_typeName").val(typeName);
					    }
					});
				}
		    }
		});
	});
	
</script>
<div class="easyui-layout" data-options="fit:true,border:false">
	<div data-options="region:'center',border:false" title="" style="overflow: hidden;padding:5px">
		<form id="form" method="post">
			<fieldset>
				<table class="table" style="width:97%;">
					<tr>
						<th>开始时间</th>
						<td>
							<input name="date_plan1" type="text" class="easyui-my97"  style="width:130px" data-options="panelHeight:'auto',required:true,prompt:'请选择开始时间'"/>
						</td>
						<th>结束时间</th>
						<td>
							<input name="date_plan2" type="text" class="easyui-my97" style="width:130px" data-options="panelHeight:'auto',required:true,prompt:'请选择结束时间'"/>
						</td>
					</tr>
					<tr>
						<th>设备类型</th>
						<td>
							<select id="eqp_category" name="eqp_category" class="easyui-combobox" data-options="panelHeight:'auto',width:175,editable:false,required:true,prompt:'请选择设备类型'"/>
						</td>
						<th>设备型号</th>
						<td>
							<input id="eqp_typeId" name="eqp_typeId" class="easyui-combobox" data-options="panelHeight:'auto',width:175,editable:false,required:true,prompt:'请选择设备型号'"/>
							<input id="eqp_typeName" name="eqp_typeName" class="combo-value" type="hidden"/>
						</td>
					</tr>
					<tr>
						<th>轮保规则</th>
						<td>
							<input id="ruleId" name="ruleId" class="easyui-combobox" data-options="width:140,editable:false,required:true,prompt:'请选择润滑规则'"/>
							<input id="ruleName" name="ruleName" type="hidden"/>
						</td>
						<th>牌号</th>
						<td>
							<select id="matId" name="matId" data-options="panelHeight:'auto',width:130,editable:false,required:true"/>
						</td>
					</tr>
					<tr>
						<th>轮保时长</th>
						<td>
							<input id="equipmentMinute" name="equipmentMinute" type="text" value="480"  data-options="panelHeight:'auto',width:175,editable:false,required:true,prompt:'请选择时长'"/>
						</td>
						<th>班次</th>
						<td>
							<select id="shiftId" name="shiftId" style="width:170px;" data-options="panelHeight:'auto',width:175,editable:false,required:true,prompt:'请选择班次'"/>
						</td>
					</tr>
				</table>
			</fieldset>
		</form>
	</div>
</div>