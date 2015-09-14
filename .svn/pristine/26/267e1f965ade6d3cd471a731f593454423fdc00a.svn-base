//
//  WithdrawalCashViewController.m
//  SimuStock
//
//  Created by jhss_wyz on 15/4/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "LianLianWithdrawalCashViewController.h"
#import "LianLianWithdrawInfoView.h"
#import "LianLianWithdrawScrollView.h"
#import "AppDelegate.h"
#import "InputTextFieldView.h"
#import "WithdrawDetailViewController.h"
#import "LianLianBankCardView.h"
#import "NetLoadingWaitView.h"
///提现
#import "WFAccountInterface.h"

///身份认证
#import "RealNameAuthenticationViewController.h"
///添加银行卡
#import "AddBankCardBigView.h"
///绑定银行卡界面
#import "WFBindBankCardViewController.h"
///身份验证接口
#import "WFsimuUtil.h"
/// 按钮防重点

/** 视图之间的竖直间距 */
#define Max_Number_Bankcard 5

/** 视图之间的竖直间距 */
#define Subview_Y_Margin 9.0
/** 视图之间的竖直间距 */
#define Radio_Button_Tag_Offset 1000

@interface LianLianWithdrawalCashViewController ()

/** 页面滚动器 */
@property(strong, nonatomic) LianLianWithdrawScrollView *clientScrollView;
/** 顶部右侧“提现明细”按钮 */
@property(strong, nonatomic) UIButton *withdrawDetailBtn;
/** 被选中的银行卡视图在已添加的银行卡视图数组中的编号 */
@property(assign, nonatomic) int selectedCardNum;
/** 提现相关信息视图 */
@property(strong, nonatomic) LianLianWithdrawInfoView *withdrawInfoView;
/** 绑定银行卡 */
@property(nonatomic, strong) LianLianBankCardView *bankCardview;
/** 添加银行卡 */
@property(nonatomic, strong) AddBankCardBigView *addBankBigview;
/** 用户绑定银行卡查询结果 */
@property(strong, nonatomic) WFBindedBankcardYouGuuResult *bindBankCardResult;

@end

@implementation LianLianWithdrawalCashViewController
- (id)initWithNumber:(WithdrawType)type {
  self = [super init];
  if (self) {
    self.SelectType = type;
  }
  return self;
}
- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillChange:)
                                               name:UIKeyboardWillChangeFrameNotification
                                             object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UIKeyboardWillChangeFrameNotification
                                                object:nil];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self.topToolBar resetContentAndFlage:@"提现" Mode:TTBM_Mode_Sideslip];

  self.clientView.backgroundColor = [Globle colorFromHexRGB:Color_BG_Common];

  [self setupSubviews];

  [self refreshButtonPressDown];
}
#pragma mark - 刷新按钮代理方法
- (void)refreshButtonPressDown {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  //开始菊花转动
  [self.indicatorView startAnimating];
  //展示账户余额数据
  [self.withdrawInfoView UsersAssetsInquiry];
  //获取用户绑定的银行卡
  [self Obtain_bankCard];
}

/** 设置子控件 */
- (void)setupSubviews {
  [self setupWithdrawDetailButton];
  [self setupClientScrollView];

  ///如果SelectType通联
  if (self.SelectType == YouGuuWithdrawType) { ///创建
    _addBankBigview = [[[NSBundle mainBundle] loadNibNamed:@"AddBankCardBigView"
                                                     owner:nil
                                                   options:nil] lastObject];
    _addBankBigview.width = _clientView.width;
    _addBankBigview.hidden = YES;

    __weak LianLianWithdrawalCashViewController *weakSelf = self;

    ButtonPressed buttonPressed = ^{

      LianLianWithdrawalCashViewController *strongSelf = weakSelf;
      if (strongSelf) {
        if (strongSelf && [strongSelf respondsToSelector:@selector(addBankBigviewClick)]) {
          [strongSelf addBankBigviewClick];
        }
      }
    };
    [self.addBankBigview.addCardBtn setOnButtonPressedHandler:buttonPressed];
  }

  [self.clientScrollView addSubview:_addBankBigview];
  _bankCardview = [[[NSBundle mainBundle] loadNibNamed:@"LianLianBankCardView"
                                                 owner:nil
                                               options:nil] lastObject];
  _bankCardview.width = _clientView.width;
  _bankCardview.hidden = YES;
  [self.clientScrollView addSubview:_bankCardview];
  [self.clientScrollView addSubview:self.withdrawInfoView];

  self.clientScrollView.contentSize =
      CGSizeMake(WIDTH_OF_SCREEN, self.withdrawInfoView.bottom + 35);

  [self.withdrawInfoView.determineWithdrawBtn addTarget:self
                                                 action:@selector(clickDetermineBtn:)
                                       forControlEvents:UIControlEventTouchUpInside];
}

