//
//  CapitalFirstViewCell.m
//  SimuStock
//
//  Created by Mac on 15/4/8.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "CapitalFirstViewCell.h"
#import "CapitalScrollView.h"
#import "SBTickerView.h"
#import "SBTickView.h"

#import "UIImage+colorful.h"
///手机绑定界面
#import "CacheUtil.h"
#import "BaseTableViewController.h"
#import "NetLoadingWaitView.h"
#import "ComposeInterfaceUtil.h"
#import "AccountPageViewController.h"

@implementation CapitalFirstViewCell

- (void)setIsLogin:(BOOL)isLogin {
  _isLogin = isLogin;
  ///按钮是否隐藏
  [self isShowMyWFButtton];
}

- (void)awakeFromNib {
  [super awakeFromNib];
  self.clipsToBounds = YES;

  dataBind = NO;
  _CapitalBtn.layer.cornerRadius = 18;
  _CapitalBtn.clipsToBounds = YES;
  ///我的配资的按下态
  [_myWFAccountButton
      setBackgroundImage:
          [UIImage imageWithColor:[Globle colorFromHexRGB:Color_Gray_Edge]]
                forState:UIControlStateHighlighted];

  // Init
  _currentClock = @"000000000";
  _clockTickers =
      [NSArray arrayWithObjects:_TickerViewMillions1, _TickerViewMillions2,
                                _TickerViewMillions3, _TickerViewThousand1,
                                _TickerViewThousand2, _TickerViewThousand3,
                                _TickerViewMeta1, _TickerViewMeta2,
                                _TickerViewMeta3, nil];
  _backcolorTickers = [NSArray
      arrayWithObjects:@"53a3c1", @"6295c9", @"7585d0", @"7a6ed8", @"7e60d7",
                       @"7d5cd6", @"7b59cd", @"6c57c5", @"6155be", nil];
  NSInteger index = 0;
  for (SBTickerView *ticker in _clockTickers) {
    [ticker
        setFrontView:[SBTickView tickViewWithTitle:@"0"
                                          fontSize:30.0f
                                      andBackcolor:[_backcolorTickers
                                                       objectAtIndex:index]]];
    index++;
  }
  ///是否登入后，还没有配资账户
  self.isWFamount = YES;
  _CapitalBtn.normalBGColor = [Globle colorFromHexRGB:Color_WFOrange_btn];
  _CapitalBtn.highlightBGColor =
      [Globle colorFromHexRGB:Color_WFOrange_btnDown];

  [_CapitalBtn buttonWithTitle:@"申请配资"
            andNormaltextcolor:@"ffffff"
      andHightlightedTextColor:@"ffffff"];
  __weak CapitalFirstViewCell *weakSelf = self;
  _timeUtil = [[TimerUtil alloc]
      initWithTimeInterval:60.0f
          withTimeCallBack:^{
            if (![SimuUtil isLogined] || self.isWFamount) {
              [weakSelf requestWithFundMarqueeWithRefreshType:
                            RefreshTypeTimerRefresh];
            }
          }];
  [_timeUtil resumeTimer];
  ///初始化数据请求
  [self refreshMarqueeData];
}

///实盘申请
- (IBAction)FirmApplyBtn:(UIButton *)sender {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }

  [FullScreenLogonViewController
      checkLoginStatusWithCallBack:^(BOOL isLogined) {
        if ([SimuUtil isLogined]) {
          [NetLoadingWaitView startAnimating];
          [WFApplyAccountUtil applyAccountWithOwner:self
                                  withCleanCallBack:^{
                                    [NetLoadingWaitView stopAnimating];

                                  }];
        }
      }];
}

- (IBAction)CapitalButtonClick:(UIButton *)sender {
  if ([[SimuUtil getUserID] isEqualToString:@"-1"]) {
    [[NSNotificationCenter defaultCenter]
        postNotificationName:WFLogonNotification
                      object:nil];
  }
}

