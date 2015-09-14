//
//  ShareStatic.m
//  SimuStock
//
//  Created by Mac on 15/3/12.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ShareStatic.h"
#import "BaseRequestObject.h"
#import "JsonFormatRequester.h"

@implementation ShareStatic

+ (void)sendShareSuccessToServerWithShareType:(ShareType)type
                                   withModule:(ShareModuleType)module {

  NSDictionary *shareTypeToPositionMap = @{
    @(ShareTypeSinaWeibo) : @"1",
    @(ShareTypeTencentWeibo) : @"2",
    @(ShareTypeWeixiSession) : @"3",
    @(ShareTypeWeixiTimeline) : @"4",
    @(ShareTypeQQSpace) : @"5",
    @(ShareTypeQQ) : @"6"
  };

  //发送统计数据给服务端
  NSDictionary *dic = @{
    @"moduleName" : [NSString stringWithFormat:@"%ld", (long)module],
    @"shareCode" : @"0",
    @"toPosition" : shareTypeToPositionMap[@(type)]
  };
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];

  callback.onSuccess = ^(NSObject *obj) {
    NSLog(@"分享统计发送成功，奖励待定");
  };
  callback.onFailed = ^{
    NSLog(@"分享统计发送失败，需要查找原因");
  };
  callback.onError = ^(BaseRequestObject *err, NSException *ex) {
  };
  NSString *url = [NSString stringWithFormat:@"%@stat/shareStat", stat_address];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"POST"
               withRequestParameters:dic
              withRequestObjectClass:[JsonRequestObject class]
             withHttpRequestCallBack:callback];
}

@end
