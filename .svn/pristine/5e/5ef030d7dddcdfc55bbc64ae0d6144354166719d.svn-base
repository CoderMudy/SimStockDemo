//
//  WFCancellationCapitalData.m
//  SimuStock
//
//  Created by moulin wang on 15/4/19.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "WFCancellationCapitalData.h"
#import "RealTradeTodayEntrust.h"
#import "WFDataSharingCenter.h"

@implementation WFCapitalCancellData
@end

@implementation WFcancellData

//查询当日委托 数据模型
- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  NSArray *resultArray = dic[@"result"];
  if (resultArray.count == 0 || resultArray == nil) {
    return;
  }
  self.capitalCancellList = [[NSMutableArray alloc] init];
  self.tradeTodayEntrustItemArray = [[NSMutableArray alloc] init];
  for (NSDictionary *subDict in resultArray) {
    WFCapitalCancellData *capitalCancellData =
        [[WFCapitalCancellData alloc] init];
    //子账号
    capitalCancellData.homsCombineId = subDict[@"homsCombineId"];
    //主账号
    capitalCancellData.homsFundAccount = subDict[@"homsFundAccount"];
    //恒生用户编号
    capitalCancellData.hsUserId = subDict[@"hsUserId"];
    [self.capitalCancellList addObject:capitalCancellData];

    RealTradeTodayEntrustItem *entrustItem =
        [[RealTradeTodayEntrustItem alloc] init];
    //委托数量
    entrustItem.amount = [subDict[@"entrustAmount"] longLongValue];
    //委托类别
    entrustItem.type = subDict[@"entrustDirection"];
    //委托编号
    entrustItem.commissionId = subDict[@"entrustNo"];
    //委托价格
    entrustItem.price = subDict[@"entrustPrice"];
    //委托状态
    entrustItem.status = subDict[@"entrustStatus"];
    //委托时间
    NSString *dateTime = subDict[@"entrustTime"];
    NSArray *array = [dateTime componentsSeparatedByString:@" "];
    entrustItem.entrustDate = array[0];
    entrustItem.time = array[1];
    //可撤标志 1：可以撤单 0：不可以撤单
    entrustItem.flag = [subDict[@"flag"] integerValue];

    entrustItem.stockCode = subDict[@"stockCode"];
    entrustItem.stockName = subDict[@"stockName"];
    [self.tradeTodayEntrustItemArray addObject:entrustItem];
  }
}

@end

//撤单
@implementation WFEvacuateBillData

- (void)jsonToObject:(NSDictionary *)dic {
  self.message = dic[@"status"];
  self.status = dic[@"message"];
  self.data = dic[@"data"];
}

@end

@implementation WFCancellationCapitalData
/** 查询当日委托 */
+ (void)requestCancellationCapitalWithHsUserid:(NSString *)hsUserID
                           withHomsFundAccount:(NSString *)homsFundAccount
                             withHomsCombineld:(NSString *)homsCombineld
                             withEntrustStatus:(NSString *)entrustStatus
                                  withCallBack:(HttpRequestCallBack *)callback {
  NSString *url =
      [NSString stringWithFormat:@"%@/findDayEntrustResult", WF_Trade_Address];
  NSDictionary *dic = @{
    @"hsUserId" : hsUserID,
    @"homsFundAccount" : homsFundAccount,
    @"homsCombineId" : homsCombineld
  };
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"POST"
               withRequestParameters:dic
              withRequestObjectClass:[WFcancellData class]
             withHttpRequestCallBack:callback];
}

+ (void)requestCancellationCapitalData:(HttpRequestCallBack *)callback {
  NSString *url =
      [NSString stringWithFormat:@"%@/findDayEntrustResult", WF_Trade_Address];
  // 股票代码 委托类别 买 卖  股票可用数量 委托价格
  NSString *hsUserID = [WFDataSharingCenter shareDataCenter].hsUserId;
  NSString *homsFundAccount =
      [WFDataSharingCenter shareDataCenter].homsFundAccount;
  NSString *homsCombineId = [WFDataSharingCenter shareDataCenter].homsCombineld;
  NSDictionary *dic = @{
    @"hsUserId" : hsUserID,
    @"homsFundAccount" : homsFundAccount,
    @"homsCombineId" : homsCombineId
  };
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"POST"
               withRequestParameters:dic
              withRequestObjectClass:[WFcancellData class]
             withHttpRequestCallBack:callback];
}

/** 撤单请求 */
+ (void)requestCapitalEvacuateBillWithHsUserid:(NSString *)hsUserID
                           withHomsFundAccount:(NSString *)homsFundAccount
                             withHomsCombineld:(NSString *)homsCombineld
                                 withEntrustNo:(NSString *)entrustNo
                                  withCallBack:(HttpRequestCallBack *)callback {
  NSString *url =
      [NSString stringWithFormat:@"%@/evacuateBill", WF_Trade_Address];
  NSDictionary *dic = @{
    @"hsUserId" : hsUserID,
    @"homsFundAccount" : homsFundAccount,
    @"homsCombineId" : homsCombineld,
    @"entrustNo" : entrustNo
  };
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"POST"
               withRequestParameters:dic
              withRequestObjectClass:[WFEvacuateBillData class]
             withHttpRequestCallBack:callback];
}

+ (void)requestCapitalEvacuateBillWithEntrustNo:
            (NSString *)entrustNo withCallback:(HttpRequestCallBack *)callback {
  NSString *url =
      [NSString stringWithFormat:@"%@/evacuateBill", WF_Trade_Address];

  // 股票代码 委托类别 买 卖  股票可用数量 委托价格
  NSString *hsUserID = [WFDataSharingCenter shareDataCenter].hsUserId;
  NSString *homsFundAccount =
      [WFDataSharingCenter shareDataCenter].homsFundAccount;
  NSString *homsCombineId = [WFDataSharingCenter shareDataCenter].homsCombineld;
  NSDictionary *dic = @{
    @"hsUserId" : hsUserID,
    @"homsFundAccount" : homsFundAccount,
    @"homsCombineId" : homsCombineId,
    @"entrustNo" : entrustNo
  };
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"POST"
               withRequestParameters:dic
              withRequestObjectClass:[WFEvacuateBillData class]
             withHttpRequestCallBack:callback];
}

@end
