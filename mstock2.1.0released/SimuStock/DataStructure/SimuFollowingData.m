//
//  SimuFollowingData.m
//  SimuStock
//
//  Created by Yuemeng on 14-11-17.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SimuFollowingData.h"
#import "JsonFormatRequester.h"

@implementation SimuFollowingData

- (void)jsonToObject:(NSDictionary *)dic
{
    [super jsonToObject:dic];
}


+ (void)requestFollowingWithUserId:(NSString *)userId
                       withMatchId:(NSString *)matchId
                         withIsAdd:(BOOL)isAdd
                      withCallback:(HttpRequestCallBack *)callback {

  NSString *url;
  if (isAdd) {
    url = [data_address stringByAppendingString:@"youguu/trace/following/"
                                                @"add?follow_uid={userid}&"
                                                @"follow_mid={matchId}"];
  } else {
    url = [data_address stringByAppendingString:@"youguu/trace/following/"
                                                @"del?follow_uid={userid}&"
                                                @"follow_mid={matchId}"];
  }

  NSDictionary *dic = @{ @"userid" : userId, @"matchId" : matchId };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[SimuFollowingData class]
             withHttpRequestCallBack:callback];
}

@end
