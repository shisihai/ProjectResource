<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
</head>
<title>质量告警</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script src="${pageContext.request.contextPath}/wct/js/jquery.min.js" type="text/javascript" ></script>
<link href="${pageContext.request.contextPath}/jslib/bootstrap-2.3.1/css/bootstrap.css" rel="stylesheet" media="screen">
<link rel="stylesheet" type="text/css"	href="${pageContext.request.contextPath}/wct/css/wct_global.css"></link>
<script src="${pageContext.request.contextPath}/wct/js/wctTools.js" type="text/javascript" ></script>

<jsp:include page='../../initlib/initMyAlert.jsp' ></jsp:include>
<jsp:include page='../../initlib/initManhuaDate.jsp' ></jsp:include>
<script type="text/javascript" src="${pageContext.request.contextPath}/wct/js/comboboxUtil.js" charset="utf-8"></script>
<style type="text/css">
*{font-family: "Microsoft YaHei","宋体",Arial;}
	#title{
		font-size: 20px;
		font-weight: bold;
		text-align: center;
		padding-top: 4px;
		background: #b4b4b4;
		color: #3C3C3C;
		border-radius: 0px 4px 0px 0px;
		line-height: 35px;
		height: 40px;
		border-bottom: 2px solid #838383;
	}
	#prodMailPlan-seach-box{
		border: 1px solid #9a9a9a;
		width: 821px;
		margin-left: 10px;
		height: 36px;
		margin: 0 auto;		
		margin-top: 15px;
		font-size: 14px;
		font-weight: bold;
		padding-top: 8px;
		padding-left: 5px;
		border-radius: 4px;
		background: #dedcda;
	}
	
	
	#prodMailPlan-wct-frm td{
		font-size: 14px;
		font-weight: bold;
	}
	#prodMailPlan-tab{		
		width:824px;
		margin: 0 auto;	
		height:auto;
		margin-top:5px;
		font-size:12px;
		font-weight:bold;
		height: 462px;
		border: 1px solid #858484;
		border-radius: 4px;	
	}
	.t-header{
		text-align:center;
	}
	#prodMailPlan-tab-thead tr td,#prodMailPlan-tab-tbody tr td{
		/* padding:7px; */
		height:40px;
		text-align:center;
	}
	#prodMailPlan-page{
		width:97%;
		margin-left:10px;
		height:auto;
		font-size:12px;
		font-weight:bold;
		text-align:right;
		padding-top:4px;
	}
	#details{
		border:2px solid #dddddd;
		width:96%;
		margin-left:10px;
		height:80px;
		margin-top:5px;
		padding:2px;
		text-indent:15px;
	}
	#up,#down{
		border:1px solid #9a9a9a;
		padding:3px 2px;
		width:70px;
		font-weight:bold;
		font-size:12px;
		cursor:pointer;
	}
	.btn-default {
		color: #FFFFFF;
		background-color: #5A5A5A;
		border-color: #cccccc;
	}

	.btn {
	  display: inline-block;
	  padding:0px;
	  margin-bottom: 0;
	  font-size: 14px;
	  font-weight: normal;
	  line-height: 1.428571429;
	  text-align: center;
	  white-space: nowrap;
	  vertical-align: middle;
	  cursor: pointer;
	  background-image: none;
	  border: 1px solid transparent;
	  border-radius: 4px;
	  -webkit-user-select: none;
	     -moz-user-select: none;
	      -ms-user-select: none;
	       -o-user-select: none;
	          user-select: none;
	}
