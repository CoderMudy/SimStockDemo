/**
* 查看协议
*/
define("project/scripts/account/showCertificateProtocol",function(require,exports,module){
	var appUtils = require("appUtils"),
		global = require("gconfig").global,
		service = require("serviceImp").getInstance(),  //业务层接口，请求数据
		_pageId = "#account_showCertificateProtocol";
	
	function init(){
		// 清除原有数据
		$(_pageId+" #contenttxt").text("");
		$(_pageId+" .top_title p:eq(0)").text("");
		//设置按钮显示提示文字
		if(appUtils.getSStorageInfo("openChannel") == "change")
		{
			if(appUtils.getSStorageInfo("finance") == "finance")
			{
				$(_pageId+" .fix_bot .ct_btn a").html("继续开户 >");
			}
			else
			{
				$(_pageId+" .fix_bot .ct_btn a").html("继续转户 >");
			}
		}
		else
		{
			$(_pageId+" .fix_bot .ct_btn a").html("继续开户 >");
		}
		var protocol_id = appUtils.getPageParam("protocol_id");
		var param = {
			"econtract_no" : protocol_id,
			"econtract_version":""
		}
		//查询协议内容
		service.getProtocolInfo(param,function(data){
//			alert(JSON.stringify(data));
			if(error_no = data.error_no)
			{
				$(_pageId+" .top_title p:eq(0)").text(data.results[0].econtract_brief);
				$(_pageId+" #contenttxt").append(data.results[0].econtract_content);
			}
			else
			{
				layerUtils.iMsg(-1, data.error_info);
			}
		});
	}
	function bindPageEvent(){
		
		// 绑定返回
		appUtils.bindEvent($(_pageId+" .header .icon_back"),function(){
			appUtils.pageBack();
		});
		
		// 绑定继续开户
		appUtils.bindEvent($(_pageId+" .com_btn"),function(){
			appUtils.pageInit("account/showCertificateProtocol","account/signCertificateProtocol");
		});
	}
	function destroy(){
		// 将协议内容置空
		$(_pageId+" #contenttxt").text("");
		$(_pageId+" .top_title p:eq(0)").text("");
		service.destroy();
	}
	
	var showCertificateProtocol = {
		"init" : init,
		"bindPageEvent" : bindPageEvent,
		"destroy" : destroy
	};
	
	module.exports = showCertificateProtocol;
});