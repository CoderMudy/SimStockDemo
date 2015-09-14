//
//  TrendKLineModel.m
//  SimuStock
//
//  Created by Mac on 14-10-31.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "TrendKLineModel.h"
#import "PacketCompressPointFormatRequester.h"

/*
 *类说明:走势数据
 */
@implementation TrendData

- (void)dealloc {
  if (_stockTrendArray)
    [_stockTrendArray removeAllObjects];
}

- (NSDictionary *)mappingDictionary {
  return @{
    @"stockTrendArray" : NSStringFromClass([StockTrendItemInfo class])
  };
}

- (void)packetCompressPointToObject:(NSMutableArray *)tableDataArray {
  self.stockTrendArray = [[NSMutableArray alloc] init];
  for (int i = 0; i < [tableDataArray count]; i++) {
    //取得状态
    PacketTableData *paketTableData = tableDataArray[i];
    if ([paketTableData.tableName isEqualToString:@"status"]) {
      //状态表格
    } else if ([paketTableData.tableName isEqualToString:@"StockInfo"]) {
      //股票信息表格
      for (NSDictionary *dic in paketTableData.tableItemDataArray) {
        self.stockname = dic[@"name"];
        self.stockcode = dic[@"code"];
        self.lastClosePrice = [dic[@"lastClose"] floatValue];
        if ([dic[@"state"] shortValue] == 0) {
          //正常
          self.isListed = YES;
        } else if ([dic[@"state"] shortValue] == 1) {
          //停牌
          self.isListed = NO;
        }
      }
    } else if ([paketTableData.tableName isEqualToString:@"DayStatus"]) {

      for (NSDictionary *obj in paketTableData.tableItemDataArray) {
        StockTrendItemInfo *trendItemInfo = [[StockTrendItemInfo alloc] init];
        //时间
        trendItemInfo.time = [obj[@"time"] intValue];
        //收盘价
        trendItemInfo.price = [obj[@"price"] intValue];
        //成交量
        trendItemInfo.amount = [obj[@"amount"] longLongValue];
        //均价
        trendItemInfo.avgPrice = [obj[@"avgPrice"] intValue];
        [self.stockTrendArray addObject:trendItemInfo];
        i++;
      }
    }
  }
}

//走势数据如果不全，则自动补全（兼容服务器数据不全错误）
- (void)insertMissData:(NSArray *)array totolCount:(NSInteger)total {
  if (total <= 2 || total >= 241)
    return;
  NSMutableArray *copyArray = [[NSMutableArray alloc] initWithArray:array];
  NSMutableArray *insertArray = [[NSMutableArray alloc] init];
  StockTrendItemInfo *itemInfo = copyArray[total - 1];
  int endTime = itemInfo.time;
  if (itemInfo.time <= 1130) {
    //只有上午数据
    [self detecMorningData:copyArray
               insertArray:insertArray
                startIndex:930
                  endIndex:endTime];
  } else {
    //开始有下午数据
    //上午数据检测
    [self detecMorningData:copyArray
               insertArray:insertArray
                startIndex:930
                  endIndex:1130];
    //下午数据检测
    [self detecMorningData:copyArray
               insertArray:insertArray
                startIndex:1300
                  endIndex:endTime];
  }
  //补全后，数据重新设定
  [self.stockTrendArray removeAllObjects];
  [self.stockTrendArray addObjectsFromArray:insertArray];
}

//是否存在某时间的走势点
- (StockTrendItemInfo *)timeIsExit:(NSArray *)array time:(int)currentTime {
  if (array == nil)
    return nil;
  for (StockTrendItemInfo *obj in array) {
    if (currentTime == obj.time) {
      return obj;
      break;
    }
  }
  return nil;
}

//创建走势item数据并且插入数组
- (void)creatItemToArray:(int)time
              closePrice:(int)closePrice
                  amount:(int64_t)amount
             avragePrice:(int)avragePrice
               usetArray:(NSMutableArray *)array {
  StockTrendItemInfo *itemInfo = [[StockTrendItemInfo alloc] init];
  //时间
  itemInfo.time = time;
  //收盘价
  itemInfo.price = closePrice;
  //成交量
  itemInfo.amount = amount;
  //均价
  itemInfo.avgPrice = avragePrice;

  if (array) {
    [array addObject:itemInfo];
  }
}

