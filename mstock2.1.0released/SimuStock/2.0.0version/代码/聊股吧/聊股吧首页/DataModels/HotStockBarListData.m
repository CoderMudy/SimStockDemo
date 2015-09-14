//
//  HotStockBarListData.m
//  SimuStock
//
//  Created by Yuemeng on 14-11-24.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "HotStockBarListData.h"
#import "JsonFormatRequester.h"

@implementation HotStockBarData
@end

@implementation HotStockBarListData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];

  self.dataArray = [[NSMutableArray alloc] init];

  NSArray *hotStockBars = dic[@"result"];
  for (NSDictionary *subDic in hotStockBars) {
    HotStockBarData *hotStockBarData = [[HotStockBarData alloc] init];
    [hotStockBarData setValuesForKeysWithDictionary:subDic];
    [self.dataArray addObject:hotStockBarData];
  }
}

/** 0：主题吧和1：牛人吧 */
+ (void)requestHotStockBarListDataWithFromId:(NSNumber *)fromId
                                  withReqNum:(NSInteger)reqNum
                                    withType:(NSInteger)type
                                withCallback:(HttpRequestCallBack *)callback {
  NSString *url =
      [istock_address stringByAppendingString:@"istock/newTalkStock/"
                    @"getStockBarList?fromId={" @"fromId}&reqNum={reqNum}&type={type}"];

  NSDictionary *dic = @{
    @"fromId" : [fromId stringValue],
    @"reqNum" : [NSString stringWithFormat:@"%ld", (long)reqNum],
    @"type" : [NSString stringWithFormat:@"%ld", (long)type]
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[HotStockBarListData class]
             withHttpRequestCallBack:callback];
}

/** 所有聊股吧接口 */
+ (void)requestHotStockBarListDataWithFromId:(NSNumber *)fromId withReqNum:(NSInteger)reqNum withCallback:(HttpRequestCallBack *)callback
{
  NSString *url =
  [istock_address stringByAppendingString:@"istock/newTalkStock/"
   @"getHotStockBarList?fromId={" @"fromId}&reqNum={reqNum}"];
  
  NSDictionary *dic = @{
                        @"fromId" : [fromId stringValue],
                        @"reqNum" : [NSString stringWithFormat:@"%ld", (long)reqNum],
                        };
  
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[HotStockBarListData class]
             withHttpRequestCallBack:callback];

}

@end
