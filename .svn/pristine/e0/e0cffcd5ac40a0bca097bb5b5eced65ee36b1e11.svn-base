//
//  WR.m
//  SimuStock
//
//  Created by Yuemeng on 15/5/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "WR.h"

#define DEFAULT_PERIOD 10

@implementation WR

- (NSArray *)calcHHV:(NSArray *)klineArray period:(int)period {
  NSInteger count = klineArray.count;
  NSMutableArray *hhvArray = [[NSMutableArray alloc] initWithCapacity:count];

  for (NSInteger i = 0; i < count; i++) {
    int from = (int)i - period + 1;

    if (from < 0) {
      from = 0;
    }

    float high = 0.f;

    for (NSInteger j = from; j <= i; j++) {
      float tmpHigh = [(KLineDataItem *)klineArray[j] highprice];
      if (tmpHigh <= high) {
        continue;
      }

      high = tmpHigh;
    }
    [hhvArray addObject:@(high)];
  }
  return [hhvArray copy];
}

- (NSArray *)calcLLV:(NSArray *)klineArray period:(int)period {
  NSInteger count = klineArray.count;
  NSMutableArray *llvArray = [[NSMutableArray alloc] initWithCapacity:count];

  for (NSInteger i = 0; i < count; i++) {
    int from = (int)i - period + 1;

    if (from < 0) {
      from = 0;
    }

    float low = 999999.0f;

    for (NSInteger j = from; j <= i; j++) {
      float tmpLow = [(KLineDataItem *)klineArray[j] lowprice];

      if (tmpLow >= low) {
        continue;
      }

      low = tmpLow;
    }

    [llvArray addObject:@(low)];
  }
  return [llvArray copy];
}

- (void)calculate {
  if (!_klineArray) {
    return;
  }

  NSArray *hhvArrayN1 = [self calcHHV:_klineArray period:DEFAULT_PERIOD];
  NSArray *hhvArray6 = [self calcHHV:_klineArray period:6];
  NSArray *llvArrayN1 = [self calcLLV:_klineArray period:DEFAULT_PERIOD];
  NSArray *llvArray6 = [self calcLLV:_klineArray period:6];

  NSInteger count = _klineArray.count;

  for (NSInteger i = 0; i < count; i++) {
    float close = [(KLineDataItem *)_klineArray[i] closeprice];
    int64_t date = [(KLineDataItem *)_klineArray[i] date];

    NSNumber *wr1, *wr2;

    float tmp1 = [hhvArrayN1[i] floatValue] - [llvArrayN1[i] floatValue];

    if (tmp1 != 0.f) {
      wr1 = @([KLineUtil
          roundUp:(100.f * ([hhvArrayN1[i] floatValue] - close) / tmp1)]);
    }

    float tmp2 = [hhvArray6[i] floatValue] - [llvArray6[i] floatValue];

    if (tmp2 != 0.f) {
      wr2 = @([KLineUtil
          roundUp:(100.f * ([hhvArray6[i] floatValue] - close) / tmp2)]);
    }

    WRPoint *point = [[WRPoint alloc] initWithWr1:wr1 wr2:wr2 date:date];
    [_pointsArray addObject:point];
  }
}

+ (NSArray *)getWRPoints:(NSArray *)klineArray {
  WR *wr = [[WR alloc] init];
  wr.pointsArray = [[NSMutableArray alloc] initWithCapacity:klineArray.count];
  wr.klineArray = klineArray;
  [wr calculate];
  return [wr.pointsArray copy];
}

@end

@implementation WRPoint

- (instancetype)initWithWr1:(NSNumber *)wr1
                        wr2:(NSNumber *)wr2
                       date:(int64_t)date {
  if (self = [super init]) {
    self.wr1 = wr1;
    self.wr2 = wr2;
    self.date = date;
  }
  return self;
}

@end