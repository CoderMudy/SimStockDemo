//
//  IndexCurpriceData.m
//  SimuStock
//
//  Created by Yuemeng on 15/5/14.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "IndexCurpriceData.h"
#import "CustomPageData.h"

@implementation IndexCurpriceData

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
  NSLog(@"⚠️IndexCurpriceData.UndefinedKey:%@", key);
}

- (void)packetCompressPointToObject:(NSMutableArray *)tableDataArray {
  [tableDataArray enumerateObjectsUsingBlock:^(PacketTableData *data,
                                               NSUInteger idx, BOOL *stop) {
    if ([data.tableName isEqualToString:@"CurStatus"]) {
      [self setValuesForKeysWithDictionary:data.tableItemDataArray.firstObject];
    }
  }];
}

+ (void)requestIndexCurpriceDataWithCode:(NSString *)stockCode
                            withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [market_address
      stringByAppendingFormat:@"quote/stocklist2/board/index/curprice?code=%@",
                              stockCode];

  PacketCompressPointFormatRequester *request =
      [[PacketCompressPointFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[IndexCurpriceData class]
             withHttpRequestCallBack:callback];
}

@end
