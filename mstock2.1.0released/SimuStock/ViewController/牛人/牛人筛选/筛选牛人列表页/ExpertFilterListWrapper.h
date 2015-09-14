//
//  ExpertScreenListWrapper.h
//  SimuStock
//
//  Created by jhss on 15/8/31.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"
@class HttpRequestCallBack;
@class UserListItem;

/** 牛人筛选条件 */
@interface ExpertFilterCondition : NSObject
/** 最大回撤比例 */
@property(assign, nonatomic) float condiMaxBackRate;
/** 回撤比例 */
@property(assign, nonatomic) float condiBackRate;
/** 超越同期上证 */
@property(assign, nonatomic) float condiWinRate;
/** 年化收益 */
@property(assign, nonatomic) float condiAnnualProfit;
/** 盈利天数占比 */
@property(assign, nonatomic) float condiProfitDaysRate;
/** 成功率 */
@property(assign, nonatomic) float condiSucRate;
/** 平均持股天数 */
@property(assign, nonatomic) float condiAvgDays;
/** 完整交易次数 */
@property(assign, nonatomic) int condiCloseNum;
/** 月平均收益*/
@property(assign, nonatomic) float monthAvgProfitRate;

@end

/** 牛人筛选列表页项数据 */
@interface ExpertFilterListItem : NSObject <ParseJson>

/**时间线id*/
@property(nonatomic, assign) long long seqId;

/**账户id*/
@property(nonatomic, copy) NSString *accountId;

/**用户id*/
@property(nonatomic, assign) long long uid;

/** 总盈利率 */
@property(nonatomic, assign) CGFloat totalProfitRate;

/** 月平均收益 */
@property(nonatomic, assign) CGFloat monthAvgProfitRate;

/** 成功率 */
@property(nonatomic, assign) CGFloat sucRate;

/** 平均持股数 */
@property(nonatomic, assign) CGFloat avgDays;

/** 最大回撤比例 */
@property(nonatomic, assign) CGFloat maxBackRate;

/** 回撤比率 */
@property(nonatomic, assign) CGFloat backRate;

/** 超越同期上证*/
@property(nonatomic, assign) CGFloat winRate;

/** 年化收益 */
@property(nonatomic, assign) CGFloat annualProfit;

/** 盈利天数占比 */
@property(nonatomic, assign) CGFloat profitDaysRate;

/** 完整交易次数 */
@property(nonatomic, assign) long closeNum;
/** 用户评级数据 */
@property(strong, nonatomic) UserListItem *writer;

@end

/** 牛人筛选列表页数据 */
@interface ExpertFilterListWrapper : JsonRequestObject <Collectionable>

@property(strong, nonatomic) NSMutableArray *expertFilterListArray;

/** 请求筛选牛人接口 */
+ (void)requestExpertFilterListWithInput:(NSDictionary *)dic
                            withCallback:(HttpRequestCallBack *)callback;

@end
