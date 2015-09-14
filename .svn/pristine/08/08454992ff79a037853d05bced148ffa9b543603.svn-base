//
//  RealTradeSpecifiedTransaction.m
//  SimuStock
//
//  Created by Mac on 14-9-22.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "RealTradeSpecifiedTransaction.h"
#import "RealTradeRequester.h"

@implementation RealTradeSpecifiedTransaction

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.stockholderName = dic[@"gdxm"];
  self.stockholderCode = dic[@"gddm"];
  self.marketType = dic[@"sclb"];
}

+ (void)loadSpecifiedTransactionWithCallback:(HttpRequestCallBack *)callback {
  RealTradeRequester *requester = [[RealTradeRequester alloc] init];
  id urlFactory = [RealTradeUrls getRealTradeUrlFactory];
  NSString *url = [urlFactory getSpecifiedTransaction];
  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:[urlFactory getBrokerRequstMethod]
                 withRequestParameters:nil
                withRequestObjectClass:[RealTradeSpecifiedTransaction class]
               withHttpRequestCallBack:callback];
}

@end

@implementation RealTradeDoSpecifiedTransaction

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.entrustorder = [dic[@"entrustorder"] intValue];
}

+ (void)doSpecifiedTransactionWithCallback:(HttpRequestCallBack *)callback {
  RealTradeRequester *requester = [[RealTradeRequester alloc] init];
  id urlFactory = [RealTradeUrls getRealTradeUrlFactory];
  NSString *url = [urlFactory getDoSpecifiedTransaction];
  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:[urlFactory getBrokerRequstMethod]
                 withRequestParameters:nil
                withRequestObjectClass:[RealTradeDoSpecifiedTransaction class]
               withHttpRequestCallBack:callback];
}

@end
