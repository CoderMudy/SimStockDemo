//
//  RealTradeTodayDeals.h
//  SimuStock
//
//  Created by Mac on 14-9-22.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

@class HttpRequestCallBack;

@interface RealTradeTodayDealItem : NSObject

//*** 今日成交字段 ***/

/**证券名称 */
@property(nonatomic, strong) NSString *stockName;

/**证券代码 */
@property(nonatomic, strong) NSString *stockCode;

/**成交金额 */
@property(nonatomic, strong) NSString *totalMoney;

/**成交价格 */
@property(nonatomic, strong) NSString *price;

/**成交数量 */
@property(nonatomic, strong) NSString *amount;

/**成交时间 str */
@property(nonatomic, strong) NSString *time;

/**成交日期 int */
@property(nonatomic, strong) NSString *date;

/**委托类别 */
@property(nonatomic, strong) NSString *type;

//*** 历史成交额外字段 ***/

/**印花税 str */
@property(nonatomic, strong) NSString *stampTax;

/**佣金 */
@property(nonatomic, strong) NSString *commission;

/**分页用序号 */
@property(nonatomic, strong) NSString *seq;

@end

@interface RealTradeDealList : JsonRequestObject

/**总数 */
@property(nonatomic, assign) int num;

/**成交列表 */
@property(nonatomic, strong) NSMutableArray *list;

/**加载今日成交列表 */
+ (void)loadTodayDealListWithCallback:(HttpRequestCallBack *)callback;

/**加载历史成交列表 */
+ (void)loadHistoryDealListWithStartDate:(NSString *)startDate
                             withEndData:(NSString *)endDate
                            withPageSize:(NSString *)pageSize
                                 withSeq:(NSString *)seq
                            WithCallback:(HttpRequestCallBack *)callback;

@end
