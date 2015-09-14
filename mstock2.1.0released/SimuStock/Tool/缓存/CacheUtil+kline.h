//
//  CacheUtil+kline.h
//  SimuStock
//
//  Created by Mac on 15/6/3.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "CacheUtil.h"
#import "TrendKLineModel.h"
#import "FundNetWorthList.h"

@interface CacheUtil (kline)

///保存分时数据
+ (void)saveTrendData:(TrendData *)data firstType:(NSString *)firstType;
///加载分时数据
+ (TrendData *)loadTrendDataWithStockCode:(NSString *)stockCode
                                firstType:(NSString *)firstType;

///保存五日数据
+ (void)save5DaysData:(Stock5DayStatusInfo *)data
            firstType:(NSString *)firstType;
///加载五日数据
+ (Stock5DayStatusInfo *)load5DaysDataWithStockCode:(NSString *)stockCode
                                          firstType:(NSString *)firstType;

///保存K线数据
+ (void)saveKLineData:(KLineDataItemInfo *)data firstType:(NSString *)firstType;
///加载K线数据
+ (KLineDataItemInfo *)loadKLineDataWithStockCode:(NSString *)stockCode
                                        firstType:(NSString *)firstType
                                             type:(NSString *)type
                                         xrdrType:(NSString *)xrdrType;

///保存基金净值数据
+ (void)saveFundNetWorthList:(FundNetWorthList *)data
                withFundCode:(NSString *)fundCode;
///加载基金净值数据
+ (FundNetWorthList *)loadFundNetWorthListWithFundCode:(NSString *)fundCode;
@end
