//
//  RSI.m
//  SimuStock
//
//  Created by Yuemeng on 15/5/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "RSI.h"
#import "TupleValue.h"

#define DEFAULT_PERIOD1 6
#define DEFAULT_PERIOD2 12
#define DEFAULT_PERIOD3 24

@implementation RSI

- (NSArray *)calcSMA:(NSArray *)kLineArray period:(NSInteger)period {
  NSInteger count = kLineArray.count;

  NSMutableArray *smaArray = [[NSMutableArray alloc] initWithCapacity:count];

  TupleValue *value = [[TupleValue alloc] initWithFirst:@(0.f) second:@(0.f)];
  [smaArray addObject:value];

  float posSMA = 0.f;
  float absSMA = 0.f;

  for (NSInteger i = 1; i < count; i++) {
    float closePice = [(KLineDataItem *)kLineArray[i] closeprice];
    float preClosePrice = [(KLineDataItem *)kLineArray[i - 1] closeprice];
    float closePriceDiff = closePice - preClosePrice;

    posSMA =
        (fmaxf(closePriceDiff, 0.f) * 1.f + posSMA * (period - 1)) / period;

    if (i == 1) {
      absSMA = fabsf(closePriceDiff);
    } else {
      absSMA = (fabsf(closePriceDiff) * 1.f + absSMA * (period - 1)) / period;
    }

    TupleValue *smaValue =
        [[TupleValue alloc] initWithFirst:@(posSMA) second:@(absSMA)];
    [smaArray addObject:smaValue];
  }
  return smaArray;
}

- (void)calculate {
  if (!_kLineArray) {
    return;
  }

  NSInteger count = _kLineArray.count;
  NSMutableDictionary *smaDic = [[NSMutableDictionary alloc] init];

  NSArray *periods =
      @[ @(DEFAULT_PERIOD1), @(DEFAULT_PERIOD2), @(DEFAULT_PERIOD3) ];

  for (NSInteger i = 0; i < periods.count; i++) { // 1 2 4
    NSArray *smaArray = [self calcSMA:_kLineArray period:[periods[i] intValue]];
    [smaDic setObject:smaArray forKey:periods[i]];
  }

  for (NSInteger i = 0; i < count; i++) {
    RSIPoint *rsiPoint = [[RSIPoint alloc] init];
    rsiPoint.valueDic = [[NSMutableDictionary alloc] init];
    rsiPoint.date = [(KLineDataItem *)_kLineArray[i] date];

    for (NSInteger j = 0; j < periods.count; j++) {
      int calcPeriod = [periods[j] intValue];
      if (i < calcPeriod - 1) {
        [rsiPoint.valueDic setObject:[NSNull null] forKey:periods[j]];
      } else {
        NSArray *smaArray = smaDic[periods[j]];
        float posSMA = [[(TupleValue *)smaArray[i] firstNumber] floatValue];
        float absSMA = [[(TupleValue *)smaArray[i] secondNumber] floatValue];

        NSNumber *rsi =
            (absSMA == 0.f ? nil
                           : @([KLineUtil roundUp:(posSMA / absSMA * 100.f)]));
          [rsiPoint.valueDic setObject:(rsi ? rsi : [NSNull null]) forKey:periods[j]];
      }
    }
    [_pointsArray addObject:rsiPoint];
  }
}

+ (NSArray *)getRSIPoints:(NSArray *)kLineArray {
  RSI *rsi = [[RSI alloc] init];
  rsi.pointsArray = [[NSMutableArray alloc] initWithCapacity:kLineArray.count];
  rsi.kLineArray = kLineArray;
  [rsi calculate];
  return [rsi.pointsArray copy];
}

@end

@implementation RSIPoint
@end