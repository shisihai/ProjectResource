<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<style>
	#czg-tab-tbody tr{height:30px;text-align:center;}
	#czg-tab-thead tr td{text-align:center;}
</style>
<script src="${pageContext.request.contextPath}/wct/js/qmPublic.js" type="text/javascript" ></script>
<script type="text/javascript">
	var formattedtime=/^(0\d{1}|1\d{1}|2[0-3]):([0-5]\d{1})$/;
	var formattedtime2=/^(0\d{1}|1\d{1}|2[0-3]):([0-5]\d{1})-(0\d{1}|1\d{1}|2[0-3]):([0-5]\d{1})$/;
	var flag;
	var inserttime;
	var changeClick =null;	
	var changeType ="init";
	$(function(){
		//默认光标选中文本框
	    $("#cardNum").focus();
		//checked全选、反选事件
        $("#czg-tab-thead-CKA").click(function() {
        	$("#czg-tab-tbody tr").each(function(idx) {
           		if($(this).find("#czg-tab-tbody-CK").get(0)!=null
                   	&&$(this).find("#czg-tab-tbody-CK").get(0)!=undefined){
           			$(this).find("#czg-tab-tbody-CK").get(0).checked = 
               			$("#czg-tab-thead-CKA").get(0).checked;
               }
			});
        });
        changeClick=function(type){
			//编辑事件
			$("#czg-tab-tbody tr").die().live("click",function(){
				var tr=$(this);
				if(tr.attr("edit")){
					return;
				};
				$(this).find("#czg-tab-tbody-CK").get(0).checked=true;//选中当前行
				tr.attr("edit",true);
				tr.find("td").each(function(index){
	            	var oldText=$(this).text();//原来的值   5
	            	var zjId = tr.find("#czg-tab-tbody-CK").get(0).value;//如果有 就表示 数据库数据
	            	//根据key 或 value 赋值
	            	if(index==2){
	            		var formId="form-control ";
				        var classId="zl-keyboard-"+tr.find("td:eq(1)").text()+"td"+index;
				        var classKey=".zl-keyboard-"+tr.find("td:eq(1)").text()+"td"+index;
				        var classIds = formId+classId;
	            		var se2="<input type='text' class='"+classIds+"' style='width:100%;height: 30px;' value='"+oldText+"' />";
	                   $(this).html(se2);
	                   $(classKey).keyboard({
	        				layout:"1234567890:-",
	        				customLayout: {
	        					'default': [
	        						"{accept} 1 2 3 4 5 6 ",
	        						"7 8 9 0 : - {bksp}"
	        					]
	        				}
	        			});	
	            	}
	                if(index==3){
	                	if(zjId==""||zjId==undefined){//表示是 新增的行
	                		oldText = tr.find("td:eq(3) select").val();
			            }
	                    var se3="<select style='width:100px;height:30px;'>";
	                    for(var i=0;i<arryKey.length;i++ ){
	                    	 if(arryKey[i]==oldText||arryVal[i]==oldText){
	                        	se3+="<option value='"+arryKey[i]+"' selected>"+arryVal[i]+"</option>" ;
	                        }else{
	                        	se3+="<option value='"+arryKey[i]+"' >"+arryVal[i]+"</option>";
	                        }
	                    }
	                    se3+="</select>";
	                    //alert(se3);
	                   $(this).html(se3);
	                }
	              	if(index==4){
	              		if(zjId==""||zjId==undefined){//表示是 新增的行
	              			oldText = tr.find("td:eq(4) input").val();//	当前第4列 	重量g/20支
			            }
			            var formId="form-control ";
			            var classId="zl-keyboard-"+index+"td"+index;
			            var classKey=".zl-keyboard-"+index+"td"+index;
			            var classIds =formId+classId;
	              		var se4="<input type='text' value='"+oldText+"' " 
	                    	+" class='"+classIds+"' "
	                    	+"style='height: 30px;'/>";/* width:120px; */
	                	$(this).html(se4);
	                	$(classKey).keyboard({
	        				layout:"1234567890.-",
	        				customLayout: {
	        					'default': [
	        						"{accept} 1 2 3 4 5 6 ",
	        						"7 8 9 0 . - {bksp}"
	        					]
	        				}
	        			});	
					}
	              	
					if(index==5){//外观质量情况
						if(zjId==""||zjId==undefined){//表示是 新增的行
							oldText = tr.find("td:eq(5) select").val();
			            }
	                    var se5="<select style='width:100px;height:30px;'>";
	                    for(var i=0;i<qxKey.length;i++ ){
	                        if(qxKey[i]==oldText||qxVal[i]==oldText){
	                        	se5+="<option value='"+qxKey[i]+"' selected>"+qxVal[i]+"</option>" ;
	                        }else{
	                        	se5+="<option value='"+qxKey[i]+"' >"+qxVal[i]+"</option>";
	                        }
	                    }
	                    se5+="</select>";
	                    //alert(se5);
	                   $(this).html(se5);
					}
					if(index==6){
	              		if(zjId==""||zjId==undefined){//表示是 新增的行
	              			oldText = tr.find("td:eq(6) input").val();//	当前第4列 	重量g/20支
			            }
			            var formId="form-control ";
			            var classId="zl-keyboard-"+tr.find("td:eq(6)").text()+"td"+index;
			            var classKey=".zl-keyboard-"+tr.find("td:eq(6)").text()+"td"+index;
			            var classIds =formId+classId;
	              		var se6="<input type='text' value='"+oldText+"' " 
	                    	+" class='"+classIds+"' "
	                    	+"style='height: 30px;border-radius:5px'/>";/* width:120px; */
	                	$(this).html(se6);
	                	$(classKey).keyboard({
	        				layout:"1234567890.-",
	        				customLayout: {
	        					'default': [
	        						"{accept} 1 2 3 4 5 6 ",
	        						"7 8 9 0 . - {bksp}"
	        					]
	        				}
	        			});	
					}
					if(index==7){//处理措施
						if(zjId==""||zjId==undefined){//表示是 新增的行
							oldText = tr.find("td:eq(7) select").val();
			            }
	                    var se7="<select style='width:100px;height:30px;'>";
	                    for(var i=0;i<csKey.length;i++ ){
	                        if(csKey[i]==oldText||csVal[i]==oldText){
	                        	se7+="<option value='"+csKey[i]+"' selected>"+csVal[i]+"</option>" ;
	                        }else{
	                        	se7+="<option value='"+csKey[i]+"' >"+csVal[i]+"</option>";
	                        }
	                    }
	                    se6+="</select>";
	                    //alert(se6);
	                   $(this).html(se7);
					}
					
	            }); 
	        });
        };
       changeClick("load");//供编辑用
	});
	//查询
	function search(){
		changeType ="query";
		if(schWorkorderId==""||schWorkorderId==undefined){
			jAlert("没有工单号不可以操作","提示");
			return false;
		}
		$("#czg-tab-thead-CKA").get(0).checked = false;//顶部checkbox为不选状态
		var params ={proWorkId : schWorkorderId,checkType:"1"};//工单主键ID
		$.post("${pageContext.request.contextPath}/wct/massFrist/getList.do",params,function(data){
				var html="";
				var list=data.rows;
				if(data.rows!=null&&data.rows.length>0){
					for(var i=0;i<data.rows.length;i++){
						var revalue=list[i];
						var checkMatter="";
						var checkCondition="";
						var checkStep="";
						//根据 key 或 value找 value
						for(var j=0;j<arryKey.length;j++){
							if(arryKey[j]==revalue.checkMatter||arryVal[j]==revalue.checkMatter){
								checkMatter=arryVal[j];
								 break;
							 }
						} 
						for(var j=0;j<qxKey.length;j++){
							if(qxKey[j]==revalue.checkCondition||qxVal[j]==revalue.checkCondition){
								checkCondition=qxVal[j];
								 break;
							 }
						}
						for(var j=0;j<csKey.length;j++){
							if(csKey[j]==revalue.checkStep||csVal[j]==revalue.checkStep){
								checkStep=csVal[j];
								 break;
							 }
						}
						html+="<tr>"
							+"	<td>"
							+"	<input value="+revalue.qmFirstId+" type='checkbox' style='width:20px;height:20px;' name='czg-tab-tbody-CK' id='czg-tab-tbody-CK'/></td>"
							+"	</td>"
							+"	<td>"+(i+1)+"</td>"
							+"	<td>"+revalue.checkTime+"</td>"
							+"	<td>"+checkMatter+"</td>"
							+"	<td >"+revalue.checkWeight+"</td>"
							+"	<td>"+checkCondition+"</td>"
							+"	<td>"+revalue.failureNum+"</td>"
							+"	<td>"+checkStep+"</td>"
							+"</tr>";
					}
				}else{}
				$("#czg-tab-tbody").html(html);
			},"JSON");

	}				
	//新增
	function insert(){
		changeType ="insert";
		var zjy =$("#isMassCheckZjr").text();
		if(schWorkorderId==""||schWorkorderId==undefined){
			jAlert("没有工单号不可以操作","提示");
			return false;
		}
	    if(zjy!='true'){
			jAlert("自检员不可为空,请先登录!","提示");
			return false;
		}
		var nowDate = getDateHourAndMinute();
		var trLength=$("#czg-tab-tbody tr").length;//获取tr的行数
        var se3="<select style='width:100px;'>";
        for(var i=0;i<arryKey.length;i++ ){
        	if(i==0){
            	se3+="<option value='"+arryKey[i]+"' selected>"+arryVal[i]+"</option>" ;
            }else{
          		se3+="<option value='"+arryKey[i]+"' >"+arryVal[i]+"</option>";
            }
        }
        se3+="</select>";

        var formId="form-control ";
        var classId="zl-keyboard-"+trLength+"td4";
        var classIds =formId+classId;
     	var se4="<input type='text' value='' " 
       		+" class='"+classIds+"' "
       		+"style='height: 30px;border-radius:5px'/>";
           	
        var se5="<select style='width:100px;'>";
         for(var i=0;i<qxKey.length;i++ ){
        	 if(i==0){
        		 se5+="<option value='"+qxKey[i]+"' selected>"+qxVal[i]+"</option>" ;
             }else{
            	 se5+="<option value='"+qxKey[i]+"' >"+qxVal[i]+"</option>";
             }
         }
         se5+="</select>";
           
         var se6="<input type='text' value='0' " 
            	+" class='"+classIds+"' "
            	+"style='height: 30px;border-radius:5px'/>";
            	
		 var se7="<select style='width:100px;'>";
         for(var i=0;i<csKey.length;i++ ){
        	 if(i==0){
        		 se7+="<option value='"+csKey[i]+"' selected>"+csVal[i]+"</option>" ;
             }else{
            	 se7+="<option value='"+csKey[i]+"' >"+csVal[i]+"</option>";
             }
         }
         se7+="</select>";
		var html="<tr>"
			+"	<td>"
			+"		<input value='' type='checkbox' style='width:20px;height:20px;' name='czg-tab-tbody-CK' id='czg-tab-tbody-CK'/></td>"
			+"	</td>"
			+"	<td>"+(trLength+1)+"</td>"
			+"	<td width='100px;'>"+nowDate+"</td>"
			+"	<td>"+se3+"</td>"
			+"	<td width='50'>"+se4+"</td>"
			+"	<td>"+se5+"</td>"
			+"	<td width='50'>"+se6+"</td>"
			+"	<td>"+se7+"</td>"
			+"</tr>";
			$("#czg-tab-tbody").append(html);
			var trRow="#czg-tab-tbody tr:eq("+(trLength)+")";//当前行
			$(trRow).click();//行 获取焦点
	}
	//修改
	function update(){
		changeType ="update";
	}
	//删除
	function deletes(){
		changeType ="delete";
		var zjy =$("#isMassCheckZjr").text();
		if(schWorkorderId==""||schWorkorderId==undefined){
			jAlert("没有工单号不可以操作","提示");
			return false;
		}
		if(zjy!='true'){
			jAlert("自检员不可为空,请先登录!","提示");
			return false;
		}
		 var ids="";
		 $("#czg-tab-tbody tr").each(function(idx) {
            //alert(idx+":"+$(this).find("#czg-tab-tbody-CK").get(0));
            var trCk = $(this).find("#czg-tab-tbody-CK").get(0);//checkbox对象
         	if(trCk!=null&&trCk!=undefined&&trCk.checked){
         		ids +=trCk.value+",";
             }
         });
         if(ids==""){
        	 jAlert("请选择需要删除的记录","删除");
             return false;
         }
         //alert(ids);
         jConfirm('删除提示?', '标题', function(r) {
 			if(r){
 				 //跑到后台处理后 并查询
 				$.ajax({
 		            type: "post",//使用get方法访问后台
 		            dataType: "json",//返回json格式的数据
 		            url: "${pageContext.request.contextPath}/wct/massFrist/deleteByIds.do",//要访问的后台地址
 		            data: "ids=" + ids,//要发送的数据
 		            complete :function(){
 		                //$("#load").hide();
 		            },//AJAX请求完成时隐藏loading提示
 		            success : function(r) {
 						if(r.success){
 							search();//重新查询下
 						}else{ 
 							jAlert("删除失败!","提示");
 						}
 					}
 		         });
 			}
 		 });
	}

	//保存
	function save(){
		changeType ="save";
		var zjy =$("#isMassCheckZjr").text();
		if(schWorkorderId==""||schWorkorderId==undefined){
			jAlert("没有工单号不可以操作","提示");
			return false;
		}
		if(zjy!='true'){
			jAlert("自检员不可为空,请先登录!","提示");
			return false;
		}
		var massCheckBc =$("#massCheckBc").text();
		var massCheckJth =$("#massCheckJth").text();
		var massCheckPm =$("#massCheckPm").text();
		var massCheckDcg =$("#massCheckDcg").text();
		var zjUserName =$("#massCheckZjr").text();//登录人
		var _eqpId=$('#eqpId').text();//设备id
		var _matId=$('#matId').text();//牌号id
		var _shiftID=$('#shiftID').text();
		//alert("dd:"+zjy);
		var checkString = '[';
			checkString += '{"proWorkId":"'+schWorkorderId 
			+ '","mdShiftName":"'+ massCheckBc//班次
			+ '","mdEqmentName":"'+ massCheckJth//机台号
			+ '","mdEqmentId":"'+ _eqpId//机台id
			+ '","mdMatId":"'+ _matId//牌号id
			+ '","mdShiftId":"'+ _shiftID//班次id
			+ '","mdMatName":"'+ massCheckPm//牌号
			+ '","mdDcgName":"'+ massCheckDcg//挡车工
			+ '","zjUserName":"'+ zjUserName//登录人
			+ '"}';
			checkString += ']';
		//alert(checkString);
		//return ;
		var reqString = '[';
		var isNextNumber= 0;
		 $("#czg-tab-tbody tr").each(function(idx) {//for循环
	           var tr = $(this);//tr对象
	           var trCk = tr.find("#czg-tab-tbody-CK").get(0);//checkbox对象,当前第0列
	        	if(trCk!=null&&trCk!=undefined&&trCk.checked){
	        		 var td0 = trCk.value;//当前第0列,主键，判断更新或者新增
	        		 var td1 = tr.find("td:eq(1)").text();//当前第1列  		序号
	        		 var td2 = tr.find("td:eq(2)").text();//当前第2列			 时间
	        		 var td3 = "";//当前第3列 	首检原因
	        		 var td4 = "";//	当前第4列 	重量g/20支
	        		 var td5 = "";//当前第5列 	不合格支数
					 var td6 = "";//当前第6列 	外观质量情况
					 var td7 = "";//当前第7列 	处理措施
					 inserttime=td2;
					 if(tr.attr("edit")){//表示当前行都在 编辑状态
						 td2 = tr.find("td:eq(2) input").val();
						 td3 = tr.find("td:eq(3) select").val();
						 td4 = tr.find("td:eq(4) input").val();
						 td5 = tr.find("td:eq(5) select").val();
						 td6 = tr.find("td:eq(6) input").val();
						 td7 = tr.find("td:eq(7) select").val();
						 inserttime=td2;
					 }else{
						 td2 = tr.find("td:eq(2)").text();
						 td3 = tr.find("td:eq(3)").text();
						 td4 = tr.find("td:eq(4)").text();
						 td5 = tr.find("td:eq(5)").text();
						 td6 = tr.find("td:eq(6)").text();
						 td7 = tr.find("td:eq(7)").text();
						 inserttime=td2;
						 //根据中文找 key
						 for(var j=0;j<arryKey.length;j++ ){
							if(arryVal[j]==td3){
								td3=arryKey[j];
								 break;
							 }
						 } 
					 	for(var j=0;j<qxKey.length;j++ ){
							if(qxVal[j]==td5){
								td5=qxKey[j];
								 break;
							 }
						}
						for(var j=0;j<csKey.length;j++ ){
							if(csVal[j]==td7){
								td7=csKey[j];
								 break;
							 }
						}
					 }
					 if(formattedtime.test(inserttime) || formattedtime2.test(inserttime)){
						 flag=true;
					 }else{
						 flag=false;
					 }
				     reqString += '{"qmFirstId":"'+td0//主键
						+ '","checkTime":"'+ td2//首检时间
						+ '","checkMatter":"'+ td3//首检原因 
						+ '","checkWeight":"'+ td4//重量
						+ '","checkCondition":"'+ td5//外观质量
						+ '","failureNum":"'+ td6//不合格数
						+ '","failureUom":"7'//单位
						+ '","addUserName":"'+ zjUserName//登录人名称
						+ '","checkStep":"'+ td7//处理措施
						+ '","proWorkId":"'+schWorkorderId //工单主键
						+ '","checkType":"1' //类型
						+ '"}';
						reqString += ',';
						//alert(idx +":"+isNextNumber);
						isNextNumber++;
						
	            }
	        });
	   	if(reqString!="["){
	   		reqString = reqString.substring(0,(reqString.length-1));
		}else{
			jAlert("请选择需要保存的记录","保存");
			return false;
		}
		reqString += ']';
	   	
		if(!flag){
			jAlert("请输入正确格式的时间,如 0"+inserttime,"温馨提示");
			return false;
		}
	 	//var params =reqString;//{eqpCod:equ}
		//alert(reqString);
		//return ;
        //跑到后台处理后 并查询
         $.ajax({
            type: "post",//使用get方法访问后台
            dataType: "json",//返回json格式的数据
            url: "${pageContext.request.contextPath}/wct/massFrist/editBean.do",//要访问的后台地址
            data: "firstArray=" + reqString+"&checkArray="+checkString,//要发送的数据
            complete :function(){
                //$("#load").hide();
            },//AJAX请求完成时隐藏loading提示
            success : function(r) {
				if(r.success){
					search();//重新查询下
				}else{
					jAlert("保存失败!","提示");
				}
			}
         });
	}
	
</script>

</head>
<title>操作工_1</title>
	<!-- 内容 -->
	<table border="1" borderColor="#9a9a9a"
		style="BORDER-COLLAPSE: collapse; font-size: 12px; font-weight: 500;margin-bottom:300px;"
		width="100%"  cellspacing="0" cellpadding="0">
		<thead id="czg-tab-thead"
			style="background: #5a5a5a; color: #fff;">
			<tr>
				<td width="40">
					<input id="czg-tab-thead-CKA" style="width:20px;height:20px;" name="czg-tab-thead-CKA" type="checkbox"/></td>
				</td>
				<td>序号</td>
				<td>时间</td><td><p>首检原因</p></td><td>重量g/20支</td><td>外观质量情况</td><td>不合格数(支)</td><td>处理措施</td>
			</tr>
		</thead>
		<tbody id="czg-tab-tbody">
		
		</tbody>
		<input type="hidden"  id="tfRole" value="8af2d43f4d73d86d014d73df6da90000"/>
	</table>
</html>
