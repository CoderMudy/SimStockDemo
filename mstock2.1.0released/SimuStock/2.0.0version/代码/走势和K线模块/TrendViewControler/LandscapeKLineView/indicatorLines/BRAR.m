//
//  BRAR.m
//  SimuStock
//
//  Created by Yuemeng on 15/5/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BRAR.h"

#define DEFAULT_PERIOD 26

@implementation BRAR

- (void)calculate {
  if (!_klineArray) {
    return;
  }

  NSInteger count = _klineArray.count;

  for (NSInteger i = 0; i < count; i++) {
    int from = (int)i - DEFAULT_PERIOD + 1;

    if (from < 0) {
      from = 0;
    }

    float sum1 = 0.f;
    float sum2 = 0.f;
    float sum3 = 0.f;
    float sum4 = 0.f;

    for (NSInteger j = from; j <= i; j++) {
      float high = [(KLineDataItem *)_klineArray[j] highprice];
      float open = [(KLineDataItem *)_klineArray[j] openprice];
      float low = [(KLineDataItem *)_klineArray[j] lowprice];
      float preClose =
          (j - 1 < 0 ? 0.f : [(KLineDataItem *)_klineArray[j - 1] closeprice]);

      sum1 += high - open;
      sum2 += open - low;

      if (j == 0) {
        continue;
      }

      sum3 += fmaxf(0.f, high - preClose);

      if (preClose <= 0.f) {
        continue;
      }

      sum4 += fmaxf(0.f, preClose - low);
    }

    int64_t date = [(KLineDataItem *)_klineArray[i] date];

    NSNumber *ar;
    NSNumber *br;

    if (sum2 != 0.f) {
      ar = @([KLineUtil roundUp:(sum1 / sum2 * 100.f)]);
    }

    if ((sum4 != 0.f) && (i > 0)) {
      br = @([KLineUtil roundUp:sum3 / sum4 * 100.f]);
    }

    BRARPoint *point = [[BRARPoint alloc] initWithAR:ar br:br date:date];
    [_pointsArray addObject:point];
  }
}

+ (NSArray *)getBRARPoints:(NSArray *)klineArray {
  BRAR *brar = [[BRAR alloc] init];
  brar.pointsArray = [[NSMutableArray alloc] initWithCapacity:klineArray.count];
  brar.klineArray = klineArray;
  [brar calculate];
  return [brar.pointsArray copy];
}

@end

@implementation BRARPoint

- (instancetype)initWithAR:(NSNumber *)ar br:(NSNumber *)br date:(int64_t)date {
  if (self = [super init]) {
    self.ar = ar;
    self.br = br;
    self.date = date;
  }
  return self;
}

@end
