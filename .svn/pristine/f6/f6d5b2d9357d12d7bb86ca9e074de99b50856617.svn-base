/**
 * 预约QQ视频认证成功
 */
define("project/scripts/account/orderSuccess",function(require, exports, module){ 
	/* 私有业务模块的全局变量 begin*/
	var appUtils = require("appUtils"),
           service = require("serviceImp").getInstance(),  //业务层接口，请求数据
		   gconfig = require("gconfig"),global = gconfig.global,
		   layerUtils = require("layerUtils"),
		   shellPlugin = require("shellPlugin"),
		   _pageId = "#account_orderSuccess";
	/* 私有业务模块的全局变量 end */
	
	function init()
	{	
		var show_day = appUtils.getPageParam("show_day");
		var show_time = appUtils.getPageParam("show_time");
		var show_str = "";
		show_str = "<p>我们的工作人员将会在</p><p class=\"info\">"+show_day+"<span class=\"ml15\">"+show_time+"</span></p><p>与您联系进行视频见证</p>";
		$(_pageId+" .yy_sucinfo").html(show_str);
	}
	
	function bindPageEvent()
	{
		/*在线视频视频见证*/
		appUtils.bindEvent($(_pageId+" .go_order"),function(){
			var url = appUtils.getSStorageInfo("branch_url");
			//判断URL是否为空
			if(url)
			{
				var param={
		            "user_id":appUtils.getSStorageInfo("user_id"),
		            "tel_num":appUtils.getSStorageInfo("mobileNo"),
		            "branch_id":appUtils.getSStorageInfo("branch_id"),
		            "cust_name":appUtils.getSStorageInfo("custname"),
		            "url":url
	            };
				require("shellPlugin").callShellMethod("videoPlugin",null,function videoError(data){
					layerUtils.iMsg(-1,data);  //显示错误信息
				},param);
			}
			else
			{
				layerUtils.iMsg(-1,"获取视频见证服务器IP或端口失败");
			}
		});
		
		/*绑定返回*/
		appUtils.bindEvent($(_pageId+" header .back_btn"),function(){
			appUtils.pageBack();
		});
		
		/*绑定下一步*/
		appUtils.bindEvent($(_pageId+" .fix_bot .ct_btn"),function(){
			queryQQOfflineState();  // 查询离线视频通过状态
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
	
	function destroy()
	{
		$(_pageId+" .qq_order p span:eq(0)").html();
		$(_pageId+" .qq_order p span:eq(1)").html();
		service.destroy();
	}
	
	/* 查询离线视频通过状态查询 */
	function queryQQOfflineState()
	{
		var lookVedioStateParam = {
			"user_id" : appUtils.getSStorageInfo("user_id")
		};
		service.queryQQOfflineState(lookVedioStateParam,function(data){
			var error_no = data.error_no;
			var errpr_info = data.error_info;
			if(error_no == 0 && data.results.length != 0)
			{
				// 视频通过状态，0：未见证、2：已预约离线见证未完成见证、1：视频见证完成、3：见证失败
				// 未见证不需要做处理
				var witnessFlag = data.results[0].witness_flag;
				if(witnessFlag==0)
				{
					layerUtils.iAlert("视频见证暂未通过，请等待！",0);
				}
				else if(witnessFlag == 1)
				{
					//跳转到视频认证的下一步
					appUtils.pageInit("account/orderSuccess","account/digitalCertificate",{});
				}
				else if(witnessFlag == 2)
				{
					layerUtils.iAlert("您的预约信息已经提交，我们的客服将尽快联系您！",0);
				}
				else if(witnessFlag == 3)
				{
					layerUtils.iAlert("视频见证失败，请重新预约！",-1);
				}
			}
			else
			{
				layerUtils.iAlert(error_info);
			}
		});
	}
	
	var orderSuccess = {
		"init" : init,
		"bindPageEvent" : bindPageEvent,
		"destroy" : destroy
	};
	
	module.exports = orderSuccess;
});