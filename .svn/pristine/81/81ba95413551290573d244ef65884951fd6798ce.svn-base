//
//  RealTradeTodayEntrust.h
//  今日委托列表和撤单接口
//  SimuStock
//
//  Created by Mac on 14-9-19.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "BaseRequestObject.h"
#import "StockEntrust.h"

/** 不可撤单 */
#define REVOKE_DISABLE 0
/** 可撤 */
#define REVOKE_ENABLE 1

@class HttpRequestCallBack;

@interface RealTradeTodayEntrustItem : NSObject <ParseJson, EntrustItem>

/** 委托号 */
@property(nonatomic, strong) NSString *commissionId;
/** 交易所 */
@property(nonatomic, strong) NSString *tradeExchange;
/** 股东号 */
@property(nonatomic, strong) NSString *stockHolderId;
/** 证券名称 str */
@property(nonatomic, strong) NSString *stockName;
/** 证券代码str */
@property(nonatomic, strong) NSString *stockCode;
/** 委托价格 */
@property(nonatomic, strong) NSString *price;
/** 委托数量 str */
@property(nonatomic, assign) long long amount;
/** 委托日期 */
@property(nonatomic, strong) NSString *entrustDate;
/** 委托时间 */
@property(nonatomic, strong) NSString *time;
/** 委托类别 */
@property(nonatomic, strong) NSString *type;
/** 订单状态 */
@property(nonatomic, strong) NSString *status;

/** 是否可撤 标记0不可,1可以 */
@property(nonatomic, assign) NSInteger flag;

@end

/** 撤单类 */
@interface RevokeTodayEntrust : JsonRequestObject
@end

@interface RealTradeTodayEntrust : JsonRequestObject

/** 数据量 */
@property(nonatomic, assign) NSInteger num;

/** 结果集 */
@property(nonatomic, strong) NSMutableArray *result;

/**
 获取今日委托列表
 */
+ (void)loadTodayEntruestList:(HttpRequestCallBack *)callback;

/**
 撤销委托
 */
+ (void)revokeTodayEntrusts:(NSString *)entrusts
               withCallBack:(HttpRequestCallBack *)callback;

@end
