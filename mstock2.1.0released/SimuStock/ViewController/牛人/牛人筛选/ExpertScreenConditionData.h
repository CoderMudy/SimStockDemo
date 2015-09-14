//
//  ExpertScreenConditionData.h
//  SimuStock
//
//  Created by jhss_wyz on 15/8/31.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"

@class HttpRequestCallBack;

@interface ESConditionInterval : NSObject

/** 左区间 */
@property(assign, nonatomic) float leftInterval;
/** 右区间 */
@property(assign, nonatomic) float rightInterval;
/** 默认值 */
@property(assign, nonatomic) float defaultValue;

+ (instancetype)conditioningIntervalWithArray:(NSArray *)array;

@end

@interface ExpertScreenConditionData : JsonRequestObject

/** 盈利能力 */
/** 超越同期上证指数条件区间 */
@property(strong, nonatomic) ESConditionInterval *winRate;
/** 年化收益条件区间 */
@property(strong, nonatomic) ESConditionInterval *annualProfit;
/** 月均收益条件区间 */
@property(strong, nonatomic) ESConditionInterval *monthAvgProfitRate;

/** 抗风险能力 */
/** 最大回撤比例条件区间 */
@property(strong, nonatomic) ESConditionInterval *maxBackRate;
/** 回撤时间占比条件区间 */
@property(strong, nonatomic) ESConditionInterval *backRate;

/** 选股能力 */
/** 盈利天数占比条件区间 */
@property(strong, nonatomic) ESConditionInterval *profitDaysRate;
/** 成功率条件区间 */
@property(strong, nonatomic) ESConditionInterval *sucRate;
/** 平均持股天数条件区间 */
@property(strong, nonatomic) ESConditionInterval *avgDays;

/** 数据准确性 */
/** 交易笔数条件区间 */
@property(strong, nonatomic) ESConditionInterval *closeNum;

/** 所有筛选区间数据数组 */
@property(copy, nonatomic) NSArray *dataArray;

#pragma mark--------- 网络请求静态方法 ---------
/** 请求筛选牛人条件区间 */
+ (void)requetExpertScreenConditionDataWithCallback:(HttpRequestCallBack *)callback;

@end
