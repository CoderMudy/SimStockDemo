//
//  StockMasterListWrapper.m
//  SimuStock
//
//  Created by moulin wang on 14-11-17.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

/**类说明（牛人四项，总盈利榜，成功率榜，月盈利榜，周盈利榜，还有跟踪判定绑定）*/
#import "StockMasterListWrapper.h"
#import "JsonFormatRequester.h"
#import "DeadlineItem.h"
//#import "SimuUtil.h"

#pragma mark-----（1）判断用户是否有跟踪权限-----
@implementation StockMasterRuleGetListWrapper
//数据解析
- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.dataArrayRule = [[NSMutableArray alloc] init];
  NSDictionary *obj = dic[@"result"];
  DeadlineItem *item = [[DeadlineItem alloc] init];
  self.isShowDeadlineStr = obj[@"tip"];
  self.isDeadlineStr = obj[@"expire"];
  if ([self.isDeadlineStr integerValue]) { //显示过期时间
    item.isShowDeadline = YES;
  } else {
    item.isShowDeadline = NO;
  }
  if ([self.isShowDeadlineStr integerValue]) { //是否显示续费
    item.isShowRenewBtn = YES;
  } else {
    item.isShowRenewBtn = NO;
  }
  //过期时间
  item.deadLineStr = obj[@"expireAt"];
  [self.dataArrayRule addObject:item];
}

// rule/get部分
+ (void)requestStockMastrbackListRuleGetWithCallback:
    (HttpRequestCallBack *)callback {
  NSString *url =
      [data_address stringByAppendingString:@"youguu/trace/rule/get"];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[StockMasterRuleGetListWrapper class]
             withHttpRequestCallBack:callback];
}
@end

#pragma mark-----（2）用户利率最高值------
@implementation StockMasterHighestListWrapper
//数据解析
- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.total = [SimuUtil changeIDtoStr:dic[@"total"]];
  self.suc = [SimuUtil changeIDtoStr:dic[@"suc"]];
  self.month = [SimuUtil changeIDtoStr:dic[@"month"]];
  self.week = [SimuUtil changeIDtoStr:dic[@"week"]];
}
// highest部分
+ (void)requestStockMastrbackListHighestWithCallback:
    (HttpRequestCallBack *)callback {
  NSString *url =
      [data_address stringByAppendingString:@"youguu/rank/highest/"];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[StockMasterHighestListWrapper class]
             withHttpRequestCallBack:callback];
}
@end
