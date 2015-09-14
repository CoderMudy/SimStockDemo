//
//  SelfStockTableModel.m
//  SimuStock
//
//  Created by Mac on 14-10-17.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SelfStockTableModel.h"
#import "CustomPageData.h"
#import "PacketCompressPointFormatRequester.h"

@implementation SelfStockItem

- (instancetype)init {
  self = [super init];
  if (self) {
    self.stockName = nil;
    self.stockCode = nil;
    self.dataPer = -1;
    self.curPrice = -1;
  }
  return self;
}

- (void)jsonToObject:(NSDictionary *)dic {
  self.code = [NSString stringWithFormat:@"%@", dic[@"code"]];
  self.stockCode = [NSString stringWithFormat:@"%@", dic[@"stockCode"]];
  self.stockName = dic[@"name"];
  self.firstType = [NSString stringWithFormat:@"%@", dic[@"firstType"]];
  self.curPrice = [dic[@"curPrice"] floatValue];
  self.dataPer = [dic[@"dataPer"] floatValue];
  self.change = [dic[@"change"] floatValue];

}


- (NSString *)objectForKey:(NSString *)key {
  if ([key isEqualToString:@"code"]) {
    return self.code;
  } else if ([key isEqualToString:@"name"]) {
    return self.stockName;
  } else if ([key isEqualToString:@"firstType"]) {
    return self.firstType;
  }
  else if([key isEqualToString:@"stockCode"])
  {
    return self.stockCode;
  }
  return nil;
}



@end

@implementation StockTableData

- (void)dealloc {

  if (_stocks)
    [_stocks removeAllObjects];
}

- (void)packetCompressPointToObject:(NSMutableArray *)tableDataArray {
  for (int t = 0; t < [tableDataArray count]; t++) {
    //取得状态
    PacketTableData *m_paketTableData = tableDataArray[t];
    if ([m_paketTableData.tableName isEqualToString:@"curstatus"]) {
      self.stocks = [[NSMutableArray alloc] init];
      for (int i = 0; i < [m_paketTableData.tableItemDataArray count]; i++) {
        NSMutableDictionary *dataDictionary =
            m_paketTableData.tableItemDataArray[i];
        SelfStockItem *stock = [[SelfStockItem alloc] init];
        [stock jsonToObject:dataDictionary];
        [self.stocks addObject:stock];
      }
    }
  }
}

-(NSArray*) getArray{
  return self.stocks;
}

+ (void)getSelfStockInfo:(NSString *)stringStock
            withCallback:(HttpRequestCallBack *)callback {
  PacketCompressPointFormatRequester *requester =
      [[PacketCompressPointFormatRequester alloc] init];
  NSString *url = [market_address
      stringByAppendingString:
          [NSString stringWithFormat:
                        @"quote/stocklist2/board/stock/curstatus/batch?code=%@",
                        [stringStock URLEncodedString]]];

  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:@"GET"
                 withRequestParameters:nil
                withRequestObjectClass:[StockTableData class]
               withHttpRequestCallBack:callback];
}

@end
