//
//  GetVerificationCode.m
//  SimuStock
//
//  Created by jhss on 14-11-9.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "GetVerificationCode.h"
#import "SimuUtil.h"

@implementation GetVerificationCode

- (void)dealloc {
  self.getAuthBtn = nil;
}
/**计时*/
- (void)changeButton {
  time = 60;
  [self startTime];
}
/**定时器关闭与开启*/
- (void)stopTime {
  if (_getTimer) {
    if ([_getTimer isValid]) {
      [_getTimer invalidate];
      _getTimer = nil;
    }
  }
}
- (void)startTime {
  //重置
  [self setTimeZero];
  if (_getTimer && [_getTimer isValid]) {
    return;
  }
  _getTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                               target:self
                                             selector:@selector(updateBtn)
                                             userInfo:nil
                                              repeats:YES];
}
//时间差清零
- (void)setTimeZero {
  //记录进入前台时间
  [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"startTimerData"];
  [[NSUserDefaults standardUserDefaults] setInteger:0.0 forKey:@"endTimerData"];
  [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)updateBtn {
  NSInteger startBGTimer =
      [[NSUserDefaults standardUserDefaults] integerForKey:@"startTimerData"];
  NSInteger endBgTimer =
      [[NSUserDefaults standardUserDefaults] integerForKey:@"endTimerData"];
  if (endBgTimer - startBGTimer > time && endBgTimer - startBGTimer > 0) {
    [self stopTime];
    [self authReset];
    [self setTimeZero];
    return;
  } else {
    time = time - endBgTimer + startBGTimer;
    [self setTimeZero];
  }
  if (![SimuUtil isExistNetwork]) {
    [self stopTime];
    [self authReset];
    return;
  }
  if (time == 60) {
    //按钮状态
    [_getAuthBtn setTitleColor:[Globle colorFromHexRGB:@"939393"]
                      forState:UIControlStateNormal];
  }
  //更改按钮名称，提示下载状态
  [_getAuthBtn setTitle:[NSString stringWithFormat:@"重新获取(%ld)", (long)time]
               forState:UIControlStateNormal];
  time--;
  if (time < 0) {
    [self stopTime];
    [self authReset];
    [_getAuthBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getAuthBtn setTitleColor:[Globle colorFromHexRGB:@"086dae"]
                      forState:UIControlStateNormal];
    _getAuthBtn.userInteractionEnabled = YES;
  } else {
    _getAuthBtn.userInteractionEnabled = NO;
  }
}
- (void)authReset {
  if ([_TPphoneNumber length] > 0) {
    _getAuthBtn.userInteractionEnabled = YES;
  } else {
    _getAuthBtn.userInteractionEnabled = NO;
  }
  [_getAuthBtn setTitleColor:[Globle colorFromHexRGB:@"086dae"]
                    forState:UIControlStateNormal];
  [_getAuthBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
}

@end
