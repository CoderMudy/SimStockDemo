//
//  SimuPageData.h
//  SimuStock
//
//  Created by Mac on 13-8-12.
//  Copyright (c) 2013年 Mac. All rights reserved.
//
//标识controller属性

typedef NS_ENUM(NSUInteger, SimPageDataType) {
  //错误提示页面
  DataPageType_Error_Page,
  //帐户信息，新接口
  DataPageType_Count_info,
  //自动注册页面
  DataPageType_Login_AutoRegist,

  //模拟炒股—帐户数据页面_资产查询
  DataPageType_Simu_Account_Asset,
  //模拟炒股—帐户数据页面_排名
  DataPageType_Simu_Account_Rank,
  //模拟炒股—帐户数据页面_利率曲线
  DataPageType_Simu_Account_ProfitLine,
  //模拟炒股－交易页面－委托
  DataPageType_Simu_Trade_etrust,
  //模拟炒股－交易页面－得到最大可买股票等信息
  DataPageType_Simu_Trade_getMaxStockInfo,

  //我的股友－我的关注
  DataPageType_MyFriend_Attention,
  //我的股友－我的粉丝
  DataPageType_MyFriend_Fans,

  //股友信息－个人粉丝信息查询
  DataPageType_PersonInfo_Fans,

  //自选股－获得我的自选股所有股票代码页面
  DataPageType_SelfStock_getstockCodes,
  //行情－（主页）表格数据
  DataPageType_Market_TableInfo,
  //行情－（个股或者大盘）走势数据页面
  DataPageType_Market_TrendLineInfo,
  //行情－（个股后者大盘）k线数据页面（日k）
  DataPageType_Market_KLineInfo,
  //行情－（个股后者大盘）k线数据页面（周k）
  DataPageType_Market_WeakKLineInfo,
  //行情－（个股后者大盘）k线数据页面（月k）
  DataPageType_Market_MonthKLineInfo,
  //行情－（个股或者大盘）股票信息 （买五卖五等）
  DataPageType_Market_StockInfo,
  //行情－（得到分类股票）信息 （沪a股，深成等）
  DataPageType_Market_GetStockInfo,

  //行情-股票头相关信息（v3.0接口）
  DataPageType_Market_headInfo,
  //行情-资金流向信息数据
  DataPageType_Market_fundlowInfo,

  //商店－追踪卡商店
  DataPageType_Purches_TrackCardInfo,
  //商店－通用商店
  DataPageType_Purches_CommonShopInfo,
  //商店－商店商品列表（钻石商店新接口）
  DataPageType_Purches_DiamondCommonShopInfo,
  //商店－宝箱的用户昵称
  DataPageType_Purches_NickNameInfo,
  //商店－我的宝箱全部商品
  DataPageType_Purches_AllMyProducteInfo,
  //商店－(钻石商城)我的宝箱全部商品
  DataPageType_Purches_DiamondsAllMyProducteInfo,
  //商店－道具使用
  DataPageType_Purches_UseProducteInfo,
  //商店－钻石列表页面
  DataPageType_Purches_DiamondListInfo,
  //炒股牛人-查看持仓
  DataPageType_Rank_PositionInfo,
  //炒股牛人 我的追踪
  DataPageType_StockMaster_MyTraceInfo,
  //炒股牛人 取消追踪
  DataPageType_StockMaster_CancelTracing,
  //炒股牛人 截止日期
  DataPageType_StockMaster_Deadline,
  //搜索股友
  DataPageType_StockMaster_StockFriendSearch,
  //炒股牛人 最大值
  DataPageType_StockMaster_MaxProfitValue,

  //炒股牛人 牛人用户信息
  DataPageType_StockMaster_UserID,
  //个人中心 我的关注
  DataPageType_PersonCenter_MyAttention,
  //个人中心 炒股那些事
  DataPageType_PersonCenter_Tradingstocks,
  //个人中心 我的粉丝
  DataPageType_PersonCenter_MyFans,
  //设置，程序推荐页面
  DataPageType_Set_AppInfo,
  //设置，意见反馈页面
  DataPageType_Set_FeedbackInfo,

  //忘记密码 获取验证码
  DataPageType_ForgetPassword_GetVerifyCode,
  //忘记密码 检验验证码
  DataPageType_Register_CodeVerifiction,

  //手机注册 获取验证码
  DataPageType_Register_GetVerifyCode,
  //手机注册 校验验证码
  // DataPageType_Register_CodeVerifiction,
  //用户注册 普通头像列表
  DataPageType_Register_HeadimageList,
  //三方登录 绑定已有账号
  DataPageType_Logon_BindExistID,
  //三方登录 绑定新账号
  DataPageType_Logon_BindNewID,
  //三方登录 自动登录
  DataPageType_ThirdPartLogon_AutoLogon,

  //登录 头像
  DataPageType_Logon_HeadImage,
  //个人中心 修改密码
  DataPageType_PersonCenter_ChangeNumber,
  //手机注册 设置密码
  DataPageType_Register_SetUpPassword,
  //手机注册 切换到密码输入界面
  DataPageType_PhoneRegister_ChangePage,
  //普通注册 用户名验证
  DataPageType_Register_UserNameAuth,
  //个人信息 是否手机注册
  DataPageType_PersonInfo_IsPhoneRegister,
  //个人信息 显示个人信息
  DataPageType_PersonCenter_ShowMyInfomation,
  //个人信息 生成邀请码
  DataPageType_PersonInfo_NewInviteCode,
  //个人信息 修改个人头像
  DataPageType_PersonCenter_changeUserPic,
  //个人信息 更换手机号
  DataPageType_PersonCenter_ChangePersonNumber,
  //个人信息 解绑手机号
  DataPageType_PersonCenter_UnbindingPhoneNumber,
  //个人信息 绑定手机号
  DataPageType_PersonCenter_BindPhoneNumber,
  //个人信息 三方绑定
  DataPageType_PersonInfo_ThirdPartBinding,
  //个人信息 邀请好友成功列表
  DataPageType_PersonCenter_InviteFriendList,
  //个人主页和TA的主页 交易统计
  DataPageType_Home_TradeStatistics,
  //个人主页和TA的主页 追踪关系
  DataPageType_Home_TrackingRelations,
  //炒股比赛 总列表
  DataPageType_StockMatch_List,
  //广告 比赛banner广告位
  DataPageType_Advertisement_Game,
  //个人主页 分享统计
  DataPageType_ShareStat
};

/*
 *类说明：网络下载数据页面基类
 */
#import <Foundation/Foundation.h>

@interface SimuPageData : NSObject

//请求的url
@property(copy, nonatomic) NSString *url;
//数据下载的时间
@property(strong, nonatomic) NSDate *date;
//数据类型
@property(assign) SimPageDataType pagetype;
//状态码 states
@property(copy, nonatomic) NSString *states;
//错误消息
@property(copy, nonatomic) NSString *message;
//返回值
@property(copy, nonatomic) NSString *result;
//金币数量
@property(copy, nonatomic) NSString *coins;

@end
