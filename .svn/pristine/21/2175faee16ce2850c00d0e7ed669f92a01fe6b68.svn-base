//
//  WR.h
//  SimuStock
//
//  Created by Yuemeng on 15/5/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLineUtil.h"

/*
 * WR 指标线计算类
 */
@interface WR : NSObject

@property(nonatomic, strong) NSArray *klineArray;
@property(nonatomic, strong) NSMutableArray *pointsArray;

///传入k线数据，返回WR点数组
+ (NSArray *)getWRPoints:(NSArray *)klineArray;

@end

/*
 * WR 点
 */
@interface WRPoint : NSObject

@property(nonatomic, strong) NSNumber *wr1;
@property(nonatomic, strong) NSNumber *wr2;
@property(nonatomic) int64_t date;

- (instancetype)initWithWr1:(NSNumber *)wr1
                        wr2:(NSNumber *)wr2
                       date:(int64_t)date;

@end
