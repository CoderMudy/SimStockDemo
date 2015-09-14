//
//  testPortfolioMerge.m
//  SimuStock
//
//  Created by Mac on 15/6/18.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "testPortfolioMerge.h"
#import "PortfolioStockMerge.h"
#import "NSString+Java.h"

@implementation testPortfolioMerge

+ (void)test1 {
  NSString *base = @"A";
  NSString *server = @"AB";
  NSString *local = @"AC";
  //  [PortfolioStockMerge mergeBaseText:base serverText:server
  //  localText:local];
  //
  //  base = @"ABC";
  //  server = @"AB";
  //  local = @"AC";
  //  [PortfolioStockMerge mergeBaseText:base serverText:server
  //  localText:local];

  base = @"ABD";
  server = @"AB";
  local = @"AD";
  [PortfolioStockMergeUtil mergeBaseText:base
                              serverText:server
                               localText:local];
}

+ (QuerySelfStockData *)createQuerySelfStockData:(NSString *)str {
  QuerySelfStockData *data = [[QuerySelfStockData alloc] init];
  data.dataArray = [[NSMutableArray alloc] init];
  NSArray *groups = [str split:@"#"];
  [groups enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx,
                                       BOOL *stop) {
    NSString *groupId = [obj substringFromIndex:0 toIndex:1];
    NSArray *stocks =
        [[obj substringFromIndex:2 toIndex:obj.length - 1] split:@","];
    QuerySelfStockElement *mergeGroup = [[QuerySelfStockElement alloc] init];
    mergeGroup.groupId = groupId;
    mergeGroup.stockCodeArray = [stocks mutableCopy];
    [data.dataArray addObject:mergeGroup];
  }];
  return data;
}

+ (NSString *)toString:(QuerySelfStockData *)data {
  __block NSString *ret = @"";
  [data.dataArray enumerateObjectsUsingBlock:^(QuerySelfStockElement *group,
                                               NSUInteger idx, BOOL *stop) {
    if (idx > 0) {
      ret = [ret stringByAppendingString:@"#"];
    }

    ret = [ret stringByAppendingString:group.groupId];
    ret = [ret stringByAppendingString:@"("];
    [group.stockCodeArray
        enumerateObjectsUsingBlock:^(NSString *stockCode, NSUInteger idx,
                                     BOOL *stop) {
          if (idx > 0) {
            ret = [ret stringByAppendingString:@","];
          }

          ret = [ret stringByAppendingString:stockCode];
        }];
    ret = [ret stringByAppendingString:@")"];
  }];
  return ret;
}

+ (void)test {
  QuerySelfStockData *merge;
  QuerySelfStockData *base;
  QuerySelfStockData *server;
  QuerySelfStockData *local;

  base = [self createQuerySelfStockData:@"1(A)"];
  server = [self createQuerySelfStockData:@"1(A,B)"];
  local = [self createQuerySelfStockData:@"1(C,A)"];
  merge = [PortfolioStockMerge mergeBaseQuerySelfStockData:base
                                  serverQuerySelfStockData:server
                                   localQuerySelfStockData:local];
  NSLog(@"base: %@", [self toString:base]);
  NSLog(@"server: %@", [self toString:server]);
  NSLog(@"local: %@", [self toString:local]);
  NSLog(@"merge: %@", [self toString:merge]);

  base = [self createQuerySelfStockData:@"1(A,B,C)"];
  server = [self createQuerySelfStockData:@"1(A,B)"];
  local = [self createQuerySelfStockData:@"1(C,A)"];
  merge = [PortfolioStockMerge mergeBaseQuerySelfStockData:base
                                  serverQuerySelfStockData:server
                                   localQuerySelfStockData:local];
  NSLog(@"base: %@", [self toString:base]);
  NSLog(@"server: %@", [self toString:server]);
  NSLog(@"local: %@", [self toString:local]);
  NSLog(@"merge: %@", [self toString:merge]);

  base = [self createQuerySelfStockData:@"1(A)"];
  server = [self createQuerySelfStockData:@"1(A,B)"];
  local = [self createQuerySelfStockData:@"1(A,C)"];
  merge = [PortfolioStockMerge mergeBaseQuerySelfStockData:base
                                  serverQuerySelfStockData:server
                                   localQuerySelfStockData:local];
  NSLog(@"base: %@", [self toString:base]);
  NSLog(@"server: %@", [self toString:server]);
  NSLog(@"local: %@", [self toString:local]);
  NSLog(@"merge: %@", [self toString:merge]);

  base = [self createQuerySelfStockData:@"1(A)#2(B)#3(C)"];
  server = [self createQuerySelfStockData:@"1(A)#2(B,D)"];
  local = [self createQuerySelfStockData:@"1(A)#3(CE)"];
  merge = [PortfolioStockMerge mergeBaseQuerySelfStockData:base
                                  serverQuerySelfStockData:server
                                   localQuerySelfStockData:local];
  NSLog(@"base: %@", [self toString:base]);
  NSLog(@"server: %@", [self toString:server]);
  NSLog(@"local: %@", [self toString:local]);
  NSLog(@"merge: %@", [self toString:merge]);

  base = [self createQuerySelfStockData:@"1(A)"];
  server = [self createQuerySelfStockData:@"1(A)#2(B)"];
  local = [self createQuerySelfStockData:@"1(A)#3(C)"];

  merge = [PortfolioStockMerge mergeBaseQuerySelfStockData:base
                                  serverQuerySelfStockData:server
                                   localQuerySelfStockData:local];
  NSLog(@"base: %@", [self toString:base]);
  NSLog(@"server: %@", [self toString:server]);
  NSLog(@"local: %@", [self toString:local]);
  NSLog(@"merge: %@", [self toString:merge]);
}

@end
