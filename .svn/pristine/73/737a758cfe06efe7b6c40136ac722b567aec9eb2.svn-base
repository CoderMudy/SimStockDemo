/**
 * 预约QQ视频认证
 */
define("project/scripts/account/orderQq",function(require, exports, module){ 
	/* 私有业务模块的全局变量 begin */
	var appUtils = require("appUtils"),
	       service = require("serviceImp").getInstance(),  //业务层接口，请求数据
	       validatorUtil = require("validatorUtil"),
	       layerUtils = require("layerUtils"),
	       shellPlugin = require("shellPlugin"),
	       gconfig = require("gconfig"),
	       global = gconfig.global,
		   _pageId = "#account_orderQq";
	/* 私有业务模块的全局变量 end*/
	
	function init(){}
	
	function bindPageEvent()
	{
		/*绑定返回*/
		appUtils.bindEvent($(_pageId+" header .back_btn"),function(){
			appUtils.pageBack();
		});
		
		/*绑定预约天数选择框*/
		appUtils.bindEvent($(_pageId+" .yy_date span"),function(){
			$(this).toggleClass("yy_current");		
			$(this).siblings().removeClass("yy_current");
		});
		
		/*绑定预约时间选择框*/
		appUtils.bindEvent($(_pageId+" .mt20 span"),function(){
			$(this).toggleClass("yy_current");	
			$(this).siblings().removeClass("yy_current");
		});
		
		/*绑定下一步*/
		appUtils.bindEvent($(_pageId+" .com_btn"),function(){
			var deal_time = "";
			var show_time = "";
			var deal_day  = "";
			var show_day = "";
			$(_pageId+" .yy_date .yy_current").each(function(){
				deal_day += $(this).attr("deal_day")+"|"
				show_day += $(this).html()+","
			});
			$(_pageId+" .mt20 .yy_current").each(function(){
				deal_time += $(this).attr("deal_time")+"|"
				show_time += $(this).html()+","
			});
			deal_day = deal_day.substring(0,deal_day.length-1);
			deal_time = deal_time.substring(0,deal_time.length-1);
			show_time = show_time.substring(0,show_time.length-1)+"";
			show_day = show_day.substring(0,show_day.length-1)+"";
			if(validatorUtil.isNotEmpty(deal_time) && validatorUtil.isNotEmpty(deal_day))
			{
				//提交后台QQ预约
				submitQQApplay(deal_time,show_time,show_day);
			}
			else if(validatorUtil.isEmpty(deal_day))
			{
				layerUtils.iMsg(-1,"请输入预约天数");
			}
			else if(validatorUtil.isEmpty(deal_time))
			{
				layerUtils.iMsg(-1,"请选择预约时间");
			}
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
		service.destroy();
	}
	
	/*提交后台QQ预约*/
	function submitQQApplay(deal_time,show_time,show_day)
	{
		var param = {
			"user_id":appUtils.getSStorageInfo("user_id"),
			//"qq":qqNum,
			"deal_date":new Date().format("yyyy-MM-dd"),
			"deal_time":deal_time,
			"week_day" : show_day,
			"mobile_no" : appUtils.getSStorageInfo("phoneNum"),
			"client_name" : appUtils.getSStorageInfo("custname")
		}
		service.submitQQApplay(param,function(data){
			//alert(JSON.stringify(data));
			var error_no = data.error_no;
			var errpr_info = data.error_info;
			//预约成功
			if(data.error_no == "0")
			{
				appUtils.pageInit("account/orderQq","account/orderSuccess",{"show_time":show_time,"show_day":show_day});
			}
			else
			{
				layerUtils.iAlert("视频见证预约失败，请重新预约！",-1);
				layerUtils.iLoading(false);
			}
		});
	}
	
	var orderQq = {
		"init" : init,
		"bindPageEvent" : bindPageEvent,
		"destroy" : destroy
	};
	
	// 暴露对外的接口
	module.exports = orderQq;
});