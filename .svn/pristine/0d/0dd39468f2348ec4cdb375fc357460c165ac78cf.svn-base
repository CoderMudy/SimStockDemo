//
//  BaseBuySellWorkRequset.m
//  SimuStock
//
//  Created by 刘小龙 on 15/7/27.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseBuySellWorkRequset.h"
#import "BaseRequester.h"
#import "SimuTradeBaseData.h"
#import "SimuDoDealSubmitData.h"

@implementation BaseBuySellWorkRequset
/** 查询可买数量 */
- (void)getAmountFromNet:(NSString *)stockCode
               withPrice:(NSString *)price
               withFunds:(NSString *)funds
           withAccountId:(NSString *)accountId
             withMatchId:(NSString *)matchId
     withMarketFixedType:(MarketFixedPriceType)marketFixedType
            withUserType:(StockBuySellType)userType {

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak BaseBuySellWorkRequset *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    BaseBuySellWorkRequset *strongSelf = weakSelf;
    if (strongSelf) {
      if (strongSelf.viewNotWork) {
        strongSelf.viewNotWork();
      }
      return NO;
    } else {
      return YES;
    }
  };
  callback.onSuccess = ^(NSObject *obj) {
    BaseBuySellWorkRequset *strongSelf = weakSelf;
    if (strongSelf) {
      if (strongSelf.succountData) {
        strongSelf.succountData((SimuTradeBaseData *)obj,NO);
      }
    }
  };
  callback.onFailed = ^() {
    BaseBuySellWorkRequset *strongSelf = weakSelf;
    if (strongSelf) {
      if (strongSelf.fialdData) {
        strongSelf.fialdData();
      }
    }
  };
  callback.onError = ^(BaseRequestObject *obj, NSException *exc){
    BaseBuySellWorkRequset *strongSelf = weakSelf;
    if (strongSelf) {
      if (strongSelf.erroeData) {
        strongSelf.erroeData(obj,exc);
      }
    }
  };

  NSString *category = nil;
  if (marketFixedType == MarketPriceType) {
    category = @"1";
  } else if (marketFixedType == FixedPriceType) {
    category = @"0";
  }

  if (userType == StockBuySellOrdinaryType) {
    //普通用户
    [SimuTradeBaseData requestSimuBuyQueryDataWithMatchId:matchId
                                            withStockCode:stockCode
                                           withStockPrice:price
                                            withStockFund:funds
                                             withCallback:callback];
  } else if (userType == StockBuySellExpentType) {
    [SimuTradeBaseData requestExpertPlanBuy:accountId
                               withCategory:category
                              withStockCode:stockCode
                                  withPrice:price
                                  withFunds:funds
                               withCallback:callback];
  }
}

/** 卖出股票查询 */
- (void)querySellInfoWidthStockCode:(NSString *)stockCode
                      withAccountId:(NSString *)accountId
                        withMatchId:(NSString *)matchId
                withMarketFixedType:(MarketFixedPriceType)marketFixedType
                       withUserType:(StockBuySellType)userType {
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak BaseBuySellWorkRequset *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    BaseBuySellWorkRequset *strongSelf = weakSelf;
    if (strongSelf) {
      if (strongSelf.viewNotWork) {
        strongSelf.viewNotWork();
      }
      return NO;
    } else {
      return YES;
    }
  };
  callback.onSuccess = ^(NSObject *obj) {
    BaseBuySellWorkRequset *strongSelf = weakSelf;
    if (strongSelf) {
      if (strongSelf.succountData) {
        strongSelf.succountData((SimuTradeBaseData *)obj,NO);
      }
    }
  };
  callback.onFailed = ^() {
    BaseBuySellWorkRequset *strongSelf = weakSelf;
    if (strongSelf) {
      if (strongSelf.fialdData) {
        strongSelf.fialdData();
      }
    }
  };

  callback.onError = ^(BaseRequestObject *obj, NSException *exc) {
    BaseBuySellWorkRequset *strongSelf = weakSelf;
    if (strongSelf) {
      strongSelf.erroeData(obj, exc);
    }
  };

  NSString *category = nil;
  if (marketFixedType == MarketPriceType) {
    category = @"1";
  } else if (marketFixedType == FixedPriceType) {
    category = @"0";
  }

  if (userType == StockBuySellOrdinaryType) {
    
    [SimuTradeBaseData requestSimuDoSellQueryDataWithMatchId:matchId
                                               withStockCode:stockCode
                                                withCatagory:category
                                                withCallback:callback];

  } else if (userType == StockBuySellExpentType) {
    
    [SimuTradeBaseData requestExpertPlanSell:accountId
                                withCategory:category
                               withStockCode:stockCode
                                withCallback:callback];
  }
}

