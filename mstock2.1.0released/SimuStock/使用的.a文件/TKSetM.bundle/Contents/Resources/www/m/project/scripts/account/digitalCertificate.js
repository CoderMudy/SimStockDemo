/**
* 数字证书
*/
define("project/scripts/account/digitalCertificate",function(require,exports,module){
	/* 私有业务模块的全局变量 begin */
	var appUtils = require("appUtils"),
	    service = require("serviceImp").getInstance(),  //业务层接口，请求数据
		global = require("gconfig").global,
		layerUtils = require("layerUtils"),
		shellPlugin = require("shellPlugin"),
		_pageId = "#account_digitalCertificate",
		cert_type = appUtils.getSStorageInfo("openChannel") == "new" ? "zd" : "tw", // tw:天威 zd:中登
		downloadProgressInterval = null;
	/* 私有业务模块的全局变量 end */
	
	function init()
	{
		layerUtils.iLoading(false);  //证书下载页屏蔽系统等待层
		canvasDraw();
		upload_cert();  //下载安装证书
	}
	
	function canvasDraw(){
		var canvas=document.getElementById("setupProgress");
		var ctx=canvas.getContext("2d");
		
		//画外圆
		ctx.fillStyle="#ddd";
		ctx.beginPath();
		ctx.arc(150,150,50,0,Math.PI*2,true); //Math.PI*2是JS计算方法，是圆
		ctx.closePath();
		ctx.fill();
		//ctx.stroke();
		
		//画内圆
		ctx.beginPath();
		ctx.fillStyle="#f9f9f9";
		ctx.arc(150,150,48,0,Math.PI*2,true); //Math.PI*2是JS计算方法，是圆
		ctx.closePath();
		ctx.fill();
		
		var drawCount,startAngle,endAngle,drawStep=Math.PI*2/100;
			ctx.shadowOffsetX = 0; // 设置水平位移
			ctx.shadowOffsetY = 0; // 设置垂直位移
			ctx.shadowBlur = 10; // 设置模糊度
			counterClockwise = false;
			var drawSpeed = 30;
			var drawInterval = null;
		   
		function startDraw(){
			drawCount = 1;
			startAngle = 0;
			//ctx.strokeStyle ='#'+('00000'+(Math.random()*0x1000000<<0).toString(16)).slice(-6); //圆圈随机颜色                
			//ctx.shadowColor = '#'+('00000'+(Math.random()*0x1000000<<0).toString(16)).slice(-6); //设置随机阴影颜色
			
			ctx.strokeStyle = '#f06868'; //圆圈颜色 
			//ctx.shadowColor = '#f06868'; //设置阴影颜色
		
			drawInterval = setInterval(animation, drawSpeed);
		}
		var animation = function () {  
//			if(drawCount == 56){
//				clearInterval(drawInterval);
//			}
			if (drawCount <= 56) {  
				endAngle = startAngle + drawStep ;  
				drawArc(startAngle, endAngle); 
				startAngle = endAngle;
				drawCount++;  
			} else {
				if(drawInterval != null){
					clearInterval(drawInterval);  
					drawInterval = null;
				}
			}      
		};
		
		var drawArc = function(sa, ea) {
//			//清理中间百分比文字，以中间点为中心，清理4个部分
//			ctx.clearRect(150,150,30,30); //右下
//			ctx.clearRect(150,150,30,-30); //右上
//			ctx.clearRect(150,150,-30,-30); //左上
//			ctx.clearRect(150,150,-30,30); //左下
			
			//画圆弧
			ctx.beginPath();
			ctx.lineWidth = 5.0;
			ctx.arc(150, 150, 49, sa, ea, counterClockwise);
			ctx.closePath();
			ctx.fill();
			ctx.stroke();
			
//			//改写中间进度数
//			ctx.beginPath();
//			ctx.fillStyle = "#f06868";
//			ctx.font = '30px 宋体';
//			ctx.fillText(drawCount+"%", 150-ctx.measureText(drawCount+"%").width/2+5, 150 + 15); //设置文字，并居中
//			ctx.closePath();
//			ctx.fill();
//			ctx.stroke();
			
			//改成span定位赋值显示
			$("#setupProgressTips").html(drawCount);
		}
		startDraw();
	}
	
	function bindPageEvent()
	{
		appUtils.bindEvent($(_pageId+" .cert_down a"),function(e){
			$(_pageId+" .qa_list").slideDown("fast");
			e.stopPropagation();
		});
		
		appUtils.bindEvent($(_pageId),function(e){
			$(_pageId+" .qa_list").slideUp("fast");
			e.stopPropagation();
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
		$(_pageId+" .success").show();
		$(_pageId+" .fail").hide();
		$(_pageId+" .com_btn").hide().html("下一步");
		$(_pageId+" .com_btn").attr("class","com_btn");
		service.destroy();
	}
	
	/*下载证书并安装*/		
	function upload_cert()
	{
		// 下载证书，创建10位随机数
		var createKeyRandom = "1";
		for(var i=0; i<9; i++)
		{
			createKeyRandom += parseInt(Math.random()*10)+"";
		}
		// 证书申请串，数据来源于壳子
		var pkcs10 = "",
			  createKeyParam = {
				"rodam" : createKeyRandom,
				"userId" : appUtils.getSStorageInfo("user_id"),
				"key" : "stockDelegateTradeSys"
			  };
		// 调用壳子的方法生成证书申请串
		require("shellPlugin").callShellMethod("createKeyPlugin",function(data){
			pkcs10 = data.pkcs10;
			// 中登证书
			var param = {
				"user_id" : appUtils.getSStorageInfo("user_id"),
				"pkcs10" : pkcs10,
				"mobile_no" : appUtils.getSStorageInfo("phoneNum")
			};
			// 新开调用中登证书
			if(appUtils.getSStorageInfo("openChannel") == "new")
			{
//				service.queryCompyCart(param,function(data){callcert(data,cert_type)},true,false,handleTimeout);
				var user_param = {"user_id":appUtils.getSStorageInfo("user_id")};
				//模拟视频见证通过
				service.syncQQUserInfo(user_param,function(data){
//					alert("模拟视频见证通过"+JSON.stringify(data));
					var error_no = data.error_no;
					var error_info = data.error_info;
					if(error_no == 0)
					{
						service.queryCompyCart(param,function(data){callcert(data,cert_type)},true,false,handleTimeout);
					}
					else
					{
						layerUtils.iLoading(false);
						layerUtils.iMsg(-1,error_info); 
					}
				}, true,true);
			}
			else if(appUtils.getSStorageInfo("openChannel") == "change")
			{
				service.queryMyselfCart(param,function(data){callcert(data,cert_type)},true,false,handleTimeout);
			}
		},install_failed,createKeyParam);
	}
	
	/* 处理请求超时 */
	function handleTimeout()
	{
		layerUtils.iConfirm("请求超时，是否重新加载？",function(){
			upload_cert();  // 再次下载证书
		});
	}
	
	/* 安装证书回调方法 */
	function callcert(data,cert_type){
//		alert("安装证书回调:"+JSON.stringify(data));
		var error_no = data.error_no;
		var error_info = data.error_info;
		if(error_no == "0" && data.results.length != 0)
		{
			var certParam = {
				// 获取证书的内容
				"content" : data.results[0].p7cert,
				"userId" : appUtils.getSStorageInfo("user_id"),
				"type" : cert_type
			};
			// 壳子读取证书，然后安装证书
			require("shellPlugin").callShellMethod("initZsPlugin",function(data){
				if(data == "OK")
				{
					$(_pageId+" .main:eq(0)").show();
					$(_pageId+" .main:eq(1)").hide();
					var success_str = "<p class=\"spel_red\">证书成功安装</p>";
					$(_pageId+" .success .az_zsbox").html(success_str);
//					$(_pageId+" .order_succes").hide();
					//隐藏canvas进度特效
					$(_pageId+" #setupProgress").hide();
					//隐藏进度
					$(_pageId+" #setupProgressSpan").hide();
					$(_pageId+" .success .mt20").show();
					$(_pageId+" footer:eq(1)").show();
					$(_pageId+" .com_btn").show().html("下一步");
					appUtils.bindEvent($(_pageId+" .com_btn"),function(e){
						appUtils.pageInit("account/digitalCertificate","account/setPwd",{});
					});
				}
				else
				{
					install_failed();
				}
			},install_failed,certParam);
		}
		else
		{
			layerUtils.iLoading(false);
			layerUtils.iAlert(data.error_info,-1);
			install_failed(data.error_info);
		}
	}
	
	/*安装证书失败回调*/
	function install_failed(info)
	{
		$(_pageId+" .main:eq(0)").hide();
		$(_pageId+" .main:eq(1)").show();
		$(_pageId+" .main:eq(1) .az_zsbox p:eq(0)").html(info);
		$(_pageId+" footer:eq(1)").show();
		$(_pageId+" .com_btn").show().html("重新安装");
		$(_pageId+" .cert_down .cert_stat").html("安装失败");
		// 为按钮绑定事件
		appUtils.bindEvent($(_pageId+" .com_btn"),function(){
			destroy();
			upload_cert();
		});
	}
	
	var digitalCertificate = {
		"init" : init,
		"bindPageEvent" : bindPageEvent,
		"destroy" : destroy
	};
	
	module.exports = digitalCertificate;
});