//检测并插入上午数据
- (int)detecMorningData:(NSMutableArray *)copyArray
            insertArray:(NSMutableArray *)insertArray
             startIndex:(int)startIndex
               endIndex:(int)endIndex {
  int i = 0;
  StockTrendItemInfo *itemInfoFirst = copyArray[0];
  StockTrendItemInfo *itemInfoFront = nil;
  for (int indexTime = startIndex; indexTime <= endIndex; indexTime++) {
    if ([self timeIsExit:copyArray time:indexTime] == nil) {
      if (indexTime == startIndex) {
        //第一个数据缺失
        [self creatItemToArray:indexTime
                    closePrice:self.lastClosePrice * 1000
                        amount:0
                   avragePrice:self.lastClosePrice * 1000
                     usetArray:insertArray];
      } else {
        //其他数据缺失
        if (itemInfoFront) {
          [insertArray addObject:itemInfoFront];
        } else {
          [self creatItemToArray:indexTime
                      closePrice:itemInfoFirst.closePrice
                          amount:itemInfoFirst.amount
                     avragePrice:itemInfoFirst.closePrice
                       usetArray:insertArray];
        }
      }
    } else {
      itemInfoFront = [self timeIsExit:copyArray time:indexTime];
      [insertArray addObject:itemInfoFront];
    }
    i++;
  }
  return i;
}

- (NSArray *)getArray {
  return _stockTrendArray;
}

+ (void)getStockTrendInfo:(NSString *)stringStock
           withStartIndex:(NSString *)startIndex
             withCallback:(HttpRequestCallBack *)callback {
  PacketCompressPointFormatRequester *requester =
      [[PacketCompressPointFormatRequester alloc] init];
  NSString *url = [market_address
      stringByAppendingString:
          [NSString stringWithFormat:
                        @"quote/timeline2/daystatus/list?code=%@&start=1",
                        stringStock]];

  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:@"GET"
                 withRequestParameters:nil
                withRequestObjectClass:[TrendData class]
               withHttpRequestCallBack:callback];
}

@end

/*
 *资金流向数据
 */
@implementation FundsFlowData

- (void)dealloc {
  if (_dataArray)
    [_dataArray removeAllObjects];
}

- (void)packetCompressPointToObject:(NSMutableArray *)tableDataArray {
  self.dataArray = [[NSMutableArray alloc] init];
  for (int t = 0; t < [tableDataArray count]; t++) {
    PacketTableData *m_paketTableData = tableDataArray[t];
    [self.dataArray addObject:m_paketTableData];
  }
}

+ (void)getFundsFlowInfo:(NSString *)stringStock
            withCallback:(HttpRequestCallBack *)callback {
  PacketCompressPointFormatRequester *requester =
      [[PacketCompressPointFormatRequester alloc] init];
  NSString *url = [market_address
      stringByAppendingString:
          [NSString stringWithFormat:@"quote/moneyflow/recentdays/info?code=%@",
                                     stringStock]];

  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:@"GET"
                 withRequestParameters:nil
                withRequestObjectClass:[FundsFlowData class]
               withHttpRequestCallBack:callback];
}

@end

/*
 *个股报价数据（包含买卖五档）
 */
@implementation StockQuotationInfo

- (NSArray *)getArray {
  return _dataArray;
}

- (void)packetCompressPointToObject:(NSMutableArray *)tableDataArray {
  self.dataArray = [[NSMutableArray alloc] init];
  for (int t = 0; t < [tableDataArray count]; t++) {
    PacketTableData *m_paketTableData = tableDataArray[t];
    [self.dataArray addObject:m_paketTableData];
  }
}

+ (void)getStockQuotaWithFivePriceInfo:(NSString *)stringStock
                          withCallback:(HttpRequestCallBack *)callback {
  PacketCompressPointFormatRequester *requester =
      [[PacketCompressPointFormatRequester alloc] init];
  NSString *url = [market_address
      stringByAppendingString:
          [NSString
              stringWithFormat:
                  @"quote/stocklist2/board/stock/curpricewithtop5?code=%@",
                  stringStock]];

  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:@"GET"
                 withRequestParameters:nil
                withRequestObjectClass:[StockQuotationInfo class]
               withHttpRequestCallBack:callback];
}

@end

/*
 *K线数据日线
 */
@implementation KLineDataItemInfo
- (void)dealloc {
  if (_dataArray)
    [_dataArray removeAllObjects];
}

- (NSDictionary *)mappingDictionary {
  return @{ @"dataArray" : NSStringFromClass([KLineDataItem class]) };
}

