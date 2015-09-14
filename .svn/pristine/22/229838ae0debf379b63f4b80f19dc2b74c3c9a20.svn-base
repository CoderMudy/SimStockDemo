/**
 * 显示安装证书协议
 */
define("project/scripts/account/signCertificateProtocol",function(require, exports, module){ 
	/* 私有业务模块的全局变量 begin */
	var appUtils = require("appUtils"),
	    service = require("serviceImp").getInstance(),  //业务层接口，请求数据
		global = require("gconfig").global,
		layerUtils = require("layerUtils"),
		utils = require("utils"),
		shellPlugin = require("shellPlugin"),
		Map = require("map"),
		fristMap = null,  //  存放所有相关协议
	    protocolArray = new Array(),  // 存放协议签名值
		isClose = true,  // 用于控制等待层
		userId = "",
		cert_type = "",
		countProtocol = 0, // 计算签署成功的数量
	    _pageId = "#account_signCertificateProtocol";
	/* 私有业务模块的全局变量 end */
	
	function init()
	{
		userId = appUtils.getSStorageInfo("user_id"),
		cert_type = appUtils.getSStorageInfo("openChannel") == "new" ? "zd" : "tw", // tw:天威 zd:中登
		getAgreements();
	}
	
	//获取安装证书协议
	function getAgreements(){
		//category_englishname:协议类型名称
		service.queryProtocolList({"category_englishname":"certprotcl"},function(data){
			if(data.error_no == 0 && data.results.length != 0)
			{
				fristMap = new Map();
				var results = data.results,
					  allProtocols = "";
				var protocolMap = null;
				for(var i=0;i<results.length;i++)
				{
					protocolMap = new Map();
					protocolMap.put("protocolid",results[i].econtract_no);	//协议id
					protocolMap.put("protocolname",results[i].econtract_name);	//协议名
					protocolMap.put("summary",results[i].econtract_md5);	//协议内容MD5,签名摘要信息
					allProtocols += "<a href=\"javascript:void(0);\" protocol-id=\""+results[i].econtract_no+"\" id=\"protocol0"+i+"\">《"+
						results[i].econtract_name+"》</a>";
					// 预绑定查看协议的事件
					appUtils.preBindEvent($(_pageId+" .agreement_list"),"#protocol0"+i,function(e){
						appUtils.pageInit("account/signCertificateProtocol","account/showCertificateProtocol",{"protocol_id" : $(this).attr("protocol-id")});
						e.stopPropagation();
					});
					fristMap.put(i,protocolMap);
				}
				$(_pageId+" .agreement_list").html(allProtocols);
			}
			else
			{
				layerUtils.iLoading(false);  // 关闭等待层。。。
				layerUtils.iAlert(data.error_info);
			}
		},true,true,handleTimeout);
	}
	
	function bindPageEvent()
	{
		/* 绑定返回 */
		appUtils.bindEvent($(_pageId+" .back_btn"),function(e){
			appUtils.pageBack();
		});
		
		/* 隐藏按钮*/
		appUtils.bindEvent($(_pageId),function(e){
			$(_pageId+" .btn_bot").hide();
		});
		
		/* 绑定签署协议*/
		appUtils.bindEvent($(_pageId+" .agreement_opea .chkbox"),function(){
			$(this).toggleClass("chkbox_ckd"); //  切换勾选样式
		});
		
		/* 继续开户（下一步）*/
		appUtils.bindEvent($(_pageId+" .com_btn"),function(){
			startSign();  // 获取签名值并验签
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

	/* 处理请求超时 */
	function handleTimeout()
	{
		layerUtils.iConfirm("请求超时，是否重新加载？",function(){
			getAgreements();  // 再次获取安装证书协议
		});
	}
	
	/* 发请求进行协议验签 */
	function startSign()
	{
		var keys = fristMap.keys();  // 协议的数量
		// 检查是否勾选签署协议
		if($(_pageId+" .agreement_opea .chkbox").hasClass("chkbox_ckd"))
		{
			layerUtils.iLoading(true);  // 开启等待层。。。
			var oneData  = fristMap.get(keys[countProtocol]); // 取出一个协议
			var protocolid = oneData.get("protocolid"); // 协议ID
			var protocolname = oneData.get("protocolname");  //协议名称
			var summary = oneData.get("summary");  // 协议内容MD5,签名摘要信息
			var signParam = {
				"medid":protocolid,
				"content":summary,
				"userId":userId,
				"type": cert_type
			};
			// 添加值到数组中
			var protocol = {
				"protocol_id" : protocolid,
				"protocol_dcsign" : summary,
				"summary" : summary
			};
			protocolArray.push(protocol);
			countProtocol = 0;  // 将签署协议的计数器置为 0
			var signProtocolParam = {
				"user_id" : userId,
				"jsondata" : JSON.stringify(protocolArray),
				"ipaddr" : appUtils.getSStorageInfo("ip"),
				"macaddr" : appUtils.getSStorageInfo("mac"),
				"checksign" : "0"
			};
			// 新开中登验签
			if(appUtils.getSStorageInfo("openChannel") == "new")
			{
				service.signCertificateProtocol(signProtocolParam,callSign,false);
			}
			// 转户天威验签
			else if(appUtils.getSStorageInfo("openChannel") == "change")
			{
				service.queryOpenCheckTsign(signProtocolParam,callSign,false);
			}
		}
		else
		{
			layerUtils.iMsg(-1,"请阅读并勾选同意签署以上全部协议！");
			return false;
		}
	}
	
	/* 验签回调函数*/
	function callSign(data)
	{
//		alert(JSON.stringify(data));
		// 如果有一个协议签署失败，就将签署结果设为 false
	    if(data.error_no == 0)
		{
			appUtils.pageInit("account/signCertificateProtocol","account/digitalCertificate",{});
		}
	    else
	    {
			layerUtils.iLoading(false);  // 关闭等待层。。。
			layerUtils.iAlert(data.error_info,-1);
	    }
	}

	/* 清理界面元素 */
	function cleanPageElement()
	{
		$(_pageId+" .radio_list ul li").remove();  // 清理证券账户
		$(_pageId+" .rule_list ul li").remove();  // 清理协议
	}
	
	var signCertificateProtocol = {
		"init" : init,
		"bindPageEvent" : bindPageEvent,
		"destroy" : destroy
	};
	
	module.exports = signCertificateProtocol;
});