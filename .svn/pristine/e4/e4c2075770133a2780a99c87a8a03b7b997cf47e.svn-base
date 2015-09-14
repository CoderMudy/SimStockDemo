//
//  SimuConst.h
//  SimuStock
//
//  Created by Mac on 13-8-7.
//  Copyright (c) 2013骞� Mac. All rights reserved.
// 123

//
#import <Foundation/Foundation.h>

#pragma mark
#pragma mark 判断类宏定义
//判断是否 iphone 5 设备
#define iPhone5                                                                                    \
  ([UIScreen instancesRespondToSelector:@selector(currentMode)]                                    \
       ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)        \
       : NO)
/**
 * System Versioning Preprocessor Macros
 * usage: if (SYSTEM_VERSION_LESS_THAN(@"4.0")){}
 */
#define SYSTEM_VERSION_EQUAL_TO(v)                                                                 \
  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)                                                             \
  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)                                                 \
  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                                                                \
  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)                                                    \
  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#pragma mark
#pragma mark 消息宏定义
//页面类互动事件消息
#define SYS_VAR_NAME_DOACTION_MSG @"SYS_DOACTION_MSG"
//搜索页弹出事件消息(普通搜索)
#define SYS_VAR_NAME_SHOWSEARCHVIEW_MSG @"SYS_SIEW_MSG"
//搜索页弹出事件消息(持仓搜索)
#define SYS_VAR_NAME_SHOWSEARCHHOLDSTOCKVIEW_MSG @"SYS_LDSTOCKVIEW_MSG"
//搜索页设置当前持仓页面比赛id
#define SYS_VAR_NAME_SetMarchID_MSG @"SYS_VAR_NAME_SetMarchID_MSG"
//搜索页面弹出时间消息(买入搜索)
#define SYS_VAR_NAME_SHOWSEARCHBUYSTOCKVIEW_MSG @"SYS_BUYSTOCKVIEW_MSG"

//搜索页面点击取消按钮隐藏
#define SYS_VAR_NAME_HIDESEARCHVIEW_CANCEL_MSG @"SYS_VAR_NAME_HIDESEARCHVIEW_CANCEL_MSG"
//显示浮动窗消息
#define SYS_VAR_NAME_SHOWFLOATVIWE_MSG @"SYS_VAR_NAME_SHOWFLOATVIWE_MSG"
//注册展示消息
#define SYS_VAR_NAME_SHOWLITTLEMESSAGE_MSG @"SYS_VAR_NAME_SHOWLITTLEMESSAGE_MSG"
//显示主界面_模拟炒股页LQ
#define SHOW_SIMUSTOCK_VIEW @"showSimuStockView"
//行情主界面定时器刷新
#define MARKET_HOME_TIMER @"marketHomeTimer"
//行情二级界面定时器刷新
#define MARKET_LIST_TIMER @"marketListTimer"

#pragma mark
#pragma mark 事件代码宏定义
//当前展示页面全屏展示
#define AC_ViewMove_ToFull @"Action_Code_ViewMove_Full"
//当前展示页面半屏展示
#define AC_ViewMove_ToHalf @"Action_Code_ViewMove_Half"
//更新用户的资产，收益率，图片等信息
#define AC_UpDate_UserInfo @"Action_Code_UpDate_UserInfo"

//个人中心页面展示
#define AC_ShowView_personCenter @"AC_ShowView_personCenter"

//非法登录 退出(lq)
#define Illegal_Logon_SimuStock @"illegal_Logon"
//实盘交易非法登录
#define illegal_Logon_realtrade @"illegal_logon_for_realtrade"

//主页面联网，取得某重要信息
#define UpDataFromNet_WithMainController @"UpDataFromNet_WithMainController"
//搜索纪录本地数据库
#define AC_SearchHistry_StockItem @"AC_SearchHistry_StockItem"
//持仓股票（可卖）
#define AC_PositionStockCodes @"AC_PositionStockCodes"

