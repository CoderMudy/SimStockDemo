//
//  SimuRankPositionPageData.h
//  SimuStock
//
//  Created by moulin wang on 14-2-12.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

@class HttpRequestCallBack;

@interface PositionInfo : BaseRequestObject2 <ParseJson>

/** id */
@property(copy, nonatomic) NSString *seqid;

/** 股票代码 */
@property(copy, nonatomic) NSString *stockCode;

/** 股票名称 */
@property(copy, nonatomic) NSString *stockName;

/** 盈亏 */
@property(assign, nonatomic) double profit;

/** 盈亏率 */
@property(copy, nonatomic) NSString *profitRate;

/** 持股数量 */
@property(copy, nonatomic) NSString *amount;

/** 持仓率 */
@property(copy, nonatomic) NSString *positionRate;

/** 成本价 */
@property(assign, nonatomic) double costPrice;

/** 当前价 */
@property(assign, nonatomic) double curPrice;

/** 涨幅 */
@property(copy, nonatomic) NSString *changePercent;

/** 持股市值 */
@property(assign, nonatomic) double value;

/** 可卖数 */
@property(assign, nonatomic) long long sellableAmount;

@property(assign, nonatomic) NSInteger tradeType;

@property(nonatomic, assign) BOOL bProfit;

@end

@interface SimuRankPositionPageData : JsonRequestObject <Collectionable>
/**持仓股票数量*/
@property(copy, nonatomic) NSNumber *positionAmount;
/**盈亏*/
@property(assign, nonatomic) double profit;
@property(assign, nonatomic) double value;
@property(assign) NSInteger traceFlag;
@property(copy, nonatomic) NSString *positionRate;
/** 持仓数据数组*/
@property(strong, nonatomic) NSMutableArray *positionList;
/** 请求持仓数据 */
+ (void)requestPositionDataWithUid:(NSString *)uid
                       withMatchId:(NSString *)matchId
                        withReqnum:(NSString *)reqnum
                        withFormid:(NSString *)fromid
                      withCallback:(HttpRequestCallBack *)callback;
@end
