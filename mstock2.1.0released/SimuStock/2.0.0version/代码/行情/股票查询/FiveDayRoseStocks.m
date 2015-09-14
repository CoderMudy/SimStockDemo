//
//  FiveDayRoseStocks.m
//  SimuStock
//
//  Created by Mac on 14-10-29.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "FiveDayRoseStocks.h"
#import "CustomPageData.h"

@implementation RoseStockItem

- (void)jsonToObject:(NSDictionary *)dic {
  self.stockCode = dic[@"code"];

  self.stockName = dic[@"name"];

  int64_t curPrice = [dic[@"curPrice"] longLongValue];
  int64_t closePrice = [dic[@"closePrice"] longLongValue];

  int64_t gain = [dic[@"gain"] longLongValue];

  if (self.stockCode.length == 8) {
    self.stockCode = [self.stockCode substringFromIndex:2];
  }

  self.gain = [NSString stringWithFormat:@"%0.2f%%", gain / 1000.0f];
  self.curPrice = [NSString stringWithFormat:@"%0.2f", curPrice / 1000.0f];
  self.priceIncrease =
      [NSString stringWithFormat:@"%0.2f", (curPrice - closePrice) / 1000.0f];
}

@end

@implementation FiveDayRoseStocks

- (void)packetCompressPointToObject:(NSMutableArray *)tableDataArray {
  for (int t = 0; t < [tableDataArray count]; t++) {
    //取得状态
    PacketTableData *m_paketTableData = tableDataArray[t];
    if ([m_paketTableData.tableName isEqualToString:@"fivedata"]) {
      self.stocks = [[NSMutableArray alloc] init];
      for (int i = 0; i < [m_paketTableData.tableItemDataArray count]; i++) {
        NSMutableDictionary *dataDictionary =
            m_paketTableData.tableItemDataArray[i];
        RoseStockItem *ItemInfo = [[RoseStockItem alloc] init];
        [ItemInfo jsonToObject:dataDictionary];
        [self.stocks addObject:ItemInfo];
      }
    }
  }
}

- (NSArray *)getArray {
  return _stocks;
}

+ (void)getFiveDayRoseStocksWithParams:(NSDictionary *)dic
                          withCallback:(HttpRequestCallBack *)callback {
  PacketCompressPointFormatRequester *requester =
      [[PacketCompressPointFormatRequester alloc] init];
  NSString *url = [data_address stringByAppendingString:

                                    @"youguu/quote/queryfivedatapacket/{ak}/"
                                @"{sid}/{pageIndex}/{pageSize}"];

  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:@"GET"
                 withRequestParameters:dic
                withRequestObjectClass:[FiveDayRoseStocks class]
               withHttpRequestCallBack:callback];
}

@end
