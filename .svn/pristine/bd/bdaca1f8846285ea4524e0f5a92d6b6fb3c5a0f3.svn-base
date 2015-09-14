//
//  DoTaskStatic.m
//  SimuStock
//
//  Created by jhss on 15/5/20.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "DoTaskStatic.h"
#import "BaseRequestObject.h"
#import "JsonFormatRequester.h"
#import "GetGoldWrapper.h"

@implementation DoTaskStatic
+ (void)doTaskWithTaskType:(NSString *)taskType {
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onSuccess = ^(NSObject *obj) {
    NSLog(@"做任务成功！！！");
  };
  callback.onError = ^(BaseRequestObject *obj, NSException *exc) {
  };
  callback.onFailed = ^() {
  };
  NSString *url = [user_address
      stringByAppendingString:@"jhss/task/doTask?taskId={taskId}"];
  NSDictionary *dic = @{ @"taskId" : taskType };
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[GetGoldWrapper class]
             withHttpRequestCallBack:callback];
}
@end
