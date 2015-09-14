//
//  SecuritiesBankInfo.m
//  SimuStock
//
//  Created by Mac on 14-9-22.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SecuritiesBankInfo.h"
#import "RealTradeRequester.h"

@implementation RealTradeBankItem

- (void)jsonToObject:(NSDictionary *)dic {
  self.currencyType = dic[@"bz"];
  self.bankCode = dic[@"yhdm"];
  self.bankName = dic[@"yhmc"];
  self.bankAccount = dic[@"yhzh"];
  self.moneyAccount = dic[@"zjzh"];
  self.name = dic[@"mc"];
}
@end

@implementation RealTradeCurrencyType

- (void)jsonToObject:(NSDictionary *)dic {
  self.abbr = dic[@"bm"];
  self.name = dic[@"mc"];
}
@end

@implementation SecuritiesBankInfo

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.banks = [[NSMutableArray alloc] init];
  NSArray *bankArray = dic[@"bank"];

  for (NSDictionary *dicBankInfo in bankArray) {
    RealTradeBankItem *bankInfo = [[RealTradeBankItem alloc] init];
    [bankInfo jsonToObject:dicBankInfo];
    [self.banks addObject:bankInfo];
  }

  self.currencyTypes = [[NSMutableArray alloc] init];
  NSArray *currencyTypeArray = dic[@"bz"];

  for (NSDictionary *dicCurrencyType in currencyTypeArray) {
    RealTradeCurrencyType *currencyType = [[RealTradeCurrencyType alloc] init];
    [currencyType jsonToObject:dicCurrencyType];
    [self.currencyTypes addObject:currencyType];
  }
}

+ (void)loadSecuritiesBankInfoWithUrl:(NSString *)url
                         WithCallback:(HttpRequestCallBack *)callback {

  RealTradeRequester *requester = [[RealTradeRequester alloc] init];
  id urlFactory = [RealTradeUrls getRealTradeUrlFactory];
  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:[urlFactory getBrokerRequstMethod]
                 withRequestParameters:nil
                withRequestObjectClass:[SecuritiesBankInfo class]
               withHttpRequestCallBack:callback];
}

@end
