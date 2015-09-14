//
//  BIAS.h
//  SimuStock
//
//  Created by Yuemeng on 15/5/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLineUtil.h"

/*
 * BIAS 指标线计算类
 */
@interface BIAS : NSObject

@property(nonatomic, strong) NSArray *klineArray;
@property(nonatomic, strong) NSMutableArray *pointsArray;

///传入k线数据，返回BIAS点数组
+ (NSArray *)getBIASPoints:(NSArray *)klineArray;

@end

/*
 * BIAS 点
 */
@interface BIASPoint : NSObject

@property(nonatomic, strong) NSNumber *bias1;
@property(nonatomic, strong) NSNumber *bias2;
@property(nonatomic, strong) NSNumber *bias3;
@property(nonatomic) int64_t date;

- (instancetype)initWithBias:(NSNumber *)bias
                       bias2:(NSNumber *)bias2
                       bias3:(NSNumber *)bias3
                        date:(int64_t)date;

@end