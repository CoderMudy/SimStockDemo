//
//  CacheUtil+kline.m
//  SimuStock
//
//  Created by Mac on 15/6/3.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "CacheUtil+kline.h"

///分时数据缓存时间
static const double TIMEOUT_PARTTIME = 60;

///基金净值缓存时间
static const double TIMEOUT_FundNetValue = 60 * 60 * 24 * 2;

/// K线数据缓存时间
static const double TIMEOUT_KLINE_D = 60 * 60 * 24;
static const double TIMEOUT_KLINE_5 = 60 * 5;
static const double TIMEOUT_KLINE_15 = 60 * 15;
static const double TIMEOUT_KLINE_30 = 60 * 30;
static const double TIMEOUT_KLINE_60 = 60 * 60;

///分时数据
static NSString *const TrendDataType = @"TrendDataType";

///五日分时数据
static NSString *const FiveDaysDataType = @"FiveDaysDataType";

/// k线数据
static NSString *const KLineDataType = @"KLineDataType";

///基金净值
static NSString *const FundNetValueType = @"FundNetValueType";

@implementation CacheUtil (kline)

+ (NSString *)getStockKey:(NSString *)stockCode
                firstType:(NSString *)firstType
                     type:(NSString *)type
                 xrdrType:(NSString *)xrdrType {
  return [NSString stringWithFormat:@"%@_%@_%@_%@", stockCode, firstType, type,
                                    xrdrType ? xrdrType : @""];
}

///趋势
+ (void)saveTrendData:(TrendData *)data firstType:(NSString *)firstType {
  NSString *key = [CacheUtil getStockKey:data.stockcode
                               firstType:firstType
                                    type:TrendDataType
                                xrdrType:nil];
  [CacheUtil saveCacheData:data withKey:key];
}

+ (TrendData *)loadTrendDataWithStockCode:(NSString *)stockCode
                                firstType:(NSString *)firstType {
  NSString *key = [CacheUtil getStockKey:stockCode
                               firstType:firstType
                                    type:TrendDataType
                                xrdrType:nil];
  return [CacheUtil loadCacheWithKey:key
                       withClassType:[TrendData class]
                         withTimeout:TIMEOUT_PARTTIME];
}

///五日
+ (void)save5DaysData:(Stock5DayStatusInfo *)data
            firstType:(NSString *)firstType {
  NSString *key = [CacheUtil getStockKey:data.stockcode
                               firstType:firstType
                                    type:FiveDaysDataType
                                xrdrType:nil];
  [CacheUtil saveCacheData:data withKey:key];
}

+ (Stock5DayStatusInfo *)load5DaysDataWithStockCode:(NSString *)stockCode
                                          firstType:(NSString *)firstType {
  NSString *key = [CacheUtil getStockKey:stockCode
                               firstType:firstType
                                    type:FiveDaysDataType
                                xrdrType:nil];
  return [CacheUtil loadCacheWithKey:key
                       withClassType:[Stock5DayStatusInfo class]
                         withTimeout:TIMEOUT_PARTTIME];
}

/// K线缓存
+ (void)saveKLineData:(KLineDataItemInfo *)data
            firstType:(NSString *)firstType {
  NSString *key = [CacheUtil getStockKey:data.stockcode
                               firstType:firstType
                                    type:data.type
                                xrdrType:data.xrdrType];
  [CacheUtil saveCacheData:data withKey:key];
}

+ (KLineDataItemInfo *)loadKLineDataWithStockCode:(NSString *)stockCode
                                        firstType:(NSString *)firstType
                                             type:(NSString *)type
                                         xrdrType:(NSString *)xrdrType {
  NSString *key = [CacheUtil getStockKey:stockCode
                               firstType:firstType
                                    type:type
                                xrdrType:xrdrType];
  return [CacheUtil loadCacheWithKey:key
                       withClassType:[KLineDataItemInfo class]
                         withTimeout:TIMEOUT_PARTTIME];
}

//未使用//
+ (double)timeoutWithType:(NSString *)type {
  if ([type isEqualToString:@"D"]) {
    return TIMEOUT_KLINE_D;
  } else if ([type isEqualToString:@"W"]) {
    return TIMEOUT_KLINE_D;
  } else if ([type isEqualToString:@"M"]) {
    return TIMEOUT_KLINE_D;
  } else if ([type isEqualToString:@"5M"]) {
    return TIMEOUT_KLINE_5;
  } else if ([type isEqualToString:@"15M"]) {
    return TIMEOUT_KLINE_15;
  } else if ([type isEqualToString:@"30M"]) {
    return TIMEOUT_KLINE_30;
  } else if ([type isEqualToString:@"60M"]) {
    return TIMEOUT_KLINE_60;
  } else {
    return TIMEOUT_KLINE_D;
  }
}

///保存基金净值数据
+ (void)saveFundNetWorthList:(FundNetWorthList *)data
                withFundCode:(NSString *)fundCode {
  NSString *key =
      [CacheUtil getStockKey:fundCode firstType:@"" type:@"" xrdrType:@""];
  [CacheUtil saveCacheData:data withKey:key];
}
///加载基金净值数据
+ (FundNetWorthList *)loadFundNetWorthListWithFundCode:(NSString *)fundCode {

  NSString *key =
      [CacheUtil getStockKey:fundCode firstType:@"" type:@"" xrdrType:@""];
  return [CacheUtil loadCacheWithKey:key
                       withClassType:[FundNetWorthList class]
                         withTimeout:TIMEOUT_FundNetValue];
}

@end
