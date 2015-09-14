//
//  FundCurStatus.m
//  SimuStock
//
//  Created by Mac on 15/5/11.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "FundCurStatus.h"
#import "PacketCompressPointFormatRequester.h"

@implementation FundCurStatus

- (void)jsonToObject:(NSDictionary *)dic {
  self.fund = [[Securities alloc] init];
  [_fund jsonToObject:dic];

  self.curPrice = [dic[@"curPrice"] floatValue];
  self.change = [dic[@"change"] floatValue];
  self.changePer = [dic[@"changePer"] floatValue];
  self.openPrice = [dic[@"openPrice"] floatValue];
  self.closePrice = [dic[@"closePrice"] floatValue];
  self.highPrice = [dic[@"highPrice"] floatValue];
  self.lowPrice = [dic[@"lowPrice"] floatValue];

  self.totalAmount = [dic[@"totalAmount"] longLongValue];
  self.totalMoney = [dic[@"totalMoney"] doubleValue];

  self.zfPer = [dic[@"zfPer"] floatValue];
  self.hsPer = [dic[@"hsPer"] floatValue];
  self.amountScale = [dic[@"amountScale"] floatValue];

  self.state = [dic[@"State"] integerValue];
  self.inAmount = [dic[@"inAmount"] longLongValue];
  self.outAmount = [dic[@"outAmount"] longLongValue];

  self.unitNAV = [dic[@"unitNAV"] floatValue];
  self.accuUnitNAV = [dic[@"accuUnitNAV"] floatValue];
  self.discountRate = [dic[@"discountRate"] floatValue];

  self.NAVEnd = [dic[@"NAVEnd"] doubleValue];
  self.latestShare = [dic[@"latestShare"] doubleValue];
}

- (NSString *)getChangeValueAndRate {

  double zdVal = _curPrice - _closePrice; // 涨跌值
  double zdPercent = _closePrice == 0 ? 0 : zdVal / _closePrice * 100; // 涨跌幅
  if (_curPrice <= 0.0) {
    zdVal = 0;
    zdPercent = 0;
  }
  return [NSString stringWithFormat:@"%+.3f    %+.2f%%", zdVal, zdPercent];
}

@end

@implementation FundCurStatusWrapper

- (void)packetCompressPointToObject:(NSMutableArray *)tableDataArray {
  _stockQuotationInfo = [[StockQuotationInfo alloc] init];
  _stockQuotationInfo.dataArray = tableDataArray;

  [tableDataArray enumerateObjectsUsingBlock:^(PacketTableData *tableData,
                                               NSUInteger idx, BOOL *stop) {
    if ([tableData.tableName isEqualToString:@"Top5Quotation"]) {
      self.top5QuotationList = [[NSMutableArray alloc] init];
      for (NSUInteger i = 0; i < [tableData.tableItemDataArray count]; i++) {
        NSMutableDictionary *dic = tableData.tableItemDataArray[i];
        B5S5TradingInfo *b5s5TradingInfo = [[B5S5TradingInfo alloc] init];
        [b5s5TradingInfo jsonToObject:dic];
        [self.top5QuotationList addObject:b5s5TradingInfo];
      }
    }
    if ([tableData.tableName isEqualToString:@"CurStatus"]) {
      self.fundInfoList = [[NSMutableArray alloc] init];
      for (NSUInteger i = 0; i < [tableData.tableItemDataArray count]; i++) {
        NSMutableDictionary *dic = tableData.tableItemDataArray[i];
        FundCurStatus *fundCurStatus = [[FundCurStatus alloc] init];
        [fundCurStatus jsonToObject:dic];
        [self.fundInfoList addObject:fundCurStatus];
      }
    }
  }];
}

- (NSArray *)getArray {
  return _top5QuotationList;
}

+ (void)requestFundCurStatusWithParameters:(NSDictionary *)dic
                              withCallback:(HttpRequestCallBack *)callback {
  PacketCompressPointFormatRequester *requester =
      [[PacketCompressPointFormatRequester alloc] init];
  NSString *url = [market_address
      stringByAppendingString:
          @"quote/stocklist2/board/fund/curpricewithtop5?code={code}"];

  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:@"GET"
                 withRequestParameters:dic
                withRequestObjectClass:[FundCurStatusWrapper class]
               withHttpRequestCallBack:callback];
}

@end
