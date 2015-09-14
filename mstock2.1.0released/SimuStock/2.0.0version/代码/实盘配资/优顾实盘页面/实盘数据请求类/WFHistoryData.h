//
//  WFHistoryData.h
//  SimuStock
//
//  Created by moulin wang on 15/5/4.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonFormatRequester.h"
@class HttpRequestCallBack;

@interface WFHistoryInfoMode : JsonRequestObject

/** 股票名称 */
@property(copy, nonatomic) NSString *stockName;
/** 股票代码 */
@property(copy, nonatomic) NSString *stockCode;
/** 操作 1=买入,2=卖出 */
@property(copy, nonatomic) NSString *entrustDirection;
/** 成交时间(2015-4-29) */
@property(copy, nonatomic) NSString *businessTime;
/** 成交数量 */
@property(copy, nonatomic) NSString *businessAmount;
/** 成交价格(分) */
@property(copy, nonatomic) NSString *businessPrice;

@property(strong, nonatomic) NSMutableArray *historyArray;

@end

@interface WFHistoryData : NSObject

/** 历史成交数据请求 */
+ (void)requestHistoryDataWithBeginTime:(NSString *)beginTime
                             andEndTime:(NSString *)endTime
                               withStat:(NSString *)stat
                           withCallback:(HttpRequestCallBack *
                                         )callback;
@end
