//
//  WFTodayTransactionData.h
//  SimuStock
//
//  Created by moulin wang on 15/4/19.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonFormatRequester.h"
@class HttpRequestCallBack;

//解析数据类 -- 模型类
@interface WFTodayJosnData : JsonRequestObject
//数组 装RealTradeTodayEntrustItem
@property(strong, nonatomic) NSMutableArray *todayDataMutableArray;

@end

@interface WFTodayTransactionData : NSObject

/** 查询当日成交 */
+ (void)requestTodayTransactionDataWithCallback:(HttpRequestCallBack *)callback;

@end
