//
//  WFBindBankRequestData.m
//  SimuStock
//
//  Created by moulin wang on 15/4/22.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

@implementation WFBindBankRequestData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
}
//发送绑定请求
+ (void)requestBindBankWithRealName:(NSString *)realName
             withIdentityCardNumber:(NSString *)identityNumber
                 withBankCardNumber:(NSString *)bankCardNumber
                         withBankid:(int)bankID
                       withCallback:(HttpRequestCallBack *)callback {
  NSString *url =
      [NSString stringWithFormat:@"%@account/bind_card",WF_Payment_Address];
  NSDictionary *dic = @{
    @"real_name" : realName,
    @"id_card_no" : identityNumber,
    @"bank_card_no" : bankCardNumber,
    @"bank_id" : [NSString stringWithFormat:@"%d", bankID]
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"POST"
               withRequestParameters:dic
              withRequestObjectClass:[WFBindBankRequestData class]
             withHttpRequestCallBack:callback];
}

@end
