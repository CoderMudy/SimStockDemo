//
//  SimuClosedDetailPageData.m
//  SimuStock
//
//  Created by moulin wang on 14-2-14.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SimuClosedDetailPageData.h"
#import "SimuUtil.h"
#import "JsonFormatRequester.h"
#import "WeiboUtil.h"

@implementation ClosedDetailInfo
- (id)init {
  self = [super init];
  if (self) {
    _heightCache = [[NSMutableDictionary alloc] init];
  }
  return self;
}
- (void)jsonToObject:(NSDictionary *)obj {
  self.seqID = [obj[@"seqId"] stringValue];
  self.type = [obj[@"stype"] stringValue];
  self.createTime = [SimuUtil changeAbsuluteTimeToRelativeTime:obj[@"ctime"]];
  self.content = obj[@"content"];
}

- (NSString *)stockCode {
  return [WeiboUtil getAttrValueWithSource:self.content withElement:@"stock" withAttr:@"code"];
}

- (NSString *)stockName {
  return [WeiboUtil getAttrValueWithSource:self.content withElement:@"stock" withAttr:@"name"];
}

@end

@implementation SimuClosedDetailPageData

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.closedDetailList = [[NSMutableArray alloc] init];
  NSArray *array = dic[@"result"];
  for (NSDictionary *dic in array) {
    ClosedDetailInfo *item = [[ClosedDetailInfo alloc] init];
    [item jsonToObject:dic];
    [self.closedDetailList addObject:item];
  }
}

- (NSArray *)getArray {
  return self.closedDetailList;
}

+ (void)requestClosedTradeDetailWithDic:(NSDictionary *)dic
                           withCallback:(HttpRequestCallBack *)callback {

  NSString *url = [data_address stringByAppendingString:@"youguu/position/closed/"
                                @"detail?userid={userid}&matchid={matchid}&"
                                @"positionid={positionid}&reqnum={reqnum}&" @"fromid={fromid}"];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[SimuClosedDetailPageData class]
             withHttpRequestCallBack:callback];
}

+ (void)requestPositionTradeDetailWithDic:(NSDictionary *)dic
                             withCallback:(HttpRequestCallBack *)callback {

  NSString *url = [data_address stringByAppendingString:@"youguu/position/current/"
                                @"detail?userid={userid}&matchid={matchid}&"
                                @"positionid={positionid}&reqnum={reqnum}&" @"fromid={fromid}"];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[SimuClosedDetailPageData class]
             withHttpRequestCallBack:callback];
}
/** 请求牛人计划的交易明细 */
+ (void)requestSuperTradeListWithParams:(NSDictionary *)dic
                           withCallback:(HttpRequestCallBack *)callback {

  NSString *url = [data_address stringByAppendingString:@"youguu/super_trade/"
                                @"conclude_query?accountId={accountId}&" @"targetUid={targetUid}&" @"reqNum={reqNum}&" @"fromId={fromId}"];
  if (dic[@"positionId"]) {
    url = [url stringByAppendingString:@"&positionId={positionId}"];
  }

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[SimuClosedDetailPageData class]
             withHttpRequestCallBack:callback];
}

@end
