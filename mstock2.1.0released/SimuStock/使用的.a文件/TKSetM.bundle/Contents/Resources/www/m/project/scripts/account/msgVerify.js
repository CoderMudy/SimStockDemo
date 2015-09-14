/**
 * 手机号码验证
*/
define("project/scripts/account/msgVerify",function(require,exports,module){
	/* 私有业务模块的全局变量 begin */
	var appUtils = require("appUtils"),
		service = require("serviceImp").getInstance(),  //业务层接口，请求数据
		global = require("gconfig").global,
		gconfig = require("gconfig"),
		layerUtils = require("layerUtils"),
		utils = require("utils"),
		shellPlugin = require("shellPlugin"),
		validatorUtil = require("validatorUtil"),
		startCountDown = null,
		clearCountDown = null, 
		_pageId = "#account_msgVerify",
		psw_id = "", key = 1, flag = false,
		count = 0;
		steps = ["uploadimg","idconfirm","witness",
		        	 "signagree","certintall","setpwd",
		        	 "risksurvey","tpbank","visitsurvey","success"
  	    ],
		stepMap = {"uploadimg":"account/uploadPhoto","idconfirm":"account/personInfo","witness":"account/videoNotice",
	               		   "signagree":"account/signCertificateProtocol","certintall":"account/digitalCertificate",
	               		   "setpwd":"account/setPwd","risksurvey":"account/riskAssessment",
	              		   "tpbank":"account/thirdDepository","visitsurvey":"account/openConfirm","success":"account/accountResult"
	    },
		stepMap0 = {"uploadimg":"account/uploadPhotoChange","witness":"account/digitalCertificate"};
		
	var lastSendPhoneNumber = "";
	/* 私有业务模块的全局变量 end */	
	
	function readWriteFunc(type){
		var clientId = $(_pageId+" .clientId").val();
		var clientParam = {
			"client_id" : clientId,  // 客户编号
			"type" : type,  //读写类型
			"fileName" : "clientInfoFile.txt",  //保存信息文件
			"metaName" : "DONGGUAN_CLIENTID" // 第一条记录是否是强制更新
		};
		//初始化调用插件读取默认客户id，保存在session
		shellPlugin.callShellMethod("fileWriteReadPlugin",
			function(data){
				var client_id = data.client_id;
				if(client_id !=""){
					appUtils.setSStorageInfo("recommender_id",client_id);
				}
			},function(){
//				layerUtils.iAlert("调用读写客户信息插件失败！");
			},clientParam);
	}
	
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
//		var _prePageCode = appUtils.getSStorageInfo("_prePageCode");
//		if(_prePageCode == null){
//			// 自动测速，选择最佳地址
//			// 启动时，检查当前客户端的版本号与服务器上最新的是否一致，根据需要更新客户端，只在启动时检查，started 为 true 表示已启动，已启动就不检查
//			if(appUtils.getSStorageInfo("started") != "true")
//			{
//				// 设置 session 中的 started 为 true ，表示已启动
//				appUtils.setSStorageInfo("started","true");
//				layerUtils.iLoading(true, "正在检查版本...");
//				setBestAddress();  // 设置最佳地址
//			}
//		}
		/*发送验证码后自动互调该方法*/
		window.getCode = getCode;
		$(_pageId+" .mobile_form .code_pic").attr("src",global.serverUrl+"/nImgServlet?key=1");
		var elements = _pageId +" .phoneNum";
		utils.getPhoneNo(elements); // 自动获取手机号，并填充
		readWriteFunc("read");
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
		
		//监听手机号码输入事件，控制输入格式为132 2222 1112
		appUtils.bindEvent($(_pageId+" .form_item .phoneNum"), function(){
			console.log("dfdfddd");
			var value = $(this).val().replaceAll(" ", "");
			var finalValue = "";
			if(value){
				var len = value.length;
				if(len > 7){ // 1341234 --> 134 1234 1
					//第三位空格之后 && 第八位之后空格
					finalValue = value.substring(0, 3)+" "+value.substring(3, 7)+" "+value.substring(7);
				} else if(len <= 7 && len > 3){ //1342 --> 134 2
					//第三位空格之后
					finalValue = value.substring(0, 3)+" "+value.substring(3);
				} else { //13 --> 13
					//不处理
					finalValue = value;
				}
			}
			$(this).val(finalValue);
			//下面是设置光标位置为最后
			var o = $(this)[0];
			if(o.setSelectionRange){//W3C
				setTimeout(function(){
					o.setSelectionRange(o.value.length,o.value.length);
					o.focus();
				},0);
			}else if(o.createTextRange){//IE
				var textRange=o.createTextRange();
				textRange.moveStart("character",o.value.length);
				textRange.moveEnd("character",0);
				textRange.select();
			}
			
			//最后判断是否输入的手机号与上一次手机号不一致，以便清楚读秒定时器
			if(validatorUtil.isMobile(finalValue.replaceAll(" ", "")) &&  lastSendPhoneNumber != finalValue.replaceAll(" ", ""))
		 	{
		 		//用户两次输入的手机号不同，重新获取验证码
	 			if(startCountDown != null)
				{
					window.clearInterval(startCountDown);
					startCountDown = null;
				}
				if(clearCountDown != null)
				{
					window.clearInterval(clearCountDown);
					clearCountDown = null;
				}
				$(_pageId+" .getmsg").show();  // 显示按钮
				$(_pageId+" .time").hide();  // 隐藏倒计时
	 		
		 	}
		}, "input");
		
		appUtils.bindEvent($(_pageId+" .form_item .phoneNum"), function(){
			$(_pageId+" footer").hide();
		}, "focus");
		
		appUtils.bindEvent($(_pageId+" .form_item .phoneNum"), function(){
			$(_pageId+" footer").show();
		}, "blur");
		
		appUtils.bindEvent($(_pageId+" .form_item .mobileCode"), function(){
			$(_pageId+" footer").hide();
		}, "focus");
		
		appUtils.bindEvent($(_pageId+" .form_item .mobileCode"), function(){
			$(_pageId+" footer").show();
		}, "blur");
		
		appUtils.bindEvent($(_pageId+" .form_item .clientId"), function(){
			$(_pageId+" footer").hide();
		}, "focus");
		
		appUtils.bindEvent($(_pageId+" .form_item .clientId"), function(){
			$(_pageId+" footer").show();
		}, "blur");
		
		/* 绑定返回事件 */
		appUtils.bindEvent($(_pageId+" .header .icon_back"),function(){
			appUtils.pageBack();
		});
		
		/* 绑定退出按钮*/
		appUtils.bindEvent($(_pageId+" .header .icon_close"),function(){
			utils.layerTwoButton("退出系统？","确认","取消",function(){
				require("shellPlugin").callShellMethod("closeAppPlugin",null,null);  // 退出程序
			},
			function(){return false;});
		});
		
		/* 限制手机号在IOS上的长度 */
//		appUtils.bindEvent($(_pageId+" .phoneNum"),function(){
//			utils.dealIPhoneMaxLength(this,11); //处理iphone兼容
//		},"input");
		
		/* 绑定获取短信验证码事件 */
		appUtils.bindEvent($(_pageId+" .getmsg"),function(){
			var phoneNum =  $(_pageId+" .phoneNum").val();
			var lastPhone = phoneNum.replaceAll(" ", "");
			var re = /^(123)[0-9]{8}$/;
			// 首先验证手机号
			if(validatorUtil.isMobile(lastPhone) || re.test(lastPhone))
			{
				getSmsCode(lastPhone);  //获取验证码
			}
			else
			{
				// 手机号没通过前端校验，弹出提示，并终止发送验证码的过程
				var times = phoneNum.length - 13;
				if(phoneNum.length > 13)
				{
					layerUtils.iMsg(-1,"您多输入&nbsp;"+times+"&nbsp;位电话号码，请重新输入！");
				}
				else if(phoneNum.length < 13)
				{
					layerUtils.iMsg(-1,"您少输入&nbsp;"+Math.abs(times)+"&nbsp;位电话号码，请重新输入！");
				}
				return;
			}
		});
		
		/* 点击三次身份验证出现客户经理id输入框 */
		appUtils.bindEvent($(_pageId+" header h2") ,function(){
		  	 count++;
		  	 if(count == 3){
		  		  $(_pageId+" .form_item:eq(2)").show();
		  		  var client_id = appUtils.getSStorageInfo("recommender_id");
				  $(_pageId+" .clientId").val(client_id);
		  	 }
		},"touchstart");
		
		/* 下一步(继续开户) */
		appUtils.bindEvent($(_pageId+" .kh_btn") ,function(){
		    if($(_pageId+" .phoneNum").val().length == 0)
			{
				layerUtils.iMsg(-1,"请输入手机号！");
				return;
			}
			if($(_pageId+" .mobileCode").val().length == 0)
			{
				layerUtils.iMsg(-1,"请输入验证码！");
				return;
			}
			checkSmsCode();  //验证码校验
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
		// 清除计时器
		if(startCountDown != null)
		{
			window.clearInterval(startCountDown);
			startCountDown = null;
		}
		if(clearCountDown != null)
		{
			window.clearInterval(clearCountDown);
			clearCountDown = null;
		}
		$(_pageId+" .getmsg").show();  // 显示按钮
		//$(_pageId+" .cert_notice").hide();  // 隐藏验证码已发出提示
		$(_pageId+" .time").hide();  // 隐藏倒计时
		$(_pageId+" .phoneNum").val("");  //清除手机号
		$(_pageId+" .pic_code").val("");  //清除手机号
		$(_pageId+" .mobileCode").val("");  // 清除验证码
		service.destroy();
	}
	
	/* 壳子获取验证码自动填充 */
	function getCode(data)
	{
//		alert("验证码："+data);
		if(data)
		{
			$(_pageId+" .mobileCode").val(data);
		}	
	}
	
	/* 获取验证码 */
	function getSmsCode(phoneNum, verify_code)
	{
		var mac = iBrowser.pc ? "02:00:5E:00:00:14" : "",
			  ip = iBrowser.pc ? "192.168.1.109" : "";
		// 只有当不是 pc 时，才调用壳子获取 ip 和 mac
		if(!iBrowser.pc)
		{
			require("shellPlugin").callShellMethod("getIpMacPLugin",function(data){
				data = data.split("|");
				mac = data[0];
				ip = data[1];
				appUtils.setSStorageInfo("ip",ip); // 将 ip 保存到 sessionStorage 里面
				appUtils.setSStorageInfo("mac",mac); // 将 mac 保存到 sessionStorage 里面
				sendmsg(phoneNum,mac,ip,verify_code); // 发送验证码
			},null);
		}
		else
		{
			sendmsg(phoneNum,mac,ip,verify_code); // 发送验证码
		}
	}
	
	/* 发送验证码 */
	function sendmsg(phoneNum,mac,ip,verify_code)
	{
		var param = {
			// 访问接口来源标识，访问来源(默认PC) 0：pc， 2：pad， 3：手机 
			"op_way" : iBrowser.pc ? 0 : 3,
			"mobile_no" : phoneNum,
			"ip" : ip, 
			"mac" : mac 
		};
		//请求获取验证码接口
		service.getSmsCode(param,function(data){
//			alert(JSON.stringify(data));
			var error_no = data.error_no;
			var error_info = data.error_info;
			var result = data.results;
			if(error_no == "0")
			{
		        //后台如果返回ip地址，则本地存储用户ip地址
			    if(result[0] && result[0].ip)
			    {
				    appUtils.setSStorageInfo("ip",result[0].ip);
			    }
				// 计时器
				var sumTime = 60;
				//处理获取验证码时发生的动作
				var handleCount = function(){
					// 获取验证码之后按钮隐藏
					$(_pageId+" .getmsg").hide();
					// 显示倒计时
					$(_pageId+" .time").show();
					//$(_pageId+" .cert_notice").show();
					$(_pageId+" .time").text(sumTime--+"秒后重发");
				};
				handleCount();
				startCountDown = window.setInterval(function(){
					handleCount();
				}, 1000);
				// 60 秒之后清除计时器
			    clearCountDown = setTimeout(function(){
					// 显示按钮
					$(_pageId+" .getmsg").show().html("重新发送");
					// 隐藏倒计时
					$(_pageId+" .time").hide();
					//$(_pageId+" .cert_notice").hide();
					$(_pageId+" .time").text(60);
					window.clearInterval(startCountDown);
					startCountDown = null;
				},61000);
				 //发送完验证码后，通过判断输入手机号是否一致，否则重新发送验证码
				 lastSendPhoneNumber = phoneNum;
				 // 调用读取短信验证码插件
				 require("shellPlugin").callShellMethod("sMSReceiverPlugin",null,null,null);
			}
			else
			{
				layerUtils.iAlert(error_info,-1);
				$(_pageId+" .mobile_form .code_pic").attr("src",global.serverUrl+"/nImgServlet?key="+Math.random());
				return false;
			}
		});
	}
	
	//保存推荐人id
	function saveRecommendId(){
		var customerId = $(_pageId+" .clientId").val();
		//未显示客户经理输入框，则默认传插件存在的默认客户经理id
		if(!$(_pageId+" .form_item:eq(2)").is(":visible")){
			appUtils.clearSStorage("client_id");
			appUtils.setSStorageInfo("client_id",appUtils.getSStorageInfo("recommender_id"));
		}
		else{
			appUtils.clearSStorage("client_id");
			//显示则传输入框的值
			appUtils.setSStorageInfo("client_id",customerId);
		}
//		appUtils.setSStorageInfo("client_id","001370");
	}
	
	/* 提交验证码校验 */
	function checkSmsCode()
	{
		saveRecommendId();
		var client_id = appUtils.getSStorageInfo("client_id");
		var login_flag = appUtils.getSStorageInfo("openChannel") == "new" ? "0" : "1";
		if(appUtils.getSStorageInfo("finance") == "finance")
		{
			login_flag = "2";   // 理财户传2
		}
		var phone = $(_pageId+" .phoneNum").val();
		var lastPhone = "";
		if(phone.length == 13){
			var ph1 = phone.substring(0,3);
			var ph2 = phone.substring(4,8);
			var ph3 = phone.substring(9,13);
			lastPhone = ph1 + ph2 +ph3;
		}
		var param = {	
			"mobile_no" : lastPhone,
			"mobile_code" : $(_pageId+" .mobileCode").val(),
			"login_flag" : login_flag,  // 登录业务标准，新开户0  转户1  理财户2
			"recommender_id" :client_id
		};	
		/*调用验证码校验接口*/
		service.checkSmsCode(param,function(data){
//			alert(JSON.stringify(param));
//			alert(JSON.stringify(data));
			appUtils.setSStorageInfo("phoneNum",lastPhone);
			var error_no = data.error_no;
			var error_info = data.error_info;
			var result = data.results;
			if(error_no == "0" && result.length != 0)
			{
				//调用写入插件保存客户经理id
				readWriteFunc("write");
				if(result[0].opentime)
				{  
					appUtils.setSStorageInfo("opentime",result[0].opentime);  
				}
				if(result[0].percent)
				{
					appUtils.setSStorageInfo("percent",result[0].percent);  
				}
				//东莞数据id
				if(result[0].serial_no)
				{
					appUtils.setSStorageInfo("serial_no",result[0].serial_no);  
				}
				// user_id保存到session
				if(result[0].user_id)
				{
					appUtils.setSStorageInfo("user_id",result[0].user_id);  
				}
				// 身份证号保存到session
				if(result[0].idno)
				{
					appUtils.setSStorageInfo("idCardNo",result[0].idno);
				}
				//手机号保存到session
				if(result[0].mobileno)
				{
					appUtils.setSStorageInfo("mobileNo",result[0].mobileno);
				}
				// 将客户姓名保存到 session 中
				if(result[0].custname)
				{
					appUtils.setSStorageInfo("custname",result[0].custname);
				}
				// 签发机关保存到session 
				if(result[0].policeorg)
				{
					appUtils.setSStorageInfo("policeorg",result[0].policeorg);
				}
				// 证件地址保存到session 
				if(result[0].native)
				{
					appUtils.setSStorageInfo("native",result[0].native);
				}
				// 联系地址保存到session 
				if(result[0].addr)
				{
					appUtils.setSStorageInfo("addr",result[0].addr);
				}
				// 起始期限保存到session 
				if(result[0].idbegindate)
				{
					appUtils.setSStorageInfo("idbegindate",result[0].idbegindate);
				}
				// 结束期限保存到session 
				if(result[0].idenddate)
				{
					appUtils.setSStorageInfo("idenddate",result[0].idenddate);
				}
				// 邮编保存到session 
				if(result[0].postid)
				{
					appUtils.setSStorageInfo("postid",result[0].postid);
				}
				// 出生日期保存到session
				if(result[0].birthday)
				{
					appUtils.setSStorageInfo("birthday",result[0].birthday);
				}
				// 职业保存到session 
				if(result[0].profession_code)
				{
					appUtils.setSStorageInfo("profession_code",result[0].profession_code);
				}
				// 学历保存到session 
				if(result[0].edu)
				{
					appUtils.setSStorageInfo("edu",result[0].edu);
				}
				// 行业保存到session 
				if(result[0].trade)
				{
					appUtils.setSStorageInfo("trade",result[0].trade);
				}
				// 将 clientinfo 保存到 session 中，用于解决壳子上传照片的权限问题
				if(result[0].clientinfo)
				{
					appUtils.setSStorageInfo("clientinfo",result[0].clientinfo);
				}
				// 将 jsessionid 保存到 session 中，用于解决壳子上传照片的权限问题
				if(result[0].jsessionid)
				{
					appUtils.setSStorageInfo("jsessionid",result[0].jsessionid);
				}
				// 将佣金id保存到session
				if(result[0].commission)
				{
					appUtils.setSStorageInfo("commission",result[0].commission);
				}
				// 将佣金值保存到session
				if(result[0].commissionname)
				{
					appUtils.setSStorageInfo("commissionname",result[0].commissionname);
				}
				// 将营业部Id保存到session
				if(result[0].branchno)
				{
					appUtils.setSStorageInfo("branchno",result[0].branchno);
				}
				// 将营业部名称保存到session
				if(result[0].branch_name)
				{
					appUtils.setSStorageInfo("branchname",result[0].branch_name);
				}
				// 将佣金类别保存到session
				if(result[0].fare_type)
				{
					appUtils.setSStorageInfo("fare_type",result[0].fare_type);
				}
				// 将佣金单位保存到session
				if(result[0].unit)
				{
					appUtils.setSStorageInfo("unit",result[0].unit);
				}
				// 将套餐名称保存到session
				if(result[0].remark)
				{
					appUtils.setSStorageInfo("remark",result[0].remark);
				}
				//身份证正面
				if(result[0].frontpath)
				{
					appUtils.setSStorageInfo("frontpath",result[0].frontpath);
				}
				//身份证背面
				if(result[0].backpath)
				{
					appUtils.setSStorageInfo("backpath",result[0].backpath);
				}
				//断点：上次走的最后一步
				if(result[0].lastcomplete_step)
				{
					appUtils.setSStorageInfo("currentStep",result[0].lastcomplete_step);
				} 
				appUtils.setSStorageInfo("shaselect",result[0].shaselect);  // 是否选择沪A
				appUtils.setSStorageInfo("szaselect",result[0].szaselect);  // 是否选择深A
				appUtils.setSStorageInfo("hacnselect",result[0].shaselect);  // 是否选择沪开放式基金
				appUtils.setSStorageInfo("zacnselect",result[0].szaselect);  // 是否选择深开放式基金
//				var  opacctkind_flag = result[0].opacctkind_flag;  // 开户通道的标识，0 新开户，1 转户 , 2 理财户
				var  opacctkind_flag = 0;  // 开户通道的标识，0 新开户，1 转户 , 2 理财户
				appUtils.setSStorageInfo("opacctkind_flag",opacctkind_flag);
				appUtils.setSStorageInfo("openChannel","new");
				// 根据 opacctkind_flag 设置 session 中的 openChannel
				if(opacctkind_flag == 0)
				{
					appUtils.setSStorageInfo("openChannel","new");
				}
				else 
				{
					if(opacctkind_flag == 2)
					{
						appUtils.setSStorageInfo("finance","finance");
					}
					appUtils.setSStorageInfo("openChannel","change");
				}
				//判断是否驳回，若驳回 则走驳回流程
				if(addition(result[0]))
				{
					return false;
				}
				//未驳回，则正常走流程
				else
				{
//					appUtils.pageInit("account/msgVerify","account/thirdDepository",{});
					nextStep(result[0], opacctkind_flag);
				}
			}
			else
			{
				layerUtils.iMsg(-1,"您尚未通过手机号码验证，请先提交验证码！");
			}
		});
	}
	
	/* 处理驳回补全资料的情况 */
	function addition(res)
	{
		//驳回情况：身份证正面、反面、大头像、交易密码、资金密码、三方存管、转户驳回到视频见证
		var photoParam = {"needFront" : res.need_photo_front != undefined ? res.need_photo_front : "0",
									   "needBack" : res.need_photo_back != undefined ? res.need_photo_back : "0",
									   "needNohat" : res.need_photo_nohat != undefined ? res.need_photo_nohat : "0"
		};
		var pwdParam = {"needBusinessPwd" : res.need_business_password != undefined ? res.need_business_password : "0",
		                            "needFundPwd" : res.need_fund_password != undefined ? res.need_fund_password : "0"
		};
		var videoParam = {"need_video" : res.need_video != undefined ? res.need_video : "0"};
		var thirdParam ={"needThirdDeposit" : res.need_third_deposit != undefined ? res.need_third_deposit : "0"};
		appUtils.setSStorageInfo("videoParam",JSON.stringify(videoParam));
		appUtils.setSStorageInfo("pwdParam", JSON.stringify(pwdParam));
		appUtils.setSStorageInfo("thirdParam", JSON.stringify(thirdParam));
		// 1.补全照片
		if(photoParam["needFront"]==1 || photoParam["needBack"]==1 || photoParam["needNohat"]==1)
		{
			appUtils.pageInit("account/msgVerify","account/backUploadPhoto",photoParam);
			return true;
		}
		// 2.驳回视频见证
		if(videoParam["need_video"]==1)
		{
			appUtils.pageInit("account/msgVerify","account/videoNotice",videoParam);
			return true;
		}
		// 3.驳回密码设置
		if(pwdParam["needBusinessPwd"]==1 || pwdParam["needFundPwd"]==1)
		{
			appUtils.pageInit("account/msgVerify","account/backSetPwd",pwdParam);
			return true;
		}
		// 4.驳回三方存管
		if(thirdParam["needThirdDeposit"]==1)
		{
			appUtils.pageInit("account/msgVerify","account/backThirdDepository",thirdParam);
			return true;
		}
		else
		{
			return false;
		}
	}
	
	/* 下一步入口 */
	function nextStep(res, opacctkind_flag)
	{
		var pageCode = "";
		var currentStep = res["lastcomplete_step"];  //断点：上次走的最后一步
//		alert("msgVerify页面当前步骤:"+currentStep);
		appUtils.setSStorageInfo("currentStep",currentStep);
		if(currentStep && currentStep.length > 0)
		{
			var index = steps.indexOf(currentStep);
			if(index < (steps.length-1))
			{
				currentStep = steps[index + 1];
			}
			if(opacctkind_flag == "0")
			{
				pageCode = stepMap[currentStep];
			}
			else
			{
				pageCode = stepMap0[currentStep];
				if(!(pageCode && pageCode.length > 0))
				{
					pageCode = stepMap[currentStep];
				}
			}
		}
		if(pageCode && pageCode.length > 0)
		{
			// 如果是直接跳转到 视频认证 页面，将 QQ 保存到 session 中
			if(pageCode == "account/videoNotice")
			{
				appUtils.setSStorageInfo("qq",res.im_code);
			}
			appUtils.pageInit("account/msgVerify",pageCode,{});
		}
		else
		{
			appUtils.pageInit("account/msgVerify","account/selDepartment",{});
		}
	}
	
	var msgVerify = {
		"init" : init,
		"bindPageEvent" : bindPageEvent,
		"destroy" : destroy
	};
	
	//暴露接口
	module.exports = msgVerify;
});