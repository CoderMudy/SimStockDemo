/**
 * 程序入口配置读取
 * 项目开发时需要的自定义配置
 * 另外：configuration为系统配置模块或者配置模板
 * 这里可以扩展，支持多个系统共用一个项目：
 * 思路：在最开始的地方做一个sysCode的获取，然后在这个模块初始化时赋不同系统的configuration配置模块的引用，
 * 当然还要做修改的地方，比如地址栏hash处理，需要增加sysCode（涉及到的模块main和appUtils）
 */
define(function(require, exports, module) {
	var configuration = {
		/**
		 * 平台，不传默认为0：
		 * 0：pc或者手机浏览器、1：android壳子嵌phonegap、2：ios壳子嵌phonegap、3：ios壳子嵌AIR、4：android壳子跳转web、5：ios壳子跳转web
		 */
		"platform": "2",
		"ajaxTimeout": 180,
		"defaultPage": {"pageCode": "account/msgVerify", "jsonParam":{}}, //项目的默认页面
		"guidePage": {"pageCode": "account/guidePage", "jsonParam":{}}, //项目的导航页面
		"firstLoadCss": ["/m/project/css/style.css"], //项目中的需要先加载的css样式文件，如果多个，添加在数组里面
		"layerTheme": "c", //各种弹出层主题样式，默认为系统自带
		/**
		 * 后台返回结果集出参结构，类似errorNo、errorInfo的出参命名定义，
		 * 防止不同项目的后台的出参命名不一致，而框架中写死导致解析出错，可由项目自己定义
		 * 标准命名结构：errorNo、errorInfo，这里只为表示可以自定义，但后台必须统一
		 */
		"resultsParser": {"errorNo": "error_no", "errorInfo": "error_info"},
		/**
		 * 前端根据后台的errorNo做的过滤器配置，需要后台配合定义errorCode，
		 * 有的需要跳转页面，有的只做提示
		 */
		"filters": {
			"-999": {"pageCode": "business/index", "jsonParam": {}} //请重新登录
		},
		//项目中模块的别名配置
		"pAlias": {
			"utils": "project/scripts/common/utils",
	        "domain": "project/scripts/thinkive/domain",
	        "service": "project/scripts/thinkive/service",
	        "serviceImp": "project/scripts/thinkive/base/serviceImp"
		},
		/**
		 * 项目中需要调用到的常量、变量这里配置
		 * 调用方式，通过require("gconfig").global.*来调用
		 */
		"global": {
			"protocol":"ajax", //协议
			"needConfirm":true,  //需要页面上进行用户回访
			"aesKey":88888888,  // 加密串
			"serverUrl":"http://218.104.187.246:8082/",
			"imgServerUrl":"http://218.104.187.246:8082/",			//配置的三方存管图片路径
//			"serverPath": "http://www.thinkive.cn:5053/servlet/json" //开户 -- 公司开户测试环境
//			"serverPath": "http://121.199.41.199:7077/servlet/json" // 开户 -- 公司开户生产环境	
//			"serverPath": "http://192.168.1.22:8010/servlet/json"	// 开户 --东莞手机开户公司测试内网环境
			"serverPath": "http://113.78.134.110:8082/servlet/json"	// 开户 --东莞手机开户测试环境
//			"serverPath": "http://218.104.187.246:8082/servlet/json"	// 开户 --东莞手机开户生产环境
		}
	};
	
	//暴露对外的接口
	module.exports = window.configuration = configuration;
});