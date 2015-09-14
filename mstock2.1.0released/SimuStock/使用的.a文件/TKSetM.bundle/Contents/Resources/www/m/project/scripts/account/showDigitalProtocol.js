/**
 * 查看数字证书的协议
 */
define("project/scripts/account/showDigitalProtocol",function(require, exports, module){ 
	var appUtils = require("appUtils"),
	    service = require("serviceImp").getInstance(),  //业务层接口，请求数据
		global = require("gconfig").global,
		layerUtils = require("layerUtils"),
		_pageId = "#account_showDigitalProtocol";
	
	function init()
	{
		// 设置协议标题
		$(_pageId+" .top_title h3").text("");
		// 清空协议内容
		$(_pageId+" .upload_main #contenttxt").text("");
		//查看协议内容
		queryProtocolText();
	}
	
	function bindPageEvent()
	{
		/* 绑定返回 */
		appUtils.bindEvent($(_pageId+" .header .icon_back"),function(){
			appUtils.pageBack();
		});
		
		/* 绑定下一步 */
		appUtils.bindEvent($(_pageId+" .com_btn"),function(){
			appUtils.pageBack();
		});
	}
	
	function destroy()
	{
		// 将协议内容置空
		$(_pageId+" #contenttxt").text("");
		service.destroy();
	}
	
	/*获取协议内容*/
	function queryProtocolText()
	{
		// 查询证书内容
		var param = {
				"econtract_no" : appUtils.getPageParam("protocolId"),
				"econtract_version":""
		};
		service.getProtocolInfo(param,function(data){
			var error_no = data.error_no;
			var error_info = data.error_info;
			if(error_no == "0")
			{
				// 设置协议标题
				$(_pageId+" .top_title h3").text(data.results[0].econtract_name);
				$(_pageId+" .upload_main #contenttxt").append(data.results[0].econtract_content);
			}
			else
			{
				layerUtils.iAlert(error_info,-1);
			}
		})
	}
	
	var showDigitalProtocol = {
		"init" : init,
		"bindPageEvent" : bindPageEvent,
		"destroy" : destroy
	};
	
	// 暴露对外的接口
	module.exports = showDigitalProtocol;
});