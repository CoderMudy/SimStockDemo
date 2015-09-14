//
//  DMI.m
//  SimuStock
//
//  Created by Yuemeng on 15/5/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "DMI.h"
#import "TupleValue.h"

#define DEFAULT_PERIOD_N 14
#define DEFAULT_PERIOD_M 6

@implementation DMI

- (NSArray *)calcTR {
  NSInteger count = _klineArray.count;
  NSMutableArray *trArray = [[NSMutableArray alloc] initWithCapacity:count];

  for (NSInteger i = 0; i < count; i++) {
    if (i == 0) {
      [trArray addObject:@(0.f)];
    } else {
      int from = (int)i - DEFAULT_PERIOD_N + 1;

      if (from < 0) {
        from = 0;
      }

      float tr = 0.f;

      for (NSInteger j = from; j <= i; j++) {
        float open = [(KLineDataItem *)_klineArray[j] openprice];
        float high = [(KLineDataItem *)_klineArray[j] highprice];
        float low = [(KLineDataItem *)_klineArray[j] lowprice];
        float preClose =
            (j == 0 ? open : [(KLineDataItem *)_klineArray[j - 1] closeprice]);
        float tmp = fmaxf(fmaxf(high - low, fabsf(high - preClose)),
                          fabsf(low - preClose));
        tr += tmp;
      }

      [trArray addObject:@(tr)];
    }
  }
  return [trArray copy];
}

- (NSArray *)calcDMM {
  NSInteger count = _klineArray.count;
  NSMutableArray *dmmArray = [[NSMutableArray alloc] initWithCapacity:count];

  for (NSInteger i = 0; i < count; i++) {
    if (i == 0) {
      [dmmArray addObject:@(0.f)];
    } else {
      int from = (int)i - DEFAULT_PERIOD_N + 1;
      if (from < 0) {
        from = 0;
      }
      float dmm = 0.f;

      for (NSInteger j = from; j <= i; j++) {
        float high = [(KLineDataItem *)_klineArray[j] highprice];
        float preHigh =
            (j == 0 ? high : [(KLineDataItem *)_klineArray[j - 1] highprice]);
        float low = [(KLineDataItem *)_klineArray[j] lowprice];
        float preLow =
            (j == 0 ? low : [(KLineDataItem *)_klineArray[j - 1] lowprice]);
        float hd = high - preHigh;
        float ld = preLow - low;
        float tmp = (ld > 0.f) && (ld > hd) ? ld : 0.f;
        dmm += tmp;
      }
      [dmmArray addObject:@(dmm)];
    }
  }
  return [dmmArray copy];
}

- (NSArray *)calcDMP {
  NSInteger count = _klineArray.count;
  NSMutableArray *dmpArray = [[NSMutableArray alloc] initWithCapacity:count];

  for (NSInteger i = 0; i < count; i++) {
    if (i == 0) {
      [dmpArray addObject:@(0.f)];
    } else {
      int from = (int)i - DEFAULT_PERIOD_N + 1;

      if (from < 0) {
        from = 0;
      }

      float dmp = 0.f;

      for (NSInteger j = from; j <= i; j++) {
        float high = [(KLineDataItem *)_klineArray[j] highprice];
        float preHigh =
            (j == 0 ? high : [(KLineDataItem *)_klineArray[j - 1] highprice]);
        float low = [(KLineDataItem *)_klineArray[j] lowprice];
        float preLow =
            (j == 0 ? low : [(KLineDataItem *)_klineArray[j - 1] lowprice]);
        float hd = high - preHigh;
        float ld = preLow - low;
        float tmp = (hd > 0.f) && (hd > ld) ? hd : 0.f;
        dmp += tmp;
      }
      [dmpArray addObject:@(dmp)];
    }
  }
  return [dmpArray copy];
}

