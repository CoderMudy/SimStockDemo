//
//  MarketWindIndicatorView.m
//  SimuStock
//
//  Created by Yuemeng on 15/5/13.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "WindVaneView.h"
#import "Globle.h"
#import "FindWindVaneData.h"
#import "CowThanBearUserVoteData.h"

@implementation WindVaneView

- (void)awakeFromNib {
  //改变图片的缩放模式为等比缩放0
  _riseNumButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
  _fallNumButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
  // rise 为红 fall为绿
  [_voteRiseButton setBackgroundImage:[SimuUtil imageFromColor:@"#FCA9A9"]
                             forState:UIControlStateDisabled];
  [_voteRiseButton setBackgroundImage:[SimuUtil imageFromColor:@"#CE4D4D"]
                             forState:UIControlStateHighlighted];
  [_voteFallButton setBackgroundImage:[SimuUtil imageFromColor:@"#93d693"]
                             forState:UIControlStateDisabled];
  [_voteFallButton setBackgroundImage:[SimuUtil imageFromColor:@"#388738"]
                             forState:UIControlStateHighlighted];
  [self layoutIfNeeded];
}

- (void)requestDataFromNet {

  __weak WindVaneView *weakSelf = self;
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onCheckQuitOrStopProgressBar = ^{
    WindVaneView *strongSelf = weakSelf;
    if (strongSelf) {
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *object) {
    WindVaneView *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindWindVaneData:(FindWindVaneData *)object];
    }
  };

  [FindWindVaneData requsetFindWindVaneData:callback];
}

- (void)bindWindVaneData:(FindWindVaneData *)data {
  //涨百分比
  float upNum = [data.upstr floatValue] * 100.f;
  static float lastUp = 0;
  NSMutableAttributedString *riseArrStr = [[NSMutableAttributedString alloc]
      initWithString:[NSString stringWithFormat:@"%.2f%%", upNum]];

  [riseArrStr addAttributes:@{
    NSFontAttributeName : [UIFont systemFontOfSize:10]
  } range:NSMakeRange(riseArrStr.length - 1, 1)];

  _risePercentLabel.attributedText = riseArrStr;

  //根据前一个数据来决定上下淡出
  if (lastUp != upNum) {
    [UIView animateWithDuration:0.25f
        animations:^{
          _risePercentLabel.top += (lastUp < upNum ? -24 : 24);
          _risePercentLabel.alpha = 0;
        }
        completion:^(BOOL finished) {
          _risePercentLabel.top += (lastUp < upNum ? 48 : -48);
          lastUp = upNum;
          [UIView animateWithDuration:0.25f
                           animations:^{
                             _risePercentLabel.top = 72;
                             _risePercentLabel.alpha = 1;
                           }];
        }];
  }

  //跌
  float downNum = [data.downstr floatValue] * 100.f;
  static float lastDown = 0;

  NSMutableAttributedString *fallArrStr = [[NSMutableAttributedString alloc]
      initWithString:[NSString stringWithFormat:@"%.2f%%", downNum]];

  [fallArrStr addAttributes:@{
    NSFontAttributeName : [UIFont systemFontOfSize:10]
  } range:NSMakeRange(riseArrStr.length - 1, 1)];
  _fallPercentLabel.attributedText = fallArrStr;

  //根据前一个数据来决定上下淡出
  if (lastDown != downNum) {
    [UIView animateWithDuration:0.25f
        animations:^{
          _fallPercentLabel.top += (lastDown < downNum ? -24 : 24);
          _fallPercentLabel.alpha = 0;
        }
        completion:^(BOOL finished) {
          _fallPercentLabel.top += (lastDown < downNum ? 48 : -48);
          lastDown = downNum;
          [UIView animateWithDuration:0.25f
                           animations:^{
                             _fallPercentLabel.top = 72;
                             _fallPercentLabel.alpha = 1;
                           }];
        }];
  }

  //牛 和 熊 看涨跌数字
  [_riseNumButton setTitle:data.up forState:UIControlStateNormal];
  [_fallNumButton setTitle:data.down forState:UIControlStateNormal];

  // 根据用户状态和投票状态来改变button文字和状态

  //已投禁用button
  if ([data.userStatus isEqualToString:@"1"]) {
    [_voteRiseButton setTitle:@"已投" forState:UIControlStateNormal];
    [_voteFallButton setTitle:@"已投" forState:UIControlStateNormal];
    _voteRiseButton.enabled = NO;
    _voteFallButton.enabled = NO;

    //禁投时间
  } else if ([data.voteStatus isEqualToString:@"1"]) {
    [_voteRiseButton setTitle:@"结束" forState:UIControlStateNormal];
    [_voteFallButton setTitle:@"结束" forState:UIControlStateNormal];
    _voteRiseButton.enabled = NO;
    _voteFallButton.enabled = NO;
  } else {
    [_voteRiseButton setTitle:@"投票" forState:UIControlStateNormal];
    [_voteFallButton setTitle:@"投票" forState:UIControlStateNormal];
    _voteRiseButton.enabled = YES;
    _voteFallButton.enabled = YES;
  }
}