//自己持仓标记
#define Their_positions @"Their_positions"

//行情页刷新
#define Timer_Refresh @"Timer_Refresh"

//用户头像

#pragma mark
#pragma mark 常用句丙宏定义
#define WINDOW [[[UIApplication sharedApplication] delegate] window]

#define CONTROLER [(AppDelegate *)[[UIApplication sharedApplication] delegate] viewController]

#pragma mark
#pragma mark 全局变量ce
extern NSMutableDictionary *sysConfig; //存储系统变量的动态数组

//#pragma mark
//#pragma mark 网络访问相关常量宏定义

#define push_address @"http://192.168.1.92/"
#define user_address @"http://192.168.1.92/"
#define mall_address @"http://192.168.1.92/"
#define pay_address @"http://192.168.1.92/"
#define game_address @"http://192.168.1.92/"
#define stat_address @"http://192.168.1.92/"
#define wap_address @"http://192.168.1.92"
#define istock_address @"http://192.168.1.92/"
#define push_address @"http://192.168.1.92/"
#define data_address @"http://192.168.1.92/"
#define sharesWeb_address @"http://192.168.1.22:7073/"
#define market_address @"http://192.168.1.92/"
#define TEST_NET_STATUS_HOST @"192.168.1.92"
#define URL_address @"http://192.168.1.22:7073/resource/f10html/"
#define adData_address @"http://192.168.1.92/"

///配资需要添加https的接口
#define WF_Account_Address @"https://192.168.1.92/stockFinWeb/account"
#define WF_Trade_Address @"https://192.168.1.92/stockFinWeb/trade"
#define WF_Contract_Address @"https://192.168.1.92/stockFinWeb/contract"

///配资需要添加http的接口
#define WF_Other_User_Address @"http://192.168.1.92/jhss"
#define With_Capital_address @"http://192.168.1.92/"
#define WF_Payment_Address @"http://192.168.1.92/payment/"

//开户券商对应公网接口
#define brokerage_Account_List @"http://192.168.1.92/"
//
/// 牛人计划http的接口地址
#define CP_YieldCurve_Address @"http://192.168.1.92/"
#define CP_SuperTradeAction_Address @"http://192.168.1.92/"
///高校比赛用途列表
#define school_match_uses @"http://192.168.1.92/"
/** 比赛web端URL */
#define scholl_web_url @"http://test.youguu.com/"

//王东
//石磊主机
// 192.168.1.190:8888
//#define user_address @"http://192.168.1.190:8888/"
//#define data_address @"http://192.168.1.190:8888/"

//#define push_address @"http://bind.youguu.com/"
//#define data_address @"http://mncg.youguu.com/"
//#define user_address @"http://user.youguu.com/"
//#define mall_address @"http://pay.youguu.com/"
//#define pay_address @"http://pay.youguu.com/"
//#define stat_address @"http://log.youguu.com/"
//#define wap_address @"http://m.youguu.com"
//#define istock_address @"http://istock.youguu.com/"
//#define sharesWeb_address @"http://quote.youguu.com/"
//#define market_address @"http://quote.youguu.com/"
//#define TEST_NET_STATUS_HOST @"mncg.youguu.com"
//#define URL_address @"http://quote.youguu.com/resource/f10html/"
//#define adData_address @"http://asteroid.youguu.com/"
//#define game_address @"http://mncg.youguu.com/"
//
/////配资需要添加https的接口
//#define WF_Account_Address @"https://peizi.youguu.com/stockFinWeb/account"
//#define WF_Trade_Address @"https://peizi.youguu.com/stockFinWeb/trade"
//#define WF_Contract_Address @"https://peizi.youguu.com/stockFinWeb/contract"
//
/////配资需要添加http的接口
//#define WF_Other_User_Address @"http://user.youguu.com/jhss"
//#define With_Capital_address @"http://peizi.youguu.com/"
//#define WF_Payment_Address @"http://payment.youguu.com/payment/"
//
////开户券商对应公网接口
//#define brokerage_Account_List @"http://asteroid.youguu.com/"
//
///// 牛人计划http的接口地址
//#define CP_YieldCurve_Address @"http://192.168.1.92/"
//#define CP_SuperTradeAction_Address @"http://192.168.1.92/"
/////高校比赛用途列表接口地址
//#define school_match_uses @"http://mncg.youguu.com/"
///** 比赛web端URL */
//#define scholl_web_url @"http://m.youguu.com/"

