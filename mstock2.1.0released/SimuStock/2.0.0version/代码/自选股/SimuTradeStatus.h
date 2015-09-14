//
//  SimTradeStatus.h
//  SimuStock
//
//  Created by Mac on 14-8-25.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequestObject.h"

typedef NS_ENUM(NSUInteger, TradeStatus) {
  TradeOpenning = 0,
  TradeClosed,
  TradeStatusUnknown,
};

@interface SimuTradeStatus : JsonRequestObject

/**
 * 状态码，int类型，-2：非交易日，-1非交易时间，0：交易时间
 */
@property(nonatomic, assign) int result;

/**
 * 状态描述，string类型
 */
@property(nonatomic, copy) NSString *desc;

/**
 * 服务器时间,long类型
 */
@property(nonatomic, assign) int64_t serverTime;

/**
 * 距离下次开盘的时间，long类型 单位：毫秒
 */
@property(nonatomic, assign) int64_t openCountDown;

/**
 * 距离下次收盘时间，long类型 单位：毫秒
 */
@property(nonatomic, assign) int64_t closeCountDown;

/**
 * 本次修改时间
 */
@property(nonatomic, assign) int64_t mtime;

/**
 * 状态描述，string类型
 */
@property(atomic, copy) NSMutableAttributedString *exchangeStatusDesc;

/**
 * 状态描述，string类型
 */
@property(atomic, copy) NSMutableAttributedString *exchangeStatusDescForBuySell;

+ (SimuTradeStatus *)instance;

/**
 * 发起请求获取最新的交易所状态
 */
- (void)requestExchangeStatus:(void(^)())onRefreshCallBack;

/**
 * 获取交易所状态：开市中TradeOpenning，已经闭市TradeClosed，状态未知TradeStatusUnknown
 * 如果返回状态未知，发起请求获取最新的交易所状态
 */
- (TradeStatus)getExchangeStatus;

/**
 * 获取交易所状态描述
 */
- (NSMutableAttributedString *)getExchangeStatusDescription;

/**
 * 获取交易所状态描述
 */
- (NSMutableAttributedString *)getExchangeStatusDescriptionForBuySell;

/** 返回是否需要每秒刷新一次，例如：距开盘一分钟之内，距收盘一分钟之内 */
- (BOOL)needRefreshBySecond;

@end
