//
//  SimuRankClosedPositionPageData.h
//  SimuStock
//
//   Created by moulin wang on 14-2-12.
//  strongright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

@class HttpRequestCallBack;

@interface ClosedPositionInfo : NSObject <ParseJson>

/** 序列号 */
@property(copy, nonatomic) NSString *seqID;
/** 完整交易号 */
@property(copy, nonatomic) NSString *positionID;
/** 股票代码 */
@property(copy, nonatomic) NSString *stockCode;
/** 股票名字 */
@property(copy, nonatomic) NSString *stockName;
/** 建仓时间 */
@property(copy, nonatomic) NSString *createAt;
/** 清仓时间 */
@property(copy, nonatomic) NSString *closeAt;
/** 持仓时间 */
@property(copy, nonatomic) NSString *totalDays;
/** 盈利 */
@property(copy, nonatomic) NSString *profit;
/** 盈利率 */
@property(copy, nonatomic) NSString *profitRate;
/** 交易次数 */
@property(copy, nonatomic) NSString *tradeTimes;

@property(assign) BOOL bProfit;

@end

@interface SimuRankClosedPositionPageData : JsonRequestObject <Collectionable>

@property(strong, nonatomic) NSMutableArray *closedPositionList;

/**请求清仓股票列表 */
+ (void)requestClosedPositionWithParameters:(NSDictionary *)dic
                               withCallback:(HttpRequestCallBack *)callback;

/**请求清仓股票列表 */
+ (void)requestClosedPositionDataWithUid:(NSString *)uid
                             withMatchId:(NSString *)matchId
                              withReqnum:(NSString *)reqnum
                              withFromid:(NSString *)fromid
                            withCallback:(HttpRequestCallBack *)callback;

@end

/**清仓数量*/
@interface SimuRankClosedPositionNumber : JsonRequestObject

@property(copy, nonatomic) NSString *closeStockNumber;

/**请求清仓数量*/
+ (void)requestClosedPositionNumberWithUid:(NSString *)uid
                               withMatchId:(NSString *)matchId
                              wichCallback:(HttpRequestCallBack *)callback;

@end
