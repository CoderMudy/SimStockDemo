//
//  PortfolioStockModel.h
//  SimuStock
//
//  Created by Mac on 15/6/19.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuerySelfStockData.h"
#import "Globle.h"

/**
 * 自选股上限
 */
static const int CUSTOM_STOCK_LIMIT_UNVIP = 100;
static const int CUSTOM_STOCK_LIMIT_VIP = 200;

/** 添加删除自选股事件通知 */
static NSString *const AddRemovePortFolioStockNotiification =
    @"AddRemovePortFolioStockNotiification";

/** 自选股分组数据类型 */
typedef NS_ENUM(NSUInteger, QuerySelfStockDataType) {
  /** base类型 */
  QuerySelfStockDataTypeBase = 0,

  /** local类型 */
  QuerySelfStockDataTypeLocal = 1,

  /** server类型 */
  QuerySelfStockDataTypeServer = 2,

  /** merge类型 */
  QuerySelfStockDataTypeMerge = 3,
};

@interface PortfolioStockLoadSaveUtil : NSObject

+ (void)savePortfolioStock:(QuerySelfStockData *)data
                withUserId:(NSString *)userId
                  withType:(QuerySelfStockDataType)type;

+ (QuerySelfStockData *)loadPortfolioStockWithUserId:(NSString *)userId
                                            withType:
                                                (QuerySelfStockDataType)type;

@end

@interface PortfolioStockModel : NSObject

@property(nonatomic, strong) NSString *userId;

@property(nonatomic, strong) QuerySelfStockData *base;

@property(nonatomic, strong) QuerySelfStockData *local;

- (void)save;

/** 获取游客用户对应的自选股数据模型 */
+ (PortfolioStockModel *)getTouristPortfolioStockModel;

/** 获取指定用户对应的自选股数据模型
 * userId: -1表示未登录用户，其他为可登录用户
 */
+ (PortfolioStockModel *)getPortfolioStockModelByUserId:(NSString *)userId;

@end

@interface PortfolioStockManager : NSObject


/** 增加自选股, 当成功后，回调 */
+ (void)setPortfolioStock:(NSString *)stockCode
                onSuccess:(CallBackAction)onSuccess;

/** 设置自选股至一个或多个分组中，可能导致分组中增删自选股
 * stockCode: 8位股票代码
 */
+ (void)setPortfolioStock:(NSString *)stockCode inGroupIds:(NSArray *)groups;

/** 从一个或多个分组中删除指定股票
 * stockCode: 8位股票代码
 */
+ (void)removePortfolioStock:(NSString *)stockCode
                withGroupIds:(NSArray *)groups;

/** 返回股票是否是自选股
 * stockCode: 8位股票代码
 */
+ (BOOL)isPortfolioStock:(NSString *)stockCode;

/** 同步自选股，流程：update--merge--checkin
 * 注：仅当用户登录有效，未登录时调用此方法无效
 */
+ (void)synchronizePortfolioStock;

+ (void)synchronizePortfolioStockWithIncrementFlag:(BOOL)incrementFlag;

+ (PortfolioStockModel *)currentPortfolioStockModel;

@end
