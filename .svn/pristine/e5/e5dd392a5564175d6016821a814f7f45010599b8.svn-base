/**
 * 视频见证注意事项
 */
define("project/scripts/account/videoNotice",function(require, exports, module){ 
	/* 私有业务模块的全局变量 begin */
	var appUtils = require("appUtils"),
	      service = require("serviceImp").getInstance(),  //业务层接口，请求数据
		  gconfig = require("gconfig"),
		  global = gconfig.global,
		  layerUtils = require("layerUtils"),
		  shellPlugin = require("shellPlugin"),
		  needVideo = "",
		  steps = ["uploadimg","idconfirm","witness",
		        	 "signagree","certintall","setpwd",
		        	 "risksurvey","tpbank","visitsurvey","success"
  	      ],
		  stepMap = {"uploadimg":"account/uploadPhoto","idconfirm":"account/personInfo","witness":"account/videoNotice",
	               		   "signagree":"account/signCertificateProtocol","certintall":"account/digitalCertificate",
	               		   "setpwd":"account/setPwd","risksurvey":"account/riskAssessment",
	              		   "tpbank":"account/thirdDepository","visitsurvey":"account/openConfirm","success":"account/accountResult"
	      };
	      stepMap0 = {"uploadimg":"account/uploadPhotoChange","witness":"account/digitalCertificate"};
		  _pageId = "#account_videoNotice";
	/* 私有业务模块的全局变量 end */
	
	function init()
	{
		window.videoSuccess = videoSuccess;  // 见证成功
		window.videoFail = videoFail;  // 见证中断
//		window.videoReject = videoReject;  // 见证驳回
	    window.qqApplay = qqApplay;
	    //预约见证
	    window.reserveVideo = reserveVideo;
	    initPage();  // 初始化页面
		getVedioport();  // 获取营业部视频端口
	}
	
	function bindPageEvent()
	{
		/* 绑定返回 */
		appUtils.bindEvent($(_pageId+" header .back_btn"),function(){
			pageBack();
		});
		
//		/* 重新上传照片 */
//		appUtils.bindEvent($(_pageId+" .photo_again"),function(){
//			var param = {
//				user_id : appUtils.getSStorageInfo("user_id"),
//				lastcomplete_step : "0", 
//				opacctkind_flag : ""  
//			};
//			service.queryChangeState(param,function(data){
//				var error_no = data.error_no;
//				var error_info = data.error_info;
//				if(error_no == 0)
//				{
//					appUtils.setSStorageInfo("idInfo","exist");
//					appUtils.pageInit("account/videoNotice","account/uploadPhoto",{});
//				}
//				else
//				{
//					layerUtils.iLoading(false);
//					layerUtils.iMsg(-1,error_info); 
//				}
//			});
//		});
//		
//		/* 重新提交资料 */
//		appUtils.bindEvent($(_pageId+" .info_again"),function(){
//			var Flag = false;
//			var currentStep = appUtils.getSStorageInfo("currentStep");
//			if(currentStep == "uploadimg" || currentStep == null)
//			{
//				Flag = true;
//			}
//			else
//			{
//				Flag = false;
//			}
//			var param = {
//				user_id : appUtils.getSStorageInfo("user_id"),
//				lastcomplete_step : "uploadimg", 
//				opacctkind_flag : ""  
//			};
//			service.queryChangeState(param,function(data){
//				var error_no = data.error_no;
//				var error_info = data.error_info;
//				if(error_no == 0)
//				{
//					pageBack();
//				}
//				else
//				{
//					layerUtils.iLoading(false);
//					layerUtils.iMsg(-1,error_info); 
//				}
//			}, Flag);
//		});
		
		/* 申请QQ预约 */
		appUtils.bindEvent($(_pageId+" .c_link"),function(){
			appUtils.pageInit("account/videoNotice","account/orderQq",{});
		});
		
		/* 在线视频视频见证 */
		appUtils.bindEvent($(_pageId+" .ready"),function(){
//			alert("branchno:"+appUtils.getSStorageInfo("branchno"));
			//判断URL是否为空
			var param = {
				"url":global.serverPath+"?",
				"user_id":appUtils.getSStorageInfo("user_id"),
//	            "user_id":appUtils.getSStorageInfo("serial_no"),
	            "user_name":appUtils.getSStorageInfo("custname"),
	            "org_id":appUtils.getSStorageInfo("branchno"),
	            "jsessionid":appUtils.getSStorageInfo("jsessionid"),
	            "phone":"95328"
	            //"clientinfo":appUtils.getSStorageInfo("clientinfo")
            };
			require("shellPlugin").callShellMethod("videoWitnessPlugin",null,null,param);
		});		
		
//		/* 继续开户 */
//		appUtils.bindEvent($(_pageId+" .ready"),function(){
//			queryQQOfflineState();  // 查询视频通过状态
//		});

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
		// 页面初始化样式重置
		$(_pageId+" .header h3:eq(0)").show();
		$(_pageId+" .header h3:eq(1)").hide();
		$(_pageId+" .error_notice:eq(0)").hide();
		$(_pageId+" .error_notice:eq(1)").hide();
		$(_pageId+" .camera_notice:eq(0)").show();
		$(_pageId+" .camera_notice:eq(1)").hide();
		$(_pageId+" .photo_again").hide();
		$(_pageId+" .info_again").hide();
		$(_pageId+" .c_link").show();
		$(_pageId+" .fix_bot").show();
		$(_pageId+" .fix_bot .ct_btn:eq(0)").show();
		$(_pageId+" .fix_bot .ct_btn:eq(1)").hide();
		service.destroy();
	}
	
	/* 处理返回按钮 */
	function pageBack()
	{
		var currentStep = appUtils.getSStorageInfo("currentStep");
		// 从短信登陆进入(当前完成步骤为：已提交资料)，处理返回按钮
		if(currentStep == "idconfirm")
		{
			appUtils.setSStorageInfo("currentStep","uploadimg");
			appUtils.setSStorageInfo("personInfo","exist");  // 标记完成资料填写步骤
			appUtils.pageInit("account/videoNotice","account/personInfo",{});
		}
		// 从短信登陆进入，在personInfo提交资料后，处理返回按钮
		else if(appUtils.getSStorageInfo("currentStep") == "uploadimg")
		{
			appUtils.setSStorageInfo("personInfo","exist");  // 标记完成资料填写步骤
			appUtils.pageBack();
		}
		// 正常开户流程处理返回按钮
		else
		{
			appUtils.pageBack();
		}
	}
	
	/* 初始化页面 */
	function initPage()
	{
		layerUtils.iLoading(false);  // 关闭等待层。。。
		//处理营业部工作时间与非工作时间的情况
		var tradeTime = 1;
		//营业部工作时间
		if(tradeTime == 1){
			//显示视频见证页面
			$(_pageId+" .jobTimeVideo").show();
			//显示我准备好了按钮
			$(_pageId+" footer:eq(1)").show();
			//隐藏预约视频页面
			$(_pageId+" .notJobTimeVideo").hide();
			$(_pageId+" footer:eq(0)").hide();
		}
		else{
			//显示预约视频页面
			$(_pageId+" .notJobTimeVideo").show();
			$(_pageId+" .jobTimeVideo").hide();
			$(_pageId+" footer:eq(0)").show();
			$(_pageId+" footer:eq(1)").hide();
		}
		needVideo = appUtils.getPageParam("need_video");  
		if(needVideo == 1)
		{
			videoReject();
		}
	}
	
	/* 获取营业部视频端口 */
	function getVedioport()
	{
		//获取营业部视频端口
		var param={
			"branchno":appUtils.getSStorageInfo("branchno"),
			"userid":appUtils.getSStorageInfo("user_id")
		};
		service.queryVideoAddress(param,function(data){
			 if(data.error_no=="0" && data.results.length != 0)
			 {
				appUtils.setSStorageInfo("branch_id",data.results[0].branch_id);
				appUtils.setSStorageInfo("branch_url",data.results[0].url);
				// 如果是从短信验证码页面跳转过来的，从 session 中取 QQ 号并填充
				if(appUtils.getSStorageInfo("_prePageCode") == "account/msgVerify")
				{
					 queryQQOfflineState();  // 查询视频通过状态
				}
			 }
			 else
			 {
				 layerUtils.iMsg(-1,"获取视频服务器IP端口异常");  //提示错误信息
			 }
		 },true,true,handleTimeout);
	}
	
	/* 处理请求超时 */
	function handleTimeout()
	{
		layerUtils.iConfirm("请求超时，是否重新加载？",function(){
			getVedioport();  // 再次获取视频端口
		});
	}
	
	/* 查询离线视频通过状态 */
	function queryQQOfflineState()
	{
//		alert("queryQQOfflineState");
		var lookVedioStateParam = {
			"user_id" : appUtils.getSStorageInfo("user_id")
		};
		service.queryQQOfflineState(lookVedioStateParam,function(data){
//			alert(JSON.stringify(data));
			var error_no = data.error_no;
			var error_info = data.error_info;
			if(error_no == 0 && data.results.length != 0)
			{
				// 视频通过状态，0：未见证、2：已预约离线见证未完成见证、1：视频见证完成、3：见证失败
				// 未见证不需要做处理
				var witnessFlag = data.results[0].witness_flag;
				if(witnessFlag == 1)
				{
//					appUtils.pageInit("account/videoNotice","account/signCertificateProtocol",{});
					var param = {"user_id":appUtils.getSStorageInfo("user_id")};
					//模拟视频见证通过
					service.syncQQUserInfo(param,function(data){
		//				alert(JSON.stringify(data));
						var error_no = data.error_no;
						var error_info = data.error_info;
						if(error_no == 0)
						{
							appUtils.pageInit("account/videoNotice","account/signCertificateProtocol",{});
						}
						else
						{
							layerUtils.iLoading(false);
							layerUtils.iMsg(-1,error_info); 
						}
					}, true,true);
//					layerUtils.iConfirm("您的视频审核已通过，接下来即将为您安装数字证书...", function(){
//						appUtils.pageInit("account/videoNotice","account/digitalCertificate",{});
//					},function(){return false;});
				}
				else if(witnessFlag == 2)
				{
					layerUtils.iAlert("您已预约了视频见证开户服务，请在预约时间或正常服务时间发起视频见证！",0);
				}
				else if(witnessFlag == 3)
				{
					$(_pageId+" .c_link").show();
					$(_pageId+" .fix_bot .ct_btn:eq(0)").show();
					$(_pageId+" .fix_bot .ct_btn:eq(1)").hide();
					layerUtils.iAlert("视频见证失败，请重新申请见证！");
				}
				else if(witnessFlag == 4)
				{
					layerUtils.iAlert("资料审核中，工作人员会尽快给您回复，请耐心等候！");
				}
			}
			else
			{
				layerUtils.iAlert(data.error_info);
			}
		});
	}
	
	//获取当前步骤
	function getCurrentStep(){
		var currentStep = appUtils.getSStorageInfo("currentStep");
		var pageCode = "";
//		alert("当前的步骤："+currentStep);
		if(currentStep && currentStep.length > 0)
		{
			var index = steps.indexOf(currentStep);
			if(index < (steps.length-1))
			{
				currentStep = steps[index + 1];
//				alert("if 1 "+currentStep);
			}
			//获取session中的开户标识
			var opacctkind_flag = appUtils.getSStorageInfo("opacctkind_flag");
//			alert(opacctkind_flag);
			if(opacctkind_flag == "0")
			{
				pageCode = stepMap[currentStep];
//				alert("if 2 pageCode:"+pageCode);
			}
			else
			{
				pageCode = stepMap0[currentStep];
//				alert("else:"+pageCode);
				if(!(pageCode && pageCode.length > 0))
				{
					pageCode = stepMap[currentStep];
				}
			}
		}
		if(pageCode && pageCode.length > 0)
		{
//			alert("最后 if"+pageCode);
			// 如果是直接跳转到 视频认证 页面，将 QQ 保存到 session 中
			if(pageCode == "account/videoNotice")
			{
//				alert("最后 if if");
				appUtils.setSStorageInfo("qq",res.im_code);
			}
			appUtils.pageInit("account/msgVerify",pageCode,{});
		}
	}
	
	/* 重新提交视频  */
	function aginSubmitVideo()
	{
		//调用提交补全资料接口
		var param = {
			"userid" : appUtils.getSStorageInfo("user_id"),
			"fieldname" : "video"  
		};
		//如果视频被驳回
		if(needVideo == 1){
			service.rejectStep(param,function(data){
//				alert(JSON.stringify(data));
				if(data.error_no == 0)
				{
					appUtils.setSStorageInfo("isBack", "backInfo");  //标志重新提交资料成功
					getCurrentStep();
				}
			});
		}
		else{
			layerUtils.iLoading(true);
			var time = null;
			// android 延时 2 秒钟
			if(gconfig.platform == 1)
			{
				time = 2000;
			}
			// ios 延时 50 毫秒
			else if(gconfig.platform == 2 || gconfig.platform == 3)
			{
				time = 50;
			}
			//跳转到设置证书密码界面
			setTimeout(function(){
				layerUtils.iLoading(false);
				appUtils.pageInit("account/videoNotice","account/signCertificateProtocol",{});
			},time);
		}
	}
	
	/* 见证通过 */
	function videoSuccess()
	{
		aginSubmitVideo();
		queryQQOfflineState();  // 查询视频通过状态
	}
	
	/* 见证不通过 */
	function videoFail(){}
	
	/* 见证被驳回 */
	function videoReject()
	{
		$(_pageId+" header h2:eq(0)").hide();
		$(_pageId+" header h2:eq(1)").show();
		$(_pageId+" footer:eq(1)").show();
		$(_pageId+" footer:eq(1) a").html("重新进行视频见证");
	}
	
	/* QQ预约 */
	function qqApplay()
	{
		appUtils.pageInit("account/videoNotice","account/orderQq",{});
	}
	
	/* 预约见证  */
	function reserveVideo()
	{
		appUtils.pageInit("account/videoNotice","account/orderQq",{});
	}
	
	var videoNotice = {
		"init" : init,
		"bindPageEvent" : bindPageEvent,
		"pageBack" : pageBack,
		"destroy" : destroy
	};
	
	// 暴露对外的接口
	module.exports = videoNotice;
});