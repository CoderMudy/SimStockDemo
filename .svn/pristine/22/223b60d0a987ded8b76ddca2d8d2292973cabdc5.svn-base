/**
 * 设置密码
 */
define("project/scripts/account/setPwd",function(require, exports, module){ 
	/* 私有业务模块的全局变量 begin */
	var appUtils = require("appUtils"),
	    service = require("serviceImp").getInstance(),  //业务层接口，请求数据
		global = require("gconfig").global,
		validatorUtil = require("validatorUtil"),
		shellPlugin = require("shellPlugin"),
		layerUtils = require("layerUtils"),
		utils = require("utils"),
		platform = require("gconfig").platform,
		Map = require("map"),
		fristMap = null,  //  存放所有相关协议
	    protocolArray = new Array(),  // 存放协议签名值
	    isClose = true,  // 用于控制等待层
		countProtocol = 0, // 计算签署成功的数量
		cert_type = appUtils.getSStorageInfo("openChannel") == "new" ? "zd" : "tw", // tw:天威 zd:中登
		_pageId = "#account_setPwd";
	/* 私有业务模块的全局变量 end */
	
	function init()
	{
		initPage();  // 初始化页面
		checkCert();  //检测证书是否存在
		//getAgreement();
	}
	
	function bindPageEvent()
	{
		/* 点击页面隐藏键盘 */
		appUtils.bindEvent($(_pageId),function(e){
			if(platform == '1'){
				//关闭密码键盘
				require("shellPlugin").callShellMethod("softKeyboardPlugin",null,null,{"isShow":false});
			}
			e.stopPropagation();	// 阻止冒泡
		});
		
		/* 返回*/
		appUtils.bindEvent($(_pageId+" header .back_btn"),function(){
			appUtils.pageBack();
		});
		
		/* 是否设置资金密码与交易密码一致（隐藏显示）*/
		appUtils.bindEvent($(_pageId+" .set_pwbox .chkbox:eq(0)"),function(){
			$(_pageId+" .fundPwd").toggle();
			$(this).toggleClass("chkbox_ckd");
		});
		
		/* 勾选协议按钮 */
		appUtils.bindEvent($(_pageId+" #checkprotocol .chkbox:eq(0)"),function(){
			$(this).toggleClass("chkbox_ckd");
		});
		
		/* 查看协议内容的事件 */
		appUtils.bindEvent($(_pageId+" #protocolName"),function(){
			appUtils.pageInit("account/setPwd","account/showProtocol",{"protocol_id":$(this).attr("protocolId")});
		});
		
		/* 点击密码框统一调用密码键盘 */
		appUtils.bindEvent($(_pageId+" .form_box input"),function(e){
			utils.dealIPhoneMaxLength(this,6); // 处理iphone兼容
			if(platform == '1'){
				var psw_id = "#"+$(this).attr("id"); // 当前input元素id
				var eleName = _pageId+" "+psw_id; // 当前密码卡的Dom值
				var pwsdParam = {"isShow": true," oldPwd": $(this).val(), "maxLength": 6, "eleName": eleName};
				var topHeight = $(this).offset().top+$(this).parent().height();  //当前元素到顶部的高度
				var bodyHeight = $(document.body).height();  //当前body的高度
				require("shellPlugin").callShellMethod("softKeyboardPlugin",function(data){
					//解决弹出键盘遮挡输入框的情况
					var keyheight = data.height/window.devicePixelRatio; //键盘高度
					var newbody = bodyHeight - keyheight; // 键盘弹出 body的高度
					var scrollheight = topHeight - newbody; // 输入框被遮住的高度
					if(scrollheight>0) //只有当密码键盘挡住输入框的时候才进行处理
					{
						scrollheight2 = bodyHeight - $(_pageId).height() + scrollheight; //页面需要滚动的高度
						$("body").css("padding-bottom",scrollheight2+"px").scrollTop(scrollheight);
					}
				},null,pwsdParam);
			}
			e.stopPropagation();	// 阻止冒泡
		});
		
		/* 密码框绑定失去焦点事件 */
		appUtils.bindEvent($(_pageId+" #pass1"),function(){
			validatePassword($(this));
		},"blur");
		
		appUtils.bindEvent($(_pageId+" #pass3"),function(){
			validatePassword($(this));
		},"blur");
		
		/* 密码框绑定检验二次密码是否匹配事件 */
		appUtils.bindEvent($(_pageId+" #pass2"),function(){
			validatePassword($(this));
			validateSecondPassword($(this),"1");
		},"blur");
		
		appUtils.bindEvent($(_pageId+" #pass4"),function(){
			validatePassword($(this));
			validateSecondPassword($(this),"2");
		},"blur");
		
		/* 继续开户 */
		appUtils.bindEvent($(_pageId+" .com_btn"),function(){
			if(validatePost())
			{
				if($(_pageId+" .set_pwbox .chkbox:eq(0)").hasClass("checked"))
				{
					signProtocol(); // 交易密码和资金密码相同，签署密码协议
				}
				else
				{
//					postPassword();  //签署密码协议
					signProtocol(); 
				}
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
	
	/* 页面初始化 */
	function initPage()
	{
		if(platform == '2' || platform == '3'){
			$(_pageId+" .form_item input").removeAttr("readonly");
		}
		layerUtils.iLoading(true);  // 开启等待层。。。
		cleanPageElement();  // 清理页面元素
	}
	
	/* 清理界面元素 */
	function cleanPageElement()
	{
		$(_pageId+" .form_item input").val(""); // 清理所有的密码框
//		$(_pageId+" .input_form:eq(1)").hide(); 
//		$(_pageId+" .user_form h5:eq(1)").hide();
//		$(_pageId+" .user_form .mt10").show();
		$(_pageId+" .set_pwbox .chkbox:eq(0)").addClass("chkbox_ckd"); //默认选中
	}
	
	/* 检测证书是否存在 */
	function checkCert()
	{
		var existsParam = {
			"userId" : appUtils.getSStorageInfo("user_id"),
			"mediaid" : "certificate",
			"type" : cert_type
		};
		require("shellPlugin").callShellMethod("fileIsExistsPlugin",function(data){
			// 如果未检测到本地有证书，就安装证书
			if(data.mediaId == "")
			{
				//appUtils.pageInit("account/setPwd","account/digitalCertificate");
				utils.installCertificate(getAgreement);  //下载安装证书并且查询协议
			}
			else
			{
			    getAgreement();  //查询协议
			}
		},function(){
			layerUtils.iLoading(false);  // 关闭等待层。。。
		},existsParam);
	}
	
	/* 密码提交时校验 */
	function validatePost()
	{
		var pass1 = $(_pageId+" #pass1").val().trim();
		var pass2 = $(_pageId+" #pass2").val().trim();
		var pass3 = $(_pageId+" #pass3").val().trim();
		var pass4 = $(_pageId+" #pass4").val().trim();
		if($(_pageId+" .set_pwbox .chkbox:eq(0)").hasClass("chkbox_ckd"))
		{
			if(validatorUtil.isEmpty(pass1)||validatorUtil.isEmpty(pass2))
			{
				layerUtils.iMsg(-1,"请完成密码设置!");
				return false;	
			}
		}
		else
		{
			if((validatorUtil.isEmpty(pass1)||validatorUtil.isEmpty(pass2))&&(validatorUtil.isEmpty(pass3)||validatorUtil.isEmpty(pass4)))
			{
				layerUtils.iMsg(-1,"请完成密码设置!");
				return false;	
			}
			else if(validatorUtil.isEmpty(pass1)||validatorUtil.isEmpty(pass2))
			{
				layerUtils.iMsg(-1,"请完成交易密码设置!");
				return false;	
			}
			else if(validatorUtil.isEmpty(pass3)||validatorUtil.isEmpty(pass4))
			{
				layerUtils.iMsg(-1,"请完成资金密码设置!");
				return false;	
			}
			if(!$(_pageId+" #checkprotocol .chkbox").hasClass("chkbox_ckd"))
			{
				layerUtils.iMsg(-1,"请阅读并同意上述协议!");
				return false;
			}
		}
		if(pass1.length!="6")
		{
			layerUtils.iMsg(-1,"请输入6位数字交易密码，请重新输入!");
			return false;	
		}
		else if(pass1!=pass2)
		{
			layerUtils.iMsg(-1,"交易密码与第一次不符，请重新输入!");
			$(_pageId+" #pass2").val("");
			return false;	
		}
		if(!$(_pageId+" .set_pwbox .chkbox:eq(0)").hasClass("chkbox_ckd"))
		{
			if(pass3.length!="6")
			{
				layerUtils.iMsg(-1,"请输入6位数字资金密码，请重新输入!");
				return false;	
			}
			else if(pass3 != pass4)
			{
				layerUtils.iMsg(-1,"资金密码与第一次不符，请重新输入!");
				$(_pageId+" #pass4").val("");
				return false;	
			}
			if(!$(_pageId+" #checkprotocol .chkbox").hasClass("chkbox_ckd"))
			{
				layerUtils.iMsg(-1,"请阅读并同意上述协议!");
				return false;
			}
		}
		else
		{
			$(_pageId+" #pass3").val(pass1);
			$(_pageId+" #pass4").val(pass1);
			if(!$(_pageId+" #checkprotocol .chkbox").hasClass("chkbox_ckd"))
			{
				layerUtils.iMsg(-1,"请阅读并同意上述协议!");
				return false;
			}
		}
		return true;
	}
	
	/* 验证密码 6位数字 */
	function validatePassword(obj)
	{
		var password = obj.val().trim();
		if(!validatorUtil.isNumeric(password) || password.length !=6)
		{
			layerUtils.iMsg(-1,"请输入6位数字密码");
			return;
		}
		/**
		 * 增加弱密校验
		 * 1、出生日期的一部分
		 * 2、证件号码的一部分
		 * 3、某一字符出现的概率不能占总长度的一半以上
		 * 4、顺序递增或者递减
		 * 5、弱密表的控制值
		 * 6、移动电话的一部分
		 * 7、固定电话的一部分
		 */
		var idCardNo = appUtils.getSStorageInfo("idCardNo")?appUtils.getSStorageInfo("idCardNo"):"",
			mobileNo = appUtils.getSStorageInfo("mobileNo")?appUtils.getSStorageInfo("mobileNo"):"";
		// 判断是不是出生日期的一部分
		if(password == idCardNo.substring(6,12) || password == idCardNo.substring(8,14))
		{
			layerUtils.iAlert("密码不能是出生日期的一部分！",-1);
			// 将密码清除
			obj.val("");
			return false;
		}
		// 判断是不是证件号码的一部分
		if(idCardNo.indexOf(password) != -1)
		{
			layerUtils.iAlert("密码不能是证件号码的一部分！",-1);
			// 将密码清除
			obj.val("");
			return false;
		}
		// 判断某一字符出现的次数
		for(var i=0;i<password.length;i++)
		{
			var oneChar = password.charAt(i),
				count = 0;
			var firstPosition = 0;
			for(var j=0;j<password.length;j++)
			{
				if(oneChar == password.charAt(j))
				{
					count++;
				}
			}
			if(count >= 3)
			{
				layerUtils.iAlert("密码中&nbsp;"+oneChar+"&nbsp;出现的次数超过了三次！",-1);
				// 将密码清除
				obj.val("");
				return false;
			}
			
		}
		// 判断顺序递增或者递减
		var orderArray = [012345,123456,234567,345678,456789,987654,876543,765432,654321,543210];
		if(orderArray.indexOf(password) != -1)
		{
			layerUtils.iAlert("密码不能是顺序递增或者递减！",-1);
			// 将密码清除
			obj.val("");
			return false;
		}
		//判断弱密码库
		var weakpwdArr=['111111','222222','333333','444444','555555','666666','777777','888888','999999','101010','202020','303030',
					'404040','505050','606060','707070','808080','909090','101010','121212','131313','141414','151515','161616',
					'171717','181818','191919','202020','212121','232323','242424','252525','262626','272727','282828','292929',
					'303030','313131','323232','343434','353535','363636','373737','383838','393939','404040','414141','424242',
					'434343','454545','464646','474747','484848','494949','505050','515151','525252','535353','545454','565656',
					'575757','585858','595959','606060','616161','626262','636363','646464','656565','676767','686868','696969',
					'707070','717171','727272','737373','747474','757575','767676','787878','797979','808080','818181','828282',
					'838383','848484','858585','868686','878787','898989','909090','919191','929292','939393','949494','959595',
					'969696','979797','989898','123412','234523','345634','456745','567856','678967','123012','123123','234234',
					'345345','456456','567567','678678','789789','112233','111222','123412','123443','234567','123456','876543',
					'111122','222233','333344','444455','555566','666677','777788','888899','999900','111111','111122','111133',
					'111144','111155','111166','111177','111188','111199','111100'];
		if(weakpwdArr.indexOf(password) != -1)
		{
			layerUtils.iAlert("请勿输入简单组合的密码！",-1);
			// 将密码清除
			obj.val("");
			return false;
		}
		// 判断是否是移动电话的一部分
		if(mobileNo.indexOf(password) != -1)
		{
			layerUtils.iAlert("密码不能是移动电话的一部分！",-1);
			// 将密码清除
			obj.val("");
			return;
		}
	}
	
	/* 验证二次输入密码是否相同 */
	function validateSecondPassword(obj,i)
	{
		if(i=="1")//交易密码
		{
			var pass1 = $(_pageId+" #pass1").val().trim();
			var pass2 = $(_pageId+" #pass2").val().trim();
			if(pass1.length != 6)
			{
				layerUtils.iMsg(-1,"请输入6位数字交易密码，请重新输入!");
			}
			else if(pass1 != pass2 && pass2 != "")
			{
				layerUtils.iMsg(-1,"交易密码与第一次不符，请重新输入!");
				$(_pageId+" #pass2").val("");
			}
		}
		else  //资金密码
		{
			var pass3 = $(_pageId+" #pass3").val().trim();
			var pass4 = $(_pageId+" #pass4").val().trim();
			if(pass3.length != 6)
			{
				layerUtils.iMsg(-1,"请输入6位数字资金密码，请重新输入!");
			}
			else if(pass3 != pass4 && pass4 != "")
			{
				layerUtils.iMsg(-1,"资金密码与第一次不符，请重新输入!");
				$(_pageId+" #pass4").val("");
			}
		}
	}
	
	/* 获取协议 */
	function getAgreement()
	{
		//调用service查询协议
		service.queryProtocolList({"category_englishname":"pwdprotcl"},function(data){
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
					allProtocols += "<a href=\"javascript:void(0);\" protocolId=\""+results[i].econtract_no+"\" id=\"protocol0"+i+"\">《"+
					results[i].econtract_name+"》</a>";
					fristMap.put(i,protocolMap);
				}
				$(_pageId+" .set_xylist").html(allProtocols);
				// 预绑定查看协议的事件
				appUtils.preBindEvent($(_pageId+" .set_xylist a"),function(e){
					appUtils.pageInit("account/setPwd","account/showProtocol",{"protocol_id" : $(this).attr("protocolId")});
					e.stopPropagation();
				});
			}
			else
			{
				layerUtils.iAlert(data.error_info);
			}
		},true,true,handleTimeout);
	}
	
	/* 处理请求超时 */
	function handleTimeout()
	{
		layerUtils.iConfirm("请求超时，是否重新加载？",function(){
			getAgreement();  // 再次获取密码协议
		});
	}
	
	/* 签署协议 */
	function signProtocol()
	{
		var keys = fristMap.keys();  // 协议的数量
		// 开启等待层。。。
		layerUtils.iLoading(true);
		var userid = appUtils.getSStorageInfo("user_id");	//用户编号
		var protocolid = ""; // 得到第一个协议ID
		var summary = "";
		var data = "";
		for(var i = 0;i< keys.length;i++){
			data  = fristMap.get(keys[countProtocol]); // 取出一个协议
//			protocolid = fristMap.get(keys[0]).get("protocolid");
			protocolid += data.get("protocolid")+",";
		    summary += data.get("summary");  // 协议内容MD5,签名摘要信息
		    countProtocol++;
		}
		signParam = {
			"medid":protocolid,
			"content":summary,
			"userId":userid,
			"type": cert_type,
			"mobile_no" : appUtils.getSStorageInfo("phoneNum")	//手机号码
		};
		// 获取协议的数字签名值
		require("shellPlugin").callShellMethod("signPlugin",function(data){
			// 数字签名值
			var protocoldcsign = data.ciphertext;
			var protocol = {
				"protocol_id" : protocolid,			//协议编号
				"protocol_dcsign" : protocoldcsign,	//数字签名值
				"summary" : summary			// 协议内容MD5,签名摘要信息
			};
			protocolArray.push(protocol);  
//			countProtocol++;
			startSign();  
		},function() {
			layerUtils.iLoading(false);
			countProtocol = 0;  // 将签署协议的计数器置为 0 
		},signParam);
	}
	
	/* 发请求进行协议验签 */
	function startSign()
	{
//		countProtocol = 0;  // 将签署协议的计数器置为 0
		var ipaddr  = appUtils.getSStorageInfo("ip"),
			macaddr = appUtils.getSStorageInfo("mac"),
			userid = appUtils.getSStorageInfo("user_id");
		// 签署协议
		var signProtocolParam = {
			"user_id" : userid,
			"jsondata" : JSON.stringify(protocolArray),
			"ipaddr" : ipaddr,
			"macaddr" : macaddr,
			"checksign" : "1",
			"mobile_no"	: appUtils.getSStorageInfo("phoneNum"),	//手机号码
			"protcl_type" : "1"
		};
//		alert(JSON.stringify(signProtocolParam));
		// 新开中登验签
		if(appUtils.getSStorageInfo("openChannel") == "new")
		{
//			,function(data){alert(JSON.stringify(data))},
			service.queryOpenCheckSign(signProtocolParam,postPassword,false);
		}
		// 转户天威验签
		else if(appUtils.getSStorageInfo("openChannel") == "change")
		{
			service.queryOpenCheckTsign(signProtocolParam,postPassword,false);
		}
	}

	/**
	 * 提交交易密码，资金密码 两次单独请求
	 * 第一次提交设置交易密码 若失败 直接返回；若成功则锁定交易密码设置
	 * 第二次提交设置资金密码 若失败 程序停止，交易密码设置锁定；
	 * pwd_type 1:资金密码 2:交易密码
	 */
	function postPassword()
	{
		service.getRSAKey({}, function(data) {
			if( data.error_no==0)	//请求获取rsa公钥成功
			{
				//密码采用rsa加密
				var results = data.results[0];
				var modulus = results.modulus;
				var publicExponent =  results.publicExponent;
				var endecryptUtils = require("endecryptUtils");
				
				var tpassword = endecryptUtils.rsaEncrypt(modulus, publicExponent, $(_pageId+" #pass1").val().trim());  //交易密码
				var fpassword = endecryptUtils.rsaEncrypt(modulus, publicExponent, $(_pageId+" #pass3").val().trim());  //资金密码
				var userid = appUtils.getSStorageInfo("user_id");
				var is_same = $(_pageId+" .mt15 .icon_check:eq(0)").hasClass("checked") ? 1 : 0;  // 判断资金密码和交易密码是否一致
				var phoneNum = appUtils.getSStorageInfo("phoneNum");
				var tradePasswordParam = {"user_id":userid,"acct_clientid":"","password":tpassword,"pwd_type":"2","is_same":is_same,"mobile_no":phoneNum};
				var fundPasswordParam  = {"user_id":userid,"acct_clientid":"","password":fpassword,"pwd_type":"1","is_same":is_same,"mobile_no":phoneNum};
				service.setAccountPwd(tradePasswordParam, function(data){
					var errorNo   = data.error_no;
					var errorInfo = data.error_info;
					if(errorNo==0)	//交易密码设置成功，锁定交易密码设置框
					{
						$(_pageId+" #pass1").attr("readonly","readonly"); //锁定密码框
						$(_pageId+" #pass2").attr("readonly","readonly");
						//第二次调用接口，提交资金密码
						service.setAccountPwd(fundPasswordParam, function(data){
							if( data.error_no==0)	//交易密码设置成功，锁定交易密码设置框
							{
								$(_pageId+" #pass3").attr("readonly","readonly");
								$(_pageId+" #pass4").attr("readonly","readonly");
								appUtils.pageInit("account/setPwd","account/riskAssessment",{});
							}
							else
							{
								layerUtils.iLoading(false);
								layerUtils.iAlert(data.error_info);
							}
						},false);
					}
					else
					{
						layerUtils.iLoading(false);
						layerUtils.iAlert(errorInfo);
						return false;
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
	
	var setPwd = {
		"init" : init,
		"bindPageEvent" : bindPageEvent,
		"destroy" : destroy
	};
	
	// 暴露对外的接口
	module.exports = setPwd;
});