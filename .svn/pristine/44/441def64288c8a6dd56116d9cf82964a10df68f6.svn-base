/**
 * 三方存管
 */
define("project/scripts/account/thirdDepository",function(require, exports, module){ 
	/* 私有业务模块的全局变量 begin */
	var appUtils = require("appUtils"),
		global = require("gconfig").global,
		platform = require("gconfig").platform,
		service = require("serviceImp").getInstance(),  // 业务层接口，请求数据
		layerUtils = require("layerUtils"),
		shellPlugin = require("shellPlugin"),
		gconfig = require("gconfig"),
		global = gconfig.global,
		utils = require("utils"),
		validatorUtil = require("validatorUtil"),
		zzispwd = 1,  // zzispwd	密码方式，1 需要，0 不需要
		iscard = 1,  // iscard	是否需要银行卡，1 需要，0 不需要
		protocol = null,  // 协议保存
		totalTime = "",   //开户时间
		percent = "",	  //超越股民的百分比
		client_id = "", //客户经理id
		cert_type = appUtils.getSStorageInfo("openChannel") == "new" ? "zd" : "tw", // tw:天威 zd:中登
		_pageId = "#account_thirdDepository";
	/* 私有业务模块的全局变量 end */
	
	function init()
	{
		client_id = appUtils.getSStorageInfo("client_id");
//		client_id = "001370";
//		client_id = "";
		if(platform == '2' || platform == '3'){
			$(_pageId+" .form_item #bankcardPwd").removeAttr("readonly");
		}
		cleanPageElement();
		window.imgState = imgState;  // 银行卡上传完成后自动调用该方法
		initPage();  // 初始化页面并检测证书是否存在
//		getBankList();
	}
	
	function bindPageEvent(){
		
		/* 绑定返回 */
		appUtils.bindEvent($(_pageId+" header .back_btn"),function(){
			appUtils.pageBack();
		});
		
		/* 点击页面隐藏键盘 */
		appUtils.bindEvent($(_pageId),function(e){
			$(_pageId+" .ly_shadow").slideUp("fast"); // 隐藏银行卡列表
			$(_pageId+" footer").show();
			$(_pageId+" .main .pz_btn").hide();
			if(platform == '1'){
				require("shellPlugin").callShellMethod("softKeyboardPlugin",null,null,{"isShow":false});  //关闭密码键盘
			}
			e.stopPropagation();  // 阻止冒泡
		});
		
		/* 签署银行相关协议  */
		appUtils.bindEvent($(_pageId+" .set_pwbox a"),function(){
			$(this).toggleClass("chkbox_ckd"); 
			$(_pageId+" footer").show();
			$(_pageId+" .main .pz_btn").hide();
		});
				
		/* 选择银行绑定下拉框按钮事件  */
		appUtils.bindEvent($(_pageId+" .form_box #selectBank"),function(e){
			if(platform == '1'){
				require("shellPlugin").callShellMethod("softKeyboardPlugin",null,null,{"isShow":false});  //关闭密码键盘
			}
			$(_pageId+" #bank_list a").removeClass("active");
			$(_pageId+" .ly_shadow").slideToggle("fast");  // 显示银行下拉列表
			$(_pageId+" footer").show();
			$(_pageId+" .main .pz_btn").hide();
			e.stopPropagation();  // 阻止冒泡
		});

		/* 选择银行卡绑定选择某银行事件 */
		appUtils.bindEvent($(_pageId+" #bankcard"),function(e){
			validateSelectBank(); // 验证是否选择银行卡
			$(_pageId+" footer").show();
			$(_pageId+" .main .pz_btn").hide();
			if(platform == '1'){
				require("shellPlugin").callShellMethod("softKeyboardPlugin",null,null,{"isShow":false});  //关闭密码键盘
			}
			e.stopPropagation();  // 阻止冒泡
		});
		
		/* 银行卡号输入控制（每四位分隔） */
		appUtils.bindEvent($(_pageId+" #bankcard"),function(){
			utils.dealIPhoneMaxLength(this,19); // 处理iphone兼容
			utils.showBigNo(this,2);  // 调用放大镜插件
			$(_pageId+" footer").show();
			$(_pageId+" .main .pz_btn").hide();
		},"input");
		
		/* 银行密码输入框 */
		appUtils.bindEvent($(_pageId+" #bankcardPwd"),function(e){
			validateSelectBank();  // 验证是否选择银行卡
			utils.dealIPhoneMaxLength(this,6); // 处理iphone兼容
			if(platform == '1'){
				var eleName = _pageId+" #bankcardPwd";
				var topHeight = $(this).offset().top + $(this).parent().height();  // 当前元素到顶部的高度
				var bodyHeight = $(document.body).height();  // 当前body的高度
				var pwsdParam = {"isShow": true,"oldPwd": $(this).val(),"maxLength": 6, "eleName": eleName};
				require("shellPlugin").callShellMethod("softKeyboardPlugin",function(data){
					// 解决弹出键盘遮挡输入框的情况
					var keyheight = data.height/window.devicePixelRatio;  // 键盘高度
					var newbody = bodyHeight - keyheight;  // 键盘弹出 body的高度
					var scrollheight = topHeight - newbody; // 输入框被遮住的高度
					if(scrollheight>0)  // 只有当密码键盘挡住输入框的时候才进行处理
					{
						scrollheight2 = bodyHeight - $(_pageId).height() + scrollheight; //页面需要滚动的高度
						$("body").css("padding-bottom",scrollheight2+"px").scrollTop(scrollheight);
					}
				},null,pwsdParam);
				$(_pageId+" footer").show();
				$(_pageId+" .main .pz_btn").hide();
			}
			e.stopPropagation();  // 阻止冒泡
		});
		
		/* 处理点击上传身份证正面、反面效果 */
		function switchCss(ele,isActive,media)
		{
			if(isActive)
			{
				$(_pageId+" .pz_btn").slideUp("fast");
				$(_pageId+" .pz_btn a").attr("media-id","null");
			}
			else
			{
				$(_pageId+" .pz_btn").slideDown("fast");
				$(_pageId+" .pz_btn a").attr("media-id",media);
			}
			$(ele).toggleClass("active");
		}
	
		/* 绑定绑定上传银行卡 */
		appUtils.bindEvent($(_pageId+" .bk_upload"),function(e){
			//隐藏开通三方存管按钮
			$(_pageId+" footer").hide();
			//显示拍照相册div
			$(_pageId+" .main .pz_btn").slideUp("fast");
			var isActive = $(this).hasClass("active");
			switchCss($(_pageId+" .mt20"), isActive, 4);
			e.stopPropagation();  // 阻止冒泡
		});
		
		/* 绑定绑定已上传银行卡，重新上传 */
		appUtils.bindEvent($(_pageId+" .bk_upsuc"),function(e){
			//隐藏开通三方存管按钮
			$(_pageId+" footer").hide();
			//显示拍照相册div
			$(_pageId+" .main .pz_btn").slideUp("fast");
			var isActive = $(this).hasClass("active");
			switchCss($(_pageId+" .mt20"), isActive, 4);
			e.stopPropagation();  // 阻止冒泡
		});
		
		/* 点击上传相册 */
		appUtils.bindEvent($(_pageId+" .pz_btn .photo"),function(e){
			// 相册上传的参数
			var phoneConfig = {
				"funcNo" : $(this).attr("media-id") == "3" ? "501525" : "501526",	
				"uuid" : "index",
				"r" : Math.random(),
				"user_id" : appUtils.getSStorageInfo("user_id"),
				"phototype" : $(this).attr("media-id") == "3" ? "人像正面" : "银行卡",	// 影像名称
				"action" : "phone",	// 照片来源类别，phone 相册，pai 相机
				"img_type" : $(this).attr("media-id"),
				"url" : global.serverPath,
				"clientinfo" : "", 	// 从 session 中将 clientinfo 取出
				"jsessionid" : appUtils.getSStorageInfo("jsessionid"),	// 从 session 中将 jsessionid 取出
				"mobile_no" : appUtils.getSStorageInfo("phoneNum"),			// 从 session中将 手机号码取出
				"branchno" : appUtils.getSStorageInfo("branchno")		// 从 session中将营业部编号取出
			};
			if(gconfig.platform == 3)
			{
				layerUtils.iLoading(true);
			}
			require("shellPlugin").callShellMethod("uploadBankPlugin",null,null,phoneConfig);
			// 隐藏照片上传按钮
			$(_pageId+" .pz_btn").slideUp("fast");
			$(_pageId+" .mt20").removeClass("active");
			// 将按钮的自定义属性  last-media-id 设为 当前的 media-id
			$(_pageId+" .pz_btn .photo").attr("last-media-id",$(_pageId+" .pz_btn .photo").attr("media-id"));
			$(_pageId+" .pz_btn .photo").attr("media-id","null");
			e.stopPropagation();  // 阻止冒泡
		});
		
		/* 点击重拍拍照 */
		appUtils.bindEvent($(_pageId+" .pz_btn .carmera"),function(e){
			// 相机上传的参数
			var paiConfig = {
				"funcNo" : $(this).attr("media-id") == "3" ? "501525" : "501526",	
				"uuid" : "index",
				"r" : Math.random(),
				"user_id" : appUtils.getSStorageInfo("user_id"),
				"phototype" : $(this).attr("media-id") == "3" ? "人像正面" : "银行卡",	// 影像名称
				"action" : "pai",	// 照片来源类别，phone 相册，pai 相机
				"img_type" : $(this).attr("media-id"),
				"url" : global.serverPath,
				"clientinfo" : "", 	// 从 session 中将 clientinfo 取出
				"jsessionid" : appUtils.getSStorageInfo("jsessionid"),	// 从 session 中将 jsessionid 取出
				"mobile_no" : appUtils.getSStorageInfo("phoneNum"),			// 从 session中将 手机号码取出
				"branchno" : appUtils.getSStorageInfo("branchno")		// 从 session中将营业部编号取出
			};
			if(gconfig.platform == 3)
			{
				layerUtils.iLoading(true);
			}
			require("shellPlugin").callShellMethod("uploadBankPlugin",null,null,paiConfig);
			// 隐藏照片上传按钮
			$(_pageId+" .pz_btn").slideUp("fast");
			$(_pageId+" .mt20").removeClass("active");
			// 将按钮的自定义属性  last-media-id 设为 当前的 media-id
			$(_pageId+" .pz_btn .photo").attr("last-media-id",$(_pageId+" .pz_btn .photo").attr("media-id"));
			// 将按钮的自定义属性 media-id 设为 null
			$(_pageId+" .pz_btn .photo").attr("media-id","null");
			e.stopPropagation();  // 阻止冒泡
		});
		
		/* 开通三方存管按钮绑定事件 */
		appUtils.bindEvent($(_pageId+" .com_btn"),function(){
			signProtocol();  // 提交验签，并且提交三方存管信息
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
	
	/**
	 * 照片上传完成后，会自动调用 imgState 方法，但是该方法只能写在 m/index.html
	 * 或者暴露给 window ，否则无法调用
	 * 已在 init 中暴露给 window 
	 */ 
	function imgState(mediaId, data)
	{
		if(gconfig.platform == 3)
		{
			layerUtils.iLoading(false);
			data = unescape(data);
		}
		data = JSON.parse(data);  // 返回的是 json 串
		var base64Str = (data.base64).replace(/[\n\r]*/g,"");
		if(data.error_no != 0)
		{
			layerUtils.iAlert(data.error_info);
			return false;
		}
		$(_pageId+" .mt20 .bk_upsuc").show();
		$(_pageId+" .mt20 .bk_upload").hide();
		$(_pageId+" .protocolshow").show();
		$(_pageId+" footer").show();
		$(_pageId+" .main .pz_btn").hide();
	}
	
	function destroy()
	{
//		$(_pageId+" input").val("");  // 把所有的input置空
		service.destroy();
	}
	
	/* 初始化页面 */
	function initPage()
	{
		layerUtils.iLoading(false);  // 开启等待层。。。
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
				//appUtils.pageInit("account/setPwd","account/digitalCertificate");
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
		var queryParam = {"bindtype" : "", "ispwd" : "","recommendNo":client_id};
		service.queryBankList(queryParam,function(data){
//			alert(JSON.stringify(data));
			var errorNo = data.error_no;
			var errorInfo = data.error_info;
			$(_pageId+" .ly_shadow .bank_list").html("");  // 清除页面的银行列表
			if(errorNo==0 && data.results.length != 0)
			{
				var results = data.results;
				var length = results.length;
				var itemElement = "";
				for(var i =0; i<length; i++)
				{
					var item = results[i],
				   		  bankcode = item.bankcode,  // 银行代码
						  bankname = item.bankname,  // 银行名称
						  zzbindtype = item.zzbindtype, // 绑定方式：1 一步式 2 预指定 3 同时支持两种方式
					      sortnum  = item.sortnum,  // 排序
					      smallimg = item.smallimg, // 图标
					      isbuffet = item.isbuffet, // 是否支持自助
					      sign_info = item.sign_info, // 提示信息简介
					      brief = item.brief; // 银行简介
				    zzispwd = item.zzispwd; // 密码方式：1 需要 0 不需要  
				    iscard = item.iscard; // 卡号方式：1 需要 0 不需要  
					itemElement += "<a class=\"fl\" bankname='"+bankname+"' id='"+bankcode+"' " +"zzispwd=\""+zzispwd+"\""+
									            "iscard=\""+iscard+"\"  zzbindtype=\""+zzbindtype+"\" sign-info=\""+sign_info+"\"><img src='"+global.imgServerUrl+smallimg+"' height=\"38px\"></a>";
				}
				$(_pageId+" .ly_shadow .bank_list").html(itemElement);
				//存在预置值id，并且返回一个银行时
				if(client_id != null && length == 1){
					$(_pageId+" .protocolshow").show();
					$(_pageId+" .set_pwbox a").addClass("chkbox_ckd");
					var banckName = $(_pageId+" .ly_shadow .bank_list a").attr("bankname"),
						  id = $(_pageId+" .ly_shadow .bank_list a").attr("id"),
						  zzbindtype = $(_pageId+" .ly_shadow .bank_list a").attr("zzbindtype"),  // 绑定方式
						  signInfo = $(_pageId+" .ly_shadow .bank_list a").attr("sign-info");  // 提示信息
				    	  zzispwd = $(_pageId+" .ly_shadow .bank_list a").attr("zzispwd");  // 密码方式
				          iscard = $(_pageId+" .ly_shadow .bank_list a").attr("iscard");  // 是否需要银行卡号
				          smallimg = $(_pageId+" .ly_shadow .bank_list a").children("img").attr("src");
					addBankItem(banckName,id,zzbindtype,signInfo,smallimg,client_id);
				}
				else{
					// 选择银行添加银行事件
					appUtils.bindEvent($(_pageId+" .ly_shadow .bank_list a"),function(e){
						$(_pageId+" .ly_shadow .bank_list").removeClass("active");
						$(this).parent().addClass("active");
						$(_pageId+" .protocolshow").show();
						$(_pageId+" .set_pwbox a").addClass("chkbox_ckd");
						var banckName = $(this).attr("bankname"),
							  id = $(this).attr("id"),
							  zzbindtype = $(this).attr("zzbindtype"),  // 绑定方式
							  signInfo = $(this).attr("sign-info");  // 提示信息
					    zzispwd = $(this).attr("zzispwd");  // 密码方式
					    iscard = $(this).attr("iscard");  // 是否需要银行卡号
					    smallimg = $(this).children("img").attr("src");
						addBankItem(banckName,id,zzbindtype,signInfo,smallimg,"");
						e.stopPropagation();
					});
				}
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
	function addBankItem(banckName,id,zzbindtype,signInfo,smallimg,client_id)
	{
		if(client_id !=""){
			$(_pageId+" .form_box #selectBank").off();
			$(_pageId+" .ly_shadow").hide();
		}
		$(_pageId+" .bank_pass .txt_tit").html("银行密码");
		if(banckName == "中国银行"){
			$(_pageId+" .bank_pass .txt_tit").html("电话银行密码");
		}
		var img_str = "";
		// 显示银行的签约信息
		if(signInfo != "" && signInfo != undefined)
		{
			$(_pageId+" #bindInfo").html("温馨提示: "+signInfo);
		}
		else 
		{
			$(_pageId+" #bindInfo").html(""); 
		}
		$(_pageId+" #bankcard").val("");  // 清空银行卡号值
		$(_pageId+" #bankcardPwd").val(""); // 清空银行卡密码
		//$(_pageId+" #selectBank").html(banckName);  // 赋值银行卡名称
		img_str = "<img src= "+ smallimg+" style=\"height:38px\">";
		$(_pageId+" #selectBank").attr("bankcode",id);
		$(_pageId+" #selectBank").html(img_str);
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
			$(_pageId+" .form_box:eq(1)").show();  // 显示银行卡、密码输入框
			//$(_pageId+" #bindInfo").hide();  // 隐藏预指定提示信息
		}
		if(zzbindtype == 2)  // 判断预指定(二步式)
		{
			if(iscard == 1)  // 需要银行卡
			{
				$(_pageId+" .form_box:eq(1)").show();  // 显示银行卡
				$(_pageId+" .form_box:eq(1) .form_item:eq(1)").hide();  // 隐藏密码
			}
			else // 不需要银行卡
			{
				$(_pageId+" .form_box:eq(1)").hide();  // 隐藏银行卡、密码输入框
			}
			//$(_pageId+" #bindInfo").show();  // 显示预指定提示信息
		}
		$(_pageId+" .ly_shadow").slideUp("fast");  // 隐藏银行下拉列表
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
		if(!validateIsUploadCard()){
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
				"macaddr" : macaddr,
				"mobile_no"	: appUtils.getSStorageInfo("phoneNum"),	//手机号码
				"protcl_type" : "2"
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
//			alert(JSON.stringify(data));
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
					"op_type":$(_pageId+" #selectBank").attr("zzbindtype"),
					"mobile_no" : appUtils.getSStorageInfo("phoneNum")
				};
				// 调用service绑定存管银行
				service.bindBank(thirdDepositParam,function(data){
					totalTime = data.results[0].total_time;	
					percent = data.results[0].percent;
//					alert("三方存管接口返回："+percent);
					//把开户时间以及百分比保存到session中，传到结果页显示
					appUtils.clearSStorage("totalTime");
					appUtils.clearSStorage("openPercent");
					appUtils.setSStorageInfo("totalTime",totalTime);
					appUtils.setSStorageInfo("openPercent",percent)
					var errorNo = data.error_no;
					var errorInfo = data.error_info;
					if(errorNo==0)	 // 调用成功,跳转到风险测评页面
					{
						cleanPageElement();
						//判断是否需要问卷回访
						if(global.needConfirm)
						{
							appUtils.pageInit("account/thirdDepository","account/openConfirm",{});
						}
						else
						{
							appUtils.pageInit("account/thirdDepository","account/accountResult",{});
						}
					//appUtils.pageInit("account/thirdDepository","account/accountResult",{"totalTime":totalTime,"percent":percent});
					}
					else
					{
						layerUtils.iLoading(false);
						layerUtils.iAlert(errorInfo,-1);
					}
				},true);
			}
			else
			{
				layerUtils.iLoading(false);
				layerUtils.iAlert(data.error_info);
			}
		}, true);
	}
	
	/* 验证是否选择银行  */
	function validateSelectBank()
	{
		var obj = $(_pageId+" #selectBank");
		var value = obj.html();
		if(validatorUtil.isEmpty(value)||value=="请选择开通银行")
		{
			layerUtils.iMsg(-1,"请先选择银行");
			return false;
		}
		return true;
	}
	
	/* 检验银行卡填写是否正确 */
	function validateBankCorrect()
	{
		var bankcard = $(_pageId+" #bankcard").val();
		if(bankcard == "")  // 验证通过的情况
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
		var cardPwd = $(_pageId+" #bankcardPwd").val();
		if(!validatorUtil.isNumeric(cardPwd) || cardPwd.length !=6)
		{
			layerUtils.iMsg(-1,"银行卡密码有误，请重新输入！");
			return false;
		}
		return true;
	}
	
	/* 验证是否上传银行卡 */
	function validateIsUploadCard(){
//		alert($(_pageId+" .bk_upload").is(":visible"));
//		alert(!$(_pageId+" .bk_upsuc").is(":visible"));
		if($(_pageId+" .bk_upload").is(":visible") && !$(_pageId+" .bk_upsuc").is(":visible")){
			layerUtils.iMsg(-1,"请上传银行卡!");
			$(_pageId+" .bk_upload").show();
			return false;
		}
		return true;
	}
	
	/* 检测勾选阅读协议 */
	function validateDepositProtocolSelect()
	{
		if(!$(_pageId+" .protocolshow .chkbox:eq(0)").hasClass("chkbox_ckd"))
		{
			layerUtils.iMsg(-1,"请阅读并勾选三方存管协议!");
			return false;
		}
		return true;
	}
	
	/* 获取存管银行签约电子协议列表 */
	function getDepositoryAgreement(bankcode)
	{
		$(_pageId+" #protocolName").html("");  // 清空协议
		// 调用service查询存管银行协议
		var param = {"econtract_no" : bankcode};
		service.queryProtocolList(param,function(data){
			$(_pageId+" #protocolName").html("");
			if(data.error_no == 0)
			{
				if(data.results&&data.results.length>=1)
				{
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
		$(_pageId+" .protocolshow a").removeClass("chkbox_ckd");  // 取消勾选协议
		$(_pageId+" #selectBank").html("请选择开通银行");  // 清理银行卡的名字
		$(_pageId+" #bankcard").val("");  // 清理银行卡号
		$(_pageId+" #bankcardPwd").val("");  // 清理密码
		$(_pageId+" #protocolName").text("《客户交易结算资金银行存管协议》");  // 清理协议名
		$(_pageId+" #signInfo").html("");  // 清除银行签约信息
		$(_pageId+" footer").show();
		$(_pageId+" .main .pz_btn").hide();
	}
	
	var thirdDepository = {
		"init" : init,
		"bindPageEvent" : bindPageEvent,
		"destroy" : destroy
	};
	
	// 暴露对外的接口
	module.exports = thirdDepository;
});