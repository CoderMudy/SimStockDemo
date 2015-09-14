/**
* 风险测评
*/
define("project/scripts/account/riskAssessment",function(require,exports,module){
	/* 私有业务模块的全局变量 begin */
	var appUtils = require("appUtils"),
		  service = require("serviceImp").getInstance(),  //业务层接口，请求数据
		  global = require("gconfig").global,
		  layerUtils = require("layerUtils"),
		  shellPlugin = require("shellPlugin"),
		  Map = require("map"),
		  fristMap = "",
		  _pageId = "#account_riskAssessment";
	/* 私有业务模块的全局变量 end */
	
	function init()
	{
		layerUtils.iLoading(false);
		cleanPageElement();
	}
	
	function bindPageEvent()
	{
		/* 绑定返回  */
		appUtils.bindEvent(_pageId+" .back_btn",function(){
			$(_pageId+" .main .risk_dl:eq(0)").show();
			appUtils.pageBack();
		});
		
		//绑定所有题目的答案点击事件
		appUtils.preBindEvent(_pageId+" .main .risk_dl a",function(){
			// 处理每一个问题
				$(this).addClass("radio_ckd").parent().siblings().find("a").removeClass("radio_ckd");
				var ele_dom = $(this);
				setTimeout(function(){
					ele_dom.parent().parent().hide();
					ele_dom.parent().parent().next().show();
					if(ele_dom.parent().parent().attr("id") == "dl20"){
						postRiskAssessmentData();
					}
				},100);
		});
		
		/* 拨打客服热线  */ 
		appUtils.bindEvent($(_pageId+" header .tel_btn"),function(){
		 	var param = {
		 		"telNo":"95328",		//客服电话
				"callStatus" : "1"  		//1、进入拨打界面   2、直接拨打电话
			};
			shellPlugin.callShellMethod("callPhonePlugin",null,function(){
			},param);
		});
	}
	
	/* 提交风险评测答案 */
	function postRiskAssessmentData()
	{
		var oneRiskAssessData ="";	// 格式如：1_2_7|2_7_3|  问题ID_答案ID_答案分值
		var dgansid_str ="";	//选项拼接
		$(_pageId+" .main .risk_dl a").each(function (){
			if($(this).hasClass("radio_ckd"))
			{
				var ansid = $(this).attr("ans-id");	
				var queid = $(this).attr("queid");
				var mark  = $(this).attr("ans-mark");
				var dgansid = $(this).attr("dgansid");
				dgansid_str += dgansid+",";
				oneRiskAssessData +=(queid+"_"+ansid+"_"+mark+"|");
			}
		});
		var userid = appUtils.getSStorageInfo("user_id");
		var phoneNum = appUtils.getSStorageInfo("phoneNum");
		var submitTestParam ={
			"user_id":userid,
			"sub_id":"1",
			"q_a_args":oneRiskAssessData,
			"mobile_no" : phoneNum,
			"dgansid" : dgansid_str
		};
		// 提交风险评测答案
		service.submitTestAnswer(submitTestParam,function(data){
//			alert(JSON.stringify(submitTestParam));
			var errorNo = data.error_no;
			var errorInfo = data.error_info;
			if(errorNo==0 && data.results.length != 0)	//调用成功,跳转到风险测评页面
			{
				var remark = data.results[0].remark;
				var riskdesc = data.results[0].riskdesc;
				appUtils.pageInit("account/riskAssessment","account/riskAssessmentResult",{"remark":remark,"riskdesc":riskdesc});
			}
			else
			{
				layerUtils.iMsg("-1",errorInfo);
			}
		});
	}
	
	function cleanPageElement(){
		$(_pageId+" .main .risk_dl:eq(0)").show();
//		$(_pageId+" .main .risk_dl a").each(function(){
//			for(var i=0;i<$(this).length;i++){
//				$(this).removeClass("radio_ckd");
//				$(_pageId+" .main .risk_dl:eq(0)").show();
//			}
//		});
	}
	
	function destroy()
	{
		service.destroy();
	}
	
	var riskAssessment = {
		"init" : init,
		"bindPageEvent" : bindPageEvent,
		"destroy" : destroy
	};
	
	module.exports = riskAssessment;
});