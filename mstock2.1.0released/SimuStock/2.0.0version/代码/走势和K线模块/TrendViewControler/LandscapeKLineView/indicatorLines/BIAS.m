//
//  BIAS.m
//  SimuStock
//
//  Created by Yuemeng on 15/5/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BIAS.h"

#define DEFAULT_PERIOD_6 6
#define DEFAULT_PERIOD_12 12
#define DEFAULT_PERIOD_24 24
#define DEFAULT_TIMES 2

@implementation BIAS

- (NSArray *)calcMA:(NSArray *)klineArray period:(int)period {
  NSInteger count = klineArray.count;
  NSMutableArray *maArray = [[NSMutableArray alloc] initWithCapacity:count];

  for (NSInteger i = 0; i < count; i++) {
    int from = (int)i - period + 1;

    if (from < 0) {
      from = 0;
    }

    int num = 0;
    float sum = 0.f;

    for (NSInteger j = from; j <= i; j++) {
      float close = [(KLineDataItem *)klineArray[j] closeprice];
      sum += close;
      num++;
    }

    float ma = sum / num;
    [maArray addObject:@(ma)];
  }
  return [maArray copy];
}

- (void)calculate {
  if (!_klineArray) {
    return;
  }

  NSArray *maArray1 = [self calcMA:_klineArray period:DEFAULT_PERIOD_6];
  NSArray *maArray2 = [self calcMA:_klineArray period:DEFAULT_PERIOD_12];
  NSArray *maArray3 = [self calcMA:_klineArray period:DEFAULT_PERIOD_24];

  NSInteger count = _klineArray.count;

  for (NSInteger i = 0; i < count; i++) {
    float close = [(KLineDataItem *)_klineArray[i] closeprice];
    int64_t date = [(KLineDataItem *)_klineArray[i] date];
    float ma1 = [maArray1[i - 0] floatValue];
    float ma2 = [maArray2[i - 0] floatValue];
    float ma3 = [maArray3[i - 0] floatValue];

    NSNumber *bias1, *bias2, *bias3;

    if ((i >= DEFAULT_PERIOD_6 - 1) && (ma1 != 0.f)) {
      bias1 = @([KLineUtil roundUp:(close - ma1) / ma1 * 100.f]);
    }

    if ((i >= DEFAULT_PERIOD_12 - 1) && (ma2 != 0.f)) {
      bias2 = @([KLineUtil roundUp:(close - ma2) / ma2 * 100.f]);
    }

    if ((i >= DEFAULT_PERIOD_24 - 1) && (ma3 != 0.f)) {
      bias3 = @([KLineUtil roundUp:(close - ma3) / ma3 * 100.f]);
    }

    BIASPoint *point = [[BIASPoint alloc] initWithBias:bias1
                                                 bias2:bias2
                                                 bias3:bias3
                                                  date:date];
    [_pointsArray addObject:point];
  }
}

+ (NSArray *)getBIASPoints:(NSArray *)klineArray {
  BIAS *bias = [[BIAS alloc] init];
  bias.pointsArray = [[NSMutableArray alloc] initWithCapacity:klineArray.count];
  bias.klineArray = klineArray;
  [bias calculate];
  return [bias.pointsArray copy];
}

@end

@implementation BIASPoint

- (instancetype)initWithBias:(NSNumber *)bias
                       bias2:(NSNumber *)bias2
                       bias3:(NSNumber *)bias3
                        date:(int64_t)date {
  if (self = [super init]) {
    self.bias1 = bias;
    self.bias2 = bias2;
    self.bias3 = bias3;
    self.date = date;
  }
  return self;
}

@end
