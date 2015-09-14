//
//  realTradeAccountVC.m
//  SimuStock
//
//  Created by Mac on 14-9-19.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "RealTradeAccountVC.h"

#import "RealTradeFundTransferVC.h"
#import "UpdateCustomerInfomationAssets.h"
#import "InfomationDisplayView.h"
#import "DepositTopUpViewController.h"

#import "WFDataSharingCenter.h"
//判断资金池是否充足的类
#import "ComposeInterfaceUtil.h"
#import "NetLoadingWaitView.h"

@interface RealTradeAccountVC () <InfomationDisplayButtonDelegate> {
  // title
  NSString *_navTitle;

  /** 实盘账户信息 还是 优顾配资实盘账户信息 */
  BOOL _firmOfferInfoViewOrCapitalInfoView;

  /** 判断资金池是否充足 */
  BOOL _isClose;
}

@end

@implementation RealTradeAccountVC

- (id)initWithFrame:(CGRect)frame
               withNavTitle:(NSString *)title
    withOneViewOrSecondView:(BOOL)firstOrSecond {
  self = [super initWithFrame:frame];
  if (self) {
    _navTitle = title;
    _firmOfferInfoViewOrCapitalInfoView = firstOrSecond;
  }
  return self;
}

#pragma mark - 跳到保证金充值
- (void)marginButtonDownEvent {
  NSString *contractNo = [WFDataSharingCenter shareDataCenter].contracNo;
  DepositTopUpViewController *depositVC =
      [[DepositTopUpViewController alloc] initWithContractNo:contractNo];
  [AppDelegate pushViewControllerFromRight:depositVC];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  //判断 资金池是否开放 初始化 YES
  _isClose = YES;
  [self.topToolBar resetContentAndFlage:_navTitle Mode:TTBM_Mode_Leveltwo];

  [self creatAccountInfoView];
  [self creatPositionView];
  [_indicatorView startAnimating];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [_ravc_positionView.view removeFromSuperview];
  [_ravc_positionView removeFromParentViewController];
  _ravc_positionView = nil;
  _accountInfoView = nil;
}
//创建账户信息页面
- (void)creatAccountInfoView {
  if (_firmOfferInfoViewOrCapitalInfoView == YES) {
    self.accountInfoView = [[RealTradeFoundView alloc]
        initWithFrame:CGRectMake(0, 18, self.view.bounds.size.width, 142)];
    self.accountInfoView.delegate = self;
    [_clientView addSubview:self.accountInfoView];
  } else {
    self.infomationDisplayView = [InfomationDisplayView theReturnOfTheir];
    self.infomationDisplayView.frame =
        CGRectMake(0, 0, self.view.bounds.size.width, 188);
    self.infomationDisplayView.infomationDisplayDelegate = self;
    [_clientView addSubview:self.infomationDisplayView];
    //实盘申请按钮
    [self firmOfferForApply];
  }
}
#pragma mark - 实盘申请按钮
- (void)firmOfferForApply {
  UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
  rightButton.frame = CGRectMake(
      self.view.frame.size.width - 70 - _indicatorView.bounds.size.width,
      _topToolBar.frame.size.height - CGRectGetHeight(_indicatorView.bounds),
      70, CGRectGetHeight(_indicatorView.bounds));
  rightButton.titleLabel.font = [UIFont systemFontOfSize:Font_Height_16_0];
  rightButton.titleLabel.numberOfLines = 0;
  [rightButton setTitle:@"申请配资" forState:UIControlStateNormal];
  [rightButton setTitleColor:[Globle colorFromHexRGB:@"4dfdff"]
                    forState:UIControlStateNormal];
  [rightButton setBackgroundImage:[UIImage imageNamed:@"return_touch_down.png"]
                         forState:UIControlStateHighlighted];
  [rightButton addTarget:self
                  action:@selector(dialSevicesTelephoneNumber)
        forControlEvents:UIControlEventTouchUpInside];
  [_topToolBar addSubview:rightButton];
}
//申请实盘按钮 点击事件
- (void)dialSevicesTelephoneNumber {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  BOOL notLogined = [@"-1" isEqualToString:[SimuUtil getUserID]];
  if (notLogined) {
    [AppDelegate pushViewControllerFromRight:
     [[FullScreenLogonViewController alloc]
      init]];
  } else {
    [NetLoadingWaitView startAnimating];
    [WFApplyAccountUtil applyAccountWithOwner:self
                            withCleanCallBack:^{
                              [NetLoadingWaitView stopAnimating];
                              
                            }];
  }
}

