//
//  TimerUtil.m
//  SimuStock
//
//  Created by Mac on 15/5/8.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "TimerUtil.h"

@implementation TimerUtil

- (void)dealloc {
  NSLog(@"TimerUtil dealloc");
}

- (id)initWithTimeInterval:(NSTimeInterval)timeinterval
          withTimeCallBack:(TimerCallBack)timerCallBack {
  self = [super init];
  if (self) {
    _timerCallBack = timerCallBack;
    self.timeinterval = timeinterval;
  }
  return self;
}

- (void)setTimeinterval:(NSTimeInterval)timeinterval {
  _timeinterval = timeinterval;
  if (_timeinterval > 0) {
    [self resumeTimer];
  } else {
    [self stopTimer];
  }
}

///定时器停止
- (void)stopTimer {
  if (_iKLTimer) {
    [_iKLTimer invalidate];
    _iKLTimer = nil;
  }
}

///定时器启动
- (void)resumeTimer {
  [self stopTimer];
  _iKLTimer = [NSTimer scheduledTimerWithTimeInterval:_timeinterval
                                               target:self
                                             selector:@selector(loopByTimer)
                                             userInfo:nil
                                              repeats:YES];
}

///定时器回调函数
- (void)loopByTimer {
  if (_timerCallBack) {
    _timerCallBack();
  }
}

@end
