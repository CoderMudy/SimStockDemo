/**
 * 选择营业部
 */
define("project/scripts/account/selDepartment",function(require, exports, module){ 
	/* 私有业务模块的全局变量 begin */
	var appUtils = require("appUtils"),
		   service = require("serviceImp").getInstance(),  //业务层接口，请求数据
	       global = require("gconfig").global,
	       layerUtils = require("layerUtils"),
	       shellPlugin = require("shellPlugin"),
	       areaList = "",  //区域集合
		   branchList = "",  //营业部
		   fareList = "",  //佣金套餐
		   localPro = "",  // 本地省份
		   localCity = "",  // 本地城市
		   localBranch = "",  // 本地营业部
		   branchParam={"branchno" : "", "commission" : "","unit" : "","fare_type":"","remark" :"" ,"has_ttj":""},  //营业部编号,佣金编号，佣金单位,套餐名称,是否勾选天添金
		   client_id = "", //客户经理id
		   econtract_no = "",	//协议编号
		   _pageId = "#account_selDepartment";
	/* 私有业务模块的全局变量 end */
	
	function init()
	{
		initPage();  // 初始化页面
		getAgreement();
	}
	
	/* 获取协议 */
	function getAgreement()
	{
		//调用service查询协议
		service.queryProtocolList({"category_englishname":"tiantianprotcl"},function(data){
			if(data.error_no == 0 && data.results.length != 0)
			{
				protocol = data.results[0];
				// 协议编号
				econtract_no = protocol.econtract_no;
				/* 勾选协议按钮 */
				appUtils.bindEvent($(_pageId+" .com_link"),function(){
					appUtils.pageInit("account/setPwd","account/showProtocol",{"protocol_id" : econtract_no});
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
			getAgreement();  // 再次获取天添金协议
		});
	}
	
	//套餐列表封装
	function showMeal(){
		var fare_type = appUtils.getSStorageInfo("fare_type");
		var meal_str = "";
		var fare = fare_type.split("|");
		for(var i=0;i<fareList.length;i++){
			 var type = fareList[i].fare_type;	//费率类型
			 var remark = fareList[i].remark;	//服务套餐
			 var content = fareList[i].content;	//服务套餐详情描述
			 var fare_rate = fareList[i].fare_rate;	//佣金
			 var unit = fareList[i].unit;	//佣金
			 for(var j=0;j<fare.length;j++){
				 if(fare[j]==type){
					 if(unit * 1000 == 1){
						 unit = "‰" ;
					 }
					 else if(unit * 100 == 1){
						 unit = "%" ;
					 }
					 meal_str +="<a href=\"javascript:void(0);\"  fare_type=\""+type+"\" content =\""+content+"\" fare_rate =\""+fare_rate+"\" unit =\""+unit+"\">"+remark+"<span>（点击看详情）</span></a>";
					 $(_pageId+" .tc_sele .mealList").html(meal_str);
				 }
			 }
		}
		bindServiceMeal();
	}
	
	function bindPageEvent()
	{
		/* 绑定返回 */
		appUtils.bindEvent($(_pageId+" header .back_btn"),function(){
			appUtils.pageBack();
		});
		
		/* 点击页面其他元素隐藏下拉列表 */
		appUtils.bindEvent($(_pageId),function(e){
			$(_pageId+" .sel_list").slideUp("fast");	// 隐藏下拉列表
			e.stopPropagation();	// 阻止冒泡
		});
		
		/* 绑定选择营业部下拉显示所有区域 */
//		appUtils.bindEvent($(_pageId+" .form_item .sel_branch"),function(e){
//			$(_pageId+" .sele_layer").show();
//			$(_pageId+" .dongGuanBranch").hide();    //隐藏东莞地区的营业部
//			$(_pageId+" .otherAreaBranch").hide();  //隐藏其他地区的营业部
//			$(_pageId+" .allArea").slideToggle("fast");	 
//			$(_pageId+" .tc_sele").hide();
//			$(_pageId+" .tc_info").hide();
//			e.stopPropagation();	// 阻止冒泡
//		});
		
		/* 绑定选择服务套餐下拉显示所有套餐 */
		appUtils.bindEvent($(_pageId+" .mt20 .sel_serviceMeal"),function(e){
			var branch_name =$(_pageId+" .form_item .sel_branch").text();
			if(branch_name == "请选择营业部")
			{
				layerUtils.iMsg(-1,"请先选择营业部");
				return false;
			}
			$(_pageId+" .sele_layer").show();
			$(_pageId+" .tc_sele").slideUp("fast");
			$(_pageId+" .tc_sele").show();
			$(_pageId+" .tc_info").hide();	//显示套餐详情
			//隐藏区域显示列表
			$(_pageId+" .allArea").hide();
			$(_pageId+" .dongGuanBranch").hide();
			$(_pageId+" .otherAreaBranch").hide();
			showMeal();
			e.stopPropagation();	// 阻止冒泡
		});	
		
		/* 绑定选此套餐事件 */
		appUtils.bindEvent($(_pageId+" .sele_btnbox .first"),function(e){
			var remark = appUtils.getSStorageInfo("remark");
			$(_pageId+" .mt20 .sel_serviceMeal").html(remark);
			$(_pageId+" .tc_info").hide();	//隐藏套餐详情
			e.stopPropagation();	// 阻止冒泡
		});	
		
		/* 绑定返回套餐事件 */
		appUtils.bindEvent($(_pageId+" .sele_btnbox .backMeal"),function(e){
			$(_pageId+" .tc_info").hide();	//隐藏套餐详情
			$(_pageId+" .tc_sele").show();	//返回到套餐列表
			$(_pageId+" .sel_serviceMeal").text("请选择服务套餐");
			$(_pageId+" .yj_box").html("佣金");
			var fare_type = appUtils.getSStorageInfo("fare_type");
			showMeal();
			e.stopPropagation();	// 阻止冒泡
		});	
		
		/* 绑定下一步 */
		appUtils.bindEvent($(_pageId+" .com_btn"),function(){
			var branch_name =$(_pageId+" .form_item .sel_branch").text();
			var meal_name =$(_pageId+" .mt20 .sel_serviceMeal").text();
			appUtils.setSStorageInfo("branchno",branchParam.branchno);  // 营业部id保存在session
			appUtils.setSStorageInfo("commission",branchParam.commission);  // 佣金保存在session
			appUtils.setSStorageInfo("unit",branchParam.unit);  // 佣金单位保存在session
			appUtils.setSStorageInfo("remark",branchParam.remark);  // 套餐名称保存在session
			if(branch_name == "请选择营业部")
			{
				layerUtils.iMsg(-1,"请先选择营业部");
				return false;
			}
			if(meal_name == "请选择服务套餐")
			{
				layerUtils.iMsg(-1,"请先选择服务套餐");
				return false;
			}
			//是否勾选天添金选项
			if($(_pageId+" .mt50 .chkbox:eq(0)").hasClass("chkbox_ckd")){
				branchParam.has_ttj = 1;
			}
			else{
				branchParam.has_ttj = 0;
			}
			//判断新开户还是转户
			if(appUtils.getSStorageInfo("openChannel") == "new")
			{
				appUtils.pageInit("account/selDepartment","account/uploadPhoto",branchParam);
				appUtils.clearSStorage("idInfo");  // 清除完成身份证上传步骤标记
			}
			else
			{
				appUtils.pageInit("account/selDepartment","account/uploadPhotoChange",branchParam);
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
		
		/* 大市区、镇区拉动效果  */ 
		appUtils.bindEvent($(_pageId+" #cityDiv .dg_selelk, "+_pageId+" #townshipDiv .dg_selelk"),function(e){
			var startY = e.originalEvent.changedTouches[0].clientY;
			appUtils.bindEvent($(this), function(e){
				if(startY-e.originalEvent.changedTouches[0].clientY>30){
					showTown();
				} else if (startY-e.originalEvent.changedTouches[0].clientY<-30){
					showCity();
				}
			},"touchend");
			e.stopPropagation();	// 阻止冒泡
		},"touchstart");
		
		/* 大市区、镇区拉动效果  */ 
		appUtils.bindEvent($(_pageId+" #cityDiv .dg_selelk"),function(e){
			showCity();
			e.stopPropagation();	// 阻止冒泡
		});
		appUtils.bindEvent($(_pageId+" #townshipDiv .dg_selelk"),function(e){
			showTown();
			e.stopPropagation();	// 阻止冒泡
		});
	}
	
	function togglePro(){
		/* 勾选协议按钮 */
		appUtils.bindEvent($(_pageId+" .mt50 .chkbox:eq(0)"),function(){
			if($(this).hasClass("chkbox_ckd")){
				$(this).removeClass("chkbox_ckd");
				$(this).parent().removeClass("com_span");
			}
			else{
				$(this).addClass("chkbox_ckd");
				$(this).parent().addClass("com_span");
			}
		});
	}
	
	function destroy()
	{
		service.destroy();
	}
	
	/* 初始化页面 */
	function initPage()
	{
		cleanPageElement(); // 清理页面元素值
		var Commission = appUtils.getSStorageInfo("commission");  // 用户已选佣金佣金值
		var Branch_no = appUtils.getSStorageInfo("branchno"); // 用户已选营业部id
		var Branch_name = appUtils.getSStorageInfo("branchname");  // 用户已选营业部名称
		var Fare_type = appUtils.getSStorageInfo("fare_type");  // 用户已选佣金类别
		var Unit = appUtils.getSStorageInfo("unit");  // 用户已选佣金单位
		var Remark = appUtils.getSStorageInfo("remark");  // 用户已选套餐名称
		client_id = appUtils.getSStorageInfo("client_id");
//		alert("客户经理id"+client_id);
		var unit = "";
		if(Unit * 1000 == 1){
			 unit = "‰" ;
		}
		else if(Unit * 100 == 1){
			 unit = "%" ;
		}
		getBranch();  // 获取营业部List
//		if(Branch_name)
//		{
//			branchParam.branchno = Branch_no;
//			$(_pageId+" .sel_branch").html(Branch_name);
//			$(_pageId+" .sel_serviceMeal").html(Remark);
//			if(Commission)
//			{
//				branchParam.commission = Commission;
//				var rate_str = "";
//				rate_str += "<span class=\"yj_dataspan right\"><strong>"+ Commission +"</strong> <em>"+unit+"</em></span> 佣金";
//				$(_pageId+" .yj_box").html(rate_str);
//			}
//			getBranch();  // 获取营业部List
//		}
//		else{
//			getBranch();  // 获取营业部List
//		}
	}
	
	
	/* 获取营业部List */
	function getBranch()
	{
		//05070：北京中关村大街证券营业部
		//000870 ：莞太路营业部
		var param = {"recommender_id":client_id};
		service.queryBranch(param,function(data){
//			alert(JSON.stringify(data));
			var error_no = data.error_no;
			var error_info = data.error_info;
			if(error_no=="0")
			{
				areaList = data.regionList;	//区域集合
				branchList = data.branchList; //营业部集合
				fareList = data.fareList;	//佣金集合
				var areaName = "",areaStr = "" ;	 
				for(var i=0;i<areaList.length;i++){
					var areaLength = areaList.length;
					areaName = areaList[i].area;		//所有区域
					areaStr += "<a href=\"javascript:void(0);\">"+areaName+"</a>";
				}
				$(_pageId+" .allArea .sele_list").html(areaStr);
				bindArea(areaName);
			}
			else
			{
				layerUtils.iMsg(-1,"营业部获取失败");  //提示错误信息
			}
		},true,true,handleTimeout);
	}
	
	/* 处理请求超时 */
	function handleTimeout()
	{
		layerUtils.iConfirm("请求超时，是否重新加载？",function(){
			getBranch();  // 再次获取营业部
		});
	}
	
	/* 选中区域事件处理 */
	function bindArea(areaName)
	{
		var branchLength = branchList.length;
		if(client_id !=null && branchLength == 1){
			appUtils.clearSStorage("customer_id");
			//如果客户经理id有返回对应的营业部时，保存在session中
			appUtils.setSStorageInfo("customer_id",client_id);
			var branchno = "";  //营业部编号
			var fare_type = "";	//费率类型
			var branch_name = "";	//营业部名称
		 	for(var i=0; i<branchList.length; i++)
			{
				branchno =  branchList[i].branch_no;
				branchParam.branchno = branchno;
				branch_name = branchList[i].branch_name;
				fare_type = branchList[i].fare_type;
				$(_pageId+" .sel_branch").text(branch_name);	  //选中值赋给选择框
				appUtils.setSStorageInfo("fare_type",fare_type);
			}
		 	$(_pageId+" .form_item .sel_branch").off();
	    }
		else{
			appUtils.setSStorageInfo("customer_id",null);
			/* 绑定选择营业部下拉显示所有区域 */
			appUtils.bindEvent($(_pageId+" .form_item .sel_branch"),function(e){
				$(_pageId+" .sele_layer").show();
				$(_pageId+" .dongGuanBranch").hide();    //隐藏东莞地区的营业部
				$(_pageId+" .otherAreaBranch").hide();  //隐藏其他地区的营业部
				$(_pageId+" .allArea").slideToggle("fast");	 
				$(_pageId+" .tc_sele").hide();
				$(_pageId+" .tc_info").hide();
				e.stopPropagation();	// 阻止冒泡
			});
			
			appUtils.bindEvent($(_pageId+" .allArea .sele_list a"),function(e){
				$(_pageId+" .yj_box").html("佣金");	//清空佣金显示
				$(_pageId+" .allArea").hide();		//隐藏区域显示
				var areaName = $(this).text(); 		//当前选中区域的值
				$(this).addClass("active").siblings().removeClass("active");
				var sel_aname = $(_pageId+" .sel_branch").text();  //上一次选中省份的值
				$(_pageId+" .sel_branch").text(areaName);	  //将选中值赋给选择框
				appUtils.setSStorageInfo("areaName",areaName);
				$(_pageId+" .allArea").slideUp("fast");	//隐藏下拉框
				 //再次点击相同区域,下级菜单不改变，否则重置
				if(areaName != sel_aname)   
				{
					$(_pageId+" .sel_serviceMeal").text("请选择服务套餐");
				}
				var branchno = "";  //营业部编号
				var area = "";	//营业部集合中对应区域
				var branch_name = "";	//营业部名称
				var istown = "";	//判断区域类型
				var branch_citystr = "";
				var branch_constr = "";
				var branch_otherstr = "";
				var show_str = "";
				//判断当前选中的区域与营业部中区域是否匹配
				for(var i=0; i<branchList.length; i++)
				{
					branchno =  branchList[i].branch_no;
					area = branchList[i].area;
					branch_name = branchList[i].branch_name;
					var branchLength = branchList.length;
					istown = branchList[i].istown;
					fare_type = branchList[i].fare_type;
					//匹配则再判断区域是东莞地区还是其他地区
					if(areaName == area)  
					{
						if(areaName == "东莞地区"){
							//显示东莞地区营业部显示div
							$(_pageId+" .dongGuanBranch").show();
							//市区
							if(istown == 0){
								branch_citystr += "<a href=\"javascript:void(0);\" branchId='"+branchno+"' fare_type='"+fare_type+"'>"+branch_name+"</a>";
							}
							else if(istown == 1){
								branch_constr += "<a href=\"javascript:void(0);\" branchId='"+branchno+"' fare_type='"+fare_type+"'>"+branch_name+"</a>";
							}
						}
						else{
							//隐藏东莞地区营业部显示div
							$(_pageId+" .dongGuanBranch").hide();
							//显示其他地区营业部div
							$(_pageId+" .otherAreaBranch").show();
							branch_otherstr +="<a href=\"javascript:void(0);\" branchId='"+branchno+"' fare_type='"+fare_type+"'>"+branch_name+"</a>";
						}
					}
				}
				var area_show = areaName.substr(0,2);
				show_str +="请选择营业部("+area_show+")";
				$(_pageId+" .otherAreaBranch h3").html(show_str);
				$(_pageId+" .dg_seleright .cityBranch").html(branch_citystr);
				$(_pageId+" .dg_seleright .townshipBranch").html(branch_constr);
				$(_pageId+" .otherAreaBranch .yyb_list").html(branch_otherstr);
				e.stopPropagation();	// 阻止冒泡
				bindBranch(" .dg_seleright .cityBranch a");  //点击营业部(东莞大市区)
				bindBranch(" .dg_seleright .townshipBranch a");  //点击营业部(东莞镇区)
				bindBranch(" .otherAreaBranch .yyb_list a");  //点击营业部(其他地区的营业部)
				$(_pageId+" .yj_box").html("佣金<div class=\"mt50 com_span\"><span class=\"chkbox chkbox_ckd\">&nbsp;</span>加入<a class=\"com_link\" href=\"javascript:void(0)\">“天添金”</a>计划，日享12倍活期收益</div>");
				//点击选择营业部改变了“绑定元素”，重新绑定勾选协议和查看协议内容事件
				togglePro();
				getAgreement();
			});
		}
	}
	
	function showTown(){
		//这里避免城镇出现空白，先直接改变高度为269px
		$(_pageId + " #townshipDiv").removeClass("h36");
		$(_pageId + " #townshipDiv").addClass("h269");
		$(_pageId + " #cityDiv").removeClass("h269");
		$(_pageId + " #cityDiv").addClass("h36");
		
		$(_pageId + " #townshipDiv").animate({
			height: "269px"
		}, 1000, function(){
			$(_pageId + " #townshipDiv").removeClass("h36");
			$(_pageId + " #townshipDiv").addClass("h269");
		});
		$(_pageId + " #cityDiv").animate({
			height: "36px"
		}, 1000, function(){
			$(_pageId + " #cityDiv").removeClass("h269");
			$(_pageId + " #cityDiv").addClass("h36");
		});
	}
	
	function showCity(){
		//这里避免城镇出现空白，先不直接改变高度为36px
		$(_pageId + " #cityDiv").removeClass("h36");
		$(_pageId + " #cityDiv").addClass("h269");
		$(_pageId + " #townshipDiv").addClass("h36");
		
		$(_pageId + " #cityDiv").animate({
			height: "269px"
		}, 1000, function(){
			$(_pageId + " #cityDiv").removeClass("h36");
			$(_pageId + " #cityDiv").addClass("h269");
		});
		$(_pageId + " #townshipDiv").animate({
			height: "36px"
		}, 1000, function(){
			$(_pageId + " #townshipDiv").removeClass("h269");
			$(_pageId + " #townshipDiv").addClass("h36");
		});
	}
	
	/* 选中营业部事件绑定 */
	function bindBranch(element)
	{
		appUtils.bindEvent($(_pageId+element),function(e){
			var parentEle = $(this).parent(".yyb_list");
			var aList = parentEle.children("a");
			if(parentEle.hasClass("cityBranch") && aList.index($(this)) == aList.length-1 
				|| parentEle.hasClass("cityBranch") && aList.index($(this)) == 0
				|| parentEle.hasClass("townshipBranch") && aList.index($(this)) == 0
				|| parentEle.hasClass("townshipBranch") && aList.index($(this)) == aList.length-1 ){
				var startY = e.originalEvent.changedTouches[0].clientY;
				appUtils.bindEvent($(this), function(e){
					if(startY-e.originalEvent.changedTouches[0].clientY>30){
						showTown();
					} else if (startY-e.originalEvent.changedTouches[0].clientY<-30){
						showCity();
					}
				},"touchend");
			}
			e.stopPropagation();	// 阻止冒泡
		},"touchstart");
		
		
		appUtils.bindEvent($(_pageId+element),function(e){
			var branchId = $(this).attr("branchId");
			branchParam.branchno = branchId;	
			$(this).addClass("active").siblings().removeClass("active");
			var branch_name = $(this).text();  //当前选择营业部的值
			var sel_branch = $(_pageId+" .sel_branch").text();  //上次选择城市的值
			$(_pageId+" .sel_branch").text(branch_name);	  //选中值赋给选择框
			appUtils.setSStorageInfo("branch_name",branch_name);
			//显示东莞地区的营业部
			if(element == " .dg_seleright .cityBranch a"){
				$(_pageId+" .dongGuanBranch").slideUp("fast");	
			}
			else if(element == " .dg_seleright .townshipBranch a"){
				$(_pageId+" .dongGuanBranch").slideUp("fast");
			}
			else{
				//显示其他地区营业部
				$(_pageId+" .otherAreaBranch").slideUp("fast");
			}
			//再次点击相同城市,下级菜单不改变，否则重置
			if(branch_name != sel_branch)	 
			{
				$(_pageId+" .sel_serviceMeal").text("请选择服务套餐");
			}
			var fare_type = $(this).attr("fare_type");	//费率类型
			branchParam.fare_type = fare_type;
			//每次保存前都清空一下之前的费率
			appUtils.clearSStorage("fare_type");
			appUtils.setSStorageInfo("fare_type",fare_type);
			showMeal();
		});
	}
	
	/* 选中服务套餐事件绑定*/
	function bindServiceMeal()
	{
		appUtils.bindEvent($(_pageId+" .mealList a"),function(e){
			$(_pageId+" .tc_sele").hide();	//隐藏服务套餐列表
			$(_pageId+" .tc_info").show();	//显示套餐详情
			var allText = $(this).text();
			var remark = allText.substr(0,allText.indexOf("（"));
			$(_pageId+" .tc_info h3").html(remark);
			var con = $(this).attr("content");
			var con_str = con.split("|");
			 var con1 = "",
			 	 con2 = "",
			 	 con3 = "",
			 	 con4 = "";
			for(var i=0;i<con_str.length;i++){
				 con1 = con_str[0];
				 con2 = con_str[1];
				 con3 = con_str[2];
				 con4 = con_str[3];
			}
			var rate = $(this).attr("fare_rate");
			var fare_type = $(this).attr("fare_type");
			var unit = $(this).attr("unit");
			var com_unit = ""; 
			if(unit == "‰"){
				com_unit = 0.001;
			}
			else if(unit == "%"){
				com_unit = 0.01;
			}
			branchParam.commission = rate;
			branchParam.unit = com_unit;
			branchParam.fare_type = fare_type;
			branchParam.remark = remark;
			$(_pageId+" .tc_info span:eq(0)").html(con1);
			$(_pageId+" .tc_info span:eq(1)").html(con2);
			$(_pageId+" .tc_info span:eq(2)").html(con3);
			$(_pageId+" .tc_info span:eq(3)").html(con4);
			var rate_str = "";
//			rate_str += "<span class=\"yj_dataspan right\"><strong>"+ rate +"</strong> <em>"+unit+"</em></span>佣金<div class=\"mt50 com_span\"><span class=\"chkbox chkbox_ckd\">&nbsp;</span>加入<a class=\"com_link\" href=\"javascript:void(0)\">“天添金”</a>计划，日享12倍活期收益</div>";
			var customer_id = appUtils.getSStorageInfo("customer_id");
			//当客户经理id为空或者非特殊客户经理id时，显示佣金率加起字
			if(customer_id == null && remark == "投资顾问服务"){
				rate_str += "<span class=\"yj_dataspan right\"><strong>"+ rate +"</strong> <em>"+unit+"起</em></span> 佣金<div class=\"mt50 com_span\"><span class=\"chkbox chkbox_ckd\">&nbsp;</span>加入<a class=\"com_link\" href=\"javascript:void(0)\">“天添金”</a>计划，日享12倍活期收益</div>";
			}
			else{
				rate_str += "<span class=\"yj_dataspan right\"><strong>"+ rate +"</strong> <em>"+unit+"</em></span> 佣金<div class=\"mt50 com_span\"><span class=\"chkbox chkbox_ckd\">&nbsp;</span>加入<a class=\"com_link\" href=\"javascript:void(0)\">“天添金”</a>计划，日享12倍活期收益</div>";	
			}
			$(_pageId+" .yj_box").html(rate_str);
			//点击选择营业部改变了“绑定元素”，重新绑定勾选协议和查看协议内容事件
			togglePro();
			getAgreement();
			appUtils.setSStorageInfo("remark",remark);
		});	
	}
	
	/* 清理界面元素 */
	function cleanPageElement()
	{
		$(_pageId+" .form_item .sel_branch").text("请选择营业部");
		$(_pageId+" .form_item .sel_serviceMeal").text("请选择服务套餐");
		$(_pageId+" .yj_box span strong").text("");
		$(_pageId+" .yj_box").html("佣金<div class=\"mt50 com_span\"><span class=\"chkbox chkbox_ckd\">&nbsp;</span>加入<a class=\"com_link\" href=\"javascript:void(0)\">“天添金”</a>计划，日享12倍活期收益</div>");
		togglePro();
		$(_pageId+" .tc_sele").hide();
		$(_pageId+" .tc_info").hide();
		$(_pageId+" .allArea").hide();
		$(_pageId+" .dongGuanBranch").hide();
	}
	var selDepartment = {
		"init" : init,
		"bindPageEvent" : bindPageEvent,
		"destroy" : destroy
	};
	
	// 暴露对外的接口
	module.exports = selDepartment;
});