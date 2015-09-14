//
//  BRAR.h
//  SimuStock
//
//  Created by Yuemeng on 15/5/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLineUtil.h"

/*
 * BRAR 指标线计算类
 */
@interface BRAR : NSObject

@property(nonatomic, strong) NSArray *klineArray;
@property(nonatomic, strong) NSMutableArray *pointsArray;

///传入k线数据，返回BRAR点数组
+ (NSArray *)getBRARPoints:(NSArray *)klineArray;

@end

/*
 * BRAR 点
 */
@interface BRARPoint : NSObject

@property(nonatomic, strong) NSNumber *ar;
@property(nonatomic, strong) NSNumber *br;
@property(nonatomic) int64_t date;

- (instancetype)initWithAR:(NSNumber *)ar br:(NSNumber *)br date:(int64_t)date;

@end
