//
//  RSI.h
//  SimuStock
//
//  Created by Yuemeng on 15/5/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLineUtil.h"

/*
 * RSI 指标线计算类
 */
@interface RSI : NSObject

@property(nonatomic, strong) NSArray *kLineArray;
@property(nonatomic, strong) NSMutableArray *pointsArray;

///传入k线数据，返回RSI点数组
+ (NSArray *)getRSIPoints:(NSArray *)kLineArray;

@end

/*
 * RSI 点
 */
@interface RSIPoint : NSObject

@property(nonatomic, strong) NSMutableDictionary *valueDic;
@property(nonatomic) int64_t date;

@end