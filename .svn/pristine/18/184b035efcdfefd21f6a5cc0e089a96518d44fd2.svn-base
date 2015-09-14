//
//  EPexpertPositionData.h
//  SimuStock
//
//  Created by 刘小龙 on 15/7/8.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"
#import "SimuRankPositionPageData.h"
@class HttpRequestCallBack;

@interface EPexpertPositionData : JsonRequestObject <Collectionable>

/** 股票盈利 */
@property(assign, nonatomic) double stockProfit;

/** 股票盈利率 */
@property(assign, nonatomic) double stockProfitRate;

/** 股票市值 */
@property(assign, nonatomic) double stockAssets;

/** 盈利 */
@property(assign, nonatomic) double positionRate;

/** 当前平衡 */
@property(assign, nonatomic) double currentBalance;

/** 总资产 */
@property(assign, nonatomic) double totalAssets;

@property(strong, nonatomic) NSMutableArray *stockPositionArray;

/** 持仓数据请求 */
+ (void)requetPositionDataWithDic:(NSDictionary *)dic
                     withCallback:(HttpRequestCallBack *)callback;

@end
