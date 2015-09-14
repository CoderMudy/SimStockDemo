//
//  FollowFriendResult.m
//  SimuStock
//
//  Created by Mac on 14-10-23.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "FollowFriendResult.h"
#import "JsonFormatRequester.h"
#import "DoTaskStatic.h"
#import "TaskIdUtil.h"

@implementation FollowFriendResult

+ (void)addCancleFollowWithUid:(NSString *)masterUid
                withFollowFlag:(NSString *)addFollow
                  withCallBack:(HttpRequestCallBack *)callback {

  NSString *url;
  if ([@"1" isEqualToString:addFollow]) {
    url = [user_address
        stringByAppendingString:
            @"jhss/member/addFollow/{ak}/{sid}/{userid}/{followId}"];
    if ([[SimuUtil getAttentionOthers] isEqualToString:@""]) {
      //首次关注他人任务
      [DoTaskStatic doTaskWithTaskType:TASK_FIRST_FOCUS];
      [SimuUtil setAttentionOthers:TASK_FIRST_FOCUS];
    }else{
      NSLog(@"首次关注他人任务已完成！！！");
    }
  } else {
    url = [user_address
        stringByAppendingString:
            @"jhss/member/cancelFollow/{ak}/{sid}/{userid}/{followId}"];
  }
  NSDictionary *dic = @{ @"followId" : masterUid };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[FollowFriendResult class]
             withHttpRequestCallBack:callback];
}

@end
