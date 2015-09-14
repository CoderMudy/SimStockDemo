//
//  CPBuyStockData.m
//  SimuStock
//
//  Created by jhss_wyz on 15/7/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "CPBuyStockData.h"

@implementation CPBuyStockData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  NSDictionary *resultDic = dic[@"result"];
  if (resultDic == nil) {
    return;
  }
  self.ID = [resultDic[@"id"] integerValue];
  self.uid = [resultDic[@"uid"] integerValue];
  self.accountId = resultDic[@"accountId"];
  self.category = [resultDic[@"category"] integerValue];
  self.tradeType = [resultDic[@"tradeType"] integerValue];
  self.stockCode = resultDic[@"stockCode"];
  self.stockName = resultDic[@"stockName"];
  self.commissionId = resultDic[@"commissionId"];
  self.commissionType = [resultDic[@"commissionType"] integerValue];
  self.commissionPrice = [resultDic[@"commissionPrice"] doubleValue];
  self.commissionAmount = [resultDic[@"commissionAmount"] integerValue];
  self.commissionTime = resultDic[@"commissionTime"];
  self.feeRate = [resultDic[@"feeRate"] doubleValue];
  self.taxRate = [resultDic[@"taxRate"] doubleValue];
  self.frozenFund = [resultDic[@"frozenFund"] doubleValue];
  self.concludePrice = [resultDic[@"concludePrice"] doubleValue];
  self.concludeAmount = [resultDic[@"concludeAmount"] integerValue];
  self.yongJin = [resultDic[@"yongJin"] doubleValue];
  self.yinHuaShui = [resultDic[@"yinHuaShui"] doubleValue];
  self.cjBalance = [resultDic[@"cjBalance"] doubleValue];
  self.regAmount = [resultDic[@"regAmount"] integerValue];
  self.regStatus = [resultDic[@"status"] integerValue];
  self.token = resultDic[@"token"];
}

@end

@implementation CPBuyStockRequest

+ (void)requestCPBuyStockWithAccountId:(NSString *)accountId
                           andCategory:(NSString *)category
                          andStockCode:(NSString *)stockCode
                              andPrice:(NSString *)price
                              andFunds:(NSString *)funds
                             andAmount:(NSString *)amount
                           andCallback:(HttpRequestCallBack *)callback {
  NSString *url = [CP_SuperTradeAction_Address
      stringByAppendingString:@"youguu/super_trade/"
      @"buy?accountId={accountId}&category={category}&"
      @"stockCode={stockCode}&price={price}&funds={" @"funds}&amount={amount}"];
  NSDictionary *dic = @{
    @"accountId" : accountId,
    @"category" : category,
    @"stockCode" : stockCode,
    @"price" : price,
    @"funds" : funds,
    @"amount" : amount,
  };
  JsonFormatRequester *requset = [[JsonFormatRequester alloc] init];
  [requset asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[CPBuyStockData class]
             withHttpRequestCallBack:callback];
}

@end
