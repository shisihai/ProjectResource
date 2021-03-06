<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript" src="${pageContext.request.contextPath}/pms/pub/combobox/comboboxUtil.js" charset="utf-8"></script>
<script type="text/javascript">
	var editWcpLbgzGrid;
	var editLbgzGrid2;
	var djMethodData ="";//点检方式
	var equipmentXhId = $('#equipmentXhId').val();//这个是绑定的 计划对应的规则 设备型号ID
	var metcId = $('#metcId').val();//根据绑定的 点检ID来锁定 已选的 规则
	$(function() {
		$.loadComboboxData($("#shiftId"),"SHIFT",false);
		$.loadComboboxData($("#matProd1"),"MATPROD",false);
		//下拉框
		$("#djMethodId").combobox({
			url:'${pageContext.request.contextPath }/pms/equ/lubricant/queryListById.do?key=402899894db7df6f014db7f7080e0001&&type=all',
			textField:'lubricantName',
			valueField:'id',
			multiple:true,//多选
			required:false,
		    onLoadSuccess: function(data){
			    if(data!=null&&data.length>0){
			    	djMethodData = data;
				}
		    }
		});
		

		
		editWcpLbgzGrid = $('#editWcpLbgzGrid').datagrid({
			rownumbers :true,
			idField : 'secId',
			fit : true,
			singleSelect :true,
			fitColumns : true,// 自动布局列宽
			remoteSort: false,
			border : false,
			striped : true,
			nowrap : false,		//这个属性很重要,确保可以多选
			checkOnSelect : false,
			selectOnCheck : false,
			columns : [ [ {
				title : '主键ID',
				field : 'metcId'
				,hidden : true
				//,checkbox : true
			},{
				title : '主键ID',
				field : 'secId'
				,hidden : true
			}, {
				field : 'secCode',
				title : '编号',
				width : 120,
				sortable : true
			} , {
				field : 'secName',
				title : '名称',
				width : 120,
				sortable : true
			} , {
				field : 'type',
				title : '类型',
				width : 160,
				sortable : true,
				formatter : function(value, row, index) {
					var thisStr = value;
					if(value=='dj'){
						thisStr="点检";
					}
					return thisStr;
				}
			}] ],
			toolbar : '#matPickToolbar',
			onLoadSuccess : function(row) {//当表格成功加载时执行       
				$(this).datagrid('tooltip');
				var rowData = row.rows;
				 $.each(rowData,function(idx,val){//遍历JSON
                     if(val.metcId==metcId){
                    	 $("#editWcpLbgzGridId").attr("value",val.metcId);//点击的时候 赋值 主键ID 这个必须要
                   	  	//editWcpLbgzGrid.datagrid('checkRow', idx);//选中当前行
                   	  	editWcpLbgzGrid.datagrid("selectRow", idx);//如果数据行为已选中则选中改行
                   	 	queryMdTypeByCategory(val.secId);
                     }
                }); 
			},
			onClickRow:function(rowIndex,rowData){
				$("#editWcpLbgzGridId").attr("value",rowData.metcId);//点击的时候 赋值 主键ID 
				queryMdTypeByCategory(rowData.secId);
			}
		});
		
		editLbgzGrid2 = $('#editLbgzGrid2').datagrid({
			//remoteSort: false,
			rownumbers : true,
			fit : true,
			fitColumns : true,//fitColumns= true就会自动适应宽度（无滚动条）
			border : false,
			pagination : true,
			idField : 'id',
			striped : true,
			remoteSort : false,
			pageSize : 10,
			pageList : [ 10, 20, 60, 80, 100 ],
			singleSelect : true,
			checkOnSelect : false,
			selectOnCheck : false,
			nowrap : true,		//false 确保可以多选;设置为 true后 字段大于该列长度后不显示全部
			showPageList : false,
			columns : [ [ {
				title : '点检设备ID',
				field : 'id',
				hidden : true
			//,checkbox : true
			}, {
				field : 'code',
				title : '点检设备编号',
				width : 120,
				sortable : true
			}, {
				field : 'name',
				title : '点检设备名称',
				width : 120,
				sortable : true
			},{
				field : 'djMethodId',
				title : '点检方式',
				width : 120,
				sortable : true,
				formatter : function(value, row, index) {
					var thisStr = value;
					if(djMethodData!=null){
						var djMethodIds =value;
						if(djMethodIds!=null){
							var values = $("#djMethodId").combobox('setValues',djMethodIds.split(','));
							//var val = $('#djMethodId').combobox('getValues').join(',');
							var val = $('#djMethodId').combobox('getText');
							thisStr = val;
							if(thisStr.indexOf("请选择")>=0){
								thisStr = thisStr.replace("请选择","");
							}
						}
					}
					return thisStr;
				}
			}, {
				field : 'djType',
				title : '点检角色',
				width : 160,
				sortable : true,
				formatter : function(value, row, index) {
					var thisStr = value;
					if(value=='0'){
						thisStr="操作工点检";
					}else if(value=='1'){
						thisStr="维修工点检";
					}else if(value=='2'){
						thisStr="维修主管点检";
					}
					return thisStr;
				}
			} ] ],
			//toolbar : '#matPickToolbar',
			onLoadSuccess : function() {
				$(this).datagrid('tooltip');
			}
		});
	});

	//首次加载 根据设备型号 加载绑定的项
	var beanQuery ={queryEqpTypeId : equipmentXhId,queryType:'dj'};//设备型号ID
	editWcpLbgzGrid.datagrid({
		url : "${pageContext.request.contextPath}/pms/equc/check/queryEqpTypeChild.do",
		queryParams :beanQuery
	});
	
	function queryMdTypeByCategory(id) {
		var bean = {
			categoryId : id
		};//设备型号ID
		editLbgzGrid2.datagrid({
			url : "${pageContext.request.contextPath}/pms/sys/eqptype/queryMdType.do",
			queryParams : bean
		});
	}

	$('#equipmentName').searchbox({  
	    searcher:function(value,name){  
	    var dialog = parent.$.modalDialog({
				title : '选择设备',
				width : 600,
				height : 420,
				href : '${pageContext.request.contextPath}/pms/equ/wcplan/eqpPicker.jsp',
				 buttons : [ {
					text : '选择',
					iconCls:'icon-standard-disk',
					handler : function() {
						var row = dialog.find("#eqpPickGrid").datagrid('getSelected');
						if(row){
							 $("#equipmentLxId").attr("value",row.mdEqpCategoryId);//设备类型
							 $("#equipmentLxName").attr("value",row.mdEqpCategoryName);
							 $("#equipmentId").attr("value",row.id);//设备名称
							 $("#equipmentName").searchbox("setValue",row.equipmentName);
							 $("#equipmentXhId").attr("value",row.eqpTypeId);//设备型号
							 $("#equipmentXhName").attr("value",row.eqpTypeName);
							 //根据 设备型号ID 查询 对应的规则(设备项 的 大类)
							 //alert(row.eqpTypeId);
							 
							 $("#editWcpLbgzGridId").attr("value","");//重新选择的时候  控制为空
							var bean ={queryEqpTypeId : row.eqpTypeId,queryType:'dj'};//设备型号ID
				     			editWcpLbgzGrid.datagrid({
				     				url : "${pageContext.request.contextPath}/pms/equc/check/queryEqpTypeChild.do",
				     				queryParams :bean
				     			});
			     			//删除表二中的数据
							 editLbgzGrid2.datagrid('loadData', { total: 0, rows: [] });//清空下方DateGrid	
							 dialog.dialog('destroy'); 
						}else{
							$.messager.show('提示', '请选择一条设备信息', 'info');
						} 
						
						
					}
				} ] 
			});
	    }  
	}); 

