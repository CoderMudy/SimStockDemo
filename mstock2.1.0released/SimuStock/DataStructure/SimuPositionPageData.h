//
//  SimuPositionPageData.h
//  SimuStock
//
//  Created by Mac on 13-8-15.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequestObject.h"

@class HttpRequestCallBack;

/*
 *类说明：持仓数据页面
 */

@interface SimuPositionPageData : JsonRequestObject<Collectionable>

/** 持仓数据数组*/
@property(strong, nonatomic) NSMutableArray *dataArray;

/** 请求持仓数据 */
+ (void)requestPositionDataWithDic:(NSDictionary *)dic
                      withCallback:(HttpRequestCallBack *)callback;
+ (void)requestPositionDataWithUid:(NSString *)uid
                       withMatchId:(NSString *)matchId
                      withCallback:(HttpRequestCallBack *)callback;

/** 牛人可卖持仓数据请求 */
+ (void)requestExpertSellStockPosition:(NSString *)accountId
                         withTargetUid:(NSString *)targetUid
                          withCallback:(HttpRequestCallBack *)callback;

/** 持仓数据 */
+ (SimuPositionPageData *)myPostion;

/** 更新持仓数据 */
+ (void)updatePostion;

+ (NSArray *)getSellableStocks;

+ (BOOL)isStockSellable:(NSString *)stockCode;

@end