//--******--//
#define shareWeb_address @"http://www.youguu.com/opms/fragment/html/shareInvite.html?code="
//////交易规则WEB页链接
#define Trading_Rules @"http://www.youguu.com/protocol/tradeRule.html"
//设定友盟渠道号码 默认空为苹果商店
#define Ument_channelId @""

//默认用户id
//#define userID @"7028"
//会话id
#define simu_sid @"-1"
//比赛id
#define MATCHID @"1"
//日志上传时间
#define Log_UpTime @"log_uptime_flage"

///身份认证信息
#define Defaut_UserCertName @"UserCertName"
///身份证信息
#define Defaut_UserCertNO @"UserCertNO"
//默认用户id
#define Defaut_UserID @"USER_ID"
#define Defaut_YouGu_UserID @"YouGu_USER_ID"
///恒生id
#define Defaut_HsUserId @"hsUserId"
//默认用户密码
#define Default_UserPassword @"USER_PASSWORD"
//会话id
#define Defaut_Sid @"USER_SESSIONID"
//比赛选择高校列表
#define Defaut_Match_University_Version @"UniversityList_Version"

//行情刷新时间
#define REFRESH_TIME_ROW @"REFRESH_TIME_ROW"

///配资资金池判断通知
#define RefrashCapitalTotalAmountView @"RefrashCapitalTotalAmountView"

#define UploadingSuccess @"uploadingSuccess"
//通知登录成功
#define NotifactionLoginSuccess @"NotifactionLoginSuccess"
//首次设置自选股KEY
#define SelfStock_TaskId @"SelfStock_TaskId"
//首次分享KEY
#define FirstShare_TaskId @"FirstShare_TaskId"
//完善个人资料KEY
#define PersonalInfo_TaskId @"PersonalInfo_TaskId"
//首次关注他人
#define FirstAttention_TaskId @"FirstAttention_TaskId"

//首次设置股价预警KEY
#define SelfStockAlarm_TaskId @"SelfStockAlarm_TaskId"
//股价预警KEY
#define SelfStockAlarm_MyStockCode @"SelfStockAlarm_MyStockCode"
// lqUmengAppKey
#define UMENG_APPKEY @"5310370656240be15001ba2f"

#pragma mark
#pragma mark 其他红定义
//对输入字符判断
#define kAlphaNum @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

#pragma amrk
#pragma mark 常用颜色和字体高度定义

//切换模拟炒股页面
#define ROOT_VIEW_CONTROLLER                                                                       \
  [(AppDelegate *)[[UIApplication sharedApplication] delegate] viewController]
#define DELEGATE (AppDelegate *)[[UIApplication sharedApplication] delegate]

/*
 *字体定义
 */
//字体
#define FONT_ARIAL @"Arial"

//字体高度
#define Font_Height_25_0 25.0f
#define Font_Height_21_0 21.0f
#define Font_Height_20_0 20.0f
#define Font_Height_19_0 19.0f
#define Font_Height_18_0 18.0f
#define Font_Height_17_0 17.0f
#define Font_Height_16_0 16.0f
#define Font_Height_15_0 15.0f
#define Font_Height_14_0 14.0f
#define Font_Height_13_0 13.0f
#define Font_Height_12_0 12.0f
#define Font_Height_11_0 11.0f
#define Font_Height_10_0 10.0f
#define Font_Height_09_0 9.0f
#define Font_Height_08_0 8.0f

