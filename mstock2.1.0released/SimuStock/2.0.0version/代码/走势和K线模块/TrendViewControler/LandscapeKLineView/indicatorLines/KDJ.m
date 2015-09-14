//
//  KDJ.m
//  SimuStock
//
//  Created by Yuemeng on 15/5/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "KDJ.h"

#define kDays 9
#define dDays 3
#define jDays 3

@implementation KDJ

- (float)getRSV:(NSArray *)subArray {
  NSInteger count = subArray.count;
  KLineDataItem *item = subArray.lastObject;

  float closePrice = item.closeprice;
  float highPrice = item.highprice;
  float lowPrice = item.lowprice;

  int step = 0;

  if (count > kDays) {
    step = (int)count - kDays;
  }

  for (; step < count; step++) {
    item = subArray[step];

    if (item.highprice > highPrice) {
      highPrice = item.highprice;
    }

    if (item.lowprice < lowPrice) {
      lowPrice = item.lowprice;
    }
  }

  if (highPrice == lowPrice) {
    return 0.0f;
  }

  return (closePrice - lowPrice) * 100.f / (highPrice - lowPrice);
}

- (void)calculate {
  if (!_linesArray) {
    return;
  }

  NSInteger count = _linesArray.count;

  float k = [self getRSV:@[ _linesArray[0] ]];
  float d = k;

  for (NSInteger i = 0; i < count; i++) {

    float rsv =
        [self getRSV:[_linesArray subarrayWithRange:NSMakeRange(0, i + 1)]];
    k = 2.f * k / 3.f + rsv / 3.f;
    d = 2.f * d / 3.f + k / 3.f;
    float j = 3.f * k - 2.f * d;

    int64_t date = [(KLineDataItem *)_linesArray[i] date];

    KDJPoint *point = [[KDJPoint alloc] init];
    point.k = [KLineUtil roundUp:k];
    point.d = [KLineUtil roundUp:d];
    point.j = [KLineUtil roundUp:j];
    point.date = date;
    [_pointsArray addObject:point];
  }
}

+ (NSArray *)getKDJPoints:(NSArray *)dataArray {
  KDJ *kdj = [[KDJ alloc] init];
  kdj.pointsArray = [[NSMutableArray alloc] initWithCapacity:dataArray.count];
  kdj.linesArray = dataArray;
  [kdj calculate];
  return [kdj.pointsArray copy];
}

@end

@implementation KDJPoint
@end
