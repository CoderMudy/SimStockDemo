//
//  FundHoldStockList.m
//  SimuStock
//
//  Created by Mac on 15/5/11.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "FundHoldStockList.h"
#import "PacketCompressPointFormatRequester.h"
#import "CustomPageData.h"


@implementation FundHoldStock

- (void)jsonToObject:(NSDictionary *)dic {
  self.fund = [[Securities alloc] init];
  [_fund jsonToObject:dic];

  self.holdingVol = [dic[@"holdingVol"] integerValue];
  self.PCTOfNAVEnd = [dic[@"PCTOfNAVEnd"] doubleValue];
}

@end

@implementation FundHoldStockList

- (void)packetCompressPointToObject:(NSMutableArray *)tableDataArray {
  [tableDataArray enumerateObjectsUsingBlock:^(PacketTableData *tableData,
                                               NSUInteger idx, BOOL *stop) {
    if ([tableData.tableName isEqualToString:@"HoldStocks"]) {
      self.stockInfoList = [[NSMutableArray alloc] init];
      for (NSUInteger i = 0; i < [tableData.tableItemDataArray count]; i++) {
        NSMutableDictionary *dic = tableData.tableItemDataArray[i];
        FundHoldStock *stock = [[FundHoldStock alloc] init];
        [stock jsonToObject:dic];
        [self.stockInfoList addObject:stock];
      }
    }
    if ([tableData.tableName isEqualToString:@"UpdateDate"]) {
      self.updateDateList = [[NSMutableArray alloc] init];
      for (NSUInteger i = 0; i < [tableData.tableItemDataArray count]; i++) {
        NSMutableDictionary *dic = tableData.tableItemDataArray[i];
        NSString *date = dic[@"updateDate"];
        [self.updateDateList addObject:date];
      }
    }
  }];
}

- (NSArray *)getArray {
  return self.stockInfoList;
}

+ (void)requestHoldStocksWithParameters:(NSDictionary *)dic
                           withCallback:(HttpRequestCallBack *)callback {
  PacketCompressPointFormatRequester *requester =
      [[PacketCompressPointFormatRequester alloc] init];
  NSString *url = [market_address
      stringByAppendingString:@"quote/stocklist2/board/fund/"
      @"holdstocks?code={code}&start={start}&reqnum={reqnum}"];

  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:@"GET"
                 withRequestParameters:dic
                withRequestObjectClass:[FundHoldStockList class]
               withHttpRequestCallBack:callback];
}

@end
