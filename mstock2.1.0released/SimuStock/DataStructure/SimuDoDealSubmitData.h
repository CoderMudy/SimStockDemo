//
//  SimuDoDealSubmitData.h
//  SimuStock
//
//  Created by Yuemeng on 14-11-17.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SimuTradeBaseData.h"

/** 买卖委托数据类，接口：dodealsubmit */
@interface SimuDoDealSubmitData : SimuTradeBaseData

/** 市价买入  */
+ (void)requestMarketBuyStockMatchID:(NSString *)mathcId
                       withStockCode:(NSString *)stockCode
                      withFrozenFund:(NSString *)frozenFund
                           withToken:(NSString *)token
                       withTradeType:(NSString *)tradeType
                        withCallback:(HttpRequestCallBack *)callback;

/** 市价卖出 */
+ (void)requestMarketSellMatchID:(NSString *)mathcID
                   withStockCode:(NSString *)stockCode
                      withAmount:(NSString *)amount
                       withToken:(NSString *)token
                   withTradeType:(NSString *)tradeType
                    withCallback:(HttpRequestCallBack *)callback;

/** 限价买入 */
+ (void)requestBuyStockWithMatchId:(NSString *)matchId
                     withStockCode:(NSString *)stockCode
                    withStockPrice:(NSString *)stockPrice
                  withStockAmounts:(NSString *)stockAmounts
                         withToken:(NSString *)token
                      withCallback:(HttpRequestCallBack *)callback;

/** 限价卖出 */
+ (void)requestSellWithMatchId:(NSString *)matchId
                 withStockCode:(NSString *)stockCode
                withStockPrice:(NSString *)stockPrice
              withStockAmounts:(NSString *)stockAmounts
                     withToken:(NSString *)token
                  withCallback:(HttpRequestCallBack *)callback;



/******************* 牛人买卖 *********************/

/** 牛人买入  */
+ (void)requestBuyAccountId:(NSString *)accountId
              withSctokCode:(NSString *)stockCode
               withCategory:(NSString *)category
                  withPrice:(NSString *)price
                   withFund:(NSString *)funds
                 withAmount:(NSString *)amount
                  withToken:(NSString *)token
               withCallback:(HttpRequestCallBack *)callback;

/** 牛人卖出 */
+ (void)requestSellAccountId:(NSString *)accountId
               withSctokCode:(NSString *)stockCode
                withCategory:(NSString *)category
                   withPrice:(NSString *)price
                  withAmount:(NSString *)amount
                   withToken:(NSString *)token
                withCallback:(HttpRequestCallBack *)callback;
@end
