//
//  MarketHomeTableData.m
//  SimuStock
//
//  Created by Mac on 14-11-15.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "MarketHomeTableData.h"
#import "PacketCompressPointFormatRequester.h"
#import "CustomPageData.h"

@implementation MarketHomeTableData
- (void)dealloc {

  if (_dataList)
    [_dataList removeAllObjects];
}
- (void)packetCompressPointToObject:(NSMutableArray *)tableDataArray {
  self.dataList = [[NSMutableArray alloc] init];
  for (int t = 0; t < [tableDataArray count]; t++) {
    //取得状态
    PacketTableData *m_paketTableData = tableDataArray[t];
    if ([@"stockquote" isEqualToString:m_paketTableData.tableName] ||
        [@"curstatus" isEqualToString:m_paketTableData.tableName] ||
        [@"newstock" isEqualToString:m_paketTableData.tableName] ||
        [@"boardquote" isEqualToString:m_paketTableData.tableName]||
        [@"TopListItem" isEqualToString:m_paketTableData.tableName]) {
      [self.dataList addObjectsFromArray:m_paketTableData.tableItemDataArray];
    }
  }
}
+ (void)getmarketRequestLinks:(NSString *)urlstr
                        start:(NSInteger)start
                       reqnum:(NSInteger)reqnum
                        order:(NSInteger)order
                 withCallback:(HttpRequestCallBack *)callback {
  PacketCompressPointFormatRequester *requester =
      [[PacketCompressPointFormatRequester alloc] init];

  NSString *url = market_address;
  NSString *real_url =
      [url stringByAppendingFormat:@"%@&start=%ld&reqnum=%ld&order=%ld", urlstr,
                                   (long)start, (long)reqnum, (long)order];
  [requester asynExecuteWithRequestUrl:real_url
                     WithRequestMethod:@"GET"
                 withRequestParameters:nil
                withRequestObjectClass:[MarketHomeTableData class]
               withHttpRequestCallBack:callback];
}
//取得大盘数据
+ (void)getmarketIndexRequestList:(NSString *)urlstr
                     withCallback:(HttpRequestCallBack *)callback {
  PacketCompressPointFormatRequester *requester =
      [[PacketCompressPointFormatRequester alloc] init];
  NSString *url = market_address;
  NSString *real_url = [url stringByAppendingFormat:@"%@", urlstr];
  [requester asynExecuteWithRequestUrl:real_url
                     WithRequestMethod:@"GET"
                 withRequestParameters:nil
                withRequestObjectClass:[MarketHomeTableData class]
               withHttpRequestCallBack:callback];
}
//取得类型为2的接口
+ (void)getmarketRequestLinks:(NSString *)urlstr
                         code:(NSString *)code
                        start:(NSInteger)start
                       reqnum:(NSInteger)reqnum
                        order:(NSInteger)order
                 withCallback:(HttpRequestCallBack *)callback {
  PacketCompressPointFormatRequester *requester =
      [[PacketCompressPointFormatRequester alloc] init];
  NSString *url = market_address;
  NSString *real_url =
      [url stringByAppendingFormat:@"%@code=%@&start=%ld&reqnum=%ld&order=%ld",
                                   urlstr, code, (long)start, (long)reqnum, (long)order];
  [requester asynExecuteWithRequestUrl:real_url
                     WithRequestMethod:@"GET"
                 withRequestParameters:nil
                withRequestObjectClass:[MarketHomeTableData class]
               withHttpRequestCallBack:callback];
}

@end
