//
//  WFBindBankRequestData.m
//  SimuStock
//
//  Created by moulin wang on 15/4/22.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "WFBindBankRequestData.h"

@implementation WFBindCardNumRequest

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
}

@end

@implementation WFBindBankRequestData

+ (void)requestBindBankWithChannel:(NSString *)channel
                        withCardNo:(NSString *)card_no
                        withBankid:(NSString *)bank_id
                      withCallback:(HttpRequestCallBack *)callback {
  NSString *url =
      [WF_Payment_Address stringByAppendingFormat:@"account/bind_card"];
  NSDictionary *dic = @{
    @"bank_id" : bank_id,
    @"channel" : channel,
    @"card_no" : card_no
  };
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"POST"
               withRequestParameters:dic
              withRequestObjectClass:[WFBindCardNumRequest class]
             withHttpRequestCallBack:callback];
}

@end
