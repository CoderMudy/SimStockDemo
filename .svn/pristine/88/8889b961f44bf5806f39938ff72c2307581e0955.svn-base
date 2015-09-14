//
//  FundNetWorthList.m
//  SimuStock
//
//  Created by Mac on 15/5/29.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "FundNetWorthList.h"
#import "PacketCompressPointFormatRequester.h"
#import "CustomPageData.h"

@implementation FundNav

- (void)jsonToObject:(NSDictionary *)dic {
  self.endDate = [dic[@"endDate"] longLongValue];
  self.fundUnitNav = [dic[@"fundUnitNav"] longLongValue];

  long long year = _endDate / (10000000000l);
  long long month = _endDate % (10000000000l) / (100000000l);
  long long day = _endDate % (100000000l) / 1000000l;

  self.fundUnitNavStr =
      [NSString stringWithFormat:@"%.4f", _fundUnitNav / 10000.f];
  self.dateStr =
      [NSString stringWithFormat:@"%lld-%02lld-%02lld", year, month, day];
  self.dateWindow = _dateStr;
  self.monthStr = [NSString stringWithFormat:@"%lld-%02lld", year, month];
}

@end

@implementation FundNetWorthList

- (void)packetCompressPointToObject:(NSMutableArray *)tableDataArray {
  [tableDataArray enumerateObjectsUsingBlock:^(PacketTableData *tableData,
                                               NSUInteger idx, BOOL *stop) {
    if ([tableData.tableName isEqualToString:@"FundUnitNAV"]) {
      self.fundInfoList = [[NSMutableArray alloc] init];
      for (NSUInteger i = 0; i < [tableData.tableItemDataArray count]; i++) {
        NSMutableDictionary *dic = tableData.tableItemDataArray[i];
        FundNav *fundNav = [[FundNav alloc] init];
        [fundNav jsonToObject:dic];
        [self.fundInfoList addObject:fundNav];
      }
    }

  }];
}

- (NSDictionary *)mappingDictionary {
  return @{ @"fundInfoList" : NSStringFromClass([FundNav class]) };
}

- (NSArray *)getArray {
  return _fundInfoList;
}

+ (void)requestFundCurStatusWithParameters:(NSDictionary *)dic
                              withCallback:(HttpRequestCallBack *)callback {
  PacketCompressPointFormatRequester *requester =
      [[PacketCompressPointFormatRequester alloc] init];
  NSString *url = [market_address stringByAppendingString:@"quote/fundnav2/day/"
                                  @"list?code={code}&pageindex={pageindex}&"
                                  @"pagesize={pagesize}"];

  [requester asynExecuteWithRequestUrl:url
                     WithRequestMethod:@"GET"
                 withRequestParameters:dic
                withRequestObjectClass:[FundNetWorthList class]
               withHttpRequestCallBack:callback];
}

@end
