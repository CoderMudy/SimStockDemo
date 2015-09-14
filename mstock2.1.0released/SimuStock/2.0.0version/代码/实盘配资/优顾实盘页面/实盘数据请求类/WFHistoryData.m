//
//  WFHistoryData.m
//  SimuStock
//
//  Created by moulin wang on 15/5/4.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "WFHistoryData.h"
#import "WFDataSharingCenter.h"

@implementation WFHistoryInfoMode

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  //解析
  NSArray *resultArray = dic[@"result"];
  if (resultArray.count == 0 || resultArray == nil) {
    return;
  }
  self.historyArray = [[NSMutableArray alloc] init];
  for (NSDictionary *subDict in resultArray) {
    WFHistoryInfoMode *mode = [[WFHistoryInfoMode alloc] init];
    mode.stockCode = subDict[@"stockCode"];
    mode.stockName = subDict[@"stockName"];
    mode.entrustDirection = subDict[@"entrustDirection"];
    mode.businessAmount = subDict[@"businessAmount"];
    mode.businessTime = subDict[@"businessTime"];
    mode.businessPrice = subDict[@"businessPrice"];
    [self.historyArray addObject:mode];
  }
}

@end

@implementation WFHistoryData
/** 历史成交数据请求 */
+ (void)requestHistoryDataWithBeginTime:(NSString *)beginTime
                             andEndTime:(NSString *)endTime
                               withStat:(NSString *)stat
                           withCallback:(HttpRequestCallBack *
                                         )callback {
  NSString *url =
  [NSString stringWithFormat:@"%@/findHistoryWinBargain",
   WF_Trade_Address];
  
  NSString *hsUserId = [WFDataSharingCenter shareDataCenter].hsUserId;
  NSString *homsFundAccount =
  [WFDataSharingCenter shareDataCenter].homsFundAccount;
  NSString *homsCombineld = [WFDataSharingCenter shareDataCenter].homsCombineld;
  
  NSDictionary *dic = @{
                        @"hsUserId" : hsUserId,
                        @"homsFundAccount" : homsFundAccount,
                        @"homsCombineId" : homsCombineld,
                        @"beginTime" : beginTime,
                        @"endTime" : endTime,
                        @"start" : stat,
                        @"size" : @"20"
                        };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"POST"
               withRequestParameters:dic
              withRequestObjectClass:[WFHistoryInfoMode class]
             withHttpRequestCallBack:callback];
  
}

@end
