//
//  ApplyForLargeMoneyViewController.m
//  SimuStock
//
//  Created by jhss_wyz on 15/3/29.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ApplyForLargeMoneyViewController.h"
#import "ApplyForLargeMoneyView.h"
#import "InputTextFieldView.h"
#import "WithCapitalHome.h"
#import "CutomerServiceButton.h"
@interface ApplyForLargeMoneyViewController () <SimuIndicatorDelegate>

/** 右上角“客服热线”按钮 */
@property(strong, nonatomic) UIButton *hotlineBtn;
/** 大额实盘申请视图（通过LargeMoneyView.xib创建） */
@property(strong, nonatomic) ApplyForLargeMoneyView *largeMoneyView;

/** 是否已经发起申请 */
@property(assign, nonatomic) BOOL isHaveApply;

@end

@implementation ApplyForLargeMoneyViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.isHaveApply = NO;
  
  [self.topToolBar resetContentAndFlage:@"大额配资申请"
                                   Mode:TTBM_Mode_Sideslip];
  _indicatorView.hidden = YES;

  /// 设置右上角“客服热线”按钮
  [[CutomerServiceButton shareDataCenter] establisthCustomerServiceTelephonetopToolBar:_topToolBar indicatorView:_indicatorView hide:YES];

  [self.clientView addSubview:self.largeMoneyView];
  /// 设置大额实盘申请视图
  [self setupLargeMoneyView];

  self.indicatorView.delegate = self;
}

#pragma mark--- 设置子视图 ---
/** 设置大额实盘申请视图 */
- (void)setupLargeMoneyView {
  /// 设置大额申请视图尺寸位置，使其完全覆盖clientView
  self.largeMoneyView.width = self.clientView.width;
  self.largeMoneyView.height = self.clientView.height;
  self.largeMoneyView.top = 0;
  self.largeMoneyView.left = 0;

  [self.largeMoneyView.determineBtn addTarget:self
                                       action:@selector(clickOnDetermineButton:)
                             forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark--- 按钮点击响应函数 ---
/** “确定”按钮点击响应函数 */
- (void)clickOnDetermineButton:(UIButton *)clickedBtn {
  [self.largeMoneyView.inputMoney.inputTextField resignFirstResponder];

  if (self.isHaveApply == YES) {
    return;
  }
  
  if ([self.largeMoneyView.inputMoney.inputTextField.text
          isEqualToString:@""]) {
    [NewShowLabel setMessageContent:@"请输入您要申请的金额"];
  } else if ([self.largeMoneyView.inputMoney.inputTextField.text intValue] <
             10) {
    [NewShowLabel setMessageContent:@"申请大额配资需超过10万元"];
  } else {
    self.isHaveApply = YES;
    [self.indicatorView startAnimating];
    [self addLargeAmount];
  }
}

#pragma mark ——— 网络访问结果处理 ———
/** 查询资金池资金是否充足成功处理函数 */
- (void)addLargeAmountOnSuccessWithResult:(NSObject *)result {
  [self.indicatorView stopAnimating];
  self.isHaveApply = NO;
  [NewShowLabel setMessageContent:@"申请成功，请等待工作人员联系"];
  self.largeMoneyView.inputMoney.inputTextField.text = @"";
}

/** 查询资金池资金是否充足错误处理函数 */
- (void)addLargeAmountOnErrorWithRequest:(BaseRequestObject *)obj
                                  andExc:(NSException *)exc {
  [self.indicatorView stopAnimating];
  BaseRequester.defaultErrorHandler(obj, exc);
  self.isHaveApply = NO;
}

/** 查询资金池资金是否充足失败处理函数 */
- (void)addLargeAmountOnFailed {
  [self.indicatorView stopAnimating];
  BaseRequester.defaultFailedHandler();
  self.isHaveApply = NO;
}

#pragma mark ——— 网络访问相关 ———
/** 查询配资产品接口相关 */
- (void)addLargeAmount {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    [self.indicatorView stopAnimating];
    self.isHaveApply = NO;
    return;
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak ApplyForLargeMoneyViewController *weakSelf = self;
  /// 解析
  callback.onSuccess = ^(NSObject *obj) {
    ApplyForLargeMoneyViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [self addLargeAmountOnSuccessWithResult:obj];
    }
  };
  callback.onError = ^(BaseRequestObject *obj, NSException *exc) {
    ApplyForLargeMoneyViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf addLargeAmountOnErrorWithRequest:obj andExc:exc];
    }
  };
  callback.onFailed = ^{
    ApplyForLargeMoneyViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf addLargeAmountOnFailed];
    }
  };
  [WithCapitalHome addWFLargeAccountWithFinancingMoney:
                       [self.largeMoneyView.inputMoney.inputTextField.text
                           stringByAppendingString:@"0000"]
                                          withCallback:callback];
}

#pragma mark--- 懒加载 ---
/** 懒加载右上角“客服热线”按钮 */
- (UIButton *)hotlineBtn {
  if (_hotlineBtn == nil) {
    _hotlineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  }
  return _hotlineBtn;
}

/** 懒加载大额实盘申请视图（通过LargeMoneyView.xib创建） */
- (ApplyForLargeMoneyView *)largeMoneyView {
  if (_largeMoneyView == nil) {
    _largeMoneyView = [[[NSBundle mainBundle] loadNibNamed:@"LargeMoneyView"
                                                     owner:nil
                                                   options:nil] lastObject];
  }
  return _largeMoneyView;
}

@end