</style>
<script type="text/javascript">
	//显示数据div, 隐藏关闭 div
	var bandParams;
	$(function(){
		$("#table_mes_div").css("display","block");
		$("#mat_system").css("display","none");
		$("input.mh_date").manhuaDate({					       
			Event : "click",//可选				       
			Left : 0,//弹出时间停靠的左边位置
			Top : -16,//弹出时间停靠的顶部边位置
			fuhao : "-",//日期连接符默认为-
			isTime : false,//是否开启时间值默认为false
			beginY : 2010,//年份的开始默认为1949
			endY :2049//年份的结束默认为2049
		});
		//初始化时间
	    var today = new Date();
		var month=today.getMonth()+1;
		if(month<10){month=("0"+month);}
		var day=today.getDate();
		if(day<10){day=("0"+day);}
	    var date=today.getFullYear()+"-"+month+"-"+day;
	    $("#startTime").val(date);	//时间用这个
		$("#endTime").val(date);	//时间用这个
		//end
	});

	var groupTypeFlag="${groupTypeFlag}";
	var group=null;
	var pageIndex=1;
	var allPages=0;
	var params={};
	$(function(){
		 bandParams=function(pageIndex,params){
			
			$.post("${pageContext.request.contextPath}/wct/msg/carn/getQmWarnList.do?pageIndex="+pageIndex,params,function(reobj){
				
			var list=reobj.rows;
				allPages=reobj.total>10?reobj.total/10:1;
				$("#pageIndex").html(pageIndex);
				$("#allPages").html(allPages);
				$("#count").html(reobj.total);
				clearParams();
				$("#prodMailPlan-tab-tbody tr").each(function(idx){
						if(list.length>idx){
							var tr=$(this);
							var revalue=list[idx];	
							//console.info(revalue);
							tr.find("td:eq(1)").html(revalue.id);//主键 FileID 
							tr.find("td:eq(2)").html(revalue.workordername);
							tr.find("td:eq(3)").html(revalue.equipmentname);
							tr.find("td:eq(4)").html(revalue.qi);
							tr.find("td:eq(5)").html(revalue.val);
							tr.find("td:eq(6)").html(revalue.content);
							tr.find("td:eq(7)").html(revalue.time);
							tr.find("td:eq(8)").html("<input type='button' id='prodFault-time-order' value='确认'  onclick=completes('"+revalue.id+"') style='height:28px;width:60px;' class='btn btn-default'/>");
						}
				}); 
			},"JSON");
		};
		
		$("#up").click(function(){
			if(pageIndex<=1){
				return;
			}
			pageIndex=pageIndex-1;
			bandParams(pageIndex,params);
		});
		
		$("#down").click(function(){
			if(pageIndex>=allPages){
				return;
			}
			pageIndex=pageIndex+1;
			bandParams(pageIndex,params);
		});
		$("#prodMailPlan-search").click(function(){
			//alert(111);
			params=getJsonData($('#prodMailPlan-wct-frm'));
			//console.info(params);
			bandParams(1,params);
		
		});
		$("#prodMailPlan-reset").click(function(){
			params={};
			
			$("#workshop").val(""); 
			$("#eqiupment").val(""); //默认值 供后台用
			 var today = new Date();
				var month=today.getMonth()+1;
				if(month<10){month=("0"+month);}
				var day=today.getDate();
				if(day<10){day=("0"+day);}
			    var date=today.getFullYear()+"-"+month+"-"+day;
			    $("#startTime").val(date);	//时间用这个
				$("#endTime").val(date);	//时间用这个
		});
		//加载品名
		$.loadSelectData($("#workshop"),"WORKSHOP",true);
		$.loadSelectData($("#eqiupment"),"ALLEQPS",true);
		var clearParams=function(){
			$("#prodMailPlan-tab-tbody tr").each(function(idx){
					var tr=$(this);
					tr.find("td:eq(1)").html(null);
					tr.find("td:eq(2)").html(null);
					tr.find("td:eq(3)").html(null);
					tr.find("td:eq(4)").html(null);
					tr.find("td:eq(5)").html(null);
					tr.find("td:eq(6)").html(null);
					tr.find("td:eq(7)").html(null);
					tr.find("td:eq(8)").html(null);
			});
		};
		
	});
	//确认功能
	function completes(id){
		$.post("${pageContext.request.contextPath}/wct/msg/carn/getQmUpdate.do?id="+id,function(json){
			console.info(json.success);
			if(json.success){		
			params=getJsonData($('#prodMailPlan-wct-frm'));
			//console.info(params);
			bandParams(1,params);
			}
		},"JSON");
		
	}
	//关闭按钮
	function closePage(){
		$("#mat_system").css("display","none");
		$("#table_mes_div").css("display","block");
		
	}

