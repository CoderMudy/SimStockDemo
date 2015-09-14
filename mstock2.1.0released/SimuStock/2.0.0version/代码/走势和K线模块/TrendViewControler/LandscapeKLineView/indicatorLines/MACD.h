//
//  MACD.h
//  SimuStock
//
//  Created by Yuemeng on 15/5/6.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLineUtil.h"

/*
 * MACD 指标线计算类
 */
@interface MACD : NSObject

@property(nonatomic, strong) NSArray *linesArray;
@property(nonatomic, strong) NSMutableArray *pointsArray;

///传入k线数据，返回MACD点数组
+ (NSArray *)getMACDPoints:(NSArray *)kLineArray;

@end

/*
 * MACD 点
 */
@interface MACDPoint : NSObject

@property(nonatomic) float dif;
@property(nonatomic) float dea;
@property(nonatomic) float macd;
@property(nonatomic) int64_t date;

@end
