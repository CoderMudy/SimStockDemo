//
//  StockAlarmRuleList.h
//  SimuStock
//
//  Created by xuming tan on 15-3-24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "JsonFormatRequester.h"
@class HttpRequestCallBack;

/**
 股价提醒规则类型：
 1：价格上限
 2.价格下限
 3.日涨幅上限
 4.日涨幅下限
 10.短线精灵
 SART is short for StockAlarmRuleType
 */
typedef NS_ENUM(NSUInteger, StockAlarmRuleType) {
  /**价格上限*/
  SART_StockPriceUpperLimit = 1,
  /**价格下限*/
  SART_StockPriceLowerLimit = 2,
  /**日涨幅上限*/
  SART_DailyGainsUpperLimit = 3,
  /**日涨幅下限*/
  SART_DailyGainsLowerLimit = 4,
  /**短线精灵*/
  SART_ShotLineSpirit = 10
};

/**
 *股价提醒操作类型：1：插入 2.修改 3.删除
 */
typedef NS_ENUM(NSUInteger, StockAlarmRuleOperationType) {
  /**插入*/
  SAR_InsertOperation = 1,
  /**修改*/
  SAR_ModifyOperation = 2,
  /**删除*/
  SAR_DeleteOperation = 3
};

@interface StockAlarmRule : BaseRequestObject2 <ParseJson>

/** 股价提醒规则类型 */
@property(assign, nonatomic) StockAlarmRuleType ruleType;

/**规则id*/
@property(nonatomic, strong) NSString *ruleId;

/**规则阈值*/
@property(nonatomic, strong) NSString *value;

@end

#pragma 指定股票的股价预警规则信息

/**查询某条股票的所有规则(五条规则)类 */
@interface StockAlarmRuleList : JsonRequestObject

/**股价提醒四条设置数组*/
@property(strong, nonatomic) NSMutableDictionary *ruleType2RuleDictionary;

/** 指定股票的股价预警规则信息 */
+ (void)requestStockRemindOperationRulesDataWithUid:(NSString *)userId
                                  withStockCodeLong:(NSString *)stockCodeLong
                                       withCallback:
                                           (HttpRequestCallBack *)callBack;
@end

#pragma 预警股票项
/** 预警股票项 */
@interface AlarmStockItem : BaseRequestObject2<ParseJson>

/**8位股票代码*/
@property(nonatomic, strong) NSString *stockCodeLong;

/**8位股票代码*/
@property(nonatomic, strong) NSString *expireDate;

@end

#pragma 设置过预警的股票列表

/**返回股价提醒的股票列表数据类*/
@interface SelfStockAlarmItems : JsonRequestObject

/**设定提醒的股票列表数组*/
@property(strong, nonatomic) NSMutableArray *stockCodesArray;

/** 请求设置过预警的股票列表 */
+ (void)requestStockListOfSettingAlarm;

@end


#pragma 清空指定股票的预警信息

/** 清空指定股票的预警信息*/
@interface EmptyStockAlarmRules : JsonRequestObject

/**8位股票代码*/
@property(nonatomic, strong) NSString *stockCodeLong;

+ (void)requestEmptyStockRulesWithUid:(NSString *)userId
                    withStockCodeLong:(NSString *)stockCodeLong
                         withCallback:(HttpRequestCallBack *)callBack;

@end