///添加银行卡
- (void)addBankBigviewClick {
  //身份验证
  [self getUserisRNA];
}
///身份验证
- (void)getUserisRNA {
  HttpRequestCallBack *callBack = [[HttpRequestCallBack alloc] init];
  __weak LianLianWithdrawalCashViewController *WeakSelf = self;
  callBack.onSuccess = ^(NSObject *obj) {
    LianLianWithdrawalCashViewController *strongSelf = WeakSelf;
    if (strongSelf) {
      WFBindBankCardViewController *bindBankCard = [[WFBindBankCardViewController alloc] init];
      bindBankCard.block = ^(BOOL success) {
        if (success) {
          /// 刷新银行卡数据
          [strongSelf refreshButtonPressDown];
          [strongSelf.navigationController popToViewController:strongSelf animated:NO];
        }
      };
      [AppDelegate pushViewControllerFromRight:bindBankCard];
    }
  };
  callBack.onError = ^(BaseRequestObject *err, NSException *ex) {
    if ([err.status isEqualToString:@"0013"]) {
      LianLianWithdrawalCashViewController *strongSelf = WeakSelf;
      if (strongSelf) {
        RealNameAuthenticationViewController *realName = [
            [RealNameAuthenticationViewController alloc] initWithRealUserCertBlock:^(BOOL success) {
              if (success) {
                WFBindBankCardViewController *bindBankCard =
                    [[WFBindBankCardViewController alloc] init];
                bindBankCard.block = ^(BOOL success) {
                  if (success) {
                    ///刷新银行卡数据
                    [strongSelf refreshButtonPressDown];
                    [strongSelf.navigationController popToViewController:strongSelf animated:NO];
                  }
                };
                [AppDelegate pushViewControllerFromRight:bindBankCard];
              }
            }];
        [AppDelegate pushViewControllerFromRight:realName];
      }

    } else {
      [BaseRequester defaultErrorHandler](err, ex);
    }
  };

  [WFinquireIsAuthRNA authUserIdentityWithCallback:callBack];
}

#pragma mark--- 键盘监听相关响应函数 ---

/** 设置滚动器 */
- (void)setupClientScrollView {
  [self.clientView addSubview:self.clientScrollView];
  [self setupView:self.clientScrollView andTop:0.0];
  self.clientScrollView.height = self.clientView.height;
  self.clientScrollView.scrollEnabled = YES;
  self.clientScrollView.showsHorizontalScrollIndicator = NO;
  self.clientScrollView.showsVerticalScrollIndicator = NO;
}

/** 设置子控件的位置尺寸 */
- (void)setupView:(UIView *)settedView andTop:(CGFloat)top {
  settedView.width = WIDTH_OF_SCREEN;
  settedView.top = top;
  settedView.left = 0;
}

