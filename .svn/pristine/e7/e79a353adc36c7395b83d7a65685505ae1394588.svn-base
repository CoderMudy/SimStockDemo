//
//  SimuValidateMatchData.m
//  SimuStock
//
//  Created by Yuemeng on 14-11-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SimuValidateMatchData.h"
#import "JsonFormatRequester.h"
#import "SimuOpenMatchData.h"
#import "CommonFunc.h"

@implementation SimuValidateMatchData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];

  self.status = dic[@"status"];
  self.message = dic[@"message"];
  NSLog(@"222 = %@", self.message);
  if ([dic[@"status"] isEqualToString:@"0219"]) {
    self.errorDictionary = dic[@"result"];
    NSLog(@"111 = %@", self.errorDictionary);
  }
}

+ (void)requestSimuValidateMatchDataWtihMatchName:(NSString *)matchName
                                    withStartTime:(NSString *)startTime
                                      withEndTime:(NSString *)endTime
                           withTempInvitationCode:(NSString *)tempInvitationCode
                                   withTemplateID:(NSString *)templateID
                                     withCallback:(HttpRequestCallBack *)callback {
  NSString *url;

  if (tempInvitationCode.length > 0) {
    url = [NSString stringWithFormat:@"%@youguu/match/"
                                     @"validateMatch?matchName=%@&openTime=%@&closeTime="
                                     @"%@&inviteCode=%@&templateId=%@",
                                     data_address, matchName, startTime, endTime,
                                     tempInvitationCode, templateID];
  } else {
    url = [NSString stringWithFormat:@"%@youguu/match/"
                                     @"validateMatch?matchName=%@&openTime=%@&closeTime="
                                     @"%@&templateId=%@",
                                     data_address, matchName, startTime, endTime, templateID];
  }

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[SimuValidateMatchData class]
             withHttpRequestCallBack:callback];
}

+ (void)requestSimuValidateMatchDataWtihMatchInfo:(MatchCreateMatchInfo *)matchInfo
                                     withCallback:(HttpRequestCallBack *)callback {
  NSString *url;

  if (matchInfo.inviteCode.length > 0) {
    url = [NSString
        stringWithFormat:@"%@youguu/match/" @"validateMatch?matchName=%@&openTime=%@&closeTime="
                         @"%@&inviteCode=%@&templateId=%@",
                         data_address, [CommonFunc base64StringFromText:matchInfo.matchName],
                         matchInfo.openTime, matchInfo.closeTime, matchInfo.inviteCode,
                         matchInfo.templateId];
  } else {
    url = [NSString
        stringWithFormat:@"%@youguu/match/" @"validateMatch?matchName=%@&openTime=%@&closeTime="
                         @"%@&templateId=%@",
                         data_address, [CommonFunc base64StringFromText:matchInfo.matchName],
                         matchInfo.openTime, matchInfo.closeTime, matchInfo.templateId];
  }

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[SimuValidateMatchData class]
             withHttpRequestCallBack:callback];
}

@end
