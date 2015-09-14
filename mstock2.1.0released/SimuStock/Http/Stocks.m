//
//  Stocks.m
//  SimuStock
//
//  Created by Mac on 14-8-28.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "Stocks.h"

@implementation klineDataItem2
@synthesize closeprice = kldi_closeprice;
@synthesize highprice = kldi_highprice;
@synthesize lowprice = kldi_lowprice;
@synthesize openprice = kldi_openprice;
@synthesize yestodaycloseprice = kldi_yestodaycloseprice;
@synthesize data = kldi_data;
@synthesize enddata = kldi_enddata;
@synthesize volume = kldi_volume;
@synthesize turnover = kldi_turnover;

- (id)init {
  self = [super init];
  if (self != nil) {
    self.closeprice = -1;
    self.highprice = -1;
    self.lowprice = -1;
    self.openprice = -1;
    self.yestodaycloseprice = -1;
    self.data = -1;
    self.volume = -1;
    self.turnover = -1;
  }
  return self;
}

- (void)jsonToObject:(NSDictionary *)dataDictionary {

  //开始日期
  NSNumber *start_date = dataDictionary[@"opendate"];
  self.data = [start_date integerValue];
  //结束日期
  NSNumber *end_date = dataDictionary[@"enddate"];
  self.enddata = [end_date integerValue];
  //收盘价
  NSNumber *closeprice = dataDictionary[@"close"];
  self.closeprice = ((float)[closeprice integerValue]) / 1000.f;
  //最高价格
  NSNumber *highest = dataDictionary[@"high"];
  self.highprice = ((float)[highest integerValue]) / 1000.f;
  //最低价格
  NSNumber *lowprice = dataDictionary[@"low"];
  self.lowprice = ((float)[lowprice integerValue]) / 1000.f;
  //开盘价
  NSNumber *openprice = dataDictionary[@"open"];
  self.openprice = ((float)[openprice integerValue]) / 1000.f;

  //设定昨收价格
  self.yestodaycloseprice = self.closeprice;

  //成交金额
  NSNumber *thurd = dataDictionary[@"money"];
  self.turnover = [thurd longLongValue];

  //成交量
  NSNumber *volume = dataDictionary[@"amount"];
  self.volume = [volume longLongValue];
}

@end

@implementation Stocks

@synthesize stockTable = _stockTable;

- (void)packetToObject:(NSMutableArray *)tableDataArray {
  for (NSUInteger t = 0; t < [tableDataArray count]; t++) {
    //取得状态
    PacketTableData *m_paketTableData = tableDataArray[t];
    if ([m_paketTableData.tableName isEqualToString:@"hq"]) {

      for (NSUInteger i = 0; i < [m_paketTableData.tableItemDataArray count]; i++) {
        NSMutableDictionary *dataDictionary =
            (m_paketTableData.tableItemDataArray)[i];
        klineDataItem2 *ItemInfo = [[klineDataItem2 alloc] init];
        [ItemInfo jsonToObject:dataDictionary];
        [self.stockTable addObject:ItemInfo];
      }
    }
  }
}

+ (void)test {
  NSString *url = @"http://220.181.47.36/youguu/quote/queryhisstatuspacket/"
      @"0110010010201/20140818113750300938/11600117/W/1/100";
  PacketCompressPointFormatRequester *requester =
      [[PacketCompressPointFormatRequester alloc] init];

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onSuccess = ^(NSObject *obj) { NSLog(@"onSuccess"); };

  callback.onError = ^(NSObject *obj, NSException *ex) { NSLog(@"onError"); };
  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:@"GET"
                 withRequestParameters:nil
                withRequestObjectClass:[Stocks class]
               withHttpRequestCallBack:callback];
};

@end
