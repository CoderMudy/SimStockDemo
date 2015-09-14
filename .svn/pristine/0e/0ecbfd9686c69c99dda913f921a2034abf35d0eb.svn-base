/**
 * 驳回三方存管
 */
define("project/scripts/account/backThirdDepository",function(require, exports, module){ 
	/* 私有业务模块的全局变量 begin */
	var appUtils = require("appUtils"),
		global = require("gconfig").global,
		platform = require("gconfig").platform,
		service = require("serviceImp").getInstance(),  //业务层接口，请求数据
		layerUtils = require("layerUtils"),
		utils = require("utils"),
		validatorUtil = require("validatorUtil"),
		zzispwd = 1,  // zzispwd	密码方式，1 需要密码，0 不需要
		iscard = 1,  // iscard	是否需要银行卡，1 需要，0 不需要
		protocol = null,  //协议保存
		cert_type = appUtils.getSStorageInfo("openChannel") == "new" ? "zd" : "tw", // tw:天威 zd:中登
		_pageId = "#account_backThirdDepository";
	/* 私有业务模块的全局变量 end */
	
	function init()
	{
		if(platform == '2' || platform == '3'){
			$(_pageId+" .input_text #bankcardPwd").removeAttr("readonly");
		}
		initPage();  // 初始化页面并检测证书是否存在
	}
	
	function bindPageEvent()
	{
		/* 点击页面隐藏键盘 */
		appUtils.bindEvent($(_pageId),function(e){
			$(_pageId+" #bankListPage").slideUp("fast"); //隐藏银行卡列表
			if(platform == '1'){
				require("shellPlugin").callShellMethod("softKeyboardPlugin",null,null,{"isShow":false});  //关闭密码键盘
			}
			e.stopPropagation();  // 阻止冒泡
		});
		
		/* 签署银行相关协议  */
		appUtils.bindEvent($(_pageId+" .rule_check a"),function(){
			$(this).toggleClass("checked"); 
		});
				
		/* 选择银行绑定下拉框按钮事件  */
		appUtils.bindEvent($(_pageId+" #selectBank"),function(e){
			if(platform == '1'){
				require("shellPlugin").callShellMethod("softKeyboardPlugin",null,null,{"isShow":false});  //关闭密码键盘
			}
			$(_pageId+" #bankListPage ul li").removeClass("active");
			$(_pageId+" #bankListPage").slideDown("fast");  // 显示银行下拉列表
			e.stopPropagation();  // 阻止冒泡
		});

		/* 选择银行卡绑定选择某银行事件 */
		appUtils.bindEvent($(_pageId+" #bankcard"),function(e){
			validateSelectBank(); // 验证是否选择银行卡
			if(platform == '1'){
				require("shellPlugin").callShellMethod("softKeyboardPlugin",null,null,{"isShow":false});  //关闭密码键盘
			}
			e.stopPropagation();  // 阻止冒泡
		});
		
		/* 银行卡号输入控制（每四位分隔） */
		appUtils.bindEvent($(_pageId+" #bankcard"),function(){
			utils.dealIPhoneMaxLength(this,21); //处理iphone兼容
			utils.showBigNo(this,2);  //调用放大镜插件
		},"input");
		
		/* 银行密码输入框 */
		appUtils.bindEvent($(_pageId+" #bankcardPwd"),function(e){
			validateSelectBank();  // 验证是否选择银行卡
			utils.dealIPhoneMaxLength(this,6); // 处理iphone兼容
			if(platform == '1'){
				var eleName = _pageId+" #bankcardPwd";
				var topHeight = $(this).offset().top + $(this).parent().height();  //当前元素到顶部的高度
				var bodyHeight = $(document.body).height();  //当前body的高度
				var pwsdParam = {"isShow":true,"oldPwd":$(this).val(),"maxLength":6, "eleName": eleName};
				require("shellPlugin").callShellMethod("softKeyboardPlugin",function(data){
					//解决弹出键盘遮挡输入框的情况
					var keyheight = data.height/window.devicePixelRatio; //键盘高度
					var newbody = bodyHeight - keyheight;  // 键盘弹出 body的高度
					var scrollheight = topHeight - newbody; // 输入框被遮住的高度
					if(scrollheight>0)  //只有当密码键盘挡住输入框的时候才进行处理
					{
						scrollheight2 = bodyHeight - $(_pageId).height() + scrollheight; //页面需要滚动的高度
						$("body").css("padding-bottom",scrollheight2+"px").scrollTop(scrollheight);
					}
				},null,pwsdParam);
			}
			e.stopPropagation();  // 阻止冒泡
		});
		
		/* 开通三方存管按钮绑定事件 */
		appUtils.bindEvent($(_pageId+" .ct_btn"),function(){
			signProtocol();  //提交验签，并且提交三方存管信息
		});
	}
	
	function destroy()
	{
		service.destroy();
	}
	
	/* 初始化页面 */
	function initPage()
	{
		layerUtils.iLoading(true);  // 开启等待层。。。
		// 本页面需要用到证书，如果进入本页面时，证书不存在就下载并安装证书
		var existsParam = {
			"userId" : appUtils.getSStorageInfo("user_id"),
			"mediaid" : "certificate",
			"type" : cert_type
		};
		require("shellPlugin").callShellMethod("fileIsExistsPlugin",function(data){
			// 如果未检测到本地有证书，就安装证书
			if(data.mediaId == "")
			{
				utils.installCertificate(getBankList);  // 下载安装证书，并且加载银行列表
			}
			else
			{
				getBankList(); //加载银行列表
			}
		},function(){
			// 关闭等待层。。。
			layerUtils.iLoading(false);
		},existsParam);
	}
	
	/* 获取存管银行列表 */
	function getBankList()
	{
		var queryParam = {"bindtype":"","ispwd":""};
		//调用service查询存管银行list
		service.queryBankList(queryParam,function(data){
			var errorNo = data.error_no;
			var errorInfo = data.error_info;
			$(_pageId+" .sel_list ul").html(""); //清除页面的银行列表
			if(errorNo==0 && data.results.length != 0) //调用成功
			{
				var results = data.results;
				var length = results.length;
				var itemElement = "";
				for(var i =0; i<length; i++)
				{
					var item = results[i];
					var bankcode = item.bankcode;  // 银行代码
					var bankname = item.bankname;  // 银行名称
					var sortnum  = item.sortnum;  // 排序
					var smallimg = item.smallimg;  // 图标
					var isbuffet = item.isbuffet;  // 是否支持自助
					var signInfo = item.sign_info;  // 提示信息简介
					var brief = item.brief; // 银行简介
					var zzbindtype = item.zzbindtype;  // 绑定方式：1 一步式 2 预指定
					zzispwd = item.zzispwd; // 密码方式：1 需要 2 不需要  
				    iscard = item.iscard; // 密码方式：1 需要 2 不需要  
					itemElement += "<li><span bankname='"+bankname+"' id='"+bankcode+"' " +
							       				"iscard=\""+iscard+"\" zzispwd=\""+zzispwd+"\""+
						           				"zzbindtype=\""+zzbindtype+"\" sign-info=\""+signInfo+"\">"+bankname+"</span></li>";
				}
				$(_pageId+" .sel_list ul").html(itemElement);
				// 选择银行添加银行事件
				appUtils.bindEvent($(_pageId+" #bankListPage ul li span"),function(e){
					$(_pageId+" #bankListPage ul li").removeClass("active");
					$(this).parent().addClass("active");
					$(_pageId+" .protocolshow").show();
					var banckName = $(this).attr("bankname"),
						  id = $(this).attr("id"),
					      zzbindtype = $(this).attr("zzbindtype"),
					      signInfo = $(this).attr("sign-info");  // 提示信息
					zzispwd = $(this).attr("zzispwd");  // zzispwd	密码方式，1 需要密码，0 不需要
					iscard = $(this).attr("iscard");  // 是否需要银行卡号
					addBankItem(banckName,id,zzbindtype,signInfo);
					e.stopPropagation();
				});
			}
			else
			{
				layerUtils.iAlert(errorInfo,-1);
			}
		},true,true,handleTimeout);	
	}
	
	/* 处理请求超时 */
	function handleTimeout()
	{
		layerUtils.iConfirm("请求超时，是否重新加载？",function(){
			getBankList();  // 再次获取银行列表
		});
	}
	
	/* 为选择银行列表添加选中银行数据 */
	function addBankItem(banckName,id,zzbindtype,signInfo)
	{
		// 显示银行的签约信息
		if(signInfo != "" && signInfo != undefined)
		{
			$(_pageId+" #signInfo").html("温馨提示: "+signInfo);
		}
		else 
		{
			$(_pageId+" #signInfo").html(""); 
		}
		$(_pageId+" #bankcard").val("");  // 清空银行卡号值
		$(_pageId+" #bankcardPwd").val(""); // 清空银行卡密码
		$(_pageId+" #selectBank").html(banckName);  // 赋值银行卡名称
		$(_pageId+" #selectBank").attr("bankcode",id);
		$(_pageId+" #selectBank").attr("zzbindtype",zzbindtype);
		getDepositoryAgreement(id);  // 获取银行协议内容
		if(zzbindtype == 1)   // 判断一步式
		{
			if(zzispwd == 0)  // 不需要输入密码
			{
				$(_pageId+" #bankcardPwd").parent().hide();  // 隐藏银行密码输入框
			}
			else   // 需要输入密码
			{
				$(_pageId+" #bankcardPwd").parent().show();  // 显示银行密码输入框
			}
			$(_pageId+" .user_form .input_form:eq(1)").show();  // 显示银行卡、密码输入框
			$(_pageId+" #bindInfo").hide();  // 隐藏预指定提示信息
		}
		if(zzbindtype == 2)  // 判断预指定(二步式)
		{
			if(iscard == 1)  // 需要银行卡
			{
				$(_pageId+" .user_form .input_form:eq(1)").show();  // 显示银行卡
				$(_pageId+" .user_form .input_form:eq(1) .input_text:eq(1)").hide();  // 隐藏密码
			}
			else // 不需要银行卡
			{
				$(_pageId+" .user_form .input_form:eq(1)").hide();  // 隐藏银行卡、密码输入框
			}
			$(_pageId+" #bindInfo").show();  // 显示预指定提示信息
		}
		$(_pageId+" #bankListPage").slideUp("fast");  // 隐藏银行下拉列表
	}
	
	/* 签署协议 */
	function signProtocol()
	{
		if(!validateSelectBank())  // 验证是否选择银行
		{
			return false;
		}
		if(iscard == 1 && !validateBankCorrect())  // 验证银行卡号
		{
			return false;
		}
		if(iscard == 1 && zzispwd == 1)  // 验证是否需要密码
		{
			if(!validateBankPwd())
			{
				return false;
			}
		}
		if(!validateDepositProtocolSelect())  // 验证是否勾选协议
		{
			return false;
		}
		// 进行协议签署
		var protocolArray = new Array(),  // 协议数组
			userid = appUtils.getSStorageInfo("user_id"),
			ipaddr  = appUtils.getSStorageInfo("ip"),
			macaddr = appUtils.getSStorageInfo("mac"),
			protocolid = protocol.econtract_no,
			protocolname = protocol.econtract_name,
			summary = protocol.econtract_md5,  // 协议内容MD5,签名摘要信息
			signParam = {
				"medid":protocolid,
				"content":summary,
				"userId":userid,
				"type": cert_type
			};
		layerUtils.iLoading(true);  // 开启等待层......
		// 获取协议的数字签名值
		require("shellPlugin").callShellMethod("signPlugin",function(data){
			var protocoldcsign = data.ciphertext;  // 数字签名值
			var protocolParam = {
				"protocol_id" : protocolid,
				"protocol_dcsign" : protocoldcsign,
				"summary" : summary
			};
			protocolArray.push(protocolParam);   // 添加值到数组中
			// 签署协议
			var signProtocolParam = {
				"user_id" : userid,
				"jsondata" : JSON.stringify(protocolArray),
				"ipaddr" : ipaddr,
				"macaddr" : macaddr
			};
			// 新开中登验签
			if(appUtils.getSStorageInfo("openChannel") == "new")
			{
				service.queryOpenCheckSign(signProtocolParam,postThirdDepositoryData,false);
			}
			// 转户天威验签
			else if(appUtils.getSStorageInfo("openChannel") == "change")
			{
				service.queryOpenCheckTsign(signProtocolParam,postThirdDepositoryData,false);
			}
		},function(){ layerUtils.iLoading(false); },signParam);
	}
	
	/* 提交三方存管银行数据 */
	function postThirdDepositoryData()
	{
		service.getRSAKey({}, function(data) {
			if( data.error_no==0)	//请求获取rsa公钥成功
			{
				//密码采用rsa加密
				var results = data.results[0];
				var modulus = results.modulus;
				var publicExponent =  results.publicExponent;
				var endecryptUtils = require("endecryptUtils");
				
				var bankpwd = endecryptUtils.rsaEncrypt(modulus, publicExponent, $(_pageId+" #bankcardPwd").val().trim());
				var userid = appUtils.getSStorageInfo("user_id");
				var bankcode= $(_pageId+" #selectBank").attr("bankcode");
				var bankaccount = $(_pageId+" #bankcard").val();
				var thirdDepositParam = {
					"user_id":userid,
					"acct_clientid":"",
					"acct_fndacct":"",
					"bank_code":bankcode,
					"bank_account":bankaccount,
					"bank_pwd":bankpwd,
					"op_type":$(_pageId+" #selectBank").attr("zzbindtype")
				};
				//调用service绑定存管银行
				service.bindBank(thirdDepositParam,function(data){
					var errorNo = data.error_no;
					var errorInfo = data.error_info;
					if(errorNo==0)	 //调用成功,则跳到结果页
					{
						var notifyParam = {
							"userid" : appUtils.getSStorageInfo("user_id"),
							"fieldname" : "bind_bank"  // 通知三方存管已补全
						};
						service.rejectStep(notifyParam,function(data){
							if(data.error_no == 0)
							{
								appUtils.setSStorageInfo("isBack", "backInfo");  //标志重新提交资料成功
								appUtils.pageInit("account/backThirdDepository","account/accountResult",{});  //返回结果页
							}
							else 
							{
								layerUtils.iAlert(data.error_info,-1);
							}
						},false);
					}
					else
					{
						layerUtils.iLoading(false);
						layerUtils.iAlert(errorInfo,-1);
					}
				},false);
			}
			else
			{
				layerUtils.iLoading(false);
				layerUtils.iAlert(data.error_info);
			}
		}, false);
	}
	
	/* 验证是否选择银行  */
	function validateSelectBank()
	{
		var obj = $(_pageId+" #selectBank");
		var value = obj.html();
		if(validatorUtil.isEmpty(value)||value=="请选择银行")
		{
			layerUtils.iMsg(-1,"请选择银行");
			return false;
		}
		return true;
	}
	
	/* 检验银行卡填写是否正确 */
	function validateBankCorrect()
	{
		var bankcard = $(_pageId+" #bankcard").val();
		if(bankcard == "")//验证通过的情况
		{
			layerUtils.iMsg(-1,"银行卡号不能为空！");
			return false;
		}
		if(!validatorUtil.isBankCode(bankcard))
		{
			layerUtils.iMsg(-1,"银行卡号格式有误，请重新输入！");
			return false;
		}
		return true;
	}
	
	/* 验证银行密码 */
	function validateBankPwd()
	{
		//验证不通过
		var cardPwd = $(_pageId+" #bankcardPwd").val();
		if(!validatorUtil.isNumeric(cardPwd) || cardPwd.length !=6)
		{
			layerUtils.iMsg(-1,"银行卡密码有误，请重新输入！");
			return false;
		}
		return true;
	}
	
	/* 检测勾选阅读协议 */
	function validateDepositProtocolSelect()
	{
		if(!$(_pageId+" .icon_check").hasClass("checked"))
		{
			layerUtils.iMsg(-1,"请阅读并勾选三方存管协议!");
			return false;
		}
		return true;
	}
	
	/* 获取存管银行签约电子协议列表 */
	function getDepositoryAgreement(bankcode)
	{
		// 获取银行协议的参数
		var param = {
			"econtract_no" : bankcode
		};
		//调用service查询存管银行协议
		service.queryProtocolList(param,function(data){
			$(_pageId+" #protocolName").html("");
			if(data.error_no == 0)
			{
				if(data.results&&data.results.length>=1){
					protocol = data.results[0];
					$(_pageId+" #protocolName").html("《"+protocol.econtract_name+"》");
					$(_pageId+" #protocolName").attr("protocolId",protocol.econtract_no);
					$(_pageId+" #protocolName").attr("protocolMd5",protocol.econtract_md5);
					// 预绑定查看银行协议内容的事件
					appUtils.preBindEvent($(_pageId+" #protocolName").parent(),"#protocolName",function(){
						appUtils.pageInit("account/thirdDepository","account/showProtocol",{"protocol_id":$(_pageId+" #protocolName").attr("protocolId")});
					});
				}
			}
			else
			{
				layerUtils.iAlert(data.error_info,-1);
			}
		});
	}
	
	/* 清理界面元素 */
	function cleanPageElement()
	{
		$(_pageId+" .rule_check a").removeClass("checked");  // 取消勾选协议
		$(_pageId+" #selectBank").text("请选择银行");  // 清理银行卡的名字
		$(_pageId+" #bankcard").val("");  // 清理银行卡号
		$(_pageId+" #bankcardPwd").val("");  // 清理密码
		$(_pageId+" #protocolName").text("《券商银行投资者三方协议》");  // 清理协议名
		$(_pageId+" #signInfo").html("");  // 清除银行签约信息
	}
	
	var backThirdDepository = {
		"init" : init,
		"bindPageEvent" : bindPageEvent,
		"destroy" : destroy
	};
	
	// 暴露对外的接口
	module.exports = backThirdDepository;
});