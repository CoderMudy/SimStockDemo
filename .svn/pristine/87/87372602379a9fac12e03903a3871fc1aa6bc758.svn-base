//
//  WFCapitalByOrSellOut.m
//  SimuStock
//
//  Created by moulin wang on 15/4/20.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "WFCapitalByOrSellOut.h"
#import "WFDataSharingCenter.h"

@implementation WFCapitalBySellJosnData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.entrusNo = dic[@"entrusNo"];
  self.batchNo = dic[@"batchNo"];
}

@end

@implementation WFCapitalByOrSellOut

+ (void)requestCapitalByOrSellWithBoll:(BOOL)isByOrSell
                         withStockCode:(NSString *)stockCode
                             withPrice:(NSString *)price
                            withAmount:(NSString *)amount
                          withCallback:(HttpRequestCallBack *)callback {
  NSString *url = nil;
  if (isByOrSell == YES) {
    url = [NSString
        stringWithFormat:@"%@/buyStock",WF_Trade_Address];
  } else {
    url = [NSString stringWithFormat:@"%@/sellStock",
                                     WF_Trade_Address];
  }

  // 股票代码 委托类别 买 卖  股票可用数量 委托价格
  NSString *hsUserID = [WFDataSharingCenter shareDataCenter].hsUserId;
  NSString *homsFundAccount =
      [WFDataSharingCenter shareDataCenter].homsFundAccount;
  NSString *homsCombineId = [WFDataSharingCenter shareDataCenter].homsCombineld;
  NSDictionary *dic = @{
    @"hsUserId" : hsUserID,
    @"homsFundAccount" : homsFundAccount,
    @"homsCombineId" : homsCombineId,
    @"entrustType" : @"0",
    @"stockCode" : stockCode,
    @"entrustPrice" : price,
    @"entrustAmount" : amount
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"POST"
               withRequestParameters:dic
              withRequestObjectClass:[WFCapitalBySellJosnData class]
             withHttpRequestCallBack:callback];
}

@end
