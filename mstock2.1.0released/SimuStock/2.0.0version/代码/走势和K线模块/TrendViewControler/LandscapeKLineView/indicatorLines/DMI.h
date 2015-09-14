//
//  DMI.h
//  SimuStock
//
//  Created by Yuemeng on 15/5/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLineUtil.h"


/*
 * DMI 指标线计算类
 */
@interface DMI : NSObject

@property (nonatomic,strong) NSArray *klineArray;
@property (nonatomic,strong) NSMutableArray *pointsArray;

///传入k线数据，返回DMI点数组
+ (NSArray *)getDMIPoints:(NSArray *)klineArray;

@end


/*
 * DMI 点
 */
@interface DMIPoint : NSObject

@property (nonatomic,strong) NSNumber *pdi;
@property (nonatomic,strong) NSNumber *mdi;
@property (nonatomic,strong) NSNumber *adx;
@property (nonatomic,strong) NSNumber *adxr;
@property (nonatomic) int64_t date;

- (instancetype)initWithPdi:(NSNumber *)pdi mdi:(NSNumber *)mdi adx:(NSNumber *)adx adxr:(NSNumber *)adxr date:(int64_t)date;

@end

