//
//  AccountPageViewController.m
//  SimuStock
//
//  Created by Jhss on 15/4/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "AccountPageViewController.h"
#import "AppDelegate.h"
#import "YouguuAccountViewController.h"
#import "ProcessInputData.h"
#import "RechargeAccountViewController.h"
///连连提现
#import "LianLianWithdrawalCashViewController.h"
/////通联提现
//#import "WithdrawalCashViewController.h"
#import "StockUtil.h"

#import "CutomerServiceButton.h"
#import "SimuConfigConst.h"

@implementation AccountPageViewController {
  OnWFShowValueChangedNotification *onWFShowValueChangedNotification;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self resetWithFundView];

  onWFShowValueChangedNotification =
      [[OnWFShowValueChangedNotification alloc] init];
  __weak AccountPageViewController *weakSelf = self;
  onWFShowValueChangedNotification.onWFShowValueChanged = ^{
    [weakSelf resetWithFundView];
  };

  //添加视图基本控件
  [self addViewBasicControls];

  [[CutomerServiceButton shareDataCenter]
      establisthCustomerServiceTelephonetopToolBar:_topToolBar
                                     indicatorView:_indicatorView
                                              hide:NO];
  //重写刷新方法,进行网络请求
  [self refreshButtonPressDown];
}
///添加视图基本控件
- (void)addViewBasicControls {
  /**  更改为"账户" 并且隐藏刷新按钮 */
  [_topToolBar resetContentAndFlage:@"我的账户" Mode:TTBM_Mode_Leveltwo];
  /** 设置_clientView透明度为0，显示sef.view视图 */
  _clientView.alpha = 0;

  //设置“优顾账户”选中时的高亮颜色
  [self.youguuAccountButton
      setBackgroundImage:[SimuUtil imageFromColor:Color_BG_Common]
                forState:UIControlStateHighlighted];
  //充值按钮和提现按钮的高亮状态设置
  self.rechargeButton.normalBGColor = [Globle colorFromHexRGB:Color_White];
  self.rechargeButton.highlightBGColor =
      [Globle colorFromHexRGB:Color_Cell_Line];
  [self.rechargeButton buttonWithTitle:@"充值"
                    andNormaltextcolor:Color_Blue_but
              andHightlightedTextColor:Color_Blue_but];

  self.withDrawButton.normalBGColor = [Globle colorFromHexRGB:Color_White];
  self.withDrawButton.highlightBGColor =
      [Globle colorFromHexRGB:Color_Cell_Line];
  [self.withDrawButton buttonWithTitle:@"提现"
                    andNormaltextcolor:@"086DAE"
              andHightlightedTextColor:@"086DAE"];
}

#pragma mark - 刷新按钮代理方法
/** 刷新按钮代理方法 */
- (void)refreshButtonPressDown {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    //无网络没有显示数据
    [self isNoInternetDisplayData];
  } else {
    //刷新菊花转动
    [_indicatorView startAnimating];
    [SimuConfigConst requestServerOnlineConfig];
    [self returnsTheTotalAccountsAndDetails];
  }
}
/** 刷新完成菊花停止转动 */
- (void)stopRefresh {
  [_indicatorView stopAnimating];
}

#pragma mark
/** 1.11获取账户总额以及明细接口解析 */
- (void)returnsTheTotalAccountsAndDetails {
  if (![SimuUtil isExistNetwork]) {
    return;
  }
  HttpRequestCallBack *callBack = [[HttpRequestCallBack alloc] init];
  __weak AccountPageViewController *weakSelf = self;
  callBack.onSuccess = ^(NSObject *obj) {
    AccountPageViewController *strongSelf = weakSelf;
    if (strongSelf) {
      WFAccountAmountAndDetails *accountAmount =
          (WFAccountAmountAndDetails *)obj;
      [self bindData:accountAmount];
      [self.indicatorView stopAnimating];
    }
  };
  callBack.onError = ^(BaseRequestObject *obj, NSException *exc) {
    AccountPageViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [self.indicatorView stopAnimating];
      [BaseRequester defaultErrorHandler](obj, exc);
    }
  };
  callBack.onFailed = ^{
    AccountPageViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [self.indicatorView stopAnimating];
      [BaseRequester defaultFailedHandler]();
    }
  };
  [WFAccountInterface WFGainAccountAmountAndDetailsWithCallback:callBack];
}
/** 无网络的情况下不显示数据 */
- (void)isNoInternetDisplayData {
  self.youguuAccountLabel.text = @"--";
  self.stockAccountLabel.text = @"--";
  self.matchMoneyLabel.text = @"--";
  self.marginLabel.text = @"--";
  self.floatFullLabel.text = @"--";
}
//绑定数据，对应label进行赋值
- (void)bindData:(WFAccountAmountAndDetails *)accountAmount {

  if (accountAmount) {
    // 优顾账户
    NSString *youguuAccount =
        [ProcessInputData convertMoneyString:accountAmount.amount];
    self.youguuAccountLabel.text =
        [youguuAccount stringByAppendingFormat:@"元"];
    //股票账户
    self.stockAccountLabel.text =
        [[ProcessInputData convertMoneyString:accountAmount.totalAsset]
            stringByAppendingFormat:@"元"];
    self.matchMoneyLabel.text =
        [[ProcessInputData convertMoneyString:accountAmount.peiziAmount]
            stringByAppendingFormat:@"元"];
    self.marginLabel.text =
        [[ProcessInputData convertMoneyString:accountAmount.cashAmount]
            stringByAppendingFormat:@"元"];
    //判断浮动盈亏：为正红色，为负绿色，0为黑
    NSString *profit =
        [ProcessInputData convertMoneyString:accountAmount.totalProfit];
    self.floatFullLabel.textColor = [StockUtil getColorByProfit:profit];
    self.floatFullLabel.text = [profit stringByAppendingString:@"元"];
  }
}

/** 点击进入优顾账户页面 */
- (IBAction)IBActionclickIntoYouguuAccountButtonPressidsender:(id)sender {

  //判断是否有网络，无网络不能进入优顾账户页面
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
  } else {
    [AppDelegate
        pushViewControllerFromRight:[[YouguuAccountViewController alloc] init]];
  }
}

/** 点击充值按钮进入充值页面 */
- (IBAction)clickRechargeButtonMethod:(id)sender {
  RechargeAccountViewController *ravc = [[RechargeAccountViewController alloc]
      initWithFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN, HEIGHT_OF_SCREEN)];
  [AppDelegate pushViewControllerFromRight:ravc];
}

/** 点击提现按钮进入提现页面 */
- (IBAction)clickWithDrawMethod:(id)sender {

  /// 优顾提现界面
  [AppDelegate
      pushViewControllerFromRight:[[LianLianWithdrawalCashViewController alloc]
                                      initWithNumber:YouGuuWithdrawType]];
}

- (void)resetWithFundView {
  self.wfView.hidden = ![SimuConfigConst isShowWithFund];
  self.wfBottomView.hidden = ![SimuConfigConst isShowWithFund];
}

@end
