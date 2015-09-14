//
//  WFsimuUtil.m
//  SimuStock
//
//  Created by Mac on 15/5/18.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "WFsimuUtil.h"

#pragma mark -身份验证
///身份验证
@implementation WFRealUserIsRNA
- (void)jsonToObject:(NSDictionary *)dic {
  _realName = dic[@"realName"];
  _certNo = dic[@"certNo"];
  if (_realName && _certNo) {
    [SimuUtil setUserCertName:_realName];
    [SimuUtil setUserCertNo:_certNo];
  }
}
@end
@implementation WFinquireIsAuthRNA

////用户身份验证
+ (void)authUserIdentityWithCallback:(HttpRequestCallBack *)callback {
  NSString *url = [user_address stringByAppendingString:@"jhss/member/getRNA"];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[WFRealUserIsRNA class]
             withHttpRequestCallBack:callback];
}

@end