/*
 *颜色定义
 */
#define Color_White @"#FFFFFF"               //白色
#define Color_Black @"#000000"               //黑色
#define Color_Little_Black @"#161616"        //浅黑色
#define Color_YELLOW_VIP @"#FABE00"          //黄色
#define Color_Dark @"#2F2E2E"                //深色
#define Color_Gray @"#939393"                //中灰色，提示文字颜色
#define Color_Cube @"#8D8E93"                //深灰色，股聊更多···
#define COLOR_SIGNATURE @"#A8A8A8"           //主页签名灰色
#define Color_Light @"#ACACAC"               //浅色
#define Color_Red @"#f61f1f"                 //红色（涨）
#define Color_Green @"#359301"               //绿色（跌）
#define Color_Yellow @"#f5a60d"              //黄色（跌）
#define Color_Table_Title @"#222222"         //表格标题文字颜色
#define Color_Blue_Profit @"#0083d1"         //蓝色主页盈利区域文字颜色
#define Color_Blue_but @"#086dae"            //蓝色按钮色值
#define Color_Gray_but @"#B9B9B9"            //深灰按钮按色值
#define Color_Gray_butDown @"#83888B"        //深灰按钮按下色值
#define Color_Blue_butDown @"#055081"        //蓝色按钮按下色值
#define Color_yellow_but @"#ffa10e"          //黄色按钮色值
#define Color_yellow_butDown @"#d18501"      //黄色按钮按下色值
#define Color_BG_Table_Title @"#e1e3e8"      //表格标题背景色
#define Color_BG_Common @"#f7f7f7"           //通用背景色
#define Color_Text_Common @"#454545"         //通用文字颜色
#define Color_Cell_Line @"#e3e3e3"           //表格底边浅灰色
#define Color_Border @"#d7d7d7"              //像素描边颜色
#define Color_Botom_Gray @"#393939"          //底部按钮灰颜色
#define Color_Botom_Red @"#c7292D"           //底部按钮红颜色
#define Color_Stock_Code @"#ff8400"          //股票代码通用颜色
#define Color_Black_Stock_Price @"#343434"   //正确股票价格字体颜色
#define Color_Red_Stock_Price @"#d70000"     //错误股票价格字体颜色
#define Color_Icon_Title @"#5A5A5A"          //首页模块的标题颜色
#define Color_Pressed_Gray @"#E8E8E8"        //按钮按下灰色背景
#define Color_StockInfo_Name @"#818181"      //行情分时页面，个股报价名称字段颜色
#define Color_Circle @"#CBCBCB"              // DDPageConrol点
#define Color_Gray_Edge @"#D3D3D3"           //股聊logo描边
#define Color_Publish @"#05F4F7"             //聊股发表按钮文字颜色
#define Color_ReplyBubble @"#EAEAEA"         //回复框气泡颜色
#define Color_AlwaysTemplate @"#007AFF"      //单图标的蓝色高亮
#define Color_SeparatorLeft @"#3D7199"       //拓展按钮左侧竖线
#define Color_SeparatorRight @"#275477"      //拓展按钮右侧竖线
#define Color_PraiseRed @"#F36C6C"           //赞数字红色
#define Color_NormalBackground @"#87C8f1"    //聊股吧默认背景
#define Color_TooltipCancelButton @"#AFB3B5" //微博提示框取消按钮背景色
#define Color_TooltipSureButton @"#31BCE9"   //微博提示框确定按钮背景色
#define Color_WeiboButtonPressDown @"#D9D9D9" //分享、评论、赞按钮按下态颜色，cell选中颜色
#define Color_TRACK_BUTTON_BORDER @"#AEAEAE" //主页追踪按钮边框
#define Color_Text_Details @"#5a5a5a" //确认支付、账户充值、资金明细等显示金额的颜色
#define Color_WFOrange_btn @"#FD8418"     //配资橘黄色按钮按色值
#define Color_WFOrange_btnDown @"#de6402" //配资橘黄色按钮按下色值
#define COLOR_KLINE_BORDER @"#CAD2D8"     // K线边框颜色
#define COLOR_KLINE_SEPARATOR @"#DEE1E2"  // K线分割线
#define COLOR_AVERAGE_LINE @"#F4CB71"     // k线均线
#define COLOR_DARK_BLUE @"#146DAE"        //深蓝色
#define COLOR_MA_BLUE @"#00ACE5"          // MA蓝
#define COLOR_MA_ORANGE @"#D98500"        // MA橙
#define COLOR_MA_PURPLE @"#C32EC3"        // MA紫
#define COLOR_MA_GREEN @"#35CE00"         // MA绿
#define COLOR_MA_MAGENTA @"#FF3E6B"       // MA品红
#define COLOR_COW_BEAR_RED @"#F16F6F"     //牛熊比红
#define COLOR_GRAY_PURPLE @"#CCCDE7"      //资金流向 浅紫
#define COLOR_INDICATOR_LINE @"#4691C1"   // k线指标线颜色，深蓝色
#define COLOR_KLINE_INFO_TITLE @"#818181" // K线信息标题颜色，比如成交、时间
//随机色
#define COLOR_RANDOM                                                                               \
  [UIColor colorWithRed:random() % 255 / 255.f                                                     \
                  green:random() % 255 / 255.f                                                     \
                   blue:random() % 255 / 255.f                                                     \
                  alpha:1]

