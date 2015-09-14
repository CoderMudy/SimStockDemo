//
//  SimuRankPageData.m
//  SimuStock
//
//  Created by Mac on 13-8-15.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "SimuRankPageData.h"
#import "JsonFormatRequester.h"

@implementation SimuRankPageData

-(void)jsonToObject:(NSDictionary *)dic{
  [super jsonToObject:dic];
  self.tRank=[dic[@"tRank"] stringValue];
  
  self.tRise=[dic[@"tRise"] stringValue];
  
  self.tProfit=dic[@"tProfit"];

  self.wRank=[dic[@"wRank"] stringValue];

  self.wRise=[dic[@"wRise"] stringValue];
  
  self.wProfit=dic[@"wProfit"];

  self.mRank=[dic[@"mRank"] stringValue];
  
  self.mRise=[dic[@"mRise"] stringValue];
  
  self.mProfit=dic[@"mProfit"];
}

//-(void) jsonToObject:(NSDictionary *)dic{
//  //周盈利率
//  self.wProfit = [dic[@"wProfit"] stringValue];
//  //周排行
//  NSString *hird_wRank = [NSString stringWithFormat:@"%d",[dic[@"wRank"] integerValue]];
//  self.wRank = [SimuUtil changeIDtoStr:hird_wRank];
//  //周上升名次
//  NSString *hird_wRise = [NSString stringWithFormat:@"%d",[dic[@"wRise"] integerValue]];
//  self.wRise = [SimuUtil changeIDtoStr:hird_wRise];
//  //月盈利率
//  NSString *hird_mProfit = dic[@"mProfit"];
//  self.mProfit = [SimuUtil changeIDtoStr:hird_mProfit];
//  //月排行
//  NSString *hird_mRank = [NSString stringWithFormat:@"%d",[dic[@"mRank"] integerValue]];
//  self.mRank = [SimuUtil changeIDtoStr:hird_mRank];
//  //月上升名次
//  NSString *hird_mRise = [NSString stringWithFormat:@"%d",[dic[@"mRise"] integerValue]];
//  self.mRise = [SimuUtil changeIDtoStr:hird_mRise];
//  //总盈利率
//  NSString *hird_tProfit = dic[@"tProfit"];
//  self.tProfit = [SimuUtil changeIDtoStr:hird_tProfit];
//  //总排行
//  NSString *hird_tRank = [NSString stringWithFormat:@"%d",[dic[@"tRank"] integerValue]];
//  self.tRank = [SimuUtil changeIDtoStr:hird_tRank];
//  //总上升名次
//  NSString *hird_tRise = [NSString stringWithFormat:@"%d",[dic[@"tRise"] integerValue]];
//  self.tRise = [SimuUtil changeIDtoStr:hird_tRise];
//}

+ (void)requestRankInfoWithUser:(NSString*) userId withMatchId:(NSString*) matchId withCallback:(HttpRequestCallBack*) callback {
  
  NSString *url = [data_address
                   stringByAppendingString:
                   @"youguu/simtrade/showmyrank/{ak}/{sid}/{userid}/{matchid}"];
  
  NSDictionary *dic = @{ @"userid" : userId, @"matchid" : matchId };
  
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[SimuRankPageData class]
             withHttpRequestCallBack:callback];
  
}

@end
