/**
* 风险测评结果
*/
define("project/scripts/account/riskAssessmentResult",function(require,exports,module){
	var appUtils = require("appUtils"),
		global = require("gconfig").global,
		shellPlugin = require("shellPlugin"),
		_pageId = "#account_riskAssessmentResult";
	
	function init()
	{
		//设置按钮显示提示文字
		if(appUtils.getSStorageInfo("openChannel") == "change")
		{
			if(appUtils.getSStorageInfo("finance") == "finance")
			{
				$(_pageId+" .fix_bot .ct_btn a").html("继续开户 >");  // 理财户
			}
			else
			{
				$(_pageId+" .fix_bot .ct_btn a").html("继续转户 >");  // 转户
			}
		}
		else
		{
			$(_pageId+" .fix_bot .ct_btn a").html("继续开户 >");  // 新开户
		}
		
		// 只有从 riskAssessment 跳转过来时，才设置页面的填充数据
		if(appUtils.getSStorageInfo("_prePageCode") == "account/riskAssessment")
		{
			var remark  = appUtils.getPageParam("remark");  //风险等级
			var riskdesc = appUtils.getPageParam("riskdesc"); //风险等级描述
			if(riskdesc == "风险型"){
				$(_pageId+" .main .jg_red").show();
				$(_pageId+" .main .jg_red02").hide();
				$(_pageId+" .main .jg_oran").hide();
				$(_pageId+" .main .jg_purple").hide();
				$(_pageId+" .main .jg_blue").hide();
			}
			else if(riskdesc == "积极型"){
				$(_pageId+" .main .jg_red02").show();
				$(_pageId+" .main .jg_red").hide();
				$(_pageId+" .main .jg_oran").hide();
				$(_pageId+" .main .jg_purple").hide();
				$(_pageId+" .main .jg_blue").hide();
			}
			else if(riskdesc == "成长型"){
				$(_pageId+" .main .jg_oran").show();
				$(_pageId+" .main .jg_red").hide();
				$(_pageId+" .main .jg_red02").hide();
				$(_pageId+" .main .jg_purple").hide();
				$(_pageId+" .main .jg_blue").hide();
			}
			else if(riskdesc == "稳健型"){
				$(_pageId+" .main .jg_purple").show();
				$(_pageId+" .main .jg_oran").hide();
				$(_pageId+" .main .jg_red").hide();
				$(_pageId+" .main .jg_red02").hide();
				$(_pageId+" .main .jg_blue").hide();
			}
			else if(riskdesc == "保守型"){
				$(_pageId+" .main .jg_blue").show();
				$(_pageId+" .main .jg_purple").hide();
				$(_pageId+" .main .jg_oran").hide();
				$(_pageId+" .main .jg_red").hide();
				$(_pageId+" .main .jg_red02").hide();
			}
		}
	}
	
	function bindPageEvent()
	{
		//返回
		appUtils.bindEvent($(_pageId+" .back_btn"),function(){
			appUtils.pageBack();
		});
		
		// 重新测评绑定事件
		appUtils.bindEvent($(_pageId+" .main .com_span"),function(){
			appUtils.pageInit("account/riskAssessmentResult","account/riskAssessment",{});
		});
		
		/**
		 * 9.1
		 * 风险测评结果页面进入三方存管页面(继续开户)
		 */
		appUtils.bindEvent($(_pageId+" .com_btn"),function(){
			appUtils.pageInit("account/riskAssessmentResult","account/thirdDepository",{});
//			if(global.needConfirm)
//			{
//				appUtils.pageInit("account/riskAssessmentResult","account/openConfirm",{});
//			}
//			else
//			{
//				appUtils.pageInit("account/riskAssessmentResult","account/accountResult",{});
//			}
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
	
	function destroy(){}
	
	var riskAssessmentResult = {
		"init" : init,
		"bindPageEvent" : bindPageEvent,
		"destroy" : destroy
	};
	
	module.exports = riskAssessmentResult;
});