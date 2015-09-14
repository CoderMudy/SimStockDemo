//
//  HotStockTopicListData.m
//  SimuStock
//
//  Created by Yuemeng on 14-11-24.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "HotStockTopicListData.h"
#import "JsonFormatRequester.h"

@implementation HotStockTopicData
@end

/** 热门个股吧数据模型 */
@implementation HotStockTopicListData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];

  self.dataArray = [[NSMutableArray alloc] init];

  NSArray *hotStockTopicList = dic[@"result"];
  for (NSDictionary *subDic in hotStockTopicList) {
    HotStockTopicData *hotStockTopicData = [[HotStockTopicData alloc] init];
    [hotStockTopicData setValuesForKeysWithDictionary:subDic];
    [self.dataArray addObject:hotStockTopicData];
  }
}

+ (void)requestHotStockTopicListDataWithFromId:(NSNumber *)fromId
                                    withReqNum:(NSInteger)reqNum
                                  withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [istock_address stringByAppendingString:@"istock/newTalkStock/"
                                @"getHotStockTopicList?fromId={"
                                @"fromId}&reqNum={reqNum}"];

  NSDictionary *dic = @{
    @"fromId" : [fromId stringValue],
    @"reqNum" : [NSString stringWithFormat:@"%ld", (long)reqNum]
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[HotStockTopicListData class]
             withHttpRequestCallBack:callback];
}

@end