</script>
</head>
<body>
	<div id="title">质量告警</div>
	<!--信息数据 div -->
	<div id="table_mes_div">
		<div id="prodMailPlan-seach-box" >
			<form id="prodMailPlan-wct-frm">
				<input type="hidden" name="prodStatus"  id="prodStatus"  value="2"/>
				<table width="100%" cellspacing="0" cellpadding="0">
					<tr>
						<td>车间：</td>
						<td>
							<select style="width:110px;height:20px;"  name="workshopid" id="workshop"></select>
				     
						</td>
						<td>机台：</td>
						<td>
							<select type="text" name="equipmentid"style="width: 110px; height: 20px;"id="eqiupment" ></select>
						</td>
						<td>时间：</td>
						<td>
							
							<input type="text" id="startTime" name="stim" class="mh_date" readonly="readonly" style="width:160px;height:20px;"/>
						</td>
						<td>到：</td>
						<td>	
							<input type="text" id="endTime" name="etim" class="mh_date" readonly="readonly" style="width:160px;height:20px;"/>
						</td>
						<td><input type="button" id="prodMailPlan-search" value="查询"style="height: 28px; width: 50px;" class="btn btn-default" /></td>
						<td><input type="button" id="prodMailPlan-reset" value="重置"style="height: 28px; width: 50px;" class="btn btn-default" /></td>
					</tr>
				</table>
			</form>
		</div>
		<div id="prodMailPlan-tab" style="height:472px;overflow:auto;">
			<table border="1" borderColor="#9a9a9a" style="BORDER-COLLAPSE:collapse;font-size: 12px;font-weight: 500;" width="824" height="474" cellspacing="0" cellpadding="0">
				<thead id="prodMailPlan-tab-thead" style="background: #5a5a5a;color: #fff;">
					<tr>
						<td class="t-header" style="width:30px"></td>
						<td class="t-header" style="width:80px;display:none"></td><!-- 主键 FileID -->
						<td class="t-header" style="width:80px">车间</td>
						<td class="t-header" style="width:80px">机台号</td>
						<td class="t-header" style="width:80px">质量标准值</td>
						<td class="t-header" style="width:80px">质量实际值</td>
						<td class="t-header" style="width:150px">告警内容</td>
						<td class="t-header" style="width:110px">告警时间</td>
						<td class="t-header" style="width:80px">操作</td>
					</tr>
				</thead>
				<tbody id="prodMailPlan-tab-tbody">
					<tr>
						<td>1</td>
						<td style="width:90px;display:none"></td><!-- 主键 FileID -->
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
					<tr>
						<td>2</td>
						<td style="width:90px;display:none"></td><!-- 主键 FileID -->
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
					<tr>
						<td>3</td>
						<td style="width:90px;display:none"></td><!-- 主键 FileID -->
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
					<tr>
						<td>4</td>
						<td style="width:90px;display:none"></td><!-- 主键 FileID -->
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
					<tr>
						<td>5</td>
						<td style="width:90px;display:none"></td><!-- 主键 FileID -->
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
					<tr>
						<td>6</td>
						<td style="width:90px;display:none"></td><!-- 主键 FileID -->
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
					<tr>
						<td>7</td>
						<td style="width:90px;display:none"></td><!-- 主键 FileID -->
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
					<tr>
						<td>8</td>
						<td style="width:90px;display:none"></td><!-- 主键 FileID -->
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
					<tr>
						<td>9</td>
						<td style="width:90px;display:none"></td><!-- 主键 FileID -->
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
					<tr>
						<td>10</td>
						<td style="width:90px;display:none"></td><!-- 主键 FileID -->
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
				</tbody>
			</table>
		</div>
		<div id="prodMailPlan-page">
			共<span id="count">0</span>条数据
			<input id="up" type="button"  value="上一页" class="btn btn-default"/>
			<span id="pageIndex">0</span>/<span id="allPages">0</span>
		    <input id="down" type="button"  value="下一页" class="btn btn-default"/>
		</div>
	</div>

	<div id="mat_system">
		<div >
			<iframe id="insertWeb" frameborder="0"  style="height: 522px;width: 818px;padding-top: -20px;"></iframe>				
		</div>
		<div>
			<input style="margin-left:384px;height:40px;width:100px;" id="closeWeb" onclick="closePage();" type="button"  value="关闭" class="btn btn-default" />
		</div>
	 </div>
</body>
</html>
	
	