/** 设置顶部右侧“提现明细”按钮 */
- (void)setupWithdrawDetailButton {
  self.withdrawDetailBtn.frame =
      CGRectMake(CGRectGetMinX(_indicatorView.frame) - 80, CGRectGetMinY(_indicatorView.frame), 80,
                 CGRectGetHeight(_indicatorView.bounds));
  [self.withdrawDetailBtn setTitle:@"提现明细" forState:UIControlStateNormal];
  self.withdrawDetailBtn.titleLabel.font = [UIFont systemFontOfSize:Font_Height_16_0];
  [self.withdrawDetailBtn setTitleColor:[Globle colorFromHexRGB:@"4dfdff"]
                               forState:UIControlStateNormal];
  [self.withdrawDetailBtn setBackgroundImage:[UIImage imageNamed:@"return_touch_down.png"]
                                    forState:UIControlStateHighlighted];
  [self.topToolBar addSubview:self.withdrawDetailBtn];
  [self.withdrawDetailBtn addTarget:self
                             action:@selector(clickDetailBtn:)
                   forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark--- 点击按钮响应函数 ---
/** 点击确认按钮响应函数 */
- (void)clickDetermineBtn:(UIButton *)clickedBtn {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  //提现金额
  NSString *amount = self.withdrawInfoView.inputMoney.inputTextField.text;
  //账户余额
  NSString *balanceAmount = self.withdrawInfoView.accountBalanceAccountLable.text;

  if ([amount doubleValue] == 0) {
    [NewShowLabel setMessageContent:@"请输入提现金额"];
  } else {

    if ([amount doubleValue] > 0) {
      if (([balanceAmount doubleValue] > 100) && ([amount doubleValue] < 100)) {
        [NewShowLabel setMessageContent:@"提现金额不能小于100元"];
      } else {
        ///进行体现网络请求
        if (self.SelectType == YouGuuWithdrawType && self.bindBankCardResult &&
            self.bindBankCardResult.isbind) {
          [self WithdrawNetworkInterface:amount];
        } else {
          [NewShowLabel setMessageContent:@"请先绑定银行卡"];
        }
      }

    } else {
      [NewShowLabel setMessageContent:@"提现金额不能大于账户余额"];
    }
  }
}
///提现网络接口
- (void)WithdrawNetworkInterface:(NSString *)amount {
  [NetLoadingWaitView startAnimating];
  if (!amount) {
    [NetLoadingWaitView stopAnimating];
    return;
  }
  amount = [NSString stringWithFormat:@"%d", (int)([amount doubleValue] * 100)];

  if (![SimuUtil isExistNetwork]) {
    [NetLoadingWaitView stopAnimating];
    [NewShowLabel showNoNetworkTip];
    return;
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  //解析
  __weak LianLianWithdrawalCashViewController *weakSelf = self;
  callback.onSuccess = ^(NSObject *obj) {
    LianLianWithdrawalCashViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf.withdrawInfoView UsersAssetsInquiry];
      //提现成功清空提现金额和到账金额输入框
      strongSelf.withdrawInfoView.inputMoney.inputTextField.text = nil;
      strongSelf.withdrawInfoView.receivedAccountLable.text = nil;
      [NewShowLabel setMessageContent:@"提现成功"];
      [self clickDetailBtn:_withdrawDetailBtn];
    }
    [NetLoadingWaitView stopAnimating];
  };

  callback.onError = ^(BaseRequestObject *obj, NSException *exc) {
    LianLianWithdrawalCashViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [BaseRequester defaultErrorHandler](obj, exc);
    }
    [NetLoadingWaitView stopAnimating];
  };

  callback.onFailed = ^{
    LianLianWithdrawalCashViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [BaseRequester defaultFailedHandler];
    }
    [NetLoadingWaitView stopAnimating];
  };

  [WFAccountInterface applyForWFWithdrawWithAmount:amount WithChannel:@"1" andCallback:callback];
}

#pragma mark--- 键盘监听相关响应函数 ---

