//
//  StockDBManager.m
//  SimuStock
//
//  Created by Mac on 15/1/12.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "StockDBManager.h"

@implementation StockDBManager
+ (StockDBManager *)sharedInstance {
  static StockDBManager *sqliteManager = nil;
  static dispatch_once_t predicate;
  dispatch_once(&predicate, ^{
    sqliteManager = [[StockDBManager alloc] init];
  });
  return sqliteManager;
}

+ (NSString *)tableName {
  return NSStringFromClass([StockFunds class]);
}

/** 存储多项数据 */
+ (BOOL)updateDataBase:(StockUpdateItemListWrapper *)obj {
  [StockDBManager deleteItemFromDatabaseWithArray:obj.deleteStockIds];

  NSArray *array =
      [StockDBManager queryItemsByIds:obj.updateStockIds withRealTradeFlag:YES];
  NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
  for (StockFunds *item in array) {
    dic[item.code] = item;
  }
  NSManagedObjectContext *context = [AppDelegate getManagedObjectContext];
  for (NSDictionary *item in obj.updateStocks) {
    StockFunds *record = dic[item[@"code"]];
    if (!record) {
      record = (StockFunds *)
          [NSEntityDescription insertNewObjectForEntityForName:@"StockFunds"
                                        inManagedObjectContext:context];
      dic[item[@"code"]] = record;
    }
    [record jsonToObject:item];
  }
  NSError *error;
  return [context save:&error];
}

+ (NSString *)searchMaxTimeItem {

  //获取Context
  NSManagedObjectContext *context = [AppDelegate getManagedObjectContext];

  //构建表达式方式查询
  NSExpression *keyPathExpression =
      [NSExpression expressionForKeyPath:@"modifyTime"];
  NSExpression *maxExpression =
      [NSExpression expressionForFunction:@"max:"
                                arguments:@[ keyPathExpression ]];

  NSExpressionDescription *expressionDescription =
      [[NSExpressionDescription alloc] init];
  [expressionDescription setName:@"maxModifyTime"];
  [expressionDescription setExpression:maxExpression];
  [expressionDescription setExpressionResultType:NSDateAttributeType];

  //生成查询请求
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

  [fetchRequest setPropertiesToFetch:@[ expressionDescription ]];
  //查询Favorite表
  NSEntityDescription *entity =
      [NSEntityDescription entityForName:self.tableName
                  inManagedObjectContext:context];
  [fetchRequest setEntity:entity];
  [fetchRequest setFetchLimit:1];
  [fetchRequest setResultType:NSDictionaryResultType];
  //执行查询
  NSError *error;
  NSArray *fetchedObjects =
      [context executeFetchRequest:fetchRequest error:&error];
  if (error) {
    return nil;
  }
  if (fetchedObjects && [fetchedObjects count] > 0) {
    NSDate *date = [fetchedObjects[0] valueForKey:@"maxModifyTime"];
    if (date) {
      return [NSString
          stringWithFormat:@"%.0f", [date timeIntervalSince1970] * 1000];
    }
  }
  return nil;
}

+ (BOOL)deleteItemFromDatabaseWithArray:(NSArray *)dataArray {
  NSManagedObjectContext *context = [AppDelegate getManagedObjectContext];
  NSArray *records = [self queryItemsByIds:dataArray withRealTradeFlag:YES];
  for (NSManagedObject *record in records) {
    [context deleteObject:record];
  }
  NSError *error = nil;
  return [context save:&error];
}

+ (NSArray *)queryItemsByIds:(NSArray *)dataArray
           withRealTradeFlag:(BOOL)isRealTrade {
  //获取Context
  NSManagedObjectContext *context = [AppDelegate getManagedObjectContext];

  NSFetchRequest *fetch = [[NSFetchRequest alloc] init];

  [fetch setEntity:[NSEntityDescription entityForName:self.tableName
                               inManagedObjectContext:context]];
  NSString *condition = [StockDBManager filterToQuery:@"code in %@"
                                    withRealTradeFlag:isRealTrade];
  [fetch setPredicate:[NSPredicate predicateWithFormat:condition, dataArray]];
  NSError *error = nil;
  NSArray *records = [context executeFetchRequest:fetch error:&error];
  return records;
}

