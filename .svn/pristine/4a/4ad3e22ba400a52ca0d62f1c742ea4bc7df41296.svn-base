//
//  OBV.h
//  SimuStock
//
//  Created by Yuemeng on 15/5/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLineUtil.h"


/*
 * OBV 指标线计算类
 */
@interface OBV : NSObject

@property (nonatomic,strong) NSArray *klineArray;
@property (nonatomic,strong) NSMutableArray *pointsArray;

///传入k线数据，返回OBV点数组
+ (NSArray *)getOBVPoints:(NSArray *)klineArray;

@end


/*
 * OBV 点
 */
@interface OBVPoint : NSObject

@property (nonatomic,strong) NSNumber *obv;
@property (nonatomic,strong) NSNumber *maObv;
@property (nonatomic) int64_t date;

- (instancetype)initWithObv:(NSNumber *)obv maObv:(NSNumber *)maObv date:(int64_t)date;

@end


