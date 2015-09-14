//
//  SimuCompetitionMillionCycleData.m
//  SimuStock
//
//  Created by Yuemeng on 14-11-18.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SimuCompetitionMillionCycleData.h"
#import "JsonFormatRequester.h"

@implementation SimuCompetitionMillionCycleData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.dataArray = [[NSMutableArray alloc] init];
  SimuCompetitionMillionCycleData *data =
      [[SimuCompetitionMillionCycleData alloc] init];
  data.myDiamond = [dic[@"myDiamond"] integerValue];
  data.list = dic[@"list"];
  [self.dataArray addObject:data];
}

+ (void)requestSimuCompetitionMillionCycleDataWithMid:
            (NSString *)mid withCallback:(HttpRequestCallBack *)callback {

  NSString *url = data_address;
  url = [url
      stringByAppendingFormat:@"youguu/match/getUserAccount?matchId=%@", mid];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[SimuCompetitionMillionCycleData class]
             withHttpRequestCallBack:callback];
}

@end
