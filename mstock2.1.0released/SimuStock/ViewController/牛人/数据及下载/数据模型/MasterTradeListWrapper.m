//
//  MasterTradeListWrapper.m
//  SimuStock
//
//  Created by jhss on 15-4-28.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MasterTradeListWrapper.h"
#import "JsonFormatRequester.h"
@implementation ConcludesListItem
- (void)jsonToObject:(NSDictionary *)dic {
  self.content = dic[@"content"];
  self.stockCode =
      [WeiboUtil getAttrValueWithSource:self.content withElement:@"stock" withAttr:@"code"];
  self.stockName =
      [WeiboUtil getAttrValueWithSource:self.content withElement:@"stock" withAttr:@"name"];
  self.profitability = dic[@"profitability"];
  self.stability = dic[@"stability"];
  self.accuracy = dic[@"accuracy"];
  self.fiveDaysPr = dic[@"fiveDaysPr"];
  self.time = dic[@"time"];
  self.profitRate = dic[@"profitRate"];
}
@end

@implementation MasterTradeListWrapper
- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];

  NSDictionary *resultDict = dic[@"result"];

  /**userList节点解析*/
  UserListWrapper *userListWrapper = [[UserListWrapper alloc] init];
  [userListWrapper jsonToMap:resultDict[@"userList"]];

  self.concludesListArray = [[NSMutableArray alloc] init];
  NSDictionary *resultDic = dic[@"result"];
  NSArray *array = resultDic[@"concludes"];
  for (NSDictionary *subDic in array) {
    ConcludesListItem *item = [[ConcludesListItem alloc] init];
    //解析tmcList部分
    [item jsonToObject:subDic];
    //找到userList的uid
    NSString *uid = [SimuUtil changeIDtoStr:subDic[@"uid"]];
    item.writer = [userListWrapper getUserById:uid];
    [self.concludesListArray addObject:item];
  }
}

- (NSArray *)getArray {
  return _concludesListArray;
}

/** 请求牛人交易 */
+ (void)requestMasterTradeListWithInput:(NSDictionary *)dic
                           withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [data_address
      stringByAppendingString:@"youguu/newRank/concludes?from={from}&reqNum={reqNum}"];
  
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[MasterTradeListWrapper class]
             withHttpRequestCallBack:callback];
}

+ (void)requestVipTradeListWithInput:(NSDictionary *)dic
                        withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [data_address
      stringByAppendingString:@"youguu/newRank/vip_concludes?from={from}&reqNum={reqNum}"];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[MasterTradeListWrapper class]
             withHttpRequestCallBack:callback];
}
@end