#define IS_IPHONE_5                                                                                \
  (fabs((double)[[UIScreen mainScreen] bounds].size.height - (float)568) < DBL_EPSILON)

//公用字符串常量
#define REQUEST_FAILED_MESSAGE @"您当前网络不给力哦" //有网络，但是网络异常

#define INPUT_ERROR_STOCK_PRICE @"请输入正确价格"

#define ALERT_STOCK_PRICE_ZERO @"最新价为0，无法设置提醒"
#define ALERT_STOCK_NOT_GER_TREND_DATA @"没有获取到行情数据，无法设置提醒"

#define ALERT_STOCK_PRICE_SET_SUCCESS @"此股票预警设置成功"

//个人主页表头
#define Notification_FansNum_Reduce @"Notification_FansNum_Reduce"
#define Notification_FansNum_Add @"Notification_FansNum_Add"

/// topToolBar统一高度 原先的高度 35.0f  现在 39.0f
static const CGFloat TOP_TABBAR_HEIGHT = 35.0f;

//侧滑最大长度
#define MAX_SIDESLIP_WIDTH WIDTH_OF_SCREEN * .75f
//上蓝色导航栏高度 原先高度 = 43.5f 现在改变后的高度 = 52.0f
#define NAVIGATION_VIEW_HEIGHT 43.5f
//上工具栏高度
#define TOP_TOOL_BAR_HEIGHT 35.5f
//下工具栏高度
#define BOTTOM_TOOL_BAR_HEIGHT 43.5f
//根据系统获得状态栏高度
#define HEIGHT_0F_STATUSBAR                                                                        \
  (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) ? 20.0f : 0.0f)
//根据系统取导航栏高度
#define HEIGHT_OF_NAVIGATIONBAR                                                                    \
  (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) ? 63.5f : 43.5f)