- (void)calculate {
  if (!_klineArray) {
    return;
  }

  NSArray *trArray = [self calcTR];
  NSArray *dmpArray = [self calcDMP];
  NSArray *dmmArray = [self calcDMM];

  NSInteger count = _klineArray.count;
  NSMutableArray *pdimdiArray = [[NSMutableArray alloc] initWithCapacity:count];

  for (NSInteger i = 0; i < count; i++) {
    float tr = [trArray[i] floatValue];
    float dmp = [dmpArray[i] floatValue];
    float dmm = [dmmArray[i] floatValue];
    float pdi = (tr == 0.f ? 0.f : dmp * 100.f / tr);
    float mdi = (tr == 0.f ? 0.f : dmm * 100.f / tr);

    TupleValue *tuple = [[TupleValue alloc] initWithFirst:@(pdi) second:@(mdi)];
    [pdimdiArray addObject:tuple];
  }

  NSMutableArray *adxArray = [[NSMutableArray alloc] initWithCapacity:count];

  for (NSInteger i = 0; i < count; i++) {
    if (i < DEFAULT_PERIOD_M) {
      [adxArray addObject:[NSNull null]];
    } else {
      int from = (int)i - DEFAULT_PERIOD_M + 1;
      if (from < 0) {
        from = 0;
      }
      float sum = 0.f;
      int num = 0;

      for (NSInteger j = from; j <= i; j++) {
        float pdi = [[(TupleValue *)pdimdiArray[j] firstNumber] floatValue];
        float mdi = [[(TupleValue *)pdimdiArray[j] secondNumber] floatValue];

        if (mdi + pdi != 0.f) {
          sum += fabsf(mdi - pdi) / (mdi + pdi) * 100.f;
        }
        num++;
      }

      float adx = sum / num;
      [adxArray addObject:@(adx)];
    }
  }

  NSMutableArray *adxrArray = [[NSMutableArray alloc] initWithCapacity:count];

  for (NSInteger i = 0; i < count; i++) {
    if (i < 2 * DEFAULT_PERIOD_M) {
      [adxrArray addObject:[NSNull null]];
    } else {
      float adx = [adxArray[i] floatValue];
      int refIndex = (i - DEFAULT_PERIOD_M < 0 ? 0 : (int)i - DEFAULT_PERIOD_M);
      float refAdx = [adxArray[refIndex] floatValue];
      float adxr = (adx + refAdx) / 2.f;
      [adxrArray addObject:@(adxr)];
    }
  }

  for (NSInteger i = 0; i < count; i++) {
    int64_t date = [(KLineDataItem *)_klineArray[i] date];
    NSNumber *pdi = @([KLineUtil
        roundUp:[[(TupleValue *)pdimdiArray[i] firstNumber] floatValue]]);
    NSNumber *mdi = @([KLineUtil
        roundUp:[[(TupleValue *)pdimdiArray[i] secondNumber] floatValue]]);
    NSNumber *adx = adxArray[i];

    if (![adx isEqual:[NSNull null]]) {
      adx = @([KLineUtil roundUp:adx.floatValue]);
    }

    NSNumber *adxr = adxrArray[i];

    if (![adxr isEqual:[NSNull null]]) {
      adxr = @([KLineUtil roundUp:adxr.floatValue]);
    }

    DMIPoint *point =
        [[DMIPoint alloc] initWithPdi:pdi mdi:mdi adx:adx adxr:adxr date:date];
    [_pointsArray addObject:point];
  }
}

+ (NSArray *)getDMIPoints:(NSArray *)klineArray {
  DMI *dmi = [[DMI alloc] init];
  dmi.pointsArray = [[NSMutableArray alloc] initWithCapacity:klineArray.count];
  dmi.klineArray = klineArray;
  [dmi calculate];
  return [dmi.pointsArray copy];
}

@end

@implementation DMIPoint

- (instancetype)initWithPdi:(NSNumber *)pdi
                        mdi:(NSNumber *)mdi
                        adx:(NSNumber *)adx
                       adxr:(NSNumber *)adxr
                       date:(int64_t)date {
  if (self = [super init]) {
    self.pdi = pdi;
    self.mdi = mdi;
    self.adx = adx;
    self.adxr = adxr;
    self.date = date;
  }
  return self;
}

@end
