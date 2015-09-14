//
//  WFTodayTransactionData.m
//  SimuStock
//
//  Created by moulin wang on 15/4/19.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "WFTodayTransactionData.h"
#import "WFDataSharingCenter.h"

#import "RealTradeTodayEntrust.h"

@implementation WFTodayJosnData
//解析  查询当日成交
- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  NSArray *resultArray = dic[@"result"];
  self.todayDataMutableArray = [NSMutableArray array];
  for (NSDictionary *subDict in resultArray) {
    RealTradeTodayEntrustItem *toydayJsonData = [[RealTradeTodayEntrustItem alloc] init];
    // 1股票代码
    toydayJsonData.stockCode = subDict[@"stockCode"];
    // 2股票名称
    toydayJsonData.stockName = subDict[@"stockName"];
    // 3委托方向(1=买入,2=卖出)
    toydayJsonData.type = subDict[@"entrustDirection"];
    // 4委托价格
    toydayJsonData.price = subDict[@"entrustPrice"];
    // 5委托数量
    toydayJsonData.amount = [subDict[@"entrustAmount"] longLongValue];
    // 6委托时间
    toydayJsonData.time = subDict[@"entrustTime"];
   
    // 7委托状态
    toydayJsonData.status = subDict[@"entrustStatus"];
    //加入数组
    [self.todayDataMutableArray addObject:toydayJsonData];
  }
}

@end

@implementation WFTodayTransactionData

//查询今日成交数据
+ (void)requestTodayTransactionDataWithCallback:(HttpRequestCallBack *)callback
{
  NSString *url =
  [NSString stringWithFormat:@"%@/findDayWinBargain",WF_Trade_Address];
  NSString *hsUserId = [WFDataSharingCenter shareDataCenter].hsUserId;
  NSString *homsFundAccount = [WFDataSharingCenter shareDataCenter].homsFundAccount;
  NSString *homsCombineId = [WFDataSharingCenter shareDataCenter].homsCombineld;
  NSDictionary *dic = @{
                        @"hsUserId" : hsUserId,
                        @"homsFundAccount" : homsFundAccount,
                        @"homsCombineId" : homsCombineId
                        };
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"POST"
               withRequestParameters:dic
              withRequestObjectClass:[WFTodayJosnData class]
             withHttpRequestCallBack:callback];
}

@end
