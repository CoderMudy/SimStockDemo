//
//  TracingPageRequest.m
//  SimuStock
//
//  Created by jhss on 14-11-19.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "TracingPageRequest.h"
#import "TraceItem.h"
#import "DeadlineItem.h"
#import "UserListItem.h"

@implementation TracingPageRequest

- (void)jsonToObject:(NSDictionary *)obj {
  [super jsonToObject:obj];
  self.dataArray = [[NSMutableArray alloc] init];
  NSArray *array = obj[@"result"];
  if (array == nil)
    return;
  for (NSDictionary *subDict in array) {
    TraceItem *item = [[TraceItem alloc] init];
    if (item) {
      item.mFollowMid = [SimuUtil changeIDtoStr:subDict[@"followMid"]];
      item.mFollowUid = [SimuUtil changeIDtoStr:subDict[@"followUid"]];
      item.mNick = subDict[@"nick"];
      item.mPhoto = subDict[@"photo"];
      item.mProfitRate = [SimuUtil changeIDtoStr:subDict[@"profitRate"]];
      item.mSeqid = [SimuUtil changeIDtoStr:subDict[@"seqId"]];
      item.mVipType = subDict[@"vipType"];
      [self.dataArray addObject:item];

      item.userListItem = [[UserListItem alloc] init];
      item.userListItem.userId =
          @([[SimuUtil changeIDtoStr:subDict[@"followUid"]] longLongValue]);
      item.userListItem.nickName = subDict[@"nick"];
      item.userListItem.rating = subDict[@"rating"];
      item.userListItem.vipType = [subDict[@"vipType"] intValue];
      item.userListItem.stockFirmFlag =
          [SimuUtil changeIDtoStr:subDict[@"stockFirmFlag"]];
    }
  }
}

- (NSArray *)getArray
{
  return _dataArray;
}

+ (void)tracingListWithFromId:(NSString *)fromId
                   withNumber:(NSString *)number
                   withUserID:(NSString *)userId
                 withCallback:(HttpRequestCallBack *)callback {
  NSString *url = data_address;
  url = [url stringByAppendingString:@"youguu/trace/following/list"];
  if (userId) {
    url = [url stringByAppendingFormat:@"?fromid=%@&reqnum=%@&userid=%@",
                                       fromId, number, userId];
  } else {
    url = [url stringByAppendingFormat:@"?fromid=%@&reqnum=%@&userid=%@",
                                       fromId, number, [SimuUtil getUserID]];
  }
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[TracingPageRequest class]
             withHttpRequestCallBack:callback];
}

+ (void)tracingListWithParameters:(NSDictionary *)parameters
                     withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [data_address
      stringByAppendingString:
          @"youguu/trace/following/list?fromid={fromid}&reqnum={reqnum}&userid={userid}"];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:parameters
              withRequestObjectClass:[TracingPageRequest class]
             withHttpRequestCallBack:callback];
}

@end

@implementation CancelTracing

+ (void)cancelTracingWithFollowUid:(NSString *)followUid
                     withFollowMid:(NSString *)followMid
                      withCallback:(HttpRequestCallBack *)callback {
  NSString *url = data_address;
  url = [url stringByAppendingString:@"youguu/trace/following/del"];
  url = [url stringByAppendingFormat:@"?follow_uid=%@&follow_mid=%@", followUid,
                                     followMid];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[CancelTracing class]
             withHttpRequestCallBack:callback];
}

@end

@implementation DeadLineRequest

- (void)jsonToObject:(NSDictionary *)obj {
  [super jsonToObject:obj];
  //截止日期
  NSDictionary *dict = obj[@"result"];
  if (dict == nil)
    return;
  DeadlineItem *item = [[DeadlineItem alloc] init];
  self.dataArray = [[NSMutableArray alloc] init];
  NSString *isShowDeadlineStr = [SimuUtil changeIDtoStr:dict[@"tip"]];
  NSString *isDeadlineStr = [SimuUtil changeIDtoStr:dict[@"expire"]];
  if ([isDeadlineStr integerValue]) {
    //显示过期时间
    item.isShowDeadline = YES;
  } else {
    item.isShowDeadline = NO;
  }
  if ([isShowDeadlineStr integerValue]) {
    //是否显示续费
    item.isShowRenewBtn = YES;
  } else {
    item.isShowRenewBtn = NO;
  }
  //过期时间
  item.deadLineStr = [SimuUtil changeIDtoStr:dict[@"expireAt"]];
  [self.dataArray addObject:item];
}

+ (void)getDeadLineWithCallback:(HttpRequestCallBack *)callback {
  NSString *url = data_address;
  url = [url stringByAppendingString:@"youguu/trace/rule/get"];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[DeadLineRequest class]
             withHttpRequestCallBack:callback];
}

@end
