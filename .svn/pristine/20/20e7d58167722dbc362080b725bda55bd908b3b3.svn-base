//
//  simuTopTimeBarView.m
//  SimuStock
//
//  Created by Mac on 14-7-11.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SimuTopTimeBarView.h"
#import "SimuUtil.h"

#import "SimuTradeStatus.h"

@implementation SimuTopTimeBarView

- (void)awakeFromNib {
  [super awakeFromNib];
  [self startUpdateTime];
  self.frame = CGRectMake(0, 0, WIDTH_OF_SCREEN, 30);
  self.bottomView.frame = CGRectMake(0, self.height - 0.5, self.width, 0.5);
}

- (void)startUpdateTime {
  _refreshTime = 1;
  self.backgroundColor = [UIColor whiteColor];
  [self updateExchangeStatusAndCurrentTime];
  [self initTrendTimer];
}

#pragma mark
#pragma mark 功能函数

+ (NSDateFormatter *)formatter {
  static NSDateFormatter *formatter;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSTimeZone *timezone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:timezone];
    [formatter setDateFormat:@"MM/dd HH:mm "];
  });
  return formatter;
}

+ (NSCalendar *)calendar {
  static NSCalendar *calendar;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSTimeZone *timezone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    calendar =
        [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setTimeZone:timezone];
  });
  return calendar;
}

//设定出本地时间
- (void)resetCurrentTimeLable {
  NSString *time =
      [[SimuTopTimeBarView formatter] stringFromDate:[NSDate date]];

  NSString *weekStr = nil;

  NSDateComponents *comps =
      [[SimuTopTimeBarView calendar] components:NSWeekdayCalendarUnit
                                       fromDate:[NSDate date]];

  NSInteger week = [comps weekday];

  if (week == 1) {
    weekStr = @"星期天";
  } else if (week == 2) {
    weekStr = @"星期一";
  } else if (week == 3) {
    weekStr = @"星期二";
  } else if (week == 4) {
    weekStr = @"星期三";
  } else if (week == 5) {
    weekStr = @"星期四";
  } else if (week == 6) {
    weekStr = @"星期五";
  } else if (week == 7) {
    weekStr = @"星期六";
  } else {
    NSLog(@"error!");
  }
  NSString *str_CorTiem = [NSString stringWithFormat:@"%@ %@", time, weekStr];
  _sttbv_timeShowLB.text = str_CorTiem;
}

#pragma mark
#pragma mark--------定时器相关函数-------------

- (void)timeVisible:(BOOL)visible {
  if (visible == YES) {
    [self stopMyTimer];
    [self initTrendTimer];
  } else {
    [self stopMyTimer];
  }
}
//创建定时器
- (void)initTrendTimer {
  if (_timer)
    return;
  //得到刷新数据

  _timer = [NSTimer scheduledTimerWithTimeInterval:_refreshTime
                                            target:self
                                          selector:@selector(execTimeTask:)
                                          userInfo:nil
                                           repeats:YES];
}

/** 定时器回调函数: 执行定时任务 */
- (void)execTimeTask:(NSTimer *)theTimer {
  if (_timer == theTimer) {
    [self updateExchangeStatusAndCurrentTime];
  }
}

- (void)forceRefresh {
  SimuTradeStatus *statusUtil = [SimuTradeStatus instance];
  [statusUtil requestExchangeStatus:^{
    [self updateExchangeStatusAndCurrentTime];
  }];
}

/**
 设置交易所开盘状态、当前时间
 */
- (void)updateExchangeStatusAndCurrentTime {
  SimuTradeStatus *statusUtil = [SimuTradeStatus instance];
  NSMutableAttributedString *text = [statusUtil getExchangeStatusDescription];
  [_sttbv_openMarketLB setAttributedText:text];
  [self resetCurrentTimeLable];

  BOOL needRefreshBySecond = [statusUtil needRefreshBySecond];
  if (needRefreshBySecond && _refreshTime != 1) {
    //如果需要每秒刷新一次，且刷新频率不对
    _refreshTime = 1;
    [self stopMyTimer];
    [self initTrendTimer];
  } else if (!needRefreshBySecond && _refreshTime != 10) {
    //如果不需要每秒刷新一次，且刷新频率不对
    _refreshTime = 10;
    [self stopMyTimer];
    [self initTrendTimer];
  }
}

//定时器停止
- (void)stopMyTimer {
  if (_timer) {
    if ([_timer isValid]) {
      [_timer invalidate];
      _timer = nil;
    }
  }
}

@end
