//
//  SimuJoinViewController.m
//  SimuStock
//
//  Created by Mac on 14-8-2.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SimuJoinViewController.h"
#import "SimuJoinBottomTabView.h"
#import "MatchChatStockPageTableVC.h"

@implementation SimuJoinViewController

- (id)init:(NSString *)march_id Name:(NSString *)march_name {
  self = [super init];
  if (self) {
    if (march_id == nil || [march_id length] == 0) {
      ssvc_marchid = @"-1";
    } else {
      ssvc_marchid = march_id;
    }
    if (march_name == nil || [march_name length] == 0) {
      ssvc_marchname = @"比赛";
    } else {
      ssvc_marchname = march_name;
    }
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];
  _indicatorView.hidden = YES;

  //创建上导航栏
  _topToolBar.tag = 9966;
  [_topToolBar resetContentAndFlage:ssvc_marchname Mode:TTBM_Mode_Leveltwo];
  self.commonBackHandler = ^{
    [AppDelegate popViewController:YES];

  };

  //创建中间承载页面
  [self creatBaseView];
  //创建下导航栏
  [self creatbottomToolBar];
  //创建用户主账户
  [self creatOrACountVC];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  if (ssvc_buyVC) {
    [ssvc_buyVC.view removeFromSuperview];
    [ssvc_buyVC removeFromParentViewController];
    ssvc_buyVC = nil;
  }
  if (ssvc_sellVC) {
    [ssvc_sellVC.view removeFromSuperview];
    [ssvc_sellVC removeFromParentViewController];
    ssvc_sellVC = nil;
  }
  if (_userAcountVC) {
    [_userAcountVC.view removeFromSuperview];
    [_userAcountVC removeFromParentViewController];
    _userAcountVC = nil;
  }
  if (ssvc_cancellVC) {
    [ssvc_cancellVC.view removeFromSuperview];
    [ssvc_cancellVC removeFromParentViewController];
    ssvc_cancellVC = nil;
  }
  if (ssvc_weiboVC) {
    [ssvc_weiboVC.view removeFromSuperview];
    [ssvc_weiboVC removeFromParentViewController];
    ssvc_weiboVC = nil;
  }
}
#pragma mark
#pragma mark 创建各个控件

//参加比赛下工具栏控件
- (void)creatbottomToolBar {
  bottomToolBar =
      [[SimuJoinBottomTabView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - BOTTOM_TOOL_BAR_HEIGHT,
                                                              _clientView.bounds.size.width, BOTTOM_TOOL_BAR_HEIGHT)];
  bottomToolBar.delegate = self;
  [self.view addSubview:bottomToolBar];
}

//创建基本承载页面
- (void)creatBaseView {
  ssvc_baseView =
      [[UIView alloc] initWithFrame:CGRectMake(0, 0, _clientView.width, self.view.height - BOTTOM_TOOL_BAR_HEIGHT)];
  ssvc_baseView.clipsToBounds = YES;
  ssvc_baseView.backgroundColor = [UIColor clearColor];
  [self.view addSubview:ssvc_baseView];
}

//创建或激活账户主页
- (void)creatOrACountVC {
  if (_userAcountVC == nil) {
    _userAcountVC = [[SimuMacthAccountVC alloc] initWithMatchId:ssvc_marchid
                                                     withUserID:[SimuUtil getUserID]
                                                   withUserName:[SimuUtil getUserNickName]
                                                      withTitle:ssvc_marchname];
    __weak SimuJoinViewController *weakSelf = self;
    _userAcountVC.buyStockAction = ^(NSString *stockCode, NSString *stockName, NSString *matchId) {
      [weakSelf switchToBuyPageWithStockCode:stockCode withStockName:stockName];

    };
    _userAcountVC.sellStockAction = ^(NSString *stockCode, NSString *stockName, NSString *matchId) {
      [weakSelf switchToSellPageWithStockCode:stockCode withStockName:stockName];

    };
    _userAcountVC.view.frame = ssvc_baseView.bounds;
    [_userAcountVC setBackButtonPressedHandler:self.commonBackHandler];
    _userAcountVC.view.tag = 0;
  }
  smvc_toViewController = _userAcountVC;
  _userAcountVC.indicatorView.hidden = NO;
  [self viewChangeWithLayerAnimate:ssvc_baseView
                        RemoveView:smvc_fromViewController.view
                           AddView:smvc_toViewController.view];
}

- (void)switchToBuyPageWithStockCode:(NSString *)stockCode withStockName:(NSString *)stockName {
  [self bottomButtonPressDown:1];
  [bottomToolBar resetSelectedState:1];
  [ssvc_buyVC resetWithStockCode:stockCode withStockName:stockName];
}
- (void)switchToSellPageWithStockCode:(NSString *)stockCode withStockName:(NSString *)stockName {
  [self bottomButtonPressDown:2];
  [bottomToolBar resetSelectedState:2];
  [ssvc_sellVC resetWithStockCode:stockCode withStockName:stockName];
}

