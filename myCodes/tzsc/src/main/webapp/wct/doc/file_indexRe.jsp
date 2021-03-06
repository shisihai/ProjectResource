<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
</head>
<title>下发的文件</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script src="${pageContext.request.contextPath}/wct/js/jquery.min.js" type="text/javascript" ></script>
<link href="${pageContext.request.contextPath}/jslib/bootstrap-2.3.1/css/bootstrap.css" rel="stylesheet" media="screen">
<link rel="stylesheet" type="text/css"	href="${pageContext.request.contextPath}/wct/css/wct_global.css"></link>
<script src="${pageContext.request.contextPath}/wct/js/wctTools.js" type="text/javascript" ></script>

<jsp:include page='../../initlib/initMyAlert.jsp' ></jsp:include>

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
	#fileMailPlan-seach-box{
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
	
	
	#fileMailPlan-wct-frm td{
		font-size: 14px;
		font-weight: bold;
	}
	#fileMailPlan-tab{		
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
	#fileMailPlan-tab-thead tr td,#fileMailPlan-tab-tbody tr td{
		/* padding:7px; */
		height:40px;
		text-align:center;
	}
	#fileMailPlan-page{
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
	$(function(){
		$("#table_mes_div").css("display","block");
		$("#mat_system").css("display","none");
	});
	var groupTypeFlag="${groupTypeFlag}";
	var group=null;
	var pageIndex=1;
	var allPages=0;
	$(function(){
		var bandParams=function(pageIndex){ 
			$.post("${pageContext.request.contextPath}/wct/file/docfile/getList.do?pageIndex="+pageIndex,{filename:$("#filename").val()},function(reobj){				
				var list=reobj.rows;
				//console.info(list);
				if(reobj.total>10){
					if(reobj.total/10==0){
						allPages=reobj.total/10;
					}else{
						allPages=Math.floor(reobj.total/10)+1;
					}
				}else{
					allPages=1;
				}
				$("#pageIndex").html(pageIndex);
				$("#allPages").html(allPages);
				$("#count").html(reobj.total);
				clearParams();
				$("#fileMailPlan-tab-tbody tr").each(function(idx){
						if(list.length>idx){
							var tr=$(this);
							var revalue=list[idx];							
							tr.find("td:eq(1)").html(revalue.id);//主键 FileID
							tr.find("td:eq(2)").html(revalue.filename);//文件名
							tr.find("td:eq(3)").html(revalue.url);//文件类型
							tr.find("td:eq(4)").html(revalue.fileType);//文件路径
							tr.find("td:eq(5)").html(revalue.createTime);//文件类型
							tr.find("td:eq(6)").html(revalue.uploadUrl);
							tr.find("td:eq(7)").html("<input type='button' id='fileFault-time-order' value='预览'  onclick=completes('"+revalue.url+"') style='height:28px;width:60px;' class='btn btn-default'/>");
						}
				});
			},"json");
		};
		
		$("#up").click(function(){
			if(pageIndex<=1){
				return;
			}
			pageIndex=pageIndex-1;
			bandParams(pageIndex);
		});
		
		$("#down").click(function(){
			if(pageIndex>=allPages){
				return;
			}
			pageIndex=pageIndex+1;
			bandParams(pageIndex);
		});
		$("#fileMailPlan-search").click(function(){
			params=getJsonData($('#fileMailPlan-wct-frm'));
			//alert(params.fileId);
			bandParams(1);
		});
		$("#fileMailPlan-reset").click(function(){
			params={};
			$("#fileMailPlan-wct-frm input[type!=button]").val(null);
			$("#matprod").val(""); 
			$("#fileStatus").val("2"); //默认值 供后台用
		});
		
		bandParams(1);
		//加载品名
		//$.loadSelectData($("#matprod"),"MATPROD",true);
		
		var clearParams=function(){
			$("#fileMailPlan-tab-tbody tr").each(function(idx){
					var tr=$(this);
					tr.find("td:eq(1)").html(null);
					tr.find("td:eq(2)").html(null);
					tr.find("td:eq(3)").html(null);
					tr.find("td:eq(4)").html(null);
					tr.find("td:eq(5)").html(null);
					tr.find("td:eq(6)").html(null);
					tr.find("td:eq(7)").html(null);
			});
		};
	});
	//预览功能
	function completes(id){
		var path ="${pageContext.request.contextPath}/pms/file/docfile/gotoView.do?fileId="+id;
		$.post(path,null,null);
		//var path="${service_url}"+id;
		$("#table_mes_div").css("display","none");
		$("#mat_system").css("display","block");
		$("#insertWeb").attr("src",path);
	}
	//关闭按钮
	function closePage(){
		$("#mat_system").css("display","none");
		$("#table_mes_div").css("display","block");
	}
	
</script>

