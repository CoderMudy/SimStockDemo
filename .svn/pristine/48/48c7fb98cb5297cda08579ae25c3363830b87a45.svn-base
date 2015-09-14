//
//  OpeningTimeView.m
//  SimuStock
//
//  Created by moulin wang on 14-8-21.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "OpeningTimeView.h"
#import "SimuUtil.h"
#import "SimuTradeStatus.h"

@implementation OpeningTimeView

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    self.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
    [self creatControlViews];
    [self updateExchangeStatus];
    [self initTrendTimer];
  }
  return self;
}

-(void)awakeFromNib
{
  self.backgroundColor = [Globle colorFromHexRGB:Color_White];
  [self creatControlViews];
  [self updateExchangeStatus];
  [self initTrendTimer];
}

//创建基本可用控件
- (void)creatControlViews {
  //小闹钟图片
  UIImage *image = [UIImage imageNamed:@"交易闹钟图标"];
  _sttbv_alarmIV = [[UIImageView alloc]
      initWithFrame:CGRectMake(
                        7, (self.bounds.size.height - image.size.height) / 2,
                        image.size.width, image.size.height)];
  _sttbv_alarmIV.image = image;
  [self addSubview:_sttbv_alarmIV];

  //开盘时间标签
  sttbv_openMarketLB = [[UILabel alloc]
      initWithFrame:CGRectMake(_sttbv_alarmIV.frame.origin.x +
                                   _sttbv_alarmIV.bounds.size.width + 4,
                               (self.bounds.size.height - 14) / 2, 225, 17)];
  sttbv_openMarketLB.backgroundColor = [UIColor clearColor];
  sttbv_openMarketLB.font = [UIFont systemFontOfSize:14];
  sttbv_openMarketLB.textAlignment = NSTextAlignmentLeft;
  sttbv_openMarketLB.textColor = [Globle colorFromHexRGB:Color_Icon_Title];
  [self addSubview:sttbv_openMarketLB];
}

#pragma mark
#pragma mark 功能函数

- (void)updateExchangeStatus {
  if ([[SimuTradeStatus instance] getExchangeStatus] == TradeClosed) {
    _sttbv_alarmIV.hidden = NO;
  } else {
    _sttbv_alarmIV.hidden = YES;
  }
  [sttbv_openMarketLB
      setAttributedText:
          [[SimuTradeStatus instance] getExchangeStatusDescriptionForBuySell]];
}

#pragma mark
#pragma mark--------定时器相关函数-------------

- (void)timeVisible:(BOOL)visible {
  if (visible == YES) {
    [self initTrendTimer];
  } else {
    [self stopMyTimer];
  }
}
//创建定时器
- (void)initTrendTimer {
  //得到刷新数据
  NSInteger refreshTime = 1;
  if (iKLTimer) {
    if ([iKLTimer isValid]) {
      [iKLTimer invalidate];
    }
  }
  iKLTimer =
      [NSTimer scheduledTimerWithTimeInterval:refreshTime
                                       target:self
                                     selector:@selector(KLineHandleTimer:)
                                     userInfo:nil
                                      repeats:YES];
}

//定时器回调函数
- (void)KLineHandleTimer:(NSTimer *)theTimer {
  if (iKLTimer == theTimer) {
    [self updateExchangeStatus];
  }
}
//定时器停止
- (void)stopMyTimer {
  if (iKLTimer) {
    if ([iKLTimer isValid]) {
      [iKLTimer invalidate];
      iKLTimer = nil;
    }
  }
}

@end
