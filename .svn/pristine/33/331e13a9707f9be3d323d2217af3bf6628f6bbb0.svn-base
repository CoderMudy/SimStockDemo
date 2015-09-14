//
//  BOLL.h
//  SimuStock
//
//  Created by Yuemeng on 15/5/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLineUtil.h"

/*
 * BOLL 指标线计算类
 */
@interface BOLL : NSObject

@property(nonatomic, strong) NSArray *kLineArray;
@property(nonatomic, strong) NSMutableArray *pointsArray;

///传入k线数据，返回BOLL点数组
+ (NSArray *)getBOLLPoints:(NSArray *)klineArray;

@end

/*
 * BOLL 点
 */
@interface BOLLPoint : NSObject

@property(nonatomic, strong) NSNumber *mid;
@property(nonatomic, strong) NSNumber *upper;
@property(nonatomic, strong) NSNumber *lower;
@property(nonatomic) int64_t date;

- (instancetype)initWithMid:(NSNumber *)mid
                      upper:(NSNumber *)upper
                      lower:(NSNumber *)lower
                       date:(int64_t)date;

@end