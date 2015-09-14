//
//  BOLL.m
//  SimuStock
//
//  Created by Yuemeng on 15/5/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BOLL.h"

#define DEFAULT_PERIOD 20
#define DEFAULT_TIMES 2

@implementation BOLL

- (NSArray *)calcMA:(NSArray *)klineArray period:(int)period {
  NSInteger arrayCount = klineArray.count;
  NSMutableArray *maArray =
      [[NSMutableArray alloc] initWithCapacity:arrayCount];

  for (NSInteger i = 0; i < arrayCount; i++) {
    int from = (int)i - period + 1;
      
    if (from < 0) {
      from = 0;
    }
      
    int count = 0;
    float sum = 0.f;

    for (int j = from; j <= i; j++) {
      sum += [(KLineDataItem *)klineArray[j] closeprice];
      count++;
    }

    float ma = sum / count;
    [maArray addObject:@(ma)];
  }
  return [maArray copy];
}

- (NSArray *)calcSTD:(NSArray *)klineArray
              period:(int)period
             maArray:(NSArray *)maArray {
  NSInteger arrayCount = klineArray.count;

  NSMutableArray *stdArray =
      [[NSMutableArray alloc] initWithCapacity:arrayCount];

  for (NSInteger i = 0; i < arrayCount; i++) {
    float ma = [maArray[i] floatValue];
    int from = (int)i - period + 1;
      
    if (from < 0) {
      from = 0;
    }
      
    int count = 0;
    float sum = 0.f;

    for (NSInteger j = from; j <= i; j++) {
      float close = [(KLineDataItem *)klineArray[j] closeprice];
      sum += (close - ma) * (close - ma);
      count++;
    }

    double std = (count == 1 ? 0.0 : sqrtf(sum / (count - 1)));
    [stdArray addObject:@(std)];
  }
  return [stdArray copy];
}

- (void)calculate {
  if (!_kLineArray) {
    return;
  }

  NSArray *maArray = [self calcMA:_kLineArray period:DEFAULT_PERIOD];
  NSArray *stdArray =
      [self calcSTD:_kLineArray period:DEFAULT_PERIOD maArray:maArray];

  NSInteger count = _kLineArray.count;

  for (NSInteger i = 0; i < count; i++) {
    int64_t date = [(KLineDataItem *)_kLineArray[i] date];

    if (i < DEFAULT_PERIOD - 1) {
      BOLLPoint *point =
          [[BOLLPoint alloc] initWithMid:nil upper:nil lower:nil date:date];
      [_pointsArray addObject:point];
    } else {
      float mid = [KLineUtil roundUp:[maArray[i] floatValue]];
      float upper =
          [KLineUtil roundUp:(mid + DEFAULT_TIMES * [stdArray[i] doubleValue])];
      float lower =
          [KLineUtil roundUp:(mid - DEFAULT_TIMES * [stdArray[i] doubleValue])];

      BOLLPoint *point = [[BOLLPoint alloc] initWithMid:@(mid)
                                                  upper:@(upper)
                                                  lower:@(lower)
                                                   date:date];
      [_pointsArray addObject:point];
    }
  }
}

+ (NSArray *)getBOLLPoints:(NSArray *)klineArray {
  BOLL *boll = [[BOLL alloc] init];
  boll.pointsArray = [[NSMutableArray alloc] initWithCapacity:klineArray.count];
  boll.kLineArray = klineArray;
  [boll calculate];
  return [boll.pointsArray copy];
}

@end

@implementation BOLLPoint

- (instancetype)initWithMid:(NSNumber *)mid
                      upper:(NSNumber *)upper
                      lower:(NSNumber *)lower
                       date:(int64_t)date {
  if (self = [super init]) {
    self.mid = mid;
    self.upper = upper;
    self.lower = lower;
    self.date = date;
  }
  return self;
}

@end
