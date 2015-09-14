//
//  CPSendCattleResult.m
//  SimuStock
//
//  Created by jhss_wyz on 15/7/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "CPSendCattleResult.h"

@implementation CPSendCattleResult

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
}

@end

@implementation CPSendCattleRequest

+ (void)requestCPSendCattleWithReceiverId:(NSString *)receiverId
                                andCowNum:(NSString *)cowNum
                              andCallback:(HttpRequestCallBack *)callback {
  NSString *url = [mall_address stringByAppendingString:@"pay/cow/sendCow"];
  NSDictionary *dic = @{
    @"receiverId" : receiverId,
    @"cowNum" : cowNum,
  };
  JsonFormatRequester *requset = [[JsonFormatRequester alloc] init];
  [requset asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"POST"
               withRequestParameters:dic
              withRequestObjectClass:[CPSendCattleResult class]
             withHttpRequestCallBack:callback];
}

@end