//激活并创建买入页面
- (void)creatOrActiveBuyVC { // ssvc_marchid
  if (ssvc_buyVC == nil) {
    ssvc_buyVC = [[simuBuyViewController alloc] initWithStockCode:@""
                                                    withStockName:@""
                                                      withMatchId:ssvc_marchid
                                                    withAccountId:@""
                                             withStockSellBuyType:StockBuySellOrdinaryType
                                                    withTitleName:@""
                                                    withTargetUid:@""];
    [ssvc_buyVC setBackButtonPressedHandler:self.commonBackHandler];
    ssvc_buyVC.isFromMatch = YES;
    ssvc_buyVC.view.frame = ssvc_baseView.bounds;
    ssvc_buyVC.view.tag = 1;
    [self addChildViewController:ssvc_buyVC];
    [ssvc_baseView addSubview:ssvc_buyVC.view];
  }
  [ssvc_baseView bringSubviewToFront:ssvc_buyVC.view];
}

- (void)creatOrActiveSellVC {
  if (ssvc_sellVC == nil) {
    ssvc_sellVC = [[simuSellViewController alloc] initWithStockCode:@""
                                                      withStockName:@""
                                                        withMatchId:ssvc_marchid
                                                      withAccountId:@""
                                               withStockSellBuyType:StockBuySellOrdinaryType
                                                      withTitleName:@""
                                                      withTargetUid:@""];
    [ssvc_sellVC setBackButtonPressedHandler:self.commonBackHandler];
    ssvc_sellVC.view.frame = ssvc_baseView.bounds;
    ssvc_sellVC.view.tag = 2;
    [self addChildViewController:ssvc_sellVC];
    [ssvc_baseView addSubview:ssvc_sellVC.view];
  }
  [ssvc_baseView bringSubviewToFront:ssvc_sellVC.view];
}

- (void)creatOrActiveCancelVC {
  if (nil == ssvc_cancellVC) {
    ssvc_cancellVC = [[simuCancellationViewController alloc] initWithMatchId:ssvc_marchid
                                                               withAccountId:@""
                                                               withTitleName:@""
                                                            withUserOrExpert:StockBuySellOrdinaryType];
    ssvc_cancellVC.view.frame = ssvc_baseView.bounds;
    [ssvc_cancellVC setBackButtonPressedHandler:self.commonBackHandler];
    ssvc_cancellVC.view.tag = 3;
    [self addChildViewController:ssvc_cancellVC];
    [ssvc_baseView addSubview:ssvc_cancellVC.view];
  } else {
    [ssvc_cancellVC doqueryWithRequestFromUser:NO];
  }
  [ssvc_baseView bringSubviewToFront:ssvc_cancellVC.view];
}

- (void)createWeiboVC {
  if (nil == ssvc_weiboVC) {
    ssvc_weiboVC = [[MatchWeiboViewController alloc] initWithFrame:ssvc_baseView.bounds
                                                         withTitle:ssvc_marchname];
    [ssvc_weiboVC setBackButtonPressedHandler:self.commonBackHandler];
    ssvc_weiboVC.view.tag = 3;
    [self addChildViewController:ssvc_weiboVC];
    [ssvc_baseView addSubview:ssvc_weiboVC.view];
    ssvc_weiboVC.tableVC.clientView = self.clientView;
  }
  [ssvc_baseView bringSubviewToFront:ssvc_weiboVC.view];
}

- (void)destroyself {
  if (ssvc_buyVC) {
  }
  if (ssvc_sellVC) {
  }
  [self leftButtonPress];
}

#pragma mark
#pragma mark--底部按钮点击回调 simuBottomToolBarViewDelegate------
//底部按钮点击
- (void)bottomButtonPressDown:(NSInteger)index {
  switch (index) {
  case 0: {
    //账户持仓
    [self creatOrACountVC];
    break;
  }
  case 1: {
    //买入
    [self creatOrActiveBuyVC];
    break;
  }
  case 2: {
    //卖出
    [self creatOrActiveSellVC];
    break;
  }
  case 3: {
    [self creatOrActiveCancelVC];
    break;
  }
  //聊股
  case 4: {
    [self createWeiboVC];
    break;
  }

  default:
    break;
  }
}

#pragma mark
#pragma mark 功能函数
#pragma mark
#pragma mark-------------动画相关函数----------------
//推拉动画效果
- (void)viewChangeWithLayerAnimate:(UIView *)baseView
                        RemoveView:(UIView *)removeView
                           AddView:(UIView *)addView {
  if (baseView == nil)
    return;
  if (addView == nil)
    return;
  CATransition *animation = [CATransition animation];
  animation.delegate = self;
  animation.duration = 0.05;
  animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  animation.type = kCATransitionFade; // kCATransitionPush;
  if (removeView.tag < addView.tag) {
    animation.subtype = kCATransitionFromRight;
  } else {
    animation.subtype = kCATransitionFromLeft;
  }
  BOOL viewadded = NO;
  for (UIView *view in baseView.subviews) {
    if (view.tag == addView.tag) {
      viewadded = YES;
    }
  }
  if (viewadded == NO) {
    [baseView addSubview:addView];
  } else {
    [baseView bringSubviewToFront:addView];
  }
  [[baseView layer] addAnimation:animation forKey:@"animation"];
}
- (void)animationDidStart:(CAAnimation *)anim {
}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
  //当前正在展示的视图更新
  smvc_fromViewController = smvc_toViewController;
}

#pragma mark
#pragma mark SimTopBannerViewDelegate
//左边按钮按下
- (void)leftButtonPress {
  [super leftButtonPress];
}

@end
