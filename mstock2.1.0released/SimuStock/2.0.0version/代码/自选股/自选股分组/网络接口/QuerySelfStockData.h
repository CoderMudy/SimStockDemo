//
//  QuerySelfStockData.h
//  SimuStock
//
//  Created by Yuemeng on 15/6/17.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

static NSString *const GROUP_ALL_ID = @"0";

typedef void (^OnEndUpdateSelfStockAction)();

@class HttpRequestCallBack;

/*
 *  分组信息，包含所有分组
 */
@interface QuerySelfStockElement : BaseRequestObject2 <ParseJson>

@property(nonatomic, strong) NSString *groupId;
@property(nonatomic, strong) NSString *groupName;
//该分组下所有股票代码。如果没有股票，则返回nil
@property(nonatomic, strong) NSMutableArray *stockCodeArray;

- (NSString *)stockListString;

- (NSString *)stockListStringWithSplit:(NSString *)split;

+ (QuerySelfStockElement *)copy:(QuerySelfStockElement *)data;

@end

/*
 *  查询自选股【分组版】（新版）
 */
@interface QuerySelfStockData : JsonRequestObject <Collectionable>
///全部分组信息
@property(nonatomic, strong) NSMutableArray *dataArray;
///版本号
@property(nonatomic, strong) NSString *ver;

/** 查找指定分组id的分组 */
- (QuerySelfStockElement *)findGroupById:(NSString *)groupId;

- (void)setGroupAllExist;

/** 设置自选股至一个或多个分组中，可能导致分组中增删自选股
 * stockCode: 8位股票代码
 */
- (void)setPortfolioStock:(NSString *)stockCode inGroupIds:(NSArray *)groups;

/** 从一个或多个分组中删除指定股票
 * stockCode: 8位股票代码
 */
- (void)removePortfolioStock:(NSString *)stockCode
                withGroupIds:(NSArray *)groups;

///获取修改自选股时需要的“portfolio”字段
- (NSString *)getUploadPortfolioString;

+ (QuerySelfStockData *)copy:(QuerySelfStockData *)data;

+ (void)requestSelfStocksWithCallback:(HttpRequestCallBack *)callback;

+ (void)requestSelfStocksWithVerstion:(NSString *)ver
                         withCallback:(HttpRequestCallBack *)callback;

@end
