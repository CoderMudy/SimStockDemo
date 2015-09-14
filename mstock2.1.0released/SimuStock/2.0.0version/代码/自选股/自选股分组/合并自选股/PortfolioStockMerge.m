//
//  PortfolioStockMergeUtil.m
//  SimuStock
//
//  Created by Mac on 15/6/18.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "PortfolioStockMerge.h"

#import "NSString+JavaSubstring.h"

@implementation EditResult

- (instancetype)initWithDiffList:(NSMutableArray *)diffs {
  if (self = [super init]) {
    _inserts = [[NSMutableArray alloc] init];
    _deletes = [[NSMutableArray alloc] init];
    _replaces = [[NSMutableArray alloc] init];

    [diffs enumerateObjectsUsingBlock:^(Diff *diff, NSUInteger idx,
                                        BOOL *stop) {
      if (diff.operation == DIFF_EQUAL) {
        // do nothing
      } else if (diff.operation == DIFF_INSERT) {
        //出现同一个字符的插入和删除操作，则合并为一个替换操作
        NSInteger index = [EditResult
            indexOfDiff:[Diff diffWithOperation:DIFF_DELETE andText:diff.text]
                inArray:_deletes];
        if (index == -1) {
          [_inserts addObject:diff];
        } else {
          [_deletes removeObjectAtIndex:index];
          [_replaces addObject:diff];
        }

      } else if (diff.operation == DIFF_DELETE) {
        //出现同一个字符的插入和删除操作，则合并为一个替换操作
        NSInteger index = [EditResult
            indexOfDiff:[Diff diffWithOperation:DIFF_INSERT andText:diff.text]
                inArray:_inserts];
        if (index == -1) {
          [_deletes addObject:diff];
        } else {
          [_inserts removeObjectAtIndex:index];
          [_replaces addObject:diff];
        }
      }

    }];
  }
  return self;
}

+ (NSInteger)indexOfDiff:(Diff *)diff inArray:(NSMutableArray *)array {
  __block NSInteger retIndex = -1;
  [array
      enumerateObjectsUsingBlock:^(Diff *diffItem, NSUInteger idx, BOOL *stop) {
        if (diffItem.operation == diff.operation &&
            [diffItem.text isEqualToString:diff.text]) {
          retIndex = idx;
          *stop = YES;
        }
      }];
  return retIndex;
}

- (NSString *)description {
  return
      [NSString stringWithFormat:@"_inserts: %@,\n_replaces: %@,\n_deletes: %@",
                                 _inserts, _replaces, _deletes];
}

@end

@implementation PortfolioStockMergeUtil

/** 每个字符代码一个股票，因此，需要将一个diff拆分为原子diff
 * 例如：（delete, AB) --> (delete, A), (delete, B)
 */
+ (NSMutableArray *)toAtomic:(NSMutableArray *)diffs {
  NSMutableArray *newDiffs = [[NSMutableArray alloc] init];
  [diffs
      enumerateObjectsUsingBlock:^(Diff *diffItem, NSUInteger idx, BOOL *stop) {
        for (NSInteger i = 0, size = diffItem.text.length; i < size; i++) {
          NSString *charStr =
              [diffItem.text diff_javaSubstringFromStart:i toEnd:i + 1];
          [newDiffs addObject:[Diff diffWithOperation:diffItem.operation
                                              andText:charStr]];
        }
      }];
  return newDiffs;
}

