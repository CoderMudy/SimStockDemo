//
//  StockUtil.h
//  SimuStock
//
//  Created by Mac on 14-10-25.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+Java.h"
#import "TrendKLineModel.h"

static NSString *const FIRST_TYPE_UNSPEC = @"-1"; ///默认类型

static NSString *const FIRST_TYPE_INDEX = @"1"; ///指数

static NSString *const FIRST_TYPE_STKA = @"2"; /// A股

static NSString *const FIRST_TYPE_STKB = @"3"; /// B股

static NSString *const FIRST_TYPE_FND = @"4"; ///基金

static NSString *const FIRST_TYPE_BND = @"5"; ///债券

static NSString *const FIRST_TYPE_OPT = @"6"; ///权证

static NSString *const FIRST_TYPE_INDUSTRY = @"21"; ///行业

static NSString *const FIRST_TYPE_CONCEPT = @"22"; ///概念

static NSString *const SECOND_TYPE_GEM = @"21"; ///创业板

static NSString *const SECOND_TYPE_SMB = @"22"; ///中小板

static NSString *const SECOND_TYPE_ETF = @"41"; /// ETF

static NSString *const SECOND_TYPE_LOF = @"42"; /// LOF

static const int MARKET_SH = 1; ///上海市场ID

static const int MARKET_SZ = 2; ///深圳市场ID

static const int MARKET_BOARD = 9; ///行业与概念 市场ID

/**
 点击按钮的回调函数
 */
typedef void (^OnStockSelected)(NSString *stockCode, NSString *stockName,
                                NSString *firstType);

///调用此回调，可以获取证券名称
typedef void (^OnStockQuotationInfoReady)(NSObject *);

/** 返回价格格式化字符串 */
typedef NSString * (^PriceFormatAction)();

///调用此回调，可以获取证券代码
typedef NSString * (^GetSecuritiesCodeCallback)();

///调用此回调，可以获取证券名称
typedef NSString * (^GetSecuritiesNameCallback)();

///调用此回调，可以获取证券firstType
typedef NSString * (^GetSecuritiesFirstTypeCallback)();

///调用此回调，可以获取证券价格和价格上涨率
typedef NSString * (^GetSecuritiesPriceAndRiseRateCallback)();

static NSString *const LastClosePriceKey = @"LastClosePrice";
static NSString *const SelectTrendViewIndexKey = @"SelectTrendViewIndexKey";

/** 封装股票信息的回调，用于页面之间的数据同步 */
@interface SecuritiesInfo : NSObject

@property(nonatomic, copy) GetSecuritiesCodeCallback securitiesCode;

@property(nonatomic, copy) GetSecuritiesNameCallback securitiesName;

@property(nonatomic, copy) GetSecuritiesFirstTypeCallback securitiesFirstType;

@property(nonatomic, strong) NSMutableDictionary *otherInfoDic;

@end

@interface StockUtil : NSObject

/** 股票六位变成八位小工具函数*/
+ (NSString *)eightStockCode:(NSString *)stockCode;

/** 股票八位变成六位小工具函数*/
+ (NSString *)sixStockCode:(NSString *)stockCode;

/** 是否为大盘指数 */
+ (BOOL)isMarketIndex:(NSString *)firstType;

/** 是否为基金 */
+ (BOOL)isFund:(NSString *)firstType;

/** 返回涨红跌绿平灰的颜色：根据价格变化百分比、盈利变化百分比 */
+ (UIColor *)getColorByChangePercent:(NSString *)changePercent;

/** 返回涨红跌绿平灰的颜色：根据价格变化、盈利变化 */
+ (UIColor *)getColorByProfit:(NSString *)profit;

/** 返回涨红跌绿平灰的颜色 */
+ (UIColor *)getColorByText:(NSString *)text;

/** 返回涨红跌绿平灰的颜色 */
+ (UIColor *)getColorByFloat:(float)value;

/** 返回价格格式化模板，基金3位有效数字，其他2位有效数字 */
+ (NSString *)getPriceFormatWithFirstType:(NSString *)firstType;

/** 返回价格格式化模板，基金3位有效数字，其他2位有效数字 */
+ (NSString *)getPriceFormatWithTradeType:(NSInteger)tradeType;
/**
 * （量线专用）返回涨红跌绿，如果价格相等，则返回上一个颜色，如果第一个数据就相等，则返回灰色
 */
+ (UIColor *)getColorByFloatAndLastColor:(float)value;
/**
 * 判断格式化保留几位小数点 B股，基金 3位 其他两位
 *
 * @param code
 * @return 2 保留2位，3保留三位
 */
+ (int)digitalNumFromStockCode:(NSString *)stockCode;

///对数量进行格式化
+ (NSString *)formatAmount:(double)amount isVolum:(BOOL)isVolum;

///转换112233格式为11:22:33
+ (NSString *)timeFromNSIntegerWithSec:(NSInteger)time;
+ (NSString *)timeFromNSIntegerWithoutSec:(NSInteger)date;
///转换20150427格式为04-27
+ (NSString *)dateFromNSInteger:(NSInteger)date;

///整数手换算万、亿单位，保留2位小数
+ (NSString *)handsStringFromVolume:(int64_t)volume needsHand:(BOOL)needsHand;
+ (NSString *)handsStringFromDouble:(double)volume needsHand:(BOOL)needsHand;
///买五整数手换算万，百万以上显示万
+ (NSString *)handsStringForS5B5FromVolume:(int64_t)volume;

///获取当前时间
+ (NSString *)getCurrentTime:(NSInteger)index;

///查询FirstType
+ (NSString *)queryFirstTypeWithStockCode:(NSString *)stockCode
                            withStockName:(NSString *)stockName;
@end
