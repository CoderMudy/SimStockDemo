//
//  SimuTradeBaseData.h
//  SimuStock
//
//  Created by Yuemeng on 14-11-17.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

@class HttpRequestCallBack;

/** 模拟盘买入、卖出和委托的数据基类 */
@interface SimuTradeBaseData : JsonRequestObject

/** token */
@property(strong, nonatomic) NSString *token;

/** 股票代码 */
@property(strong, nonatomic) NSString *stockCode;
/** 股票名称 */
@property(strong, nonatomic) NSString *stockName;
/** 开盘价 */
@property(assign, nonatomic) double openPrice;
/** 收盘价 */
@property(assign, nonatomic) double closePrice;
/** 最新价 */
@property(assign, nonatomic) double newstockPrice;
/** 最高价 */
@property(assign, nonatomic) double highestPrice;
/** 最低价 */
@property(assign, nonatomic) double lowestPrice;
/** 涨停价 */
@property(assign, nonatomic) double uplimitedPrice;
/** 跌停价 */
@property(assign, nonatomic) double downlimitedPrice;
/** 可用资金 */
@property(assign, nonatomic) double fundsable;
/** 可买股数 */
@property(assign, nonatomic) NSInteger stockamount;
/** 卖出价 */
@property(assign, nonatomic) double salePrice;
/** 佣金 */
@property(strong, nonatomic) NSString *commission;
/** 持股数 */
@property(strong, nonatomic) NSString *holdstock;
/** 可卖股数 */
@property(strong, nonatomic) NSString *sellable;
/** 印花税 */
@property(strong, nonatomic) NSString *tax;
/** 传入资金的最大可买数 */
@property(strong, nonatomic) NSString *maxBuy;
/** 最小手续费 */
@property(assign, nonatomic) double minFee;
/** 买入价格 */
@property(assign, nonatomic) double buyPrice;
/** 佣金比例，按照万分之一处理 */
@property(assign, nonatomic) NSInteger feeRateInt;

/** 交易类型(0股票，1基金) */
@property(assign, nonatomic) NSInteger tradeType;
/**止盈价*/
@property(assign, nonatomic) NSString *stopWinPri;
/**止盈比例*/
@property(assign, nonatomic) NSString *stopWinRate;
/**止损价*/
@property(assign, nonatomic) NSString *stopLosePri;
/**止损比例*/
@property(assign, nonatomic) NSString *stopLoseRate;
/** 成本价 */
@property(assign, nonatomic) double costPri;
/** 当前盈亏率 */
@property(assign, nonatomic) NSString *profitRate;

/** 可买可卖查询数据类，接口：buy/query */
+ (void)requestSimuBuyQueryDataWithMatchId:(NSString *)matchId
                             withStockCode:(NSString *)stockCode
                            withStockPrice:(NSString *)stockPrice
                             withStockFund:(NSString *)stockFund
                              withCallback:(HttpRequestCallBack *)callback;

/** 卖出查询数据类，接口：dosellquery */
+ (void)requestSimuDoSellQueryDataWithMatchId:(NSString *)matchId
                                withStockCode:(NSString *)stockCode
                                 withCatagory:(NSString *)catagory
                                 withCallback:(HttpRequestCallBack *)callback;

/**止盈止损委托下单*/
+ (void)requestProfitAndStopWithMatchId:(NSString *)matchId
                          withStockCode:(NSString *)stockCode
                             withAmount:(NSString *)amount
                              withToken:(NSString *)token
                           withCategory:(NSString *)category
                              withPrice:(NSString *)price
                           withCallback:(HttpRequestCallBack *)callback;

/****************** 牛人计划 买入卖出*********************/

/** 牛人买入查询 */
+ (void)requestExpertPlanBuy:(NSString *)accountId
                withCategory:(NSString *)category
               withStockCode:(NSString *)stockCode
                   withPrice:(NSString *)price
                   withFunds:(NSString *)funds
                withCallback:(HttpRequestCallBack *)callback;

/** 牛人卖出查询 */
+ (void)requestExpertPlanSell:(NSString *)accountId
                 withCategory:(NSString *)category
                withStockCode:(NSString *)stockCode
                 withCallback:(HttpRequestCallBack *)callback;

/** 牛人止盈止损 */
+ (void)requestExpertProfitAndStopWithAccountId:(NSString *)accountId
                                   withCategory:(NSString *)category
                                  withStockCode:(NSString *)stockCode
                                      withPrice:(NSString *)price
                                     withAmount:(NSString *)amount
                                      withToken:(NSString *)token
                                   withCallback:(HttpRequestCallBack *)callback;

@end