+ (NSString *)mergeBaseText:(NSString *)base
                 serverText:(NSString *)server
                  localText:(NSString *)local {

  DiffMatchPatch *diffUtil = [[DiffMatchPatch alloc] init];
  NSMutableArray *diffServer = [PortfolioStockMergeUtil
      toAtomic:[diffUtil diff_mainOfOldString:base andNewString:server]];
  //  NSMutableArray *diffLocal = [PortfolioStockMergeUtil
  //      toAtomic:[diffUtil diff_mainOfOldString:base andNewString:local]];
  //  NSLog(@"base: %@\nserver:%@\nlocal:%@", base, server, local);
  //  NSLog(@"diffServer:%@\t", diffServer);
  //  NSLog(@"diffLocal:%@\t", diffLocal);

  /// diffS2L: 从server文本变化为local文本，需要发生的所有变化
  NSMutableArray *diffS2L = [PortfolioStockMergeUtil
      toAtomic:[diffUtil diff_mainOfOldString:server andNewString:local]];
  //  NSLog(@"diffS2L:%@\t", diffS2L);

  EditResult *editResultServer =
      [[EditResult alloc] initWithDiffList:diffServer];
  //  EditResult *editResultLocal = [[EditResult alloc]
  //  initWithDiffList:diffLocal];
  //  NSLog(@"editResultServer: %@", editResultServer);
  //  NSLog(@"editResultLocal: %@", editResultLocal);

  ///遍历diffS2L，生成从base--> merged的所有变化
  NSMutableArray *mergedDiffs = [[NSMutableArray alloc] init];
  [diffS2L enumerateObjectsUsingBlock:^(Diff *diff, NSUInteger idx,
                                        BOOL *stop) {
    if (diff.operation == DIFF_EQUAL) {
      // 0. 没有发生变化，保持不变
      [mergedDiffs addObject:diff];
    } else if (diff.operation == DIFF_INSERT) {
      // 1. 如果是插入类型，需要检查server版本的变化中是否发生了删除操作，
      // 1.1 如果有，说明此插入类型虚假, 则插入真实的删除类型；
      // 1.2 否则，添加插入类型
      Diff *deleteDiff = [Diff diffWithOperation:DIFF_DELETE andText:diff.text];
      NSInteger index =
          [EditResult indexOfDiff:deleteDiff inArray:editResultServer.deletes];
      if (index == -1) {
        [mergedDiffs addObject:diff];
      } else {
        [mergedDiffs addObject:deleteDiff];
      }

    } else if (diff.operation == DIFF_DELETE) {
      // 2. 如果是删除类型，需要检查server版本的变化中是否发生了插入操作，
      // 2.1 如果有，说明此删除类型虚假, 则插入真实的插入类型；
      // 2.2 否则，添加删除类型
      Diff *insertDiff = [Diff diffWithOperation:DIFF_INSERT andText:diff.text];
      NSInteger index =
          [EditResult indexOfDiff:insertDiff inArray:editResultServer.inserts];
      if (index == -1) {
        [mergedDiffs addObject:diff];
      } else {
        [mergedDiffs addObject:insertDiff];
      }
    }
  }];

  //  NSLog(@"mergedDiffs: %@", mergedDiffs);

  NSString *mergedText = [diffUtil diff_text2:mergedDiffs];
  NSLog(@"merged text: %@", mergedText);
  return mergedText;
}

@end

@implementation StockGroupEncode {
  NSMutableDictionary *encodeDic;
  unichar c;
}

- (instancetype)init {
  if (self = [super init]) {
    encodeDic = [[NSMutableDictionary alloc] init];
    c = 0x4e00;
  }
  return self;
}

- (NSString *)encode:(NSString *)objString {
  NSString *encode = encodeDic[objString];
  if (encode == nil) {
    encode = [NSString stringWithFormat:@"%C", c++];
    encodeDic[objString] = encode;
  }
  return encode;
}

- (NSString *)decode:(NSString *)encodeString {
  __block NSString *objString = nil;
  [encodeDic enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj,
                                                 BOOL *stop) {
    if ([encodeString isEqualToString:obj]) {
      objString = key;
      *stop = YES;
    }
  }];
  return objString;
}

@end

@implementation PortfolioStockMerge

+ (NSString *)encodeGroupWithQuerySelfStockData:(QuerySelfStockData *)data
                           withStockGroupEncode:(StockGroupEncode *)codeUtil {
  __block NSString *groupEncodeString = @"";
  [data.dataArray enumerateObjectsUsingBlock:^(QuerySelfStockElement *group,
                                               NSUInteger idx, BOOL *stop) {
    NSString *groupStr = group.groupId;
    groupEncodeString =
        [groupEncodeString stringByAppendingString:[codeUtil encode:groupStr]];
  }];
  return groupEncodeString;
}

