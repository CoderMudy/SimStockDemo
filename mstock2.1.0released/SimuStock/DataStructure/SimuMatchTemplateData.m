//
//  SimuMatchData.m
//  SimuStock
//
//  Created by Yuemeng on 14-11-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SimuMatchTemplateData.h"
#import "JsonFormatRequester.h"

@implementation SimuMatchTemplateData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];

  //获得比赛模板
  NSArray *array = dic[@"result"];
  self.dataArray = [[NSMutableArray alloc] init];
  for (NSDictionary *subDict in array) {
    SimuMatchTemplateData *matchData = [[SimuMatchTemplateData alloc] init];
    matchData.mTemplateID = [SimuUtil changeIDtoStr:subDict[@"id"]];
    matchData.mTemplateName = [SimuUtil changeIDtoStr:subDict[@"name"]];
    matchData.mTemplateRank = [SimuUtil changeIDtoStr:subDict[@"rank"]];
    matchData.mCreateFee = [SimuUtil changeIDtoStr:subDict[@"createFee"]];
    matchData.mCreateFlag = [SimuUtil changeIDtoStr:subDict[@"createFlag"]];
    matchData.mSignupFee = [SimuUtil changeIDtoStr:subDict[@"signupFee"]];
    matchData.mSignupFlag = [SimuUtil changeIDtoStr:subDict[@"signupFlag"]];
    [self.dataArray addObject:matchData];
  }
}

+ (void)requestSimuMatchTemplateDataWithCallback:
    (HttpRequestCallBack *)callback {

  NSString *url = [data_address
      stringByAppendingString:@"youguu/match/matchTemplateList?category=1032"];
  //  金币模板：1032

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];

  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[SimuMatchTemplateData class]
             withHttpRequestCallBack:callback];
}

@end