- (void)packetCompressPointToObject:(NSMutableArray *)tableDataArray {
  // klineDataItem * ItemInfo=[[klineDataItem alloc] init];
  self.dataArray = [[NSMutableArray alloc] init];
  for (int i = 0; i < [tableDataArray count]; i++) {
    //取得状态
    PacketTableData *paketTableData = tableDataArray[i];
    if ([paketTableData.tableName isEqualToString:@"KLine"]) {

      int i = 0;
      for (NSDictionary *obj in paketTableData.tableItemDataArray) {
        KLineDataItem *item = [[KLineDataItem alloc] init];
        //结束日期
        item.date = [obj[@"endDate"] longLongValue];
        //开盘价
        item.openprice = (float)[obj[@"open"] intValue] / (float)1000;
        //最高价
        item.highprice = (float)[obj[@"high"] intValue] / (float)1000;
        //最低价
        item.lowprice = (float)[obj[@"low"] intValue] / (float)1000;
        //收盘价
        item.closeprice = (float)[obj[@"close"] intValue] / (float)1000;
        //成交量
        item.volume = [obj[@"amount"] longLongValue];
        //成交额
        item.amount = [obj[@"money"] longLongValue];
        i++;
        [self.dataArray addObject:item];
      }
    }
  }
}

- (NSArray *)getArray {
  return _dataArray;
}

+ (void)getKLineTypesInfo:(NSString *)stockcode
                     type:(NSString *)type
                 xrdrType:(NSString *)xrdrType
             withCallback:(HttpRequestCallBack *)callback {
  PacketCompressPointFormatRequester *requester =
      [[PacketCompressPointFormatRequester alloc] init];

  NSString *url;
  //日
  if ([type isEqualToString:@"D"]) {
    url = [market_address
        stringByAppendingString:
            [NSString stringWithFormat:@"quote/kline2/day/"
                                       @"list?code=%@&xrdrtype=%@&"
                                       @"pageindex=1&pagesize=560",
                                       stockcode, xrdrType]];
    //周、月
  } else if ([type isEqualToString:@"W"] || [type isEqualToString:@"M"]) {
    url = [market_address
        stringByAppendingString:
            [NSString stringWithFormat:@"quote/kline2/moredays/"
                                       @"list?code=%@&type=%@&xrdrtype=%@&"
                                       @"pageindex=1&pagesize=560",
                                       stockcode, type, xrdrType]];
    //分钟
  } else {
    url = [market_address
        stringByAppendingString:
            [NSString stringWithFormat:@"quote/kline2/minute/"
                                       @"list?code=%@&type=%@&xrdrtype=%@&"
                                       @"pageindex=1&pagesize=560",
                                       stockcode, type, xrdrType]];
  }

  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:@"GET"
                 withRequestParameters:nil
                withRequestObjectClass:[KLineDataItemInfo class]
               withHttpRequestCallBack:callback];
}

@end

/*
 *明细
 */
@implementation StockTradeDetailInfo

- (NSDictionary *)mappingDictionary
{
  return @{@"dataArray": NSStringFromClass([StockTradeDetailData class])};
}

- (NSArray *)getArray
{
  return self.dataArray;
}


- (void)packetCompressPointToObject:(NSMutableArray *)tableDataArray {
  self.dataArray = [[NSMutableArray alloc] initWithCapacity:20];
  [tableDataArray enumerateObjectsUsingBlock:^(PacketTableData *data,
                                               NSUInteger idx, BOOL *stop) {
    if ([data.tableName isEqualToString:@"TradeDetail"]) {
      *stop = YES;
      [data.tableItemDataArray enumerateObjectsUsingBlock:^(NSDictionary *dic,
                                                            NSUInteger idx,
                                                            BOOL *stop) {
        StockTradeDetailData *detailData = [[StockTradeDetailData alloc] init];
        [detailData setValuesForKeysWithDictionary:dic];
        [self.dataArray addObject:detailData];
      }];
    }
  }];
}

+ (void)getStockTradeDetailWithStockCode:(NSString *)stockCode
                            withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [market_address
      stringByAppendingString:
          [NSString
              stringWithFormat:
                  @"quote/timeline2/tradedetail/list?code=%@&start=1&limit=20",
                  stockCode]];
  PacketCompressPointFormatRequester *requester =
      [[PacketCompressPointFormatRequester alloc] init];
  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:@"GET"
                 withRequestParameters:nil
                withRequestObjectClass:[StockTradeDetailInfo class]
               withHttpRequestCallBack:callback];
}

@end

/*
 *分价
 */
@implementation StockPriceStateInfo

