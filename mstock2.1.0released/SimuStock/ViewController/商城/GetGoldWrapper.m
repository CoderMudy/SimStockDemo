//
//  GetGoldWrapper.m
//  SimuStock
//
//  Created by jhss on 15/5/14.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "GetGoldWrapper.h"
#import "JsonFormatRequester.h"
@implementation GetGoldWrapper
- (void)jsonToObject:(NSDictionary *)dic {
  self.goldNum = dic[@"goldNum"];
  self.taskStatus = dic[@"taskStatus"];
  self.taskText = dic[@"taskText"];
  self.taskId = [SimuUtil changeIDtoStr:dic[@"taskId"]];
  self.balance = dic[@"balance"];
}

+ (void)requestGetGoldWithCallback:(HttpRequestCallBack *)callback
                         andTaskId:(NSString *)taskId {
  NSString *url = [user_address
      stringByAppendingString:@"jhss/task/getGold?taskId={taskId}"];
  NSDictionary *dic = @{ @"taskId" : taskId };
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[GetGoldWrapper class]
             withHttpRequestCallBack:callback];
}

+ (void)requestDoTaskWithCallback:(HttpRequestCallBack *)callback
                        andTaskId:(NSString *)taskId {
  NSString *url = [user_address
      stringByAppendingString:@"jhss/task/doTask?taskId={taskId}"];
  NSDictionary *dic = @{ @"taskId" : taskId };
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[GetGoldWrapper class]
             withHttpRequestCallBack:callback];
}

+ (void)saveInviteCodeWithCallback:(HttpRequestCallBack *)callback
                     andInviteCode:(NSString *)inviteCode {
  NSString *url = [user_address
      stringByAppendingString:
          @"jhss/task/writeInviteCode?inviteCode={inviteCode}&imei={imei}"];
  NSString *ucode = [SimuUtil getUUID];
  NSDictionary *dic = @{ @"inviteCode" : inviteCode, @"imei" : ucode };
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[GetGoldWrapper class]
             withHttpRequestCallBack:callback];
}
@end
