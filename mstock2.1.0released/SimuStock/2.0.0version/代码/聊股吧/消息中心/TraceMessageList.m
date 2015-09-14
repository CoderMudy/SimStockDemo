//
//  TraceMessageList.m
//  SimuStock
//
//  Created by jhss on 15/6/30.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "TraceMessageList.h"
#import "SimuUtil.h"
#import "JsonFormatRequester.h"
#import "WeiboUtil.h"

@implementation TraceMsgData

- (void)jsonToObject:(NSDictionary *)dic {
  self.superUid = [SimuUtil changeIDtoStr:dic[@"superUid"]];
  self.accountId = [SimuUtil changeIDtoStr:dic[@"accountId"]];

  self.title = dic[@"title"];

  self.seq = [SimuUtil changeIDtoStr:dic[@"seq"]];

  self.type = [SimuUtil changeIDtoStr:dic[@"type"]];

  self.subType = [SimuUtil changeIDtoStr:dic[@"subType"]];

  self.time = [dic[@"time"] longLongValue];

  self.source = dic[@"source"];

  //时间转换成用户可读模式
  NSDate *date =
      [[NSDate alloc] initWithTimeIntervalSince1970:self.time / 1000.0];
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
  NSString *data_content = [dateFormatter stringFromDate:date];
  self.mstrTime = [SimuUtil changeAbsuluteTimeToRelativeTime:data_content];

  self.des = dic[@"des"];

  switch ([self.subType integerValue]) {
  case STATE_Sell:
  case STATE_Buy: {
    self.stockCode = [WeiboUtil getAttrValueWithSource:self.des
                                           withElement:@"stock"
                                              withAttr:@"code"];
    self.stockName = [WeiboUtil getAttrValueWithSource:self.des
                                           withElement:@"stock"
                                              withAttr:@"name"];
  } break;

  default:
    break;
  }
}
@end

@implementation TraceMessageList
- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.dataArray = [[NSMutableArray alloc] init];
  NSArray *array = dic[@"list"];
  for (NSDictionary *dic in array) {
    TraceMsgData *item = [[TraceMsgData alloc] init];
    [item jsonToObject:dic];
    [self.dataArray addObject:item];
  }
}
- (NSArray *)getArray {
  return _dataArray;
}

+ (void)requestTraceMessageListWithInput:(NSDictionary *)dic
                            withCallback:(HttpRequestCallBack *)callback {

  NSString *url = [data_address
      stringByAppendingString:@"msg/tracemsg/list?seq={seq}&limit=20"];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[TraceMessageList class]
             withHttpRequestCallBack:callback];
}

+ (void)requestRefundWithAccoundId:(NSString *)accountId
                  andWithTargetUid:(NSString *)targetUid
                      withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [user_address
      stringByAppendingString:@"youguu/super_trade/"
      @"refund_trace?accountId={accountId}&targetUid={" @"targetUid}"];
  NSDictionary *dic = @{ @"accountId" : accountId, @"targetUid" : targetUid };
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[TraceMessageList class]
             withHttpRequestCallBack:callback];
}
@end
