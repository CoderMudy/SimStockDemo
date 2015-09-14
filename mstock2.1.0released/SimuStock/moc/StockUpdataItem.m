//
//  StockUpdateItem.m
//  SimuStock
//
//  Created by Mac on 15/1/12.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "StockUpdataItem.h"
#import "StockDBManager.h"
#import "CustomPageData.h"

@implementation StockFunds (Update)
- (void)jsonToObject:(NSDictionary *)obj {

  //股票代码
  self.code = obj[@"code"];

  self.stockCode = obj[@"stockCode"];
  if ([@"" isEqualToString:self.stockCode]) {
    self.stockCode = [self.code length] == 6 ? self.code : [self.code substringFromIndex:2];
  }

  //股票名称
  self.name = obj[@"name"];
  //简拼
  self.pyjc = obj[@"pyjc"];

  NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
  [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
  self.marketId = obj[@"marketId"];
  self.firstType = obj[@"firstType"];
  self.secondType = obj[@"secondType"];
  self.decimalDigits = obj[@"decimalDigits"];

  self.openDate = [NSDate dateWithTimeIntervalSince1970:[obj[@"openDate"] longLongValue] / 1000.0];
  self.closeDate = [NSDate dateWithTimeIntervalSince1970:[obj[@"closeDate"] longLongValue] / 1000.0];
  self.modifyTime = [NSDate dateWithTimeIntervalSince1970:[obj[@"modifyDate"] longLongValue] / 1000.0];
}

@end

@implementation StockUpdateItemListWrapper

- (void)packetCompressPointToObject:(NSMutableArray *)tableDataArray {
  for (NSUInteger t = 0; t < [tableDataArray count]; t++) {
    //取得状态
    PacketTableData *m_paketTableData = tableDataArray[t];
    if ([m_paketTableData.tableName isEqualToString:@"Dictionary"]) {
      self.updateStocks = [[NSMutableArray alloc] init];
      self.updateStockIds = [[NSMutableArray alloc] init];
      self.deleteStockIds = [[NSMutableArray alloc] init];
      for (NSUInteger i = 0; i < [m_paketTableData.tableItemDataArray count]; i++) {
        NSMutableDictionary *dic = m_paketTableData.tableItemDataArray[i];
        if (dic[@"closeDate"] == nil || [((NSNumber *)dic[@"closeDate"])integerValue] == 0 ||
            [dic[@"name"] characterAtIndex:0] == 'N') {
          [self.updateStocks addObject:dic];
          [self.updateStockIds addObject:dic[@"code"]];
        } else {
          [self.deleteStockIds addObject:dic[@"code"]];
        }
      }
    }
  }
}

static int64_t lastUpdateTime = 0;

+ (void)incrementUpdateStockInfo {
  NSTimeInterval currentTimestamp = [[NSDate date] timeIntervalSince1970];

  if (fabs(currentTimestamp - lastUpdateTime) < 60 * 60 * 4) {
    // 4小时之内，不更新股票信息
    return;
  }
  lastUpdateTime = currentTimestamp;

  NSString *maxModifytime = [StockDBManager searchMaxTimeItem];
  if (!maxModifytime) {
    return;
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onSuccess = ^(NSObject *obj) {
    StockUpdateItemListWrapper *wrapper = (StockUpdateItemListWrapper *)obj;
    [StockDBManager updateDataBase:wrapper];
  };
  callback.onFailed = ^{
    NSLog(@"");
  };

  PacketCompressPointFormatRequester *requester = [[PacketCompressPointFormatRequester alloc] init];

  NSString *url = [market_address
      stringByAppendingString:@"quote/stocklist2/dictionary/" @"inclist?time={time}&type={type}"];

  NSDictionary *dic = @{
    @"time" : maxModifytime,
    @"type" : [CommonFunc base64StringFromText:@"1:1,2,4;2:1,2,4;9:21,22"]
  };

  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:@"GET"
                 withRequestParameters:dic
                withRequestObjectClass:[StockUpdateItemListWrapper class]
               withHttpRequestCallBack:callback];
}

@end
