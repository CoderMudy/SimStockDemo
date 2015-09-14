//
//  WFStockByData.m
//  SimuStock
//
//  Created by moulin wang on 15/4/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "WFStockByData.h"
#import "WFDataSharingCenter.h"
#import "JsonFormatRequester.h"

@implementation WFStockByInfoData

-(void)jsonToObject:(NSDictionary *)dic
{
  NSDictionary *resultDict = dic[@"result"];
  if (resultDict.count == 0 || resultDict == nil) {
    return;
  }
  self.message = dic[@"message"];
  self.status = dic[@"status"];
  //解析
  //股票名称
  self.stockName = resultDict[@"stockName"];
  //股票代码
  self.stockCode = resultDict[@"stockCode"];
  //停盘标志
  //self.suspend = [resultDict[@"tpflag"] intValue];
  self.stockInfoSuspend = resultDict[@"tpflag"];
  
  //股票类型
  self.stockType = resultDict[@"stockType"];
  //最大可买入数量
  self.entrustAmount = resultDict[@"maxNumber"];
  //涨停 跌停
  self.highPrice = resultDict[@"highLimitPrice"];
  self.lowPrice = resultDict[@"lowLimitPrice"];
  
  //最新价格
  self.latestPrice = resultDict[@"curPrice"];
  //昨天收盘价
  self.closePrice = resultDict[@"closePrice"];
  
  //委托价格
  self.entrustPrice = resultDict[@"entrustPrice"];
  //最小买入价格
  self.tradePrice = resultDict[@"minimumUnit"];
  //市场类型
  self.marketId = resultDict[@"marketId"];
  
  
  
  //买入 卖出 5档
  self.buyPriceArray = @[resultDict[@"mRJG1"],
                         resultDict[@"mRJG2"],
                         resultDict[@"mRJG3"],
                         resultDict[@"mRJG4"],
                         resultDict[@"mRJG5"]];
  
  self.buyAmountArray = @[resultDict[@"mRSL1"],
                          resultDict[@"mRSL2"],
                          resultDict[@"mRSL3"],
                          resultDict[@"mRSL4"],
                          resultDict[@"mRSL5"]];
  
  self.sellPriceArray = @[resultDict[@"mCJG1"],
                          resultDict[@"mCJG2"],
                          resultDict[@"mCJG3"],
                          resultDict[@"mCJG4"],
                          resultDict[@"mCJG5"]];
  
  self.sellAmountArray = @[resultDict[@"mCSL1"],
                           resultDict[@"mCSL2"],
                           resultDict[@"mCSL3"],
                           resultDict[@"mCSL4"],
                           resultDict[@"mCSL5"]];
  
  
  
}

@end


@implementation WFStockByData

+ (void)computeStockByInfoWithStockCode:(NSString *)stockCode
                        withEntrustType:(NSString *)entrusType
                          withCurAmount:(NSString *)curAmount
                       withEnableAmount:(NSString *)enableAmount
                       withEntrustPrice:(NSString *)entrustPirce
                         withIsByOrSell:(BOOL)isByOrSell
                           withCallBack:(HttpRequestCallBack *)callback {
  NSString *url =
  [NSString stringWithFormat:@"%@/getStockQuotation",WF_Trade_Address];
  
 // NSString *url = @"http://192.168.1.172:8080/stockFinWeb/trade/getStockQuotation";
  
  //入参 stock entrustType curAmount enableAmount  entrustPrice
  // 股票代码 委托类别 买 卖  股票可用数量 委托价格
  NSString *hsUserID = [WFDataSharingCenter shareDataCenter].hsUserId;
  NSString *homsFundAccount = [WFDataSharingCenter shareDataCenter].homsFundAccount;
  NSString *homsCombineId = [WFDataSharingCenter shareDataCenter].homsCombineld;
  NSString *operatorNo = [WFDataSharingCenter shareDataCenter].operatorNo;
  NSDictionary *dic = @{
    @"stockCode" : stockCode,
    @"entrustType" : entrusType,
    @"entrustPrice" : entrustPirce,
    @"hsUserId" : hsUserID,
    @"homsFundAccount" : homsFundAccount,
    @"homsCombineId" : homsCombineId,
    @"operatorNo" : operatorNo
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"POST"
               withRequestParameters:dic
              withRequestObjectClass:[WFStockByInfoData class]
             withHttpRequestCallBack:callback];
}


@end
