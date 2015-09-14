//
//  TrendDateElement.m
//  iNtgStock
//
//  Created by Li BB on 12-2-17.
//  Copyright 2012 netgen. All rights reserved.
//

#import "TrendDateElement.h"

/*
 *类描述：浮窗显示元素定义
 */
@implementation TrendFloatViewElment

- (id)init:(NSString *)title forContent:(NSString *)content forContentColor:(UIColor *)color
{
    if (self = [super init]) {
        self.title = title;
        self.content = content;
        self.color = color;
    }
    return self;
}

@end

/*
 *类描述：浮窗显示的消息数据定义
 */
@implementation TrendFloatViewMsg

- (id)init:(CGRect)frame forShowMode:(TrendFLWindowState)mode forMsgType:(TrendMsgType)type
{
    if (self = [super init]) {
        _contentDataArray = [[NSMutableArray alloc] init];
        self.floatRect = frame;
        self.floatShowMode = mode;
        self.msgType = type;
        self.msgIndex = 0;
    }
    return self;
}

@end

/*
 *类描述：走势页面均线数据元素
 */
@implementation SAverageDataManager

- (id)init {
  if (self = [super init]) {
    self.iMinDateElementArray = [[NSMutableArray alloc] init];
    self.averageDataAarray = [[NSMutableArray alloc] init];
    self.period = 0;
    self.isTrend = YES;
  }
  return self;
}

/*
 *添加k线价格元素
 */
- (BOOL)addKLinePrice:(NSInteger)price {
  if (!_iMinDateElementArray)
    return NO;
  NSNumber *number = [NSNumber numberWithLong:price];
  [_iMinDateElementArray addObject:number];
  return YES;
}

/*
 *设定周期
 */
- (void)setSAPeriod:(NSInteger)period {
  self.period = period;
}

/*
 *初始化所有数据
 */
- (void)resetDataArray {
  if (!_iMinDateElementArray || !_averageDataAarray)
    return;
  [_iMinDateElementArray removeAllObjects];
  [_averageDataAarray removeAllObjects];
}

/*
 *计算均线数据
 */
- (BOOL)calAverageData {
  NSInteger i;
  int64_t Sum = 0;
  int64_t llValue = 0;
  //	int64_t   AllVolume=0;//总成交量
  //前面不足一个周期的数据,能算多少算多少。
  NSInteger Count = [_iMinDateElementArray count];

  [_averageDataAarray removeAllObjects];

  for (i = 0; i < ((_period < Count) ? _period : Count); i++) {
    NSNumber *elment = [_iMinDateElementArray objectAtIndex:i];
    if (nil != elment) {
      Sum += [elment intValue];
      llValue = Sum / ((NSInteger)(i + 1));
      NSNumber *num = [NSNumber numberWithLongLong:llValue];
      [_averageDataAarray addObject:num];
    }
  }

  for (i = _period; i < Count; i++) {
    NSNumber *elment = [_iMinDateElementArray objectAtIndex:i];
    if (nil != elment) {
      NSNumber *new = [_iMinDateElementArray objectAtIndex : i - _period];
      Sum += (NSInteger)([elment intValue] - [new intValue]);
      llValue = Sum / _period;
      NSNumber *num = [NSNumber numberWithLongLong:llValue];
      [_averageDataAarray addObject:num];
    }
  }
  return true;
}

/*
 *设置均线类型，默认为走势均线
 * YES  走势 NO 非走势
 */
- (BOOL)setFlag:(BOOL)mflag {
  _isTrend = mflag;
  return YES;
}

@end

/*
 *类描述：k线基本数据元素定义
 */
@implementation KLineDayData

- (id)init {
  if (self = [super init]) {
    self.date = 0;
    self.openPrice = 0;
    self.highestPrice = 0;
    self.lowestPrice = 0;
    self.closePrice = 0;
    self.amount = 0;
    self.volume = 0;
  }
  return self;
}

@end
