//
//  SimuJoinMatchData.m
//  SimuStock
//
//  Created by Yuemeng on 14-11-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SimuJoinMatchData.h"
#import "SimuUtil.h"
#import "JsonFormatRequester.h"

@implementation SimuJoinMatchData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];

  self.userId = [SimuUtil changeIDtoStr:dic[@"userId"]];
  self.matchId = [SimuUtil changeIDtoStr:dic[@"matchId"]];
  self.matchName = dic[@"matchName"];
}

+ (void)requestSimuJoinMatchDataWithNickName:(NSString *)nickName
                                 withMatchId:(NSString *)matchId
                                withCallback:(HttpRequestCallBack *)callback {
  NSString *url =
      [NSString stringWithFormat:@"%@youguu/match/joinMatch?nickName=%@&matchId=%@&flag=%d", data_address, nickName, matchId, 0];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[SimuJoinMatchData class]
             withHttpRequestCallBack:callback];
}

+ (void)requestSimuJoinMatchDataWithNickName:(NSString *)nickName
                              withInviteCode:(NSString *)inviteCode
                                 withMatchID:(NSString *)matchID
                                withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [NSString
      stringWithFormat:@"%@youguu/match/joinMatch?nickName=%@&inviteCode=%@&flag=%d&matchId=%@",
                       data_address, nickName, inviteCode, 1, matchID];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[SimuJoinMatchData class]
             withHttpRequestCallBack:callback];
}

@end
