//
//  GetStockFirmPositionData.m
//  SimuStock
//
//  Created by moulin wang on 15/4/15.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "GetStockFirmPositionData.h"

@implementation WFFirmHeadInfoData
@end

@implementation WFfirmStockListData
@end

@implementation GetStockFirmPositionDataAnalysis

-(void)jsonToObject:(NSDictionary *)dic
{
  [super jsonToObject:dic];
  //解析数据
  NSDictionary *resultDict = dic[@"result"];
  
  if (resultDict.count == 0 || resultDict == nil) {
    return;
  }
  self.firmHeadInfoData = [[WFFirmHeadInfoData alloc] init];
  //总资产
  self.firmHeadInfoData.totalAsset = resultDict[@"totalAsset"];
  //总盈利
  self.firmHeadInfoData.totalProfit = resultDict[@"totalProfit"];
  //可用余额
  self.firmHeadInfoData.curAmount = resultDict[@"curAmount"];
  //保证金
  self.firmHeadInfoData.cashAmount = resultDict[@"cashAmount"];
  //预警比例
  self.firmHeadInfoData.enableAmount = resultDict[@"enableAmount"];
  //止损比例
  self.firmHeadInfoData.exposureAmount = resultDict[@"exposureAmount"];
  
  NSArray *stockList = resultDict[@"stockList"];
  self.stockListArray = [NSMutableArray array];
  for (NSDictionary *stockDic in stockList) {
    self.frimStockListData = [[WFfirmStockListData alloc] init];
    //股票代码
    self.frimStockListData.stockCode = stockDic[@"stockCode"];
    //股票名称
    self.frimStockListData.stockName = stockDic[@"stockName"];
    //当前数量
    self.frimStockListData.currentAmount = stockDic[@"currentAmount"];
    //可用数量
    self.frimStockListData.enableAmount = stockDic[@"enableAmount"];
    //现价
    self.frimStockListData.price = stockDic[@"price"];
    //当前成本
    self.frimStockListData.costBalance = stockDic[@"costBalance"];
    //当前市值
    self.frimStockListData.marketValue = stockDic[@"marketValue"];
    //盈亏
    self.frimStockListData.profit = stockDic[@"profit"];
    //盈亏率
    self.frimStockListData.profitRate = stockDic[@"profitRate"];
    
    [self.stockListArray addObject:self.frimStockListData];
  }
}

- (NSArray *)getArray {
  return _stockListArray;
}
- (NSDictionary *)mappingDictionary {
  return @{
    @"stockListArray" : NSStringFromClass([WFfirmStockListData class])
  };
}
@end


@implementation GetStockFirmPositionData

+ (void)requestToSendGetDataWithHsUserId:(NSString *)hsUserId
                     withHomsFundAccount:(NSString *)homsFundAccount
                       withHomsCombineld:(NSString *)homsCombineld
                          withOperatorNo:(NSString *)operatorNo
                            withCallback:(HttpRequestCallBack *)callback {
  //创建URL  POST http://192.168.1.172:8080/
  NSString *url =
      [NSString stringWithFormat:@"%@/findPosition",WF_Trade_Address];
  NSDictionary *dic = @{
    @"hsUserId" : hsUserId,
    @"homsFundAccount" : homsFundAccount,
    @"homsCombineId" : homsCombineld,
    @"operatorNo" : operatorNo
  };
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"POST"
               withRequestParameters:dic
              withRequestObjectClass:[GetStockFirmPositionDataAnalysis class]
             withHttpRequestCallBack:callback];
}

/** 只请求持仓数据 */
+ (void)requestQueryPositionWithHsUserID:(NSString *)hsUserID
                     withHomsFundAccount:(NSString *)homsFundAccount
                       withHomsCombineld:(NSString *)homsCombineld
                            withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [WF_Trade_Address
      stringByAppendingString:@"stockFinWeb/trade/findUserPosition"];
  NSDictionary *dic = @{
    @"hsUserId" : hsUserID,
    @"homsFundAccount" : homsFundAccount,
    @"homsCombineId" : homsCombineld
  };
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"POST"
               withRequestParameters:dic
              withRequestObjectClass:[GetStockFirmPositionDataAnalysis class]
             withHttpRequestCallBack:callback];
}

@end
