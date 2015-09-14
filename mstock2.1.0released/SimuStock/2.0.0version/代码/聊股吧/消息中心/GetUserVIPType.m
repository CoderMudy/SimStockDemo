//
//  GetUserVIPType.m
//  SimuStock
//
//  Created by jhss on 15/7/10.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "GetUserVIPType.h"
#import "JsonFormatRequester.h"

@implementation GetUserVIPType
- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.vipType = (UserVipType)[dic[@"vipType"] intValue];
}
+ (void)getUserVipTypeWithCallback:(HttpRequestCallBack *)callback {
  NSString *url = [user_address stringByAppendingString:@"jhss/member/getVip"];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[GetUserVIPType class]
             withHttpRequestCallBack:callback];
}
@end