- (NSDictionary *)mappingDictionary
{
  return @{@"dataArray": NSStringFromClass([StockTradeDetailData class])};
}

- (NSArray *)getArray
{
  return self.dataArray;
}

- (void)packetCompressPointToObject:(NSMutableArray *)tableDataArray {
  self.dataArray = [[NSMutableArray alloc] initWithCapacity:0];
  [tableDataArray enumerateObjectsUsingBlock:^(PacketTableData *data,
                                               NSUInteger idx, BOOL *stop) {
    if ([data.tableName isEqualToString:@"PriceStat"]) {
      *stop = YES;
      [data.tableItemDataArray enumerateObjectsUsingBlock:^(NSDictionary *dic,
                                                            NSUInteger idx,
                                                            BOOL *stop) {
        StockTradeDetailData *detailData = [[StockTradeDetailData alloc] init];
        [detailData setValuesForKeysWithDictionary:dic];
        [self.dataArray addObject:detailData];
      }];
    }
  }];
}

+ (void)getStockPriceStateWithStockCode:(NSString *)stockCode
                           wichCallback:(HttpRequestCallBack *)callback {
  NSString *url = [market_address
      stringByAppendingString:
          [NSString stringWithFormat:@"quote/timeline2/pricestat/list?code=%@",
                                     stockCode]];
  PacketCompressPointFormatRequester *requester =
      [[PacketCompressPointFormatRequester alloc] init];
  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:@"GET"
                 withRequestParameters:nil
                withRequestObjectClass:[StockPriceStateInfo class]
               withHttpRequestCallBack:callback];
}

@end

/*
 *5日
 */
@implementation Stock5DayStatusInfo

- (NSDictionary *)mappingDictionary {
  return @{
    @"stockTrendArray" : NSStringFromClass([StockTrendItemInfo class])
  };
}

- (void)packetCompressPointToObject:(NSMutableArray *)tableDataArray {

  self.stockTrendArray = [[NSMutableArray alloc] init];
  
  _minPrice = INT_MAX;

  [tableDataArray enumerateObjectsUsingBlock:^(PacketTableData *data,
                                               NSUInteger idx, BOOL *stop) {
    if ([data.tableName isEqualToString:@"StockInfo"]) {
      NSDictionary *dic = data.tableItemDataArray[0];
      self.lastClosePrice = [dic[@"lastClose"] floatValue];
      self.isListed = YES;
    } else if ([data.tableName isEqualToString:@"DayStatus"]) {
      [data.tableItemDataArray enumerateObjectsUsingBlock:^(NSDictionary *dic,
                                                            NSUInteger idx,
                                                            BOOL *stop) {
        //逐点压缩，恢复数据
        StockTrendItemInfo *trendItemInfo = [[StockTrendItemInfo alloc] init];
        //成交量
        trendItemInfo.amount = [dic[@"amount"] longLongValue];
        //均价
        trendItemInfo.avgPrice = [dic[@"avgPrice"] intValue];
        //时间
        trendItemInfo.time = [dic[@"hhmm"] intValue];
        //价格
        trendItemInfo.price = [dic[@"price"] intValue];
        //日期
        trendItemInfo.date = [dic[@"date"] longLongValue];
        
        //最大、最小，最大成交量计算
        if (trendItemInfo.price > _maxPrice) {
          _maxPrice = trendItemInfo.price;
        }
        
        if (trendItemInfo.price < _minPrice) {
          _minPrice = trendItemInfo.price;
        }
        
        if (trendItemInfo.amount > _maxAmount) {
          _maxAmount = trendItemInfo.amount;
        }

        //恰好保证取得每天61个数据且均包含当天首尾两个数据，最多305个数据
        if ((idx - idx / 241 * 241) % 4 == 0 || (idx + 1) % 241 == 0) {
          [self.stockTrendArray addObject:trendItemInfo];
        }
      }];
    }
  }];
}

- (NSArray *)getArray {
  return _stockTrendArray;
}

+ (void)getStock5DayStatusWithStockCode:(NSString *)stockCode
                           withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [market_address
      stringByAppendingString:
          [NSString stringWithFormat:
                        @"quote/timeline2/5daystatus/list?code=%@&start=1",
                        stockCode]];
  PacketCompressPointFormatRequester *requester =
      [[PacketCompressPointFormatRequester alloc] init];
  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:@"GET"
                 withRequestParameters:nil
                withRequestObjectClass:[Stock5DayStatusInfo class]
               withHttpRequestCallBack:callback];
}

@end