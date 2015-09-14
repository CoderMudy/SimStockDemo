/**
 * 开|转|理财户结果
 */
define("project/scripts/account/accountResult",function(require,exports,module){
	/* 私有业务模块的全局变量 begin */
	var appUtils = require("appUtils"),
		  gconfig = require("gconfig"),
		  layerUtils = require("layerUtils"),
		  global = gconfig.global,
		  shellPlugin = require("shellPlugin"),
		  service = require("serviceImp").getInstance(),  //业务层接口，请求数据
		  totalTime = "", //开户时间
		  percent = "",   //超越股民的百分比
		  state = "" , //开户状态
		  _pageId = "#account_accountResult";
	/* 私有业务模块的全局变量 end */
	
	function init()
	{
		//如果521有返回则去521的开户时间
		if(appUtils.getSStorageInfo("opentime") !="0分0秒"){
			totalTime = appUtils.getSStorageInfo("opentime");
		}
		else{
			//否则取三方存管返回存在session中的开户时间
			totalTime = appUtils.getSStorageInfo("totalTime");
		}
		//如果521有返回则取521的百分比
		if(appUtils.getSStorageInfo("percent") != 0){
			percent = appUtils.getSStorageInfo("percent");
		}
		//521返回为0，而三方存管sesssion为null
		else if(appUtils.getSStorageInfo("percent") == 0 && appUtils.getSStorageInfo("openPercent") == null){
			percent = 0;
		}
		else{
			//否则取三方存管返回存在session中的百分比
			percent = appUtils.getSStorageInfo("openPercent");
		}
//		alert("三方存管取的："+appUtils.getSStorageInfo("openPercent"));
//		alert("所有判断之后取的percent:"+percent);
		$(_pageId+" .share_top .share_span span").html(totalTime);
		$(_pageId+" .share_top p:eq(0)").html("超越了"+percent+"%的股民");
		layerUtils.iLoading(false); 
		initPage();
	}
	
	function bindPageEvent()
	{
		/* 分享拿ipad */
		appUtils.bindEvent($(_pageId+" .share_btn"),function(){
			require("shellPlugin").callShellMethod("sharePlugin",null,null,["东莞证券有财开户","我在东莞证券开户速度打败了"+percent+"%的人，你也试试吧！","测试分享结果，显示即分享成功！","http://dgzq.com.cn/wechat/index.html"]);
		});
		
		//打开下载掌证宝链接
		appUtils.bindEvent($(_pageId+" .com_btn"),function(){
			var param = 
			{
				"url":"http://wap.dgzq.com.cn/zzb/download_tlb.jsp"
			}
			require("shellPlugin").callShellMethod("webViewPlugin",null,null,param);
//			alert("");
//			document.removeEventListener("backbutton",shellPlugin.onBackKeyDown,false);
//			appUtils.clearSStorage("_prePageCode");
//			window.location.href = "http://wap.dgzq.com.cn/zzb/download_tlb.jsp";
		});
	}
	
	function destroy()
	{
		$(_pageId+" .main .center:eq(0)").html("您的开户申请当前状态为：审核中");
		$(_pageId+" .main .mb10:eq(0)").html("我们的工作人员将会在1-2个工作日内为您<br>开立帐户，请您静候佳音。");
		appUtils.clearSStorage();  // 清空所有的session
	}
	
    /* 初始化页面 */	
	function initPage()
	{
		queryFundAccount(); // 查询用户信息
	}
	
	/* 查询资金账号信息 */
	function queryFundAccount()
	{
		//手机号码
		var param = {"mobile_no" : appUtils.getSStorageInfo("phoneNum")};
		service.getFundAccount(param, function(data){
			var error_no = data.error_no;
			var error_info = data.error_info;
			if(error_no == 0)
			{ 
				var res = data.results[0];
//				alert(JSON.stringify(res));
				appUtils.clearSStorage("fund_account");
				appUtils.setSStorageInfo("fund_account",res.client_id);  // 资金账号
				showOpenAccount();  // 显示开户结果
			}
			else
			{
				layerUtils.iMsg(-1, error_info);
			}
		});
	}
	
	/* 显示新开户结果 */
	function showOpenAccount()
	{
		// 从 session 中取资金账号
		var fund_account = appUtils.getSStorageInfo("fund_account");
		// 判断资金账户是否开出
		if(fund_account != null)
		{
			$(_pageId+" .main .center:eq(0)").html("您的开户申请当前状态为：已开户");
			$(_pageId+" .main .mb10:eq(0)").html("您的资金账号为"+fund_account+"，请牢记您的账号密码");
		}
		else{
			$(_pageId+" .main .center:eq(0)").html("您的开户申请当前状态为：审核中");
			$(_pageId+" .main .mb10:eq(0)").html("我们的工作人员将会在1-2个工作日内为您<br>开立帐户，请您静候佳音。");
		}
	}
	
	var accountResult = {
		"init" : init,
		"bindPageEvent" : bindPageEvent,
		"destroy" : destroy
	};
	
	module.exports = accountResult;
});