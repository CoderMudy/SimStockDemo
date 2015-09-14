define("project/scripts/account/guidePage", function(require, exports, module) {
	
	var _pageId ="#guide_guidePage ";
	var HIscroll = require("hIscroll");
	var appUtils = require("appUtils");
	var hIscrolls = {"scroll":null,"_init":false};
	var layerUtils = require("layerUtils");
	
	function init() {
		//控制系统只有第一次启动才进来
		appUtils.setLStorageInfo("isGuided","true");
		var config = {
			wrapper: $(_pageId+' #wrapper_guide_guidePage'), //wrapper对象
			scroller: $(_pageId+' #scroller_guide_guidePage'), //scroller对象
			perCount: 1,  //每个可视区域显示的子元素
			showTab: true, //是否有导航点
			tabDiv: $(_pageId+" .yd_num"), //导航点集合对象
			interval: null, //自动播放定时器
			idxPage: 1, //记录当前scroll滚动到第几个page
			wrapperObj: null
		};
		hIscrolls.scroll = new HIscroll(config); //初始化
		$(_pageId + " #scroller_guide_guidePage .yd_khbtn").show();

		// 自动测速，选择最佳地址
		// 启动时，检查当前客户端的版本号与服务器上最新的是否一致，根据需要更新客户端，只在启动时检查，started 为 true 表示已启动，已启动就不检查
//		if(appUtils.getSStorageInfo("started") != "true")
//		{
//			// 设置 session 中的 started 为 true ，表示已启动
//			appUtils.setSStorageInfo("started","true");
//			layerUtils.iLoading(true, "正在检查版本...");
//			setBestAddress();  // 设置最佳地址
//		}
	}
	
	/* 自动测速，选择最佳地址 */
	function setBestAddress()
	{
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
	
	function bindPageEvent(){
		/* 绑定新开账户  */
		appUtils.bindEvent($(_pageId+" #scroller_guide_guidePage .yd_khbtn"),function(){
			// 设置标识'new',表示新开户,并且存到local
			appUtils.setSStorageInfo("openChannel","new");
			appUtils.pageInit("account/guidePage","account/msgVerify",{});
		});
	}
	
	function destroy() {
		if(hIscrolls.scroll != null) {
			hIscrolls._init = false; //重新初始化滑动组件
			hIscrolls.scroll.destroy();
			hIscrolls.scroll = null;
		}
	}
	
	module.exports = {
		"init" : init,
		"bindPageEvent": bindPageEvent,
		"destroy":destroy
	};
});