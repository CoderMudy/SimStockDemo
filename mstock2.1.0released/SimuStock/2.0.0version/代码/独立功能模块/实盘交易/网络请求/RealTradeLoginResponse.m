//
//  RealTradeLoginResponse.m
//  SimuStock
//
//  Created by Mac on 14-9-19.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "RealTradeLoginResponse.h"
#import "BaseRequester.h"
#import "RealTradeRequester.h"

@implementation RealTradeLoginResponse

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.customerId = dic[@"khh"];
  self.customerName = dic[@"khxm"];
  self.customerToken = dic[@"token"];
  self.customerSessionId = dic[@"jsid"];
}

+ (void)loginWithUrl:(NSString *)url
         withCaptcha:(NSString *)catcheCode
     withAccountType:(NSString *)accountType
         withAccount:(NSString *)account
        withPassword:(NSString *)password
        withCallback:(HttpRequestCallBack *)callback {

  NSDictionary *dic = @{
    @"yzm" : catcheCode,
    @"zhlx" : accountType,
    @"zh" : account,
    @"jymm" : password
  };
  RealTradeRequester *requester = [[RealTradeRequester alloc] init];
  id urlFactory = [RealTradeUrls getRealTradeUrlFactory];
  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:[urlFactory getBrokerRequstMethod]
                 withRequestParameters:dic
                withRequestObjectClass:[RealTradeLoginResponse class]
               withHttpRequestCallBack:callback];
};

@end
