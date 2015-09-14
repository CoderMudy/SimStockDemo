//
//  StockUtil+float_window.h
//  SimuStock
//
//  Created by Mac on 15/6/4.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "StockUtil.h"

/** 分时图浮窗传递的数据、index、范围及颜色*/
@interface PartTimeFloatData : NSObject

///时刻
@property(strong, nonatomic) NSString *time;

///现价
@property(strong, nonatomic) NSString *curPrice;

///涨幅
@property(strong, nonatomic) NSString *riseValue;

///均价
@property(strong, nonatomic) NSString *avgPrice;

///现量
@property(strong, nonatomic) NSString *curAmount;

///当前位置
@property(assign, nonatomic) NSInteger index;

///总数
@property(assign, nonatomic) NSInteger range;

@property(strong, nonatomic) UIColor *color;

@end

/** 当分时图被选中时，通知观察者 */
typedef void (^OnPartTimeSelected)(PartTimeFloatData *);

@interface StockUtil (float_window)

@end