<body>
	<div id="title">下发的文件</div>
	<!--信息数据 div -->
	<div id="table_mes_div">
		<div id="fileMailPlan-seach-box" >
			<form id="fileMailPlan-wct-frm">
				<input type="hidden" name="fileStatus"  id="fileStatus"  value="2"/>
				
				<table width="400px;" cellspacing="0" cellpadding="0">
					<tr>	
					<td>文件名</td>
					<td>
					<input type="text" name="filename"  id="filename" style="width:110px;height:20px;"/>
					</td>
					<td><input type="button" id="fileMailPlan-search" value="查询" style="height:28px;width:50px;" class="btn btn-default"/></td>
					<td><input type="button" id="fileMailPlan-reset" value="重置" style="height:28px;width:50px;" class="btn btn-default"/></td>
					</tr>
					
				</table>
			</form>
		</div>
		<div id="fileMailPlan-tab" style="height:472px;overflow:auto;">
			<table border="1" borderColor="#9a9a9a" style="BORDER-COLLAPSE:collapse;font-size: 12px;font-weight: 500;" width="824" height="474" cellspacing="0" cellpadding="0">
				<thead id="fileMailPlan-tab-thead" style="background: #5a5a5a;color: #fff;">
					<tr>
						<td class="t-header" style="width:30px"></td>
						<td class="t-header" style="width:90px;display:none"></td><!-- 主键 FileID -->
						<td class="t-header" style="width:90px">文件名</td>
						<td class="t-header" style="width:110px">文件类型</td>
						<td class="t-header" style="width:60px">上传时间</td>
						<td class="t-header" style="width:110px">操作</td>
						<td class="t-header" style="width:90px;display:none"></td><!-- 下载路径 -->
					</tr>
				</thead>
				<tbody id="fileMailPlan-tab-tbody">
					<tr>
						<td>1</td>
						<td style="display:none"></td><!-- 主键 FileID -->
						<td></td>
						<td style="display:none"></td>
						<td></td>
						<td></td>
						<td style="display:none"></td><!-- 下载路径 -->
						<td></td>
					</tr>
					<tr>
						<td>2</td>
						<td style="display:none"></td><!-- 主键 FileID -->
						<td></td>
						<td style="display:none"></td>
						<td></td>
						<td></td>
						<td style="display:none"></td><!-- 下载路径 -->
						<td></td>
					</tr>
					<tr>
						<td>3</td>
						<td style="display:none"></td><!-- 主键 FileID -->
						<td></td>
						<td  style="display:none"></td>
						<td></td>
						<td></td>
						<td style="display:none"></td><!-- 下载路径 -->
						<td></td>
					</tr>
					<tr>
						<td>4</td>
						<td style="display:none"></td><!-- 主键 FileID -->
						<td></td>
						<td  style="display:none"></td>
						<td></td>
						<td></td>
						<td style="display:none"></td><!-- 下载路径 -->
						<td></td>
					</tr>
					<tr>
						<td>5</td>
						<td style="display:none"></td><!-- 主键 FileID -->
						<td></td>
						<td style="display:none" ></td>
						<td></td>
						<td></td>
						<td style="display:none"></td><!-- 下载路径 -->
						<td></td>
					</tr>
					<tr>
						<td>6</td>
						<td style="display:none"></td><!-- 主键 FileID -->
						<td></td>
						<td  style="display:none"></td>
						<td></td>
						<td></td>
						<td style="display:none"></td><!-- 下载路径 -->
						<td></td>
					</tr>
					<tr>
						<td>7</td>
						<td style="display:none"></td><!-- 主键 FileID -->
						<td></td>
						<td style="display:none" ></td>
						<td></td>
						<td  style=""></td>
						<td style="display:none"></td><!-- 下载路径 -->
						<td></td>
					</tr>
					<tr>
						<td>8</td>
						<td style="display:none"></td><!-- 主键 FileID -->
						<td></td>
						<td style="display:none" ></td>
						<td></td>
						<td ></td>
						<td style="display:none"></td><!-- 下载路径 -->
						<td></td>
					</tr>
					<tr>
						<td>9</td>
						<td style="display:none"></td><!-- 主键 FileID -->
						<td></td>
						<td style="display:none"></td>
						<td></td>
						<td ></td>
						<td style="display:none"></td><!-- 下载路径 -->
						<td></td>
					</tr>
					<tr>
						<td>10</td>
						<td style="display:none"></td><!-- 主键 FileID -->
						<td></td>
						<td style="display:none"></td>
						<td></td>
						<td></td>
						<td style="display:none"></td><!-- 下载路径 -->
						<td></td>
					</tr>
				</tbody>
			</table>
		</div>
		<div id="fileMailPlan-page">
			共<span id="count">0</span>条数据
			<input id="up" type="button"  value="上一页" class="btn btn-default"/>
			<span id="pageIndex">0</span>/<span id="allPages">0</span>
		    <input id="down" type="button"  value="下一页" class="btn btn-default"/>
		</div>
	</div>
	
	<div id="mat_system">
			<div >
				<iframe id="insertWeb" frameborder="0"  style="height: 522px;width: 839px;padding-top: -20px;"></iframe>				
			</div>
			<div>
				<input style="margin-left:384px;height:40px;width:100px;" id="closeWeb" onclick="closePage();" type="button"  value="关闭" class="btn btn-default" />
			</div>
	</div>
</body>
</html>

