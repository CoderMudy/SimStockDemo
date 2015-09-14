//
//  FollowMasterViewController.m
//  SimuStock
//
//  Created by Jhss on 15/7/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "FollowMasterViewController.h"

@implementation FollowMasterViewController {
  BOOL hasAdBanner;
}
- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self initVariables];
  }
  return self;
}
/** 登陆、退出进行刷新 */
- (void)initVariables {
  __weak FollowMasterViewController *weakSelf = self;
  _loginLogoutNotification = [[LoginLogoutNotification alloc] init];
  _loginLogoutNotification.onLoginLogout = ^{
    [weakSelf refreshLoginOrLogout];
  };
}
- (void)refreshLoginOrLogout {
  [newOnlineTableVC refreshButtonPressDown];
  [hotRunTableVC refreshButtonPressDown];
}
- (void)viewDidLoad {
  [super viewDidLoad];
  hasAdBanner = YES;
  //设置默认为全新上线列表
  tempPosition = leftNewOnlineBtn;

  ///创建广告页和分段选择控件
  [self topBillboard];
  [self createSegmentedButtonView];

  [self creatNewOnlineTableView];
  currentTableVC = newOnlineTableVC;

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(refreshNewOnlieList)
                                               name:Notification_Refresh_NewOnlie
                                             object:nil];
}
- (void)refreshNewOnlieList {
  [newOnlineTableVC refreshButtonPressDown];
}
//顶部广告栏
- (void)topBillboard {
  _advViewVC = [[GameAdvertisingViewController alloc] initWithAdListType:AdListTypeFollowManster];
  _advViewVC.delegate = self;
  _advViewVC.view.userInteractionEnabled = YES;
  _advViewVC.view.backgroundColor = [Globle colorFromHexRGB:@"#efefef"];
  //数据请求
  [_advViewVC requestImageAdvertiseList];
}
#pragma mark-- GameAdvertisingViewController 的协议
- (void)advertisingPageJudgment:(BOOL)adBool intg:(NSInteger)intg {
  //判断有没有 广告
  hasAdBanner = adBool;
  currentTableVC.tableView.tableHeaderView = self.tableHeadView;
}

