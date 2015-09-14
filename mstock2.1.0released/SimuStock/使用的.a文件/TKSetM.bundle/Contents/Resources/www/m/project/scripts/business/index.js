/**
 * 手机开户3.0
 */
define("project/scripts/business/index",function(require, exports, module){ 
	/* 私有业务模块的全局变量 begin */
	var appUtils = require("appUtils"),
		service = require("serviceImp").getInstance(),  //业务层接口，请求数据
		layerUtils = require("layerUtils"),
		gconfig = require("gconfig"),
		global = gconfig.global,
		shellPlugin = require("shellPlugin"),
		utils = require("utils"),
		_pageId = "#business_index";
	/* 私有业务模块的全局变量 end */
	
	function init()
	{
		window.getInput = utils.getInput;  // 暴露调用密码键盘给window
		window.onFinish = utils.onFinish;  // 暴露关闭密码键盘给window
		// 自动测速，选择最佳地址
		// 启动时，检查当前客户端的版本号与服务器上最新的是否一致，根据需要更新客户端，只在启动时检查，started 为 true 表示已启动，已启动就不检查
		if(appUtils.getSStorageInfo("started") != "true")
		{
			// 设置 session 中的 started 为 true ，表示已启动
			appUtils.setSStorageInfo("started","true");
			layerUtils.iLoading(true, "正在检查版本...");
			setBestAddress();  // 设置最佳地址
		}
	}
	
	function bindPageEvent(){
		
		/* 绑定新开账户  */
		appUtils.bindEvent($(_pageId+" .yd_list .open"),function(){
			// 设置标识'new',表示新开户,并且存到local
			appUtils.setSStorageInfo("openChannel","new");
			appUtils.pageInit("business/index","account/msgVerify",{});
		});
		
		/* 绑定理财账户 */
//		appUtils.bindEvent($(_pageId+" .home_nav .open_finance"),function(){
//			// 设置标识'new',表示新开户,并且存到local
//			appUtils.setSStorageInfo("openChannel","change");
//			appUtils.setSStorageInfo("finance","finance");
//			appUtils.pageInit("business/index","account/msgVerify",{});
//		});
//		
//		/* 绑定转户 */
//		appUtils.bindEvent($(_pageId+" .home_nav .change"),function(){
//			// 设置标识'new',表示新开户,并且存到local
//			appUtils.setSStorageInfo("openChannel","change");
//			appUtils.pageInit("business/index","account/msgVerify",{});
//		});
		
	}
	
	function destroy(){}
	
	/* 动态加载css */
	function loadCSS(id, fileUrl) 
	{
	    var cssTag = document.getElementById(id),
	    	  oHead = document.getElementsByTagName('head').item(0),
	    	  ocss= document.createElement("link");
	    if(id == "#blue")
	    {
	    	oHead.removeChild(document.getElementById("#yellow"));
	    }
	    else
	    {
	    	if (cssTag) oHead.removeChild(cssTag); 
		    ocss.id= id;
		    ocss.href = fileUrl; 
		    ocss.rel = "stylesheet"; 
		    ocss.charset= "uf-8";
	    	oHead.appendChild(ocss); 
	    }
	}
	
	
	/* 自动测速，选择最佳地址 */
	function setBestAddress()
	{
		// 在启动时，首先选择网速最优的地址,key 测试地址，value 服务地址
//		var addressMap = {
//				"119.145.1.145" : "119.145.1.155:8088",
//				"58.251.38.39" : "58.251.38.52:8088"
//			},
//			bestAddressParam = {
//				"urlArray" : ["119.145.1.145","58.251.38.39"]
//			};
//		shellPlugin.callShellMethod("speedServerPlugin",function(data){
//			// 取映射中的服务地址
//			var serverAddress = addressMap[data.urlArray[0]];
//			// 在壳子里面设置 serverPath 会影响全局，但是浏览器不行，因为浏览器有刷新功能
//			global.serverPath = "http://"+serverAddress+"/servlet/json";
//			global.serverPathTrade = "http://"+serverAddress+"/servlet/trade/json";
//			global.ticketImage = "http://"+serverAddress+"/servlet/Image";
//			queryVersAndAddr();  // 查询服务器上的版本号和下载地址
//		},null,bestAddressParam);
		
		queryVersAndAddr();  // 查询服务器上的版本号和下载地址
	}
	
	/* 查询服务器上的版本号和下载地址 */
	function queryVersAndAddr()
	{
		var queryParam = {
			"terminal_type" : gconfig.platform == "1" ? "android" : "ios"
		};
		service.getVersion(queryParam,function(data){
			if(data.error_no == 0)
			{
				layerUtils.iLoading(false);
				// 服务器有数据返回时
				if(data.results.length != 0 && data.results[0].update_url != undefined)  
				{
					execUpdate(data.results);  // 执行更新
				}
			}
			else  // 查询地址失败
			{
				layerUtils.iLoading(false);
				layerUtils.iAlert("版本检查失败，请稍后重试！");
			}
		},true,false);
	}
	
	// 执行更新
	function execUpdate(results)
	{
		var length = results.length,
			updateParam = {
				"url" : results[0].update_url,  // 更新地址
				"versionLatest" : results[0].version,  // 最新版本号  
				// 只有一条记录取 0
				"versionLowest" : results[0].version == results[length-1].version ? "0" : results[length-1].version,  
				"firstEnforcement" : results[0].enforcement  // 第一条记录是否是强制更新
		};
		shellPlugin.callShellMethod("updateManagerPlugin",null,function(){
			layerUtils.iAlert("调用版本更新插件失败！");
		},updateParam);
	}
	
	var index = {
		"init" : init,
		"bindPageEvent" : bindPageEvent,
		"destroy" : destroy
	};
	
	module.exports = index;
});