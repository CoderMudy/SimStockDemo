//
//  StockDBManager.h
//  SimuStock
//
//  Created by Mac on 15/1/12.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "StockFunds.h"
#import "StockUpdataItem.h"


@interface StockDBManager : NSObject

/** 得到单例句柄 */
+ (StockDBManager *)sharedInstance;


/** 存储多项数据 */
+ (BOOL)updateDataBase:(StockUpdateItemListWrapper *)obj;

/** 查询股票
 1. 以股票简拼片段开头
 2. 以股票代码片段开头
 3. 包含股票代码片段
 4. 包含股票简拼片段
 */
+ (NSArray *)searchStockWithQueryText:(NSString *)queryText withRealTradeFlag:(BOOL) isRealTrade;

/** 查询数据根据股票代码片段 */
+ (NSArray *)searchFromDataBaseWithCode:(NSString *)stockCode withRealTradeFlag:(BOOL) isRealTrade;

/** (YL)查询数据根据股票名称\股票代码 */
+ (NSArray *)searchFromDataBaseWithName:(NSString *)stockName withRealTradeFlag:(BOOL) isRealTrade;

/** 查询数据根据股票简拼片段 */
+ (NSArray *)searchFromDataBaseWithJP:(NSString *)stockJP withRealTradeFlag:(BOOL) isRealTrade;

/** 查询数据根据8位股票代码 */
+ (NSArray *)searchFromDataBaseWith8CharCode:(NSString *)stockCode withRealTradeFlag:(BOOL) isRealTrade;


/** 查询指定股票id数组对应的股票列表*/
+ (NSArray *)queryItemsByIds:(NSArray *)dataArray withRealTradeFlag:(BOOL) isRealTrade;

/** 取得表格中的最大时间 */
+ (NSString *)searchMaxTimeItem;

/** 通过指定id列表，删除数据库中的项目 */
+ (BOOL)deleteItemFromDatabaseWithArray:(NSArray *)dataArray;

/** 通过股票名 和 股票代码来查询股票或者基金 */
+(NSArray *)searchFromdataWithStockName:(NSString *)stockName withStockCode:(NSString *)stockCode;


@end