- (UIView *)tableHeadView {
  CGRect frame = CGRectMake(0, 0, WIDTH_OF_SCREEN, hasAdBanner ? 178 : 43);
  tableHeadView = [[UIView alloc] initWithFrame:frame];
  tableHeadView.backgroundColor = [Globle colorFromHexRGB:@"#efefef"];

  [_advViewVC.view removeFromSuperview];
  if (hasAdBanner) {
    CGFloat factor = WIDTH_OF_SCREEN / 320;
    _advViewVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, competionAdvHeight * factor);
    //头部视图
    [tableHeadView addSubview:_advViewVC.view];
    _advViewVC.view.userInteractionEnabled = YES;
  }
  [segmentView removeFromSuperview];
  CGRect framebackGround = CGRectMake(0, hasAdBanner ? 138 : 3, self.view.bounds.size.width, 43);
  segmentView.frame = framebackGround;
  [tableHeadView addSubview:segmentView];
  return tableHeadView;
}
//分段按钮
- (void)createSegmentedButtonView {

  segmentView = [[UIView alloc] initWithFrame:CGRectMake(0, 138, self.view.bounds.size.width, 43)];
  segmentView.backgroundColor = [Globle colorFromHexRGB:@"#efefef"];

  //边框
  UIView *borderView =
      [[UIView alloc] initWithFrame:CGRectMake(9.0, 2, self.view.bounds.size.width - 18.0, 64.0 / 2)];
  borderView.backgroundColor = [Globle colorFromHexRGB:Color_Blue_but];
  [self.view addSubview:borderView];

  buttonView = [[UIView alloc] initWithFrame:CGRectMake(0.5, 0.5, borderView.bounds.size.width - 1.0, 31.0)];
  buttonView.backgroundColor = [UIColor whiteColor];
  [borderView addSubview:buttonView];
  [segmentView addSubview:borderView];

  CGRect residentViewFrame =
      CGRectMake(0.0, 0.0, (buttonView.bounds.size.width - 1.0) / 2, buttonView.bounds.size.height);
  residentView = [[UIView alloc] initWithFrame:residentViewFrame];
  residentView.backgroundColor = [Globle colorFromHexRGB:Color_Blue_but];
  [buttonView addSubview:residentView];

  NSArray *nameArr = @[ @"全新上线", @"火热运行" ];
  CGFloat width = (buttonView.bounds.size.width - 1.0f) / [nameArr count];
  for (int i = 0; i < [nameArr count]; i++) {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    btn.frame = CGRectMake(i * width + i * 0.5, 0.0, width, buttonView.bounds.size.height);

    [btn setTitle:nameArr[i] forState:UIControlStateNormal];
    [btn setTitle:nameArr[i] forState:UIControlStateHighlighted];
    [btn setTitleColor:[Globle colorFromHexRGB:@"#086dae"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:Font_Height_14_0];
    btn.tag = 3500 + i;
    __weak FollowMasterViewController *weakSelf = self;
    [btn setOnButtonPressedHandler:^{
      [weakSelf buttonSwitchMethod:i];
    }];
    [buttonView addSubview:btn];
    if (i != 0) {
      CGRect lineViewFrame = CGRectMake(i * (buttonView.bounds.size.width - 1.0) / 2 + (i - 1) * 0.5,
                                        0.0, 0.5, buttonView.bounds.size.height);
      UIView *lineView = [[UIView alloc] initWithFrame:lineViewFrame];

      lineView.backgroundColor = [Globle colorFromHexRGB:@"#086dae"];
      [buttonView addSubview:lineView];
    } else {
      [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
  }
}
- (void)buttonSwitchMethod:(int)tabIndex {
  /// 按钮的更新状态（0/1）
  [self buttonStatusUpdateTag:tabIndex];
  if (hotRunTableVC) {
    hotRunTableVC.tableView.tableHeaderView = nil;
    [hotRunTableVC.view removeFromSuperview];
    [hotRunTableVC removeFromParentViewController];
  }
  if (tabIndex == 0) {
    //全新上线
    tempPosition = leftNewOnlineBtn;
    [self creatNewOnlineTableView];
    currentTableVC = newOnlineTableVC;
  } else {
    //火热运行
    tempPosition = rightHotRunBtn;
    [self creatHotRunTableView];
    currentTableVC = hotRunTableVC;
  }
}
///创建全新上线列表
- (void)creatNewOnlineTableView {
  if (newOnlineTableVC == nil) {
    newOnlineTableVC = [[NewOnlineViewController alloc] initWithFrame:self.view.bounds];
    __weak FollowMasterViewController *weakSelf = self;
    newOnlineTableVC.beginRefreshCallBack = ^{
      if (weakSelf.beginRefreshCallBack) {
        weakSelf.beginRefreshCallBack();
      }
    };
    newOnlineTableVC.endRefreshCallBack = ^{
      if (weakSelf.endRefreshCallBack) {
        weakSelf.endRefreshCallBack();
      }
    };
    newOnlineTableVC.headerRefreshCallBack = ^{
      [weakSelf.advViewVC requestImageAdvertiseList];
    };
  }
  [self.view addSubview:newOnlineTableVC.view];
  [self addChildViewController:newOnlineTableVC];

  newOnlineTableVC.tableView.tableHeaderView = self.tableHeadView;
  [newOnlineTableVC refreshButtonPressDown];
}
///创建火热运行列表
- (void)creatHotRunTableView {
  if (hotRunTableVC == nil) {
    hotRunTableVC = [[HotRunViewController alloc] initWithFrame:self.view.bounds];
    __weak FollowMasterViewController *weakSelf = self;
    hotRunTableVC.beginRefreshCallBack = ^{
      if (weakSelf.beginRefreshCallBack) {
        weakSelf.beginRefreshCallBack();
      }
    };
    hotRunTableVC.endRefreshCallBack = ^{
      if (weakSelf.endRefreshCallBack) {
        weakSelf.endRefreshCallBack();
      }
    };
    hotRunTableVC.headerRefreshCallBack = ^{
      [weakSelf.advViewVC requestImageAdvertiseList];
    };
  }
  [self.view addSubview:hotRunTableVC.view];
  [self addChildViewController:hotRunTableVC];

  hotRunTableVC.tableView.tableHeaderView = self.tableHeadView;
  [hotRunTableVC refreshButtonPressDown];
}

//按钮状态更新
- (void)buttonStatusUpdateTag:(NSInteger)buttonIndex {
  for (int i = 0; i < 2; i++) {
    UIButton *btn = (UIButton *)[buttonView viewWithTag:i + 3500];
    if (i == buttonIndex) {
      [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
      residentView.frame =
          CGRectMake(i * (buttonView.bounds.size.width - 1.0) / 2 + i * 0.5, 0.0,
                     (buttonView.bounds.size.width - 1.0) / 2 + 0.5, buttonView.bounds.size.height);
    } else {
      [btn setTitleColor:[Globle colorFromHexRGB:@"#086dae"] forState:UIControlStateNormal];
    }
  }
}
/** 刷新列表数据的方法 */
- (void)refreshButtonPressDown {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  [_advViewVC requestImageAdvertiseList];
  if ([tempPosition isEqualToString:leftNewOnlineBtn]) {
    [newOnlineTableVC refreshButtonPressDown];
  } else {
    [hotRunTableVC refreshButtonPressDown];
  }
}

@end