+ (void)addIndexFromArray:(NSArray *)array toDic:(NSDictionary *)dic {
  for (StockFunds *item in array) {
    [dic setValue:item.stockCode forKeyPath:item.stockCode];
  }
}

/** (YL)查询数据根据股票名称\股票代码 */
+ (NSArray *)searchFromDataBaseWithName:(NSString *)stockName
                      withRealTradeFlag:(BOOL)isRealTrade {
  if (stockName == nil || [stockName length] == 0) {
    return nil;
  }

  NSArray *array = [self searchFromDataBaseWith8CharCode:stockName
                                       withRealTradeFlag:isRealTrade];

  if ([array count] == 0) {
    array = [self searchFromDataBaseWithName2:stockName
                            withRealTradeFlag:isRealTrade];
  }

  if ([array count] > 0) {
    NSComparator comparatore = ^NSComparisonResult(id obj1, id obj2) {
      StockFunds *stock1 = obj1;
      StockFunds *stock2 = obj2;
      return
          [stock1.code characterAtIndex:1] - [stock2.code characterAtIndex:1];
    };
    [array sortedArrayUsingComparator:comparatore];
  }

  return array;
}

+ (NSString *)filterToQuery:(NSString *)query
          withRealTradeFlag:(BOOL)isRealTrade {
  return
      [query stringByAppendingString:
                 @" and (firstType == 1 or firstType == 2 or firstType == 4)"];
}

+ (NSArray *)searchFromDataBaseWithName2:(NSString *)stockName
                       withRealTradeFlag:(BOOL)isRealTrade {
  if (stockName == nil || [stockName length] == 0) {
    return nil;
  }
  NSString *condition = [StockDBManager filterToQuery:@"name BEGINSWITH[c] %@"
                                    withRealTradeFlag:isRealTrade];
  NSPredicate *predicate =
      [NSPredicate predicateWithFormat:condition, stockName];
  NSSortDescriptor *sortDescriptor =
      [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];

  return [self searchStockListWithNSPredicate:predicate
                                     withSort:sortDescriptor
                                    withLimit:20];
}

+ (NSArray *)searchStockWithQueryText:(NSString *)queryText
                    withRealTradeFlag:(BOOL)isRealTrade {
  StockDBManager *instance = [StockDBManager sharedInstance];
  @synchronized(instance) {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if (queryText == nil || [queryText length] == 0 ||
        ![queryText isNumberOrText]) {
      return result;
    }

    int maxResultNum = 20;

    if ([queryText isNumber]) {
      NSArray *codeArray = [self searchFromDataBaseWithCode:queryText
                                          withRealTradeFlag:isRealTrade];
      [result addObjectsFromArray:codeArray];
      [self addIndexFromArray:codeArray toDic:dic];
      if (result.count < maxResultNum) {
        NSArray *jpArray = [self searchFromDataBaseWithJP:queryText
                                        withRealTradeFlag:isRealTrade];
        [result addObjectsFromArray:jpArray];
        [self addIndexFromArray:jpArray toDic:dic];
      }
    } else { // if([queryText isLetter] || [queryText isNumberOrText])
      NSArray *jpArray = [self searchFromDataBaseWithJP:queryText
                                      withRealTradeFlag:isRealTrade];
      [result addObjectsFromArray:jpArray];
      [self addIndexFromArray:jpArray toDic:dic];
    }

    if (result.count < maxResultNum) {
      NSString *condition = [StockDBManager
              filterToQuery:
                  @"(stockCode CONTAINS[cd] %@ OR pyjc CONTAINS[cd] %@)"
          withRealTradeFlag:isRealTrade];
      NSPredicate *predicate = [NSPredicate
          predicateWithFormat:condition, queryText, [queryText copy]];
      NSArray *array = [self searchStockListWithNSPredicate:predicate
                                                   withSort:nil
                                                  withLimit:20];

      for (StockFunds *item in array) {
        if (dic[item.stockCode]) {
          continue;
        }
        if (result.count <= maxResultNum) {
          [result addObject:item];
        } else {
          break;
        }
      }
    }

    return result;
  }
}