///刷新跑马灯数据
- (void)refreshMarqueeData {
  [self requestWithFundMarqueeWithRefreshType:RefreshTypeTimerRefresh];
}

///跑马灯数据
- (void)requestWithFundMarqueeWithRefreshType:(RefreshType)refreshType {
  if (!dataBind) {
    WithCapitalAvailable *data = [CacheUtil loadWithFundMarquee];
    if (data) {
      [self bindWithCapitalAvailable:data saveCache:NO];
    }
  }
  if (![SimuUtil isExistNetwork]) {
    if (!dataBind) {
      [_CapitalScrollView NotnetWork];
    }
    ///无网络block回去
    if (self.block) {
      self.block();
    }
    return;
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  //解析
  __weak CapitalFirstViewCell *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    CapitalFirstViewCell *strongSelf = weakSelf;
    if (strongSelf) {
      strongSelf.block();
      return NO;
    } else {
      return YES;
    }
  };
  callback.onSuccess = ^(NSObject *obj) {
    CapitalFirstViewCell *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindWithCapitalAvailable:(WithCapitalAvailable *)obj
                                 saveCache:YES];
    }
  };
  callback.onFailed = ^{
    if (refreshType != RefreshTypeTimerRefresh) {
      [BaseRequester defaultFailedHandler]();
    }
  };
  [WithCapitalHome checkWFAccountWithLimit:@"20" withCallback:callback];
}

- (void)bindWithCapitalAvailable:(WithCapitalAvailable *)marqueue
                       saveCache:(BOOL)saveCache {
  if (marqueue.userArray.count > 0) {

    if (saveCache) {
      [CacheUtil saveWithFundMarquee:marqueue];
    }

    dataBind = YES;

    /** IOSMNCG-6096
     未申请配资时的用户累计收益，左边第三位数字，切换栏目时经常会变成黑的或是有个黑边*/
    [SimuUtil performBlockOnMainThread:^{
      [self numberTick:marqueue.income];
    } withDelaySeconds:0.2];

    ///跑马灯
    [_CapitalScrollView StartAnimation:marqueue.userArray];
  } else {
    [_CapitalScrollView NotPeiZidata];
  }
}

- (void)numberTick:(long long)index {
  if (index > 999999999) {
    index = index / 10000;
    self.labeltext.text = @"万元";
  } else {
    self.labeltext.text = @"元";
  }

  NSString *newClock = [NSString stringWithFormat:@"%09lld", index];

  [_clockTickers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx,
                                              BOOL *stop) {
    if (![[_currentClock substringWithRange:NSMakeRange(idx, 1)]
            isEqualToString:[newClock
                                substringWithRange:NSMakeRange(idx, 1)]]) {
      [obj setBackView:
               [SBTickView
                   tickViewWithTitle:[newClock
                                         substringWithRange:NSMakeRange(idx, 1)]
                            fontSize:30.0f
                        andBackcolor:[_backcolorTickers objectAtIndex:idx]]];
      [obj tick:SBTickerViewTickDirectionDown animated:YES completion:nil];
    }
  }];

  _currentClock = newClock;
}

/** 判断用户是否登录，登陆则显示我的配资；没有登录则不显示*/
- (void)isShowMyWFButtton {
  if (_isLogin) {
    _myWFAccountButton.hidden = NO;
    _myWFAccountImgView.hidden = NO;
    _myWFAccountLabel.hidden = NO;
  } else {
    _myWFAccountButton.hidden = YES;
    _myWFAccountImgView.hidden = YES;
    _myWFAccountLabel.hidden = YES;
  }
}
- (IBAction)clickMyWFAccountButtonGotoMyAccountPage:(id)sender {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
  } else {
    AccountPageViewController *accountVC = [[AccountPageViewController alloc]
        initWithFrame:CGRectMake(0.f, 0.f, WIDTH_OF_SCREEN, HEIGHT_OF_SCREEN)];
    [AppDelegate pushViewControllerFromRight:accountVC];
  }
}

@end
