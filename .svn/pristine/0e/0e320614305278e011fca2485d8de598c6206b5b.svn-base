//
//  MACD.m
//  SimuStock
//
//  Created by Yuemeng on 15/5/6.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MACD.h"

#define SHORT_PERIOD 12
#define LONG_PERIOD 26
#define MID_PERIOD 9

@implementation MACD

- (NSArray *)getEXPMA:(NSArray *)klineArray days:(NSInteger)days {
  NSInteger count = klineArray.count;

  NSMutableArray *expArray = [[NSMutableArray alloc] initWithCapacity:count];

  float k = 2.f / (days + 1.f);
  float ema = [klineArray[0] floatValue];

  [expArray addObject:@(ema)];

  for (NSInteger i = 1; i < count; i++) {
    ema = [klineArray[i] floatValue] * k + ema * (1.f - k);
    [expArray addObject:@(ema)];
  }
  return [expArray copy];
}

- (NSArray *)getEXPMAFromKline:(NSArray *)kLineArray days:(NSInteger)days {
  NSInteger count = kLineArray.count;

  NSMutableArray *expArray = [[NSMutableArray alloc] initWithCapacity:count];

  CGFloat k = 2.f / (days + 1.f);
  CGFloat ema = [(KLineDataItem *)kLineArray[0] closeprice];
  [expArray addObject:@(ema)];

  for (NSInteger i = 1; i < count; i++) {
    ema = [(KLineDataItem *)kLineArray[i] closeprice] * k + ema * (1.f - k);
    [expArray addObject:@(ema)];
  }
  return [expArray copy];
}

- (void)calculate {
  if (!_linesArray) {
    return;
  }
  NSInteger count = _linesArray.count;

  NSArray *shortPeriodArray =
      [self getEXPMAFromKline:_linesArray days:SHORT_PERIOD];
  NSArray *longPeriodArray =
      [self getEXPMAFromKline:_linesArray days:LONG_PERIOD];
  NSMutableArray *diffArray = [[NSMutableArray alloc] initWithCapacity:count];

  for (NSInteger i = 0; i < count; i++) {
    float dif =
        [shortPeriodArray[i] floatValue] - [longPeriodArray[i] floatValue];
    [diffArray addObject:@(dif)];
  }

  NSArray *deaArray = [self getEXPMA:diffArray days:MID_PERIOD];

  for (NSInteger i = 0; i < count; i++) {
    float dif = [diffArray[i] floatValue];
    float dea = [deaArray[i] floatValue];
    float macd = (dif - dea) * 2.f;

    MACDPoint *point = [[MACDPoint alloc] init];
    point.dif = [KLineUtil roundUp3:dif];
    point.dea = [KLineUtil roundUp3:dea];
    point.macd = [KLineUtil roundUp3:macd];
    point.date = [(KLineDataItem *)_linesArray[i] date];
    [_pointsArray addObject:point];
  }
}

+ (NSArray *)getMACDPoints:(NSArray *)kLineArray {
  MACD *macd = [[MACD alloc] init];
  macd.pointsArray = [[NSMutableArray alloc] initWithCapacity:kLineArray.count];
  macd.linesArray = kLineArray;
  [macd calculate];
  return [macd.pointsArray copy];
}

@end

@implementation MACDPoint

@end