//
//  KDJ.h
//  SimuStock
//
//  Created by Yuemeng on 15/5/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLineUtil.h"

/*
 * KDJ 指标线计算类
 */
@interface KDJ : NSObject

@property(nonatomic, strong) NSArray *linesArray;
@property(nonatomic, strong) NSMutableArray *pointsArray;

///传入k线数据，返回KDJ点数组
+ (NSArray *)getKDJPoints:(NSArray *)kLineArray;

@end

/*
 * KDJ 点
 */
@interface KDJPoint : NSObject

@property(nonatomic) float k;
@property(nonatomic) float d;
@property(nonatomic) float j;
@property(nonatomic) int64_t date;

@end
