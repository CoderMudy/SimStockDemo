//
//  HotRunInfoItem.h
//  SimuStock
//
//  Created by Jhss on 15/7/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonFormatRequester.h"

@interface HotRunInfoItem : BaseRequestObject2 <ParseJson>

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
@property(nonatomic, strong) NSString *desc;
/** 计划期限（月） */
@property(nonatomic, strong) NSString *goalMonths;
/** 盈利 */
@property(nonatomic, strong) NSString *profit;
/** 运行天数 */
@property(nonatomic, strong) NSString *runDay;
/** 计划开始时间 */
//@property(nonatomic, strong) NSString *startTime;
/** 状态 4 达标   5未达标 */
@property(nonatomic, strong) NSString *status;
/** 用户ID */
@property(nonatomic, strong) NSString *uid;

/** 盈利率 */
@property(nonatomic, strong) NSString *profitRate;

@end

/** 返回参数 */
@interface HotRunInfoDataRequest : JsonRequestObject <Collectionable>
///计划列表
@property(strong, nonatomic) NSMutableArray *dataArray;

/** 全新上线计划列表 */
+ (void)hotRunPlanListRequest:(NSDictionary *)dic
                 withCallback:(HttpRequestCallBack *)callback;

@end
