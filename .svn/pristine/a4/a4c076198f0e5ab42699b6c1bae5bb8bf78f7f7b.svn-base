//
//  ActualQuotationMoneyShiftToOrRolloffData.m
//  SimuStock
//
//  Created by moulin wang on 15/3/10.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ActualQuotationMoneyShiftToOrRolloffData.h"
#import "UserRealTradingInfo.h"
#import "RealTradeRequester.h"

@implementation ActualQuotationMoneyShiftToOrRolloffData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
}

+ (void)requestActualQuotationMoneyShiftToOrRolloff:(NSString *)money
                                            andType:(BOOL)type
                                     withBrokerType:(NSInteger)brokerTpey
                                        andCallBack:
                                            (HttpRequestCallBack *)callback {
  NSString *url =
      [stat_address stringByAppendingString:@"stat/mncg/"
                    @"addRealOpRecord?khh={khh}&brokerId={brokerId}&"
                    @"type={type}&czje={czje}"];
  NSString *selectedType = [[UserRealTradingInfo sharedInstance] getUserInfo:SaveTypeSelectedType];
  SaveType customerFundID = [selectedType integerValue] == 0 ? SaveTypeUserTradingIDCustomerNumber : SaveTypeUserTradingIDFundNumber;
  NSString *khh =
      [[UserRealTradingInfo sharedInstance] getUserInfo:customerFundID];
  id urlFactory = [RealTradeUrls getRealTradeUrlFactory];
  NSString *brokerId = [urlFactory getFactoryBrokerID];  
  NSDictionary *dic = @{
    @"khh" : khh,
    @"brokerId" : brokerId,
    @"type" : (type == YES ? @"1" : @"2"),
    @"czje" : money
  };

  RealTradeRequester *requester = [[RealTradeRequester alloc] init];
  [requester
      asynExecuteWithRequestUrl:url
              WithRequestMethod:@"GET"
          withRequestParameters:dic
         withRequestObjectClass:[ActualQuotationMoneyShiftToOrRolloffData class]
        withHttpRequestCallBack:callback];
}

@end
