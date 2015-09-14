//
//  QuerySelfStockData.m
//  SimuStock
//
//  Created by Yuemeng on 15/6/17.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "QuerySelfStockData.h"
#import "JsonFormatRequester.h"
#import "PortfolioStockModel.h"

static NSString *const DefaultGroupName = @"全部";

/*
 *  分组信息，包含所有分组
 */
@implementation QuerySelfStockElement

- (instancetype)init {
  if (self = [super init]) {
    _stockCodeArray = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)jsonToObject:(NSDictionary *)dic {
  _groupId = [dic[@"groupId"] stringValue];
  _groupName =
      [_groupId isEqualToString:GROUP_ALL_ID] ? @"全部" : dic[@"groupName"];
  if (_groupName == nil && [GROUP_ALL_ID isEqualToString:_groupId]) {
    _groupName = DefaultGroupName;
  }
  NSString *stockStr = dic[@"stockList"];
  //如果分组下有股票信息
  if (stockStr.length > 0) {
    NSArray *stockAndNums =
        [stockStr componentsSeparatedByCharactersInSet:
                      [NSCharacterSet characterSetWithCharactersInString:@";"]];
    [stockAndNums enumerateObjectsUsingBlock:^(NSString *stockCode,
                                               NSUInteger idx, BOOL *stop) {
      //只要股票代码，不要序号
      if (![_stockCodeArray containsObject:stockCode] &&
          stockCode.length == 8) {
        [_stockCodeArray addObject:stockCode];
      }
    }];
  }
}

- (NSDictionary *)mappingDictionary {
  return @{ @"stockCodeArray" : NSStringFromClass([NSString class]) };
}

- (NSString *)stockListString {
  return [self stockListStringWithSplit:@";"];
}

- (NSString *)stockListStringWithSplit:(NSString *)split {
  if (_stockCodeArray.count == 0) {
    return @"";
  }
  __block NSMutableString *stockList = [[NSMutableString alloc] init];
  __block NSInteger index = 0;
  [_stockCodeArray enumerateObjectsUsingBlock:^(NSString *stockCode,
                                                NSUInteger idx, BOOL *stop) {
    if (stockCode.length > 0) {
      if (index != 0) {
        [stockList appendString:split];
      }
      [stockList appendString:stockCode];
      index++;
    }
  }];
  return stockList;
}

+ (QuerySelfStockElement *)copy:(QuerySelfStockElement *)data {
  QuerySelfStockElement *retItem = [[QuerySelfStockElement alloc] init];
  retItem.groupId = data.groupId;
  retItem.groupName = data.groupName;
  retItem.stockCodeArray = [data.stockCodeArray mutableCopy];
  return retItem;
}

@end

/*
 *  查询自选股【分组版】（新版）
 */
@implementation QuerySelfStockData

- (instancetype)init {
  if (self = [super init]) {
    _dataArray = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)jsonToObject:(NSDictionary *)dic {
  [super jsonToObject:dic];

  _ver = [dic[@"ver"] stringValue];
  NSArray *portfolio = dic[@"portfolio"];

  if (portfolio != nil && [portfolio isKindOfClass:[NSArray class]]) {
    [portfolio enumerateObjectsUsingBlock:^(NSDictionary *subDic,
                                            NSUInteger idx, BOOL *stop) {
      QuerySelfStockElement *element = [[QuerySelfStockElement alloc] init];
      [element jsonToObject:subDic];
      [_dataArray addObject:element];
    }];
  }

  [self setGroupAllExist];
}

- (void)setGroupAllExist {
  if ([self findGroupById:GROUP_ALL_ID] == nil) {
    QuerySelfStockElement *group = [[QuerySelfStockElement alloc] init];
    group.groupId = GROUP_ALL_ID;
    group.groupName = DefaultGroupName;
    [_dataArray insertObject:group atIndex:0];
  }
}

- (QuerySelfStockElement *)findGroupById:(NSString *)groupId {
  __block QuerySelfStockElement *retObj;
  [_dataArray enumerateObjectsUsingBlock:^(QuerySelfStockElement *group,
                                           NSUInteger idx, BOOL *stop) {
    if ([groupId isEqualToString:group.groupId]) {
      retObj = group;
      *stop = YES;
    }

  }];
  return retObj;
}

- (NSDictionary *)mappingDictionary {
  return @{ @"dataArray" : NSStringFromClass([QuerySelfStockElement class]) };
}

- (NSArray *)getArray {
  return _dataArray;
}

- (void)removePortfolioStock:(NSString *)stockCode
                withGroupIds:(NSArray *)groups {
  __block BOOL hasGroupAll = NO;
  [groups enumerateObjectsUsingBlock:^(NSString *groupId, NSUInteger idx,
                                       BOOL *stop) {
    QuerySelfStockElement *group = [self findGroupById:groupId];
    if (group) {
      [group.stockCodeArray removeObject:stockCode];
    }
    if ([groupId isEqualToString:GROUP_ALL_ID]) {
      hasGroupAll = YES;
    }
  }];
  //如果从“全部”分组中删除自选股，则必须从所有分组中删除自选股
  if (hasGroupAll) {
    [_dataArray enumerateObjectsUsingBlock:^(QuerySelfStockElement *group,
                                             NSUInteger idx, BOOL *stop) {
      [group.stockCodeArray removeObject:stockCode];
    }];
  }
}

- (void)setPortfolioStock:(NSString *)stockCode inGroupIds:(NSArray *)groups {
  [self.dataArray enumerateObjectsUsingBlock:^(QuerySelfStockElement *group,
                                               NSUInteger idx, BOOL *stop) {
    BOOL exist = [group.stockCodeArray containsObject:stockCode];
    if ([groups containsObject:group.groupId]) {
      if (!exist) {
        [group.stockCodeArray insertObject:stockCode atIndex:0];
      }
    } else {
      if (exist) {
        [group.stockCodeArray removeObject:stockCode];
      }
    }
  }];
}

- (NSString *)getUploadPortfolioString {
  NSMutableArray *jsonGroups = [[NSMutableArray alloc] init];
  [_dataArray enumerateObjectsUsingBlock:^(QuerySelfStockElement *group,
                                           NSUInteger idx, BOOL *stop) {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    dic[@"groupId"] = @([group.groupId longLongValue]);
    dic[@"stockList"] = [group stockListString];
    [jsonGroups addObject:dic];
  }];

  NSDictionary *dic = @{ @"jsonStr" : jsonGroups };

  // dic to json string
  NSData *jsonData =
      [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
  NSString *jsonStr = [[NSString alloc] initWithBytes:[jsonData bytes]
                                               length:[jsonData length]
                                             encoding:NSUTF8StringEncoding];

  return jsonStr;
}

+ (QuerySelfStockData *)copy:(QuerySelfStockData *)data {
  QuerySelfStockData *retItem = [[QuerySelfStockData alloc] init];
  retItem.ver = data.ver;
  retItem.dataArray = [[NSMutableArray alloc] init];
  [data.dataArray enumerateObjectsUsingBlock:^(QuerySelfStockElement *group,
                                               NSUInteger idx, BOOL *stop) {
    QuerySelfStockElement *item = [QuerySelfStockElement copy:group];
    [retItem.dataArray addObject:item];
  }];
  [retItem setGroupAllExist];
  return retItem;
}

+ (void)requestSelfStocksWithCallback:(HttpRequestCallBack *)callback {
  PortfolioStockModel *model =
      [PortfolioStockModel getPortfolioStockModelByUserId:[SimuUtil getUserID]];
  NSString *ver = model.base ? model.base.ver : @"0";
  ver = ver ? ver : @"0";
  [QuerySelfStockData requestSelfStocksWithVerstion:ver withCallback:callback];
}

///新方法
+ (void)requestSelfStocksWithVerstion:(NSString *)ver
                         withCallback:(HttpRequestCallBack *)callback {
  if (![SimuUtil isLogined]) {
    return;
  }

  NSString *URL =
      [NSString stringWithFormat:@"%@jhss/portfolio/findPortfolioStock?ver=%@",
                                 user_address, ver];

  JsonFormatRequester *request = [[JsonFormatRequester alloc] init];
  [request asynExecuteWithRequestUrl:URL
                   WithRequestMethod:@"GET"
               withRequestParameters:nil
              withRequestObjectClass:[QuerySelfStockData class]
             withHttpRequestCallBack:callback];
}

@end
