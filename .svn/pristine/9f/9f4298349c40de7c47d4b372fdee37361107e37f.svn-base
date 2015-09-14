//
//  RealTradeFundTransferResult.m
//  SimuStock
//
//  Created by Mac on 14-9-22.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "RealTradeFundTransferResult.h"
#import "RealTradeRequester.h"

@implementation RealTradeFundTransferResult

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.applyID = dic[@"sqh"];
}

/**转出 - 证券转银行 */
+ (void)transferOutWithMoneyAmount:(NSString *)amount
                      withPassword:(NSString *)password
                       WitBankInfo:(RealTradeBankItem *)bankInfo
                      WithCallback:(HttpRequestCallBack *)callback {
  NSDictionary *dic = @{
    @"zjzh" : bankInfo.moneyAccount,
    @"zjmm" : password,
    @"bz" : bankInfo.currencyType,

    @"yhzh" : bankInfo.bankAccount,
    @"yhdm" : bankInfo.bankCode,
    @"zzje" : amount
  };
  RealTradeRequester *requester = [[RealTradeRequester alloc] init];
  id urlFactory = [RealTradeUrls getRealTradeUrlFactory];
  NSString *url = [urlFactory getSecuToBank];
  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:[urlFactory getBrokerRequstMethod]
                 withRequestParameters:dic
                withRequestObjectClass:[RealTradeFundTransferResult class]
               withHttpRequestCallBack:callback];
};

/**转入 - 银行转证券 */
+ (void)transferInWithMoneyAmount:(NSString *)amount
                     withPassword:(NSString *)password
                      WitBankInfo:(RealTradeBankItem *)bankInfo
                     WithCallback:(HttpRequestCallBack *)callback {
  NSDictionary *dic = @{
    @"zjzh" : bankInfo.moneyAccount,
    @"yhmm" : password,
    @"bz" : bankInfo.currencyType,

    @"yhzh" : bankInfo.bankAccount,
    @"yhdm" : bankInfo.bankCode,
    @"zzje" : amount
  };

  RealTradeRequester *requester = [[RealTradeRequester alloc] init];
  id urlFactory = [RealTradeUrls getRealTradeUrlFactory];
  NSString *url = [urlFactory getBankToSecu];
  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:[urlFactory getBrokerRequstMethod]
                 withRequestParameters:dic
                withRequestObjectClass:[RealTradeFundTransferResult class]
               withHttpRequestCallBack:callback];
};

@end
