//
//  SimuOpenMatchData.m
//  SimuStock
//
//  Created by Yuemeng on 14-11-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SimuOpenMatchData.h"
#import "JsonFormatRequester.h"
#import "CommonFunc.h"

@implementation MatchCreateUniversityInfo

@end

@implementation MatchCreateMatchInfo

@end

@implementation MatchCreateAwardInfo

@end

@implementation SimuOpenMatchData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.dataArray = [[NSMutableArray alloc] init];

  NSMutableDictionary *matchDict = [[NSMutableDictionary alloc] init];
  matchDict[@"userId"] = [SimuUtil changeIDtoStr:dic[@"userId"]];
  matchDict[@"matchId"] = [SimuUtil changeIDtoStr:dic[@"matchId"]];
  matchDict[@"matchName"] = [SimuUtil changeIDtoStr:dic[@"matchName"]];
  matchDict[@"matchDescp"] = [SimuUtil changeIDtoStr:dic[@"matchDescp"]];
  matchDict[@"openTime"] = [SimuUtil changeIDtoStr:dic[@"openTime"]];
  matchDict[@"closeTime"] = [SimuUtil changeIDtoStr:dic[@"closeTime"]];
  matchDict[@"background"] = [SimuUtil changeIDtoStr:dic[@"background"]];
  matchDict[@"creator"] = [SimuUtil changeIDtoStr:dic[@"creator"]];
  matchDict[@"inviteCode"] = [SimuUtil changeIDtoStr:dic[@"inviteCode"]];
  [self.dataArray addObject:matchDict];
}

+ (void)requestSimuOpenMatchDataWithUsername:(NSString *)username
                               withMatchName:(NSString *)matchName
                        withMatchDescription:(NSString *)matchDestciption
                               withStartTime:(NSString *)startTime
                                 withEndTime:(NSString *)endTime
                      withTempInvitationCode:(NSString *)tempInvitationCode
                              withTemplateId:(NSString *)templateId
                                withCallback:(HttpRequestCallBack *)callback {
  NSString *url;
  if (tempInvitationCode.length > 0) {
    url = [NSString
        stringWithFormat:@"%@youguu/match/" @"openMatch?userName=%@&matchName=%@&matchDescp=%@&" @"openTime=%@&closeTime=%@&inviteCode=%@&templateId=%@",
                         data_address, username, matchName, matchDestciption, startTime, endTime, tempInvitationCode, templateId];
  } else {
    url = [NSString
        stringWithFormat:@"%@youguu/match/" @"openMatch?userName=%@&matchName=%@&matchDescp=%@&" @"openTime=%@&closeTime=%@&templateId=%@",
                         data_address, username, matchName, matchDestciption, startTime, endTime, templateId];
  }

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[SimuOpenMatchData class]
             withHttpRequestCallBack:callback];
}

+ (void)requestMatchCreateWithMatchInfo:(MatchCreateMatchInfo *)matchInfo
                         universityInfo:(MatchCreateUniversityInfo *)universityInfo
                              awardInfo:(MatchCreateAwardInfo *)awardInfo
                           withCallback:(HttpRequestCallBack *)callback {
  NSString *matchName = [CommonFunc base64StringFromText:matchInfo.matchName];
  NSString *matchDescp = [CommonFunc base64StringFromText:matchInfo.matchDescp];
  NSString *url = [NSString
      stringWithFormat:@"%@youguu/match/" @"openMatch?userName=%@&matchName=%@&matchDescp=%@&"
                       @"openTime=%@&closeTime=%@&templateId=%@" @"&isReward=%@&isSenior=%@",
                       data_address, [CommonFunc base64StringFromText:matchInfo.userName], matchName, matchDescp,
                       matchInfo.openTime, matchInfo.closeTime, matchInfo.templateId, awardInfo.isReward, universityInfo.isSenior];
  if (matchInfo.hasInviteCode && matchInfo.inviteCode.length > 0) {
    url = [url stringByAppendingString:[NSString stringWithFormat:@"&inviteCode=%@", matchInfo.inviteCode]];
  }
  if ([awardInfo.isReward boolValue]) {
    url = [url stringByAppendingString:[NSString stringWithFormat:@"&reward=%@", [CommonFunc base64StringFromText:awardInfo.reward]]];
  }
  if ([universityInfo.isSenior boolValue]) {
    url = [url stringByAppendingString:[NSString stringWithFormat:@"&purpose=%@&seniorSchool=%@", [CommonFunc base64StringFromText:universityInfo.purpose],
                                                                  [CommonFunc base64StringFromText:universityInfo.seniorSchool]]];
  }

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[SimuOpenMatchData class]
             withHttpRequestCallBack:callback];
}

@end
