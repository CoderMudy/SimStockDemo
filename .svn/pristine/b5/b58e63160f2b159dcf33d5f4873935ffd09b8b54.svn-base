//
//   SimuCancelPageData.h
//   SimuStock
//
//   Created by Mac on 13-8-15.
//   Copyright (c) 2013年 Mac. All rights reserved.
///

#import "SimuPageData.h"
#import "BaseRequestObject.h"
#import "BaseRequester.h"
#import "JsonFormatRequester.h"

/**
 *类说明：委托单据数据结构
 */

@interface SimuCancelElment : JsonRequestObject <ParseJson>

/** 流水号 */
@property(retain, nonatomic) NSString *commissionid;
/** 股票名称 */
@property(retain, nonatomic) NSString *stockname;
/** 股票代码 */
@property(retain, nonatomic) NSString *stockcode;
/** 价格 */
@property(retain, nonatomic) NSString *price;
/** 数量 */
@property(retain, nonatomic) NSString *amount;
/** 状态(已成交/未成交/已撤单) */
@property(retain, nonatomic) NSString *status;
/** 时间 */
@property(retain, nonatomic) NSString *time;
/** 类型 */
@property(retain, nonatomic) NSString *type;
/** 印花税 */
@property(retain, nonatomic) NSString *tax;
/** 佣金 */
@property(retain, nonatomic) NSString *charges;
/** 金额 */
@property(retain, nonatomic) NSString *money;

@end

/**
 *类说明：撤单页面数据
 */
@interface SimuCancelPageData : JsonRequestObject

@property (assign) SimPageDataType pagetype;

/** 数据数组 */
@property(retain, nonatomic) NSMutableArray *DataArray;

+ (void)queryTradeCancleInfoesByType:(NSString *)type
                         withMatchId:(NSString *)matchId
                       withPageIndex:(NSString*) page
                            FromTime:(NSString *)from_time
                             EndTime:(NSString *)end_time
                        withCallBack:(HttpRequestCallBack *)callback;

@end