/** 点击买入卖出按钮 */
- (void)tradeEntrustWithCode:(NSString *)stockCode
             withFrozendFund:(NSString *)frozendFund
                  withAmount:(NSString *)amount
                   withPrice:(NSString *)price
                 withMatchId:(NSString *)matchId
                   withToken:(NSString *)token
             withBuySellType:(BuySellType)buySellType
         withMarketFixedType:(MarketFixedPriceType)marketFixedType
                withUserType:(StockBuySellType)userType {
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak BaseBuySellWorkRequset *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    BaseBuySellWorkRequset *strongSelf = weakSelf;
    if (strongSelf) {
      if (strongSelf.viewNotWork) {
        strongSelf.viewNotWork();
      }
      return NO;
    } else {
      return YES;
    }
  };
  callback.onSuccess = ^(NSObject *obj) {
    BaseBuySellWorkRequset *strongSelf = weakSelf;
    if (strongSelf) {
      if (strongSelf.succountData) {
        strongSelf.succountData((SimuDoDealSubmitData *)obj,YES);
      }
    }
  };
  callback.onFailed = ^() {
    BaseBuySellWorkRequset *strongSelf = weakSelf;
    if (strongSelf) {
      if (strongSelf.fialdData) {
        strongSelf.fialdData();
      }
    }
  };

  if (userType == StockBuySellOrdinaryType) {
    if (marketFixedType == MarketPriceType) {
      if (buySellType == StockBuyType) {
        //市价 买入
        [SimuDoDealSubmitData requestMarketBuyStockMatchID:matchId
                                             withStockCode:stockCode
                                            withFrozenFund:frozendFund
                                                 withToken:token
                                             withTradeType:@"0"
                                              withCallback:callback];
      } else if (buySellType == StockSellType) {
        //市价 卖出
        [SimuDoDealSubmitData requestMarketSellMatchID:matchId
                                         withStockCode:stockCode
                                            withAmount:amount
                                             withToken:token
                                         withTradeType:@"0"
                                          withCallback:callback];
      }
    } else if (marketFixedType == FixedPriceType) {
      //限价
      if (buySellType == StockBuyType) {
        //限价 买入
        [SimuDoDealSubmitData requestBuyStockWithMatchId:matchId
                                           withStockCode:stockCode
                                          withStockPrice:price
                                        withStockAmounts:amount
                                               withToken:token
                                            withCallback:callback];
      } else if (buySellType == StockSellType) {
        //限价 卖出
        [SimuDoDealSubmitData requestSellWithMatchId:matchId
                                       withStockCode:stockCode
                                      withStockPrice:price
                                    withStockAmounts:amount
                                           withToken:token
                                        withCallback:callback];
      }
    }
  } else if (userType == StockBuySellExpentType) {
    //牛人
    //限价 0  市价 1
    NSString *tempCategory = nil;
    NSString *tempFunds = nil;
    NSString *tempStockPrice = nil;
    NSString *tempStockAmount = nil;
    if (marketFixedType == MarketPriceType) {
      //市价
      tempCategory = @"1";
      if (buySellType == StockBuyType) {
        tempStockAmount = @"0";
        tempFunds = frozendFund;
        tempStockPrice = @"0";
        tempStockAmount = @"0";
      } else if (buySellType == StockSellType) {
        tempStockAmount = amount;
        tempStockPrice = @"0";
      }
    } else if (marketFixedType == FixedPriceType) {
      tempCategory = @"0";
      if (buySellType == StockBuyType) {
        tempFunds = @"0";
        tempStockPrice = price;
        tempStockAmount = amount;
      } else if (buySellType == StockSellType) {
        tempStockPrice = price;
        tempStockAmount = amount;
      }
    }

    if (buySellType == StockBuyType) {
      //牛人 买入
      [SimuDoDealSubmitData requestBuyAccountId:matchId
                                  withSctokCode:stockCode
                                   withCategory:tempCategory
                                      withPrice:tempStockPrice
                                       withFund:tempFunds
                                     withAmount:tempStockAmount
                                      withToken:token
                                   withCallback:callback];
    } else if (buySellType == StockSellType) {
      //牛人 卖出
      [SimuDoDealSubmitData requestSellAccountId:matchId
                                   withSctokCode:stockCode
                                    withCategory:tempCategory
                                       withPrice:tempStockPrice
                                      withAmount:tempStockAmount
                                       withToken:token
                                    withCallback:callback];
    }
  }
}

@end
