//
//  PraiseTStockData.m
//  SimuStock
//
//  Created by Yuemeng on 14-12-9.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "PraiseTStockData.h"
#import "WBCoreDataUtil.h"


@implementation PraiseTStockData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
}

+ (void)requestPraiseTStockData:(TweetListItem *)homeData {
  
  if (homeData.isPraised) {
    return;
  }
  
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onSuccess = ^(NSObject *obj) {
    [WBCoreDataUtil insertPraiseTid:homeData.tstockid];
    //赞状态改变
    homeData.isPraised = YES;
    NSDictionary *userInfo = @{ @"data" : homeData };
    //广播👍赞数加1
    [[NSNotificationCenter defaultCenter]
     postNotificationName:PraiseWeiboSuccessNotification
     object:self
     userInfo:userInfo];
  };
  
  callback.onFailed = ^{
    NSLog(@"赞失败");
  };
  
  callback.onError = ^(BaseRequestObject *obj, NSException *ex){
    [BaseRequester defaultErrorHandler](obj, ex);
    
    NSDictionary *userInfo = nil;
      //广播👍赞错误，比如用户被冻结了
    [[NSNotificationCenter defaultCenter]
     postNotificationName:PraiseWeiboSuccessNotification
     object:self
     userInfo:userInfo];
  };
  
  NSString *url = [istock_address
      stringByAppendingString:@"istock/talkstock/praisetstock/{ak}/{sid}/"
      @"{userid}/{tstockid}/{act}"];
  if (!homeData.tstockid) {
    return;
  }
  NSDictionary *dic = @{
    @"tstockid" : [homeData.tstockid stringValue],
    @"act" : @"1"
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];

  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[PraiseTStockData class]
             withHttpRequestCallBack:callback];
}

@end
