//
//  StockMatchListItem.m
//  SimuStock
//
//  Created by jhss on 14-5-6.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "StockMatchListItem.h"
#import "JsonFormatRequester.h"

@implementation StockMatchListItem

- (void)jsonToObject:(NSDictionary *)subDict {
  [self setValuesForKeysWithDictionary:subDict];
  if ([subDict[@"isWapJump"] integerValue] == 0 ) {
    self.wapJump = NO;
  }else{
    self.wapJump = YES;
  }
  self.matchId = [(NSNumber *)subDict[@"matchId"] stringValue];
  self.userId = [(NSNumber *)subDict[@"userId"] stringValue];
  self.type = [(NSNumber *)subDict[@"type"] stringValue];
}

@end

@implementation StockMatchList

- (NSDictionary *)mappingDictionary {
  return @{ @"dataArray" : NSStringFromClass([StockMatchListItem class]) };
}

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];
  self.dataArray = [[NSMutableArray alloc] init];
  NSArray *array = dic[@"result"];
  for (NSDictionary *dicItem in array) {
    StockMatchListItem *item = [[StockMatchListItem alloc] init];
    [item jsonToObject:dicItem];
    [self.dataArray addObject:item];
  }
}

- (NSArray *)getArray {
  return _dataArray;
}

+ (void)requestSearchStockMatchWithQuery:(NSString *)queryString
                           withPageIndex:(NSInteger)pageIndex
                            withPageSize:(NSString *)pageSize
                            withCallback:(HttpRequestCallBack *)callback {

  NSString *url =
      [data_address
          stringByAppendingString:@"youguu/match/" @"searchMatch?likeMatchName={likeMatchName}&" @"pageIndex={pageIndex}&pageSize={pageSize}"];

  NSDictionary *dic = @{
    @"likeMatchName" : queryString,
    @"pageIndex" : [NSString stringWithFormat:@"%ld", (long)pageIndex],
    @"pageSize" : pageSize
  };

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[StockMatchList class]
             withHttpRequestCallBack:callback];
}

/** 所有比赛请求 */
+ (void)requestAllStockMatchListWithDictionary:(NSDictionary *)dic
                                  withCallback:(HttpRequestCallBack *)callback {

  NSString *url =
      [data_address stringByAppendingString:@"youguu/match/"
                    @"allMatch?pageIndex={pageIndex}&pageSize={" @"pageSize}&type={type}"];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[StockMatchList class]
             withHttpRequestCallBack:callback];
}

/** 我的比赛 */
+ (void)requestMyStockMatchListWithDictionary:(NSDictionary *)dic
                                 withCallback:(HttpRequestCallBack *)callback {
  NSString *url = [data_address
      stringByAppendingString:@"youguu/match/myMatch?pageIndex={pageIndex}&pageSize={pageSize}"];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[StockMatchList class]
             withHttpRequestCallBack:callback];
}
/** 搜索比赛 */
+ (void)requestSeatchStockMatchListWithDictionary:(NSDictionary *)dic
                                     withCallback:(HttpRequestCallBack *)callback {
  NSString *url =
      [data_address
          stringByAppendingString:@"youguu/match/" @"searchMatch?likeMatchName={likeMatchName}&" @"pageIndex={pageIndex}&pageSize={pageSize}"];
  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:url
                   WithRequestMethod:@"GET"
               withRequestParameters:dic
              withRequestObjectClass:[StockMatchList class]
             withHttpRequestCallBack:callback];
}
@end
