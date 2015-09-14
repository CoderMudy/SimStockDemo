//
//  NewOnlineInfoData.h
//  SimuStock
//
//  Created by Jhss on 15/6/30.
//  Copyright (c) 2015年 Mac. All rights reserved.
//
/** 全新上线计划列表 返回参数 */
#import <Foundation/Foundation.h>
#import "JsonFormatRequester.h"
#import "UserListItem.h"

/** 返回参数 */
@interface NewOnlineInfoItem : JsonRequestObject <Collectionable>
///计划列表
@property(strong, nonatomic) NSMutableArray *dataArray;

/** 全新上线计划列表 */
+ (void)newOnlinePlanListRequest:(NSDictionary *)dic
                    withCallback:(HttpRequestCallBack *)callback;
/** 购买牛人计划 */
+ (void)newOnlinePlanOpenTraceWithAccountId:(NSString *)accountId
                              withTargetUid:(NSString *)targetUid
                               withCallback:(HttpRequestCallBack *)callback;

@end

@interface NewOnlineInfoData : BaseRequestObject2 <ParseJson>

/** 计划名称 */
@property(nonatomic, strong) NSString *name;
/** 目标收益 */
@property(nonatomic, strong) NSString *goalProfit;
/** 止损线 */
@property(nonatomic, strong) NSString *stopLossLine;
/** 购买价格 */
@property(nonatomic, strong) NSString *price;
/** 牛人计划ID */
@property(nonatomic, strong) NSString *accountId;
/** 购买状态 1：已购买 ，0：可购买， 2：售完  */
@property(nonatomic, strong) NSString *buystatus;
/** 购买截至时间 */
@property(nonatomic, strong) NSString *buyStopTime;
/** 购买人数 */
@property(nonatomic, strong) NSString *buyerCount;
/** 购买上限 */
@property(nonatomic, strong) NSString *buyerLimit;
/** 介绍 */
@property(nonatomic, strong) NSString *slogan;
/** 计划期限（月） */
@property(nonatomic, strong) NSString *goalMonths;
/** 盈利 */
@property(nonatomic, strong) NSString *profit;
/** 运行天数 */
@property(nonatomic, strong) NSString *runDay;
/** 用户ID */
@property(nonatomic, strong) NSString *uid;
/** 用户头像 */
@property(nonatomic, strong) NSString *head_pic;

/** 用户评级数据 */
@property(nonatomic, strong) UserListItem *userListItem;

@end
