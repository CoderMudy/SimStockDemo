/**  */
/**   HomeUserInformationData.h */
/**   SimuStock */
/**  */
/**   Created by Mac on 14-10-30. */
/**   Copyright (c) 2014年 Mac. All rights reserved. */
/**  */

#import "BaseRequestObject.h"

@class UserListItem;
@class HttpRequestCallBack;

/*
 *类说明：主页 查询用户账户信息显示数据
 */
@interface HomeUserInformationData : JsonRequestObject
/** 用户id */
@property(nonatomic, copy) NSString *userid;

/** 用户昵称 */
@property(nonatomic, copy) NSString *nickName;

/** 持仓数 */
@property(nonatomic, copy) NSString *positionNum;

/** 关注数 */
@property(nonatomic, copy) NSString *followNum;

/** 粉丝数 */
@property(nonatomic, copy) NSString *fansNum;

/** 用户头像 */
@property(nonatomic, copy) NSString *headPic;

/** 个人签名 */
@property(nonatomic, copy) NSString *signature;

/** 优顾认证签名 */
@property(nonatomic, copy) NSString *certifySignature;

/** 浮动盈亏 */
@property(nonatomic, copy) NSString *fdyk;

/** 持股市值 */
@property(nonatomic, copy) NSString *cgsz;

/** 总盈利率 */
@property(nonatomic, copy) NSString *profitRate;

/** 资余额 */
@property(nonatomic, copy) NSString *balance;

/** 总资产 */
@property(nonatomic, copy) NSString *totalAssets;

/** 总盈利(资金) */
@property(nonatomic, copy) NSString *totalProfit;

/** 追踪数 */
@property(nonatomic, assign) NSInteger attention;
/** 是否购买牛人计划 */
@property(nonatomic, assign) NSInteger isShowSuper;

/** 是否关注0-否, 1-是 */
@property(nonatomic, copy) NSString *traceNum;

/** 交易数 */
@property(nonatomic, assign) NSInteger tradeNum;

/** 聊股数 */
@property(nonatomic, copy) NSString *stockNum;

/**用户等级*/
@property(nonatomic, copy) NSString *vipType;

/**优顾认证*/
@property(nonatomic, copy) NSString *vType;
/**牛人计划id*/
@property(nonatomic, copy) NSString *accountId;

/** 用户评级数据 */
@property(nonatomic, strong) UserListItem *userListItem;

/** 请求用户主页中用户信息 */
+ (void)requestUserInfoWithUid:(NSString *)uid
                  withCallback:(HttpRequestCallBack *)callback;
@end
