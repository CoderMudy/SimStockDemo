//
//  TrendDateElement.h
//  iNtgStock
//  Created by Li BB on 12-2-17.
//  Copyright 2012 netgen. All rights reserved.
//

/*
 *类总描述：走势页面数据类
 */
#import <Foundation/Foundation.h>

/*
 *类描述：浮窗显示与否状态描述
 */
typedef NS_ENUM(NSUInteger, TrendFLWindowState) {
    //浮窗未显示状态
    MOD_TREND_NOFLWindows,
    //浮窗显示状态
    MOD_TREND_SHOWFLWindows,
};

/*
 *类描述：浮窗显示与否状态描述
 */
typedef NS_ENUM(NSUInteger, TrendMsgType) {
    //走势页面，消息到达浮动窗口
    Type_TREND_TO_FloatView,
    //走势页面，消息到达数据管理器
    Type_TREND_TO_Manager,
    //走势页面，消息到达显示窗口
    Type_TREND_TO_View,
    // K线页面，消息到达浮动窗口
    Type_KLine_TO_FloatView,
    // K线页面，消息到达数据管理器
    Type_KLine_TO_Manager,
    // K线页面，消息到达显示窗口
    Type_KLine_TO_View,
};

/*
 *类描述：浮窗显示元素定义
 */
@interface TrendFloatViewElment : NSObject

//标题
@property(copy, nonatomic) NSString *title;
//内容
@property(copy, nonatomic) NSString *content;
//颜色
@property(strong, nonatomic) UIColor *color;

- (id)init:(NSString *)title
         forContent:(NSString *)content
    forContentColor:(UIColor *)color;

@end

/*
 *类描述：浮窗显示的消息数据定义
 */
@interface TrendFloatViewMsg : NSObject

//浮窗显示内容
@property(strong, nonatomic) NSMutableArray *contentDataArray;
//浮窗区域
@property(assign) CGRect floatRect;
//浮窗模式
@property(assign) TrendFLWindowState floatShowMode;
//消息类型
@property(assign) TrendMsgType msgType;
//当前数据序列号
@property(assign) NSInteger msgIndex;

- (id)init:(CGRect)frame
    forShowMode:(TrendFLWindowState)mode
     forMsgType:(TrendMsgType)type;

@end

/*
 *类描述：走势页面均线数据元素
 */
@interface SAverageDataManager : NSObject
//基本数据数组
@property(strong, nonatomic) NSMutableArray *iMinDateElementArray;
//移动平均数数组
@property(strong, nonatomic) NSMutableArray *averageDataAarray;
//走势周期
@property(assign) NSInteger period;
//是否走势均线定义  YES:走势均线  NO 非走势均线
@property(assign) BOOL isTrend;

- (id)init;
/*
 *添加k线价格元素
 */
- (BOOL)addKLinePrice:(NSInteger)price;
/*
 *设定周期
 */
- (void)setSAPeriod:(NSInteger)period;
/*
 *初始化所有数据
 */
- (void)resetDataArray;
/*
 *计算均线数据
 */
- (BOOL)calAverageData;
/*
 *设置均线类型，默认为走势均线
 */
- (BOOL)setFlag:(BOOL)flag;

@end

/*
 *类描述：k线基本数据元素定义
 */
@interface KLineDayData : NSObject

//日期
@property(assign) int64_t date;
//开盘价
@property(assign) NSInteger openPrice;
//最高价
@property(assign) NSInteger highestPrice;
//最低价
@property(assign) NSInteger lowestPrice;
//收盘价
@property(assign) NSInteger closePrice;
//成交额
@property(assign) int64_t amount;
//成交量
@property(assign) int64_t volume;

- (id)init;

@end