+ (NSString *)encodeStockWithGroup:(QuerySelfStockElement *)data
              withStockGroupEncode:(StockGroupEncode *)codeUtil {
  __block NSString *stockEncodeString = @"";
  [data.stockCodeArray
      enumerateObjectsUsingBlock:^(NSString *stock, NSUInteger idx,
                                   BOOL *stop) {
        stockEncodeString =
            [stockEncodeString stringByAppendingString:[codeUtil encode:stock]];
      }];
  return stockEncodeString;
}

+ (QuerySelfStockData *)mergeBaseQuerySelfStockData:(QuerySelfStockData *)base
                           serverQuerySelfStockData:(QuerySelfStockData *)server
                            localQuerySelfStockData:
                                (QuerySelfStockData *)local {
  StockGroupEncode *codeUtil = [[StockGroupEncode alloc] init];
  //  1. 合并组
  // 1.1 生成group字符串，合并
  NSString *groupBase =
      [PortfolioStockMerge encodeGroupWithQuerySelfStockData:base
                                        withStockGroupEncode:codeUtil];
  NSString *groupServer =
      [PortfolioStockMerge encodeGroupWithQuerySelfStockData:server
                                        withStockGroupEncode:codeUtil];
  NSString *groupLocal =
      [PortfolioStockMerge encodeGroupWithQuerySelfStockData:local
                                        withStockGroupEncode:codeUtil];
  NSString *groupMerged = [PortfolioStockMergeUtil mergeBaseText:groupBase
                                                      serverText:groupServer
                                                       localText:groupLocal];
  // 1.2  group字符串解码
  NSMutableArray *groups = [[NSMutableArray alloc] init];
  for (NSInteger i = 0, size = groupMerged.length; i < size; i++) {
    NSString *encodeString =
        [groupMerged diff_javaSubstringFromStart:i toEnd:i + 1];
    NSString *groupId = [codeUtil decode:encodeString];
    if (![groups containsObject:groupId]) {
      [groups addObject:groupId];
    }
  }

  QuerySelfStockData *merge = [[QuerySelfStockData alloc] init];
  merge.dataArray = [[NSMutableArray alloc] init];

  //  2. 组内合并
  [groups enumerateObjectsUsingBlock:^(NSString *groupStr, NSUInteger idx,
                                       BOOL *stop) {
    QuerySelfStockElement *baseGroup = [base findGroupById:groupStr];
    QuerySelfStockElement *serverGroup = [server findGroupById:groupStr];
    QuerySelfStockElement *localGroup = [local findGroupById:groupStr];
    if (baseGroup == nil || serverGroup == nil || localGroup == nil) {
      // 2.1 此情况下，只有2种结果：
      //      baseGroup = nil, serverGroup != nil, localGroup =nil;
      //      baseGroup = nil, serverGroup = nil, localGroup !=nil;
      [merge.dataArray addObject:serverGroup ? serverGroup : localGroup];
    } else {
      // 2.2  生成stock字符串，合并
      NSString *groupStockBase =
          [PortfolioStockMerge encodeStockWithGroup:baseGroup
                               withStockGroupEncode:codeUtil];
      NSString *groupStockServer =
          [PortfolioStockMerge encodeStockWithGroup:serverGroup
                               withStockGroupEncode:codeUtil];
      NSString *groupStockLocal =
          [PortfolioStockMerge encodeStockWithGroup:localGroup
                               withStockGroupEncode:codeUtil];
      NSString *groupStockMerged =
          [PortfolioStockMergeUtil mergeBaseText:groupStockBase
                                      serverText:groupStockServer
                                       localText:groupStockLocal];
      QuerySelfStockElement *mergeGroup = [[QuerySelfStockElement alloc] init];
      mergeGroup.groupId = serverGroup.groupId;
      mergeGroup.groupName = serverGroup.groupName;
      // 2.3 stock字符串解码
      mergeGroup.stockCodeArray = [[NSMutableArray alloc] init];
      for (NSInteger i = 0, size = groupStockMerged.length; i < size; i++) {
        NSString *encodeString =
            [groupStockMerged diff_javaSubstringFromStart:i toEnd:i + 1];
        NSString *stock = [codeUtil decode:encodeString];
        if (![mergeGroup.stockCodeArray containsObject:stock] &&
            stock.length == 8) {
          [mergeGroup.stockCodeArray addObject:stock];
        }
      }
      [merge.dataArray addObject:mergeGroup];
    }
  }];
  return merge;
}

@end
