/**
* 开户确认（问卷回访）
*/
define("project/scripts/account/openConfirm",function(require,exports,module){
	/* 私有业务模块的全局变量 begin */
	var appUtils = require("appUtils"),
		  service = require("serviceImp").getInstance(), //业务层接口，请求数据
		  global = require("gconfig").global,
		  layerUtils = require("layerUtils"),
		  Map = require("map"),
		  shellPlugin = require("shellPlugin"),
		  fristMap = "",
		  _pageId = "#account_openConfirm";
	/* 私有业务模块的全局变量 end */
		
	function init()
	{
		$(_pageId+" .hf_wjlist dl span").each(function (){
			$(this).removeClass("radio_ckd");
		});
	}
	
	function bindPageEvent()
	{
		/* 问题卷选项绑定提示事件 */
		appUtils.bindEvent(_pageId+"  .hf_wjlist dl span",function(){
			$(this).addClass("radio_ckd").siblings().removeClass("radio_ckd");
		});
		
		/* 提交问卷回访 */
		appUtils.bindEvent($(_pageId+" .com_btn"),function(){
			postQuestionaireData();
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
			getOpenConfirmData();  // 再次获取问卷回访题目
		});
	}
	
	/* 提交问卷回访数据（用户选择答案） */
	function postQuestionaireData()
	{

		var state = false;
		var oneQuestionaireData = "";
		var oneQuestionaireDate_info ="";  
		$(_pageId+" .hf_wjlist dl span").each(function (){
			if(!$(this).hasClass("radio_ckd") && !$(this).siblings().hasClass("radio_ckd"))
			{
				layerUtils.iAlert("亲！您还有题目未答完，请重新选择！");
				state = false;
			}
			else if($(this).hasClass("radio_ckd")){
				oneQuestionaireData += $(this).attr("ans-id")+"_";
				oneQuestionaireDate_info = oneQuestionaireData.substring(0,oneQuestionaireData.length-1); //用于剔除末尾的"_"
				state = true;
			}
		});
		if(state){
			var mobile_no = appUtils.getSStorageInfo("phoneNum");
			var submitParam = {
				"mobile_no":mobile_no,
				"revisited_wj":oneQuestionaireDate_info
			};
			service.submitAnsQustion(submitParam,function(data){
				var errorNo = data.error_no;
				var errorInfo = data.error_info;
				if(errorNo==0)	 // 调用成功,跳转到结果页
				{
					//alert("99999");
					appUtils.pageInit("account/openConfirm","account/accountResult",{});  // 直接跳到结果页
				}
				else
				{
					layerUtils.iAlert(errorInfo, -1);
				}
			});
		}
	}
	
	var questionnaireReturn = {
		"init" : init,
		"bindPageEvent" : bindPageEvent,
		"destroy" : destroy
	};
	
	module.exports = questionnaireReturn;
});