</script>
<div class="easyui-layout" style="width:100%;height:497px;">

	<div id="matPickToolbar" style="display: none;">
		<div class="topTool">
			<form id="form" method="post">
				<fieldset>
					<table class="table" style="width: 100%;">
					<tr>
						<input name="planId" id="planId" type="hidden" value="${wcpBean.planId}"/>  
						<input name="metcId" id="metcId" type="hidden" value="${wcpBean.metcId}"/>  
						<input name="editWcpLbgzGridId" type="hidden" id="editWcpLbgzGridId"/><!-- 判断用 -->  
						<th style="text-align:left" >计划编号</th>
						<td>  	
							<input name="planCode" style="width:140px" 
							onkeyup="value=value.replace(/[^\a-zA-Z0-9\_-]/g,'')"
							class="easyui-validatebox"
							data-options="required:true" maxlength="50" value="${wcpBean.planCode}"/>  
						</td>
						<th style="text-align:left" >计划名称</th>
						<td>
						<input name="planName" style="width:140px" class="easyui-validatebox" 
						data-options="required:true" maxlength="50" value="${wcpBean.planName}"/>  
						</td>
						<th style="text-align:left" >点检类别</th>
						<td>
							<select style="width:140px" name="maintenanceType" 
							class="easyui-combobox fselect" readonly="readonly" 
							data-options="panelHeight:'auto',required:true" >
								<option value="dj" <c:if test="${wcpBean.maintenanceType=='dj' }">selected="selected"</c:if>>点检</option>
							</select>
						</td>
					</tr>
					<tr>
						<th style="text-align:left" >设备名称</th>
						<td>	
							<input id="equipmentName" style="width:140px" class="easyui-searchbox"  
							data-options="prompt:'请选择卷烟机或成型机',required:true" value="${wcpBean.equipmentName}"/>  
							<input id="equipmentId" name="equipmentId" type="hidden" value="${wcpBean.equipmentId}"/>  
						</td>
						<th style="text-align:left" >设备类型</th>
						<td>
							<input id="equipmentLxId" name="equipmentLxId" type="hidden" value="${wcpBean.equipmentLxId}"/>  	
							<input id="equipmentLxName" name="equipmentLxName" value="${wcpBean.equipmentLxName}" 
							style="width:140px" readonly="readonly"/>  
						</td>
						<th style="text-align:left" >设备型号</th>
						<td>
							<input id="equipmentXhId" name="equipmentXhId" type="hidden" value="${wcpBean.equipmentXhId}" />  
							<input id="equipmentXhName" name="equipmentXhName" value="${wcpBean.equipmentXhName}" style="width:140px" readonly="readonly" />  
						</td>
					</tr>
					<tr>
						<th style="text-align:left" >点检时长</th>
						<td>
							<input name="equipmentMinute" class="easyui-numberspinner"
	     					required="required" 
	     					value="${wcpBean.equipmentMinute}"
	     					data-options="min:1,max:999,width:120"/>分钟
						</td>
						<th style="text-align:left" >点检日期</th>
						<td>
							<input id="scheduleDate" name="scheduleDate"  value="${wcpBean.scheduleDate}" 
							type="text" class="easyui-my97"  style="width:140px" data-options="required:true"/>
						</td>
						<th style="text-align:left" >牌号</th>
						<td>
							<input id="matProd1" name="matId" 
							data-options="panelHeight:'auto',width:140,editable:false,required:false" 
							value="${wcpBean.matId}" maxlength="50" />
						</td>
					</tr>
					<tr>
						<th style="text-align:left" >班次</th>
						<td>
							<input id="shiftId" name="mdShiftId" type="text"
							data-options="required:true" readonly="readonly"
							style="width: 140px" value="${wcpBean.mdShiftId}"  />
						</td>
						<th style="text-align:left" >是否维修主管点检</th>
						<td>
							<select style="width:140px" name="isZgCheck" class="easyui-combobox fselect" readonly="readonly" data-options="panelHeight:'auto',required:true">
								<option value="N"  <c:if test="${wcpBean.isZgCheck=='N' }">selected="selected"</c:if>>否</option>
								<option value="Y"  <c:if test="${wcpBean.isZgCheck=='Y' }">selected="selected"</c:if>>是</option>
							</select>
						</td>
						<th></th>
						<td></td>
					</tr>
					<tr>
						<th style="text-align:left" >备注</th>
						<td colspan="5">
							<textarea style="width:696px;height:30px;resize:none" 
							name="maintenanceContent"  maxlength="1000" >${wcpBean.maintenanceContent}</textarea>
						</td>
					</tr>
					<tr style="display: none;" >
						<td><input name="djMethodId" id="djMethodId"  type="hidden" /></td>
					</tr>
				</table>
				</fieldset>
			</form>	
		</div>		
	</div>
	
	<div style="height:350px;" split="true" iconCls="icon-reload" data-options="region:'north',border:false">
		<table id="editWcpLbgzGrid"></table>
	</div>
	<!-- style="height:100px;" -->
	<div  split="true" iconCls="icon-reload" data-options="region:'center',border:false">
		<table id="editLbgzGrid2"></table>
	</div>

</div>