- (void)drawRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();

  //画方框
  CGRect drawRect = CGRectMake(5, 25, self.width - 5 * 2, 164);
  [[Globle colorFromHexRGB:COLOR_KLINE_BORDER] set];
  CGContextSetLineWidth(context, 1.f);

  CGContextStrokeRect(context, drawRect);

  //画中线
  CGContextMoveToPoint(context, self.width / 2, 25);
  CGContextAddLineToPoint(context, self.width / 2, 190);
  CGContextStrokePath(context);
}

- (IBAction)buttonClick:(UIButton *)button {
  static BOOL _isCLick;
  if (_isCLick) {
    return;
  }
  _isCLick = YES;
  //按下态，变深灰色
  UIColor *currentColor = button.backgroundColor;
  if (button == _voteRiseButton) {
    [button setBackgroundColor:[Globle colorFromHexRGB:@"#CE4D4D"]];

  } else {
    [button setBackgroundColor:[Globle colorFromHexRGB:@"#388738"]];
  }

  [SimuUtil performBlockOnMainThread:^{
    [button setBackgroundColor:currentColor];
    _isCLick = NO;
    // tag 100 看涨投票 101 看跌投票
    [FullScreenLogonViewController
        checkLoginStatusWithCallBack:^(BOOL isLogined) {

          if (![SimuUtil isExistNetwork]) {
            [self setNoNetwork];
            return;
          }

          //点哪个button，哪个button的菊花转动
          button.imageView.layer.opacity = 0.f;
          button.titleLabel.layer.opacity = 0.f;
          if (button == _voteRiseButton) {
            _riseIndicatorView.alpha = 1;
            [_riseIndicatorView startAnimating];
          } else if (button == _voteFallButton) {
            _fallIndicatorView.alpha = 1;
            [_fallIndicatorView startAnimating];
          }
          [self userVoteWithFlag:
                    [NSString stringWithFormat:@"%d", (int)button.tag - 100]];
        }];
  } withDelaySeconds:0.2f];
}

#pragma mark 无网提示
- (void)setNoNetwork {
  [NewShowLabel showNoNetworkTip]; //显示无网络提示
}

#pragma mark - ⭐️投票
- (void)userVoteWithFlag:(NSString *)flag {

  __weak WindVaneView *weakSelf = self;
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  callback.onCheckQuitOrStopProgressBar = ^{
    WindVaneView *strongSelf = weakSelf;
    if (strongSelf) {
      [self stopActivityIndicatorViewAnimating];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    [NewShowLabel setMessageContent:[(BaseRequestObject *)obj message]];
    WindVaneView *strongSelf = weakSelf;
    //投票成功立刻刷新数据
    [strongSelf requestDataFromNet];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"VoteSuccess"
                                                        object:nil];
  };

  callback.onError = ^(BaseRequestObject *obj, NSException *ex) {
    [NewShowLabel setMessageContent:obj.message];
  };

  [CowThanBearUserVoteData requestCattleVSBearUserVoteData:flag
                                              withCallback:callback];
}

- (void)stopActivityIndicatorViewAnimating {
  _voteRiseButton.imageView.layer.opacity = 1.f;
  _voteRiseButton.titleLabel.layer.opacity = 1.f;
  _voteFallButton.imageView.layer.opacity = 1.f;
  _voteFallButton.titleLabel.layer.opacity = 1.f;
  _riseIndicatorView.alpha = 0;
  _fallIndicatorView.alpha = 0;
  [_riseIndicatorView stopAnimating];
  [_fallIndicatorView stopAnimating];
  [_voteRiseButton setTitle:@"已投" forState:UIControlStateNormal];
  [_voteFallButton setTitle:@"已投" forState:UIControlStateNormal];
  _voteRiseButton.enabled = NO;
  _voteFallButton.enabled = NO;
}

@end