/** 键盘出现时的响应函数 */
- (void)keyboardWillChange:(NSNotification *)notification {
  CGRect keyboardRect =
      [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
  CGPoint temp_point =
      [self.withdrawInfoView.withdrawView convertPoint:self.withdrawInfoView.inputMoney.origin
                                                toView:[UIApplication sharedApplication].keyWindow];
  CGFloat height = keyboardRect.origin.y - temp_point.y - self.withdrawInfoView.inputMoney.height;
  if (keyboardRect.origin.y != HEIGHT_OF_SCREEN && height < 0.0) {

    CGFloat heightkey = self.clientScrollView.contentOffset.y - height + 100;
    self.clientScrollView.contentSize =
        CGSizeMake(WIDTH_OF_SCREEN, heightkey + self.clientScrollView.height);
    /// 键盘将要出现且会遮盖输入框时的处理
    [UIView
        animateWithDuration:[[notification.userInfo
                                objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                 animations:^{
                   [self.clientScrollView setContentOffset:CGPointMake(0, heightkey) animated:YES];
                 }];
  } else if (keyboardRect.origin.y == HEIGHT_OF_SCREEN) {
    CGFloat heightKey = self.clientScrollView.contentOffset.y - keyboardRect.size.height;
    self.clientScrollView.contentSize = CGSizeMake(
        WIDTH_OF_SCREEN, self.clientScrollView.contentSize.height - keyboardRect.size.height);
    if (heightKey <= 0) {
      heightKey = 0;
    }
    /// 键盘将要消失时且键盘出现时发生过滚动的处理
    [self.clientScrollView setContentOffset:CGPointMake(0, heightKey) animated:YES];
  }
}

#pragma mark--- 懒加载 ---
/** 懒加载页面滚动器 */
- (LianLianWithdrawScrollView *)clientScrollView {
  if (_clientScrollView == nil) {
    _clientScrollView = [[LianLianWithdrawScrollView alloc] init];
    _clientScrollView.width = _clientView.width;
  }
  return _clientScrollView;
}

/** 懒加载提现相关信息视图（通过WithdrawInfoView.xib创建） */
- (LianLianWithdrawInfoView *)withdrawInfoView {
  if (_withdrawInfoView == nil) {
    _withdrawInfoView = [[[NSBundle mainBundle] loadNibNamed:@"LianLianWithdrawInfoView"
                                                       owner:nil
                                                     options:nil] lastObject];
    _withdrawInfoView.width = _clientView.width;
  }
  return _withdrawInfoView;
}

/** 懒加载顶部右侧“提现明细”按钮 */
- (UIButton *)withdrawDetailBtn {
  if (_withdrawDetailBtn == nil) {
    _withdrawDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  }
  return _withdrawDetailBtn;
}
/** 点击提现明细按钮响应函数 */
- (void)clickDetailBtn:(UIButton *)clickedBtn {
  WithdrawDetailViewController *withdrawDetailVC = [[WithdrawDetailViewController alloc] init];
  [AppDelegate pushViewControllerFromRight:withdrawDetailVC];
}

#pragma mark--- 获取用户绑定的银行卡 ---
///获取用户绑定的银行卡
- (void)Obtain_bankCard {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    //停止菊花转动
    [self.indicatorView stopAnimating];
    return;
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  //解析
  __weak LianLianWithdrawalCashViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    LianLianWithdrawalCashViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf.indicatorView stopAnimating];
      return NO;
    } else {
      return YES;
    }
  };
  callback.onSuccess = ^(NSObject *obj) {
    LianLianWithdrawalCashViewController *strongSelf = weakSelf;
    if (strongSelf) {
      if (strongSelf.SelectType == YouGuuWithdrawType) {
        strongSelf.bindBankCardResult = (WFBindedBankcardYouGuuResult *)obj;
        if (strongSelf.bindBankCardResult.isbind) {
          [_bankCardview bindDataFromYouGuu:strongSelf.bindBankCardResult];
          _bankCardview.hidden = NO;
          _addBankBigview.hidden = YES;
          self.withdrawInfoView.top = 65;
          [_bankCardview bindDataFromYouGuu:strongSelf.bindBankCardResult];
        } else {
          _addBankBigview.hidden = NO;
          _bankCardview.hidden = YES;
          self.withdrawInfoView.top = 120;
        }
      }
    }
  };
  [WFAccountInterface inquireWFBindedBankcardWithChannel:[@(self.SelectType) stringValue]
                                            WithCallback:callback];
}

@end