//创建持仓页面
- (void)creatPositionView {
  CGRect frameVC = _firmOfferInfoViewOrCapitalInfoView == YES
                       ? self.accountInfoView.frame
                       : self.infomationDisplayView.frame;
  NSString *markString =
      _firmOfferInfoViewOrCapitalInfoView == YES ? @"account" : @"WFHeadView";
  int heightNum = _firmOfferInfoViewOrCapitalInfoView == YES ? 18 : 0;
  self.ravc_positionView = _ravc_positionView = [
      [FSPositionsViewController alloc]
                 initAccount:markString
                        rect:CGRectMake(0.0, CGRectGetMaxY(frameVC),
                                        self.view.bounds.size.width,
                                        self.view.bounds.size.height -
                                            self.topToolBar.bounds.size.height -
                                            CGRectGetHeight(frameVC) -
                                            heightNum -
                                            BOTTOM_TOOL_BAR_HEIGHT)
      withFirmOfferOrCapital:
          _firmOfferInfoViewOrCapitalInfoView]; //账户信息控件是从y=18开始的。。。
  __weak SimuIndicatorView *myindicate = _indicatorView;
  __weak RealTradeFoundView *my_accountInfoView = self.accountInfoView;
  __weak InfomationDisplayView *infoMationDView = _infomationDisplayView;
  //持仓请求可买可卖数量回调
  __weak RealTradeAccountVC *accountVC = self;
  _ravc_positionView.accountZqdm = ^(PositionData *positionData) {
    RealTradeAccountVC *strongSelf = accountVC;
    [myindicate stopAnimating];
    if (my_accountInfoView) {
      [my_accountInfoView resetData:positionData];
      if (_firmOfferInfoViewOrCapitalInfoView == YES) {
        //数据绑定成功 调取统计接口
        [strongSelf updateUserInfo:positionData];
      }
    }
    NSLog(@"回调成功");
  };
  _ravc_positionView.beginRefreshCallBack = ^{
    [myindicate startAnimating];
  };

  _ravc_positionView.endRefreshCallBack = ^() {
    [myindicate stopAnimating];
  };

  //配资实盘 持仓请求
  _ravc_positionView.headViewData = ^(WFFirmHeadInfoData *headViewData) {
    if (infoMationDView) {
      //绑定数据 头
      [infoMationDView theBindingDataWithInfomationDisplay:headViewData];
    }
  };

  [self addChildViewController:_ravc_positionView];
  [_clientView addSubview:_ravc_positionView.view];
}

#pragma mark -- 更新客户资料统计接口
- (void)updateUserInfo:(PositionData *)postition {
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak RealTradeAccountVC *weakR = self;
  callback.onCheckQuitOrStopProgressBar = ^() {
    RealTradeAccountVC *strongR = weakR;
    if (strongR) {
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    UpdateCustomerInfomationAssets *updateInfo =
        (UpdateCustomerInfomationAssets *)obj;
    if ([updateInfo.status isEqualToString:@"0000"]) {
      NSLog(@"更新客户资料统计接口请求成功");
    } else {
      [NewShowLabel setMessageContent:updateInfo.message];
    }

  };

  callback.onFailed = ^() {
    NSLog(@"***** 更新客户资料统计接口失败 *******");
  };

  callback.onError = ^(BaseRequestObject *obj, NSException *exc) {
    [BaseRequester defaultFailedHandler](obj, exc);
  };

  //请求
  [UpdateCustomerInfomationAssets updateCustomerInfomationAsser:postition
                                                    andCallBack:callback];
}

#pragma mark-- 刷新按钮
- (void)refreshButtonPressDown {

  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  [self getUserCountorInfoFromNet];
}

#pragma mark
#pragma mark 网络接口
//取得账户的资金等信息信息
- (void)getUserCountorInfoFromNet {
  if (_ravc_positionView) {
    [_ravc_positionView refreshButtonPressDown];
  }
}

#pragma mark
#pragma mark 协议函数
//资金转入、转出协议 realTradeFoundViewDelegate
- (void)fundButtonPressDwon:(NSInteger)tag {
  if (tag == 40001) {
    //创建资金转入页面
    RealTradeFundTransferVC *realtradeinVC =
        [[RealTradeFundTransferVC alloc] init:YES];
    [AppDelegate pushViewControllerFromRight:realtradeinVC];

  } else if (tag == 40002) {
    //创建资金转出页面
    RealTradeFundTransferVC *realtradeinVC =
        [[RealTradeFundTransferVC alloc] init:NO];
    [AppDelegate pushViewControllerFromRight:realtradeinVC];
  }
}
@end
