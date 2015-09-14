//
//  PortfolioStockMerge.h
//  SimuStock
//
//  Created by Mac on 15/6/18.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DiffMatchPatch.h"
#import "QuerySelfStockData.h"

@interface EditResult : NSObject

@property(nonatomic, strong) NSMutableArray *inserts;
@property(nonatomic, strong) NSMutableArray *deletes;
@property(nonatomic, strong) NSMutableArray *replaces;

- (instancetype)initWithDiffList:(NSMutableArray *)diffs;

+ (NSInteger)indexOfDiff:(Diff *)diff inArray:(NSMutableArray *)array;

@end

@interface PortfolioStockMergeUtil : NSObject

/** 合并服务端的修改和本地的修改，生成合并后的字符串
 * baseText: 起始版本的字符串
 * serverText: 从baseText出发，发生修改并保存在服务端的版本
 * localText: 从baseText出发，发生修改并保存在本地的版本
 * 返回：返回合并所有修改，变化后的字符串
 */
+ (NSString *)mergeBaseText:(NSString *)baseText
                 serverText:(NSString *)serverText
                  localText:(NSString *)localText;

@end

@interface StockGroupEncode : NSObject

- (NSString *)encode:(NSString *)objString;

- (NSString *)decode:(NSString *)encodeString;

@end

@interface PortfolioStockMerge : NSObject

+ (QuerySelfStockData *)mergeBaseQuerySelfStockData:(QuerySelfStockData *)base
                           serverQuerySelfStockData:(QuerySelfStockData *)server
                            localQuerySelfStockData:(QuerySelfStockData *)local;

@end