+ (NSArray *)searchFromDataBaseWith8CharCode:(NSString *)stockCode
                           withRealTradeFlag:(BOOL)isRealTrade {
  if (stockCode == nil || [stockCode length] == 0) {
    return nil;
  }
  NSString *condition = [StockDBManager filterToQuery:@"code == %@"
                                    withRealTradeFlag:isRealTrade];
  NSPredicate *predicate =
      [NSPredicate predicateWithFormat:condition, stockCode];

  return
      [self searchStockListWithNSPredicate:predicate withSort:nil withLimit:20];
}

+ (NSArray *)searchFromDataBaseWithJP:(NSString *)shortName
                    withRealTradeFlag:(BOOL)isRealTrade {
  if (shortName == nil || [shortName length] == 0) {
    return nil;
  }

  NSString *condition = [StockDBManager filterToQuery:@"pyjc BEGINSWITH[c] %@"
                                    withRealTradeFlag:isRealTrade];
  NSPredicate *predicate =
      [NSPredicate predicateWithFormat:condition, shortName];

  NSSortDescriptor *sortDescriptor =
      [[NSSortDescriptor alloc] initWithKey:@"pyjc" ascending:YES];

  return [self searchStockListWithNSPredicate:predicate
                                     withSort:sortDescriptor
                                    withLimit:20];
}

+ (NSArray *)searchFromDataBaseWithCode:(NSString *)stockCode
                      withRealTradeFlag:(BOOL)isRealTrade {
  if (stockCode == nil || [stockCode length] == 0) {
    return nil;
  }
  NSString *condition =
      [StockDBManager filterToQuery:@"stockCode BEGINSWITH[c] %@"
                  withRealTradeFlag:isRealTrade];
  NSPredicate *predicate =
      [NSPredicate predicateWithFormat:condition, stockCode];
  NSSortDescriptor *sortDescriptor =
      [[NSSortDescriptor alloc] initWithKey:@"stockCode" ascending:YES];

  return [self searchStockListWithNSPredicate:predicate
                                     withSort:sortDescriptor
                                    withLimit:20];
}

+ (NSArray *)searchStockListWithNSPredicate:(NSPredicate *)predicate
                                   withSort:(NSSortDescriptor *)sortDescriptor
                                  withLimit:(NSUInteger)limitNum {

  //获取Context
  NSManagedObjectContext *context = [AppDelegate getManagedObjectContext];

  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

  [fetchRequest setEntity:[NSEntityDescription entityForName:self.tableName
                                      inManagedObjectContext:context]];
  [fetchRequest setFetchLimit:limitNum];
  [fetchRequest setPredicate:predicate];
  if (sortDescriptor) {
    [fetchRequest setSortDescriptors:@[ sortDescriptor ]];
  }
  NSError *error = nil;
  return [context executeFetchRequest:fetchRequest error:&error];
}
/** 通过股票名 和 股票代码来查询股票或者基金 */
+ (NSArray *)searchFromdataWithStockName:(NSString *)stockName
                           withStockCode:(NSString *)stockCode {
  NSArray *array;
  //先通过股票代码查询
  if ([stockCode length] == 8) {
    array = [StockDBManager searchFromDataBaseWith8CharCode:stockCode
                                          withRealTradeFlag:YES];
  }
  //通过股票名称查询
  if (array == nil || [array count] == 0) {
    array = [StockDBManager searchFromDataBaseWithName:stockName
                                     withRealTradeFlag:YES];
  }

  //通过股票代码片段查询
  if (array == nil || [array count] == 0) {
    array = [StockDBManager searchStockWithQueryText:stockCode
                                   withRealTradeFlag:YES];
  }
  if (array && [array count] > 0) {
    return array;
  }
  return nil;
}

@end
