//
//  TranceObservation.m
//  SimuStock
//
//  Created by Mac on 15-2-12.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SuperManTranceOperation.h"

@implementation SuperManTranceOperation

#if 0
//增加追踪
- (void)addTrace:(NSString *)userId matchID:(NSString *)matchID {
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak SuperManTranceOperation *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    SuperManTranceOperation *strongSelf = weakSelf;
    if (strongSelf) {
      return NO;
    } else {
      return YES;
    }
  };
  
  callback.onSuccess = ^(NSObject *obj) {
    SuperManTranceOperation *strongSelf = weakSelf;
    if (strongSelf) {
//      TracePCInfo *tradeInfo = (TracePCInfo *)obj;
//      if (tradeInfo) {
//        //追踪菊花消失
//        if ([trackIndicatorView isAnimating]) {
//          [trackIndicatorView stopAnimating];
//          taTrackLab.hidden = NO;
//          trackBtn.hidden = NO;
        }
        //追踪成功
        //strongSelf.traceFlagInt = 1;
        //刷新按钮 刷到0
       // [strongSelf TATrackingDataConcern];
        [NewShowLabel setMessageContent:@"追踪成功"];
        //追踪数量变化，刷新主页
        if ([SimuUtil isLogined]) {
          [AttentionEventObserver postAttentionEvent];
        }
      }
    }
  };
  callback.onFailed = ^() {
    if ([trackIndicatorView isAnimating]) {
      [trackIndicatorView stopAnimating];
      taTrackLab.hidden = NO;
      trackBtn.hidden = NO;
    }
  };
  callback.onError =
  ^(BaseRequestObject *error, NSException *ex) { NSLog(@"onerror"); };
  [TracePCInfo addTrace:userId matchID:matchID withCallback:callback];
}

//取消追踪
- (void)delTrace:(NSString *)userId matchID:(NSString *)matchID {
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak SuperManTranceOperation *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    SuperManTranceOperation *strongSelf = weakSelf;
    if (strongSelf) {
//      [strongSelf.indicatorView stopAnimating];
      return NO;
    } else {
      return YES;
    }
  };
  
  callback.onSuccess = ^(NSObject *obj) {
    HomepageViewController *strongSelf = weakSelf;
    if (strongSelf) {
      TracePCInfo *tradeInfo = (TracePCInfo *)obj;
      if (tradeInfo) {
        //菊花显示
        if ([trackIndicatorView isAnimating]) {
          [trackIndicatorView stopAnimating];
          taTrackLab.hidden = NO;
          trackBtn.hidden = NO;
        }
        //取消追踪成功
        strongSelf.traceFlagInt = -2;
        //刷新按钮 刷到0
        [strongSelf TATrackingDataConcern];
        [NewShowLabel setMessageContent:@"取消追踪成功"];
        //追踪数量变化，刷新主页
        if ([SimuUtil isLogined]) {
          [AttentionEventObserver postAttentionEvent];
        }
      }
    }
  };
  callback.onFailed = ^() {
    if ([attentionIndicatorView isAnimating]) {
      [attentionIndicatorView stopAnimating];
      attentionImageView.hidden = NO;
      taConcernLab.hidden = NO;
      attentionBtn.hidden = NO;
    }
  };
  callback.onError =
  ^(BaseRequestObject *error, NSException *ex) { NSLog(@"onerror"); };
  [TracePCInfo delTrace:userId matchID:matchID withCallback:callback];
}
#endif

@end
