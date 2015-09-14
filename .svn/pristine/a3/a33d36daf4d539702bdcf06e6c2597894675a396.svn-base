//
//  WFStockByData.h
//  SimuStock
//
//  Created by moulin wang on 15/4/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RealTradeStockPriceInfo.h"

@class HttpRequestCallBack;
@interface WFStockByInfoData : RealTradeStockPriceInfo

/** 股票类型 */
@property(copy, nonatomic) NSString *stockType;

/** 市场类型 */
@property(copy, nonatomic) NSString *marketId;

@property(copy, nonatomic) NSString *stockInfoSuspend;

@end

@interface WFStockByData : NSObject

//请求数据  委托类别 买 卖  账户可用资金 股票可用数量 委托价格
+ (void)computeStockByInfoWithStockCode:(NSString *)stockCode
                        withEntrustType:(NSString *)entrusType
                          withCurAmount:(NSString *)curAmount
                       withEnableAmount:(NSString *)enableAmount
                       withEntrustPrice:(NSString *)entrustPirce
                         withIsByOrSell:(BOOL )isByOrSell
                           withCallBack:(HttpRequestCallBack *)callback;
@end
