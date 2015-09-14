//
//  SimuTradeRevokeWrapper.h
//  SimuStock
//
//  Created by Mac on 14-9-3.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseRequestObject.h"
#import "JsonFormatRequester.h"
#import "StockEntrust.h"

typedef NS_ENUM(NSUInteger, EntrustStateType) {
  /** 已报 */
  EntrustStateSubmited = 2,
  /** 待撤 */
  EntrustStateToRevoke = 4,
  /** 已撤 */
  EntrustStateRevoked = 6,
  /** 已成 */
  EntrustStateDealDone = 8
};

typedef NS_ENUM(NSUInteger, EntrustPriceType) {
  /** 限价 */
  EntrustPriceLimit = 0,
  /** 市价 */
  EntrustPriceMarket = 1,
  /** 止盈 */
  EntrustPriceLimitProfit = 2,
  /** 止损 */
  EntrustPriceLimitLoss = 3
};

typedef NS_ENUM(NSUInteger, EntrustOrientation) {
  /** 委托方向：买 */
  EntrustBuyStock = 1,
  /** 委托方向：卖 */
  EntrustSellStock = 2
};

/**
 *类说明：委托单据数据结构
 */

@interface TradeRevokeElment : JsonRequestObject <ParseJson, EntrustItem>

/** 限价0市价1止盈2止损3 */
@property(assign, nonatomic) EntrustPriceType catagory;

/** 流水号 */
@property(copy, nonatomic) NSString *commissionId;
/** 状态(已成交/未成交/已撤单) */
@property(assign, nonatomic) EntrustStateType state;
/** 类型 */
@property(assign, nonatomic) EntrustOrientation commissionType;
/** 股票名称 */
@property(copy, nonatomic) NSString *stockName;
/** 股票代码 */
@property(copy, nonatomic) NSString *stockCode;
/** 价格 */
@property(copy, nonatomic) NSString *commissionPrice;
/** 数量 */
@property(copy, nonatomic) NSString *commissionAmount;

/** 时间 */
@property(copy, nonatomic) NSString *time;

/** 成交价 */
@property(copy, nonatomic) NSString *concludePrice;

/** 成交数量 */
@property(copy, nonatomic) NSString *concludeAmount;

/** 成交时间 */
@property(copy, nonatomic) NSString *concludeTime;

/** tradeType */
@property(assign, nonatomic) NSInteger tradeType;

- (NSString *)status;
- (NSString *)type;
- (NSString *)amountString;
- (NSString *)price;

@end

/**
 *类说明：撤单页面数据
 */
@interface SimuTradeRevokeWrapper : JsonRequestObject

/** 数据数组 */
@property(strong, nonatomic) NSMutableArray *dataArray;

@property(assign) SimPageDataType pagetype;

+ (void)queryTradeCancleInfoesWithMatchId:(NSString *)matchId
                            withPageIndex:(NSString *)page
                             withCallBack:(HttpRequestCallBack *)callback;

/** 牛人计划查看委托 */
+(void)requestTradeCancleInfoesWithAccountId:(NSString *)accoundId withCallback:(HttpRequestCallBack *)callback;


@end
