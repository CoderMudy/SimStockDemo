//
//  UserAccountPageData.h
//  SimuStock
//
//  Created by Mac on 14-11-3.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

@class HttpRequestCallBack;
@class UserListItem;





/** 帐户数据 */
@interface MatchUserAccountData : JsonRequestObject


/** 总资产 */
@property(copy, nonatomic) NSString *totalAssets;

/** 可用金额 */
@property(copy, nonatomic) NSString *fundBalance;

/** 股票市值 */
@property(copy, nonatomic) NSString *positionValue;

/** 浮动盈亏 */
@property(copy, nonatomic) NSString *floatProfit;

/** 总盈利 */
@property(copy, nonatomic) NSString *totalProfit;

@end

/** 用户股票账号信息 */
@interface UserAccountPageData : JsonRequestObject

/** 总盈利率 */
@property(copy, nonatomic) NSString *profitrate;

/** 总资产 */
@property(copy, nonatomic) NSString *totalAssets;

/** 可用金额 */
@property(copy, nonatomic) NSString *fundBalance;

/** 股票市值 */
@property(copy, nonatomic) NSString *positionValue;

/** 浮动盈亏 */
@property(copy, nonatomic) NSString *floatProfit;

/** 总仓位 */
@property(copy, nonatomic) NSString *positionRate;

/** 总盈利 */
@property(copy, nonatomic) NSString *totalProfit;

/** 持仓数据数组*/
@property(strong, nonatomic) NSMutableArray *postionArray;

/** 用户 */
@property(strong, nonatomic) UserListItem *userListItem;



/** 请求帐户数据 */
+ (void)requestAccountDataWithMatchId:(NSString *)matchId
                         withCallback:(HttpRequestCallBack *)callback;

/** 请求帐户数据 */
+ (void)requestAccountDataWithUserId:(NSString *) uid
                             withMatchId:(NSString *)matchId
                         withCallback:(HttpRequestCallBack *)callback;



@end