//买入股票的cell高度
#define HEIGHT_OF_BUY_CELL 53.0f
//卖出股票的cell高度
#define HEIGHT_OF_SELL_CELL 45.0f
//所有cell的底线粗细（灰色或白色，非两线相加的粗细）
#define HEIGHT_OF_BOTTOM_LINE 0.5f //底线宽度
// ViewController横向宽度
#define WIDTH_OF_VIEWCONTROLLER self.view.bounds.size.width
// ViewController纵向宽度
#define HEIGHT_OF_VIEWCONTROLLER self.view.bounds.size.height
// view的横向宽度
#define WIDTH_OF_VIEW self.bounds.size.width
// view的纵向高度
#define HEIGHT_OF_VIEW self.bounds.size.height
// screen的宽度
#define WIDTH_OF_SCREEN [[UIScreen mainScreen] bounds].size.width
// screen的高度
#define HEIGHT_OF_SCREEN [[UIScreen mainScreen] bounds].size.height
//主页statusBar+NavigationBar高度
#define HEIGHT_OF_STATUS_AND_NAVIGATION                                                            \
  (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) ? 63.5f : 43.5f) // 127 107
//主页tabbar高度
#define HEIGHT_OF_TABBAR 41.5f // 83
#define LongPressTime 0.5f
#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define ios7VERSION (SYSTEM_VERSION > 7.0 ? YES : NO)
//用户拒绝升级的版本
#define REJECTVERSION @"rejectVersion"
//服务器新版本检测
#define NEWVERSION @"NEWVERSION"

//聊股吧回复框宽度
#define WBReplyViewWidth 267.0f

//随机色
#define RANDOM_COLOR_WITH_ALPHA(ALPHA)                                                             \
  [UIColor colorWithRed:rand() % 255 / 255.0f                                                      \
                  green:rand() % 255 / 255.0f                                                      \
                   blue:rand() % 255 / 255.0f                                                      \
                  alpha:ALPHA]

//屏幕宽度比率
#define RATIO_OF_SCREEN_WIDTH (WIDTH_OF_SCREEN / 320.f)
//废弃方法
//#define DEPRECATED_METHOD NS_DEPRECATED_IOS(3_0,6_0)

///登录成功
static NSString *const LogonSuccess = @"logonSuccess";
///退出登录
static NSString *const LogoutSuccess = @"logoutSuccess";
///用户未读数据个数刷新
static NSString *const MessageCenterNotification = @"EvenIfTheUpdate";
///未登录，点击要不要侧滑
static NSString *const WFLogonNotification = @"WFLogonNotification";
///左侧栏显示总盈利的通知，账户持仓主页绑定总盈利时发送此通知
static NSString *const AccountTotalProfitNotification = @"AccountTotalProfitNotification";
///分享微博成功的通知
static NSString *const ShareWeiboSuccessNotification = @"ShareWeiboSuccessNotification";
///收藏微博成功的通知
static NSString *const CollectWeiboSuccessNotification = @"CollectWeiboSuccessNotification";
///赞微博成功的通知
static NSString *const PraiseWeiboSuccessNotification = @"PraiseWeiboSuccessNotification";
///评论微博成功的通知
static NSString *const CommentWeiboSuccessNotification = @"CommentWeiboSuccessNotification";
///追踪变化通知
static NSString *const TraceChangeNotification = @"TraceChangeNotification";
///股吧聊股总数变化通知
static NSString *const StockBarWeiboSumChangeNotification = @"StockBarWeiboSumChangeNotification";
///我的股吧数发生变化
static NSString *const MyStockBarsChangeNotification = @"MyStockBarsChangeNotification";
///隐藏、显示横屏segment通知
static NSString *const LandscapeSegmentShouldHideNotification =
    @"LandscapeSegmentShouldHideNotification";
///退出横屏k线视图通知
static NSString *const LandscapeVCExitNotification = @"LandscapeVCExitNotification";
///趋势图刷新通知
static NSString *const LandscapeTrendDataNotification = @"LandscapeTrendDataNotification";
///交易明细通知
static NSString *const LandscapeStockDetailDataNotification =
    @"LandscapeStockDetailDataNotification";
/// k线数据通知
static NSString *const LandscapeStockKLineDataNotification = @"LandscapeStockKLineDataNotification";
