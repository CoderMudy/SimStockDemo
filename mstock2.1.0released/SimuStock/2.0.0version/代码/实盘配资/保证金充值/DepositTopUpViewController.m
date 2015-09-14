//
//  DepositTopUpViewController.m
//  SimuStock
//
//  Created by jhss_wyz on 15/3/31.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "DepositTopUpViewController.h"
#import "DepositTopUpView.h"
#import "UILabel+SetProperty.h"
#import "ProcessInputData.h"
#import "InputTextFieldView.h"
#import "WFProductContract.h"

#import "WeiboToolTip.h"
#import "ComposeInterfaceUtil.h"
#import "CutomerServiceButton.h"
#import "NetLoadingWaitView.h"
#import "ConfirmPayView.h"

@interface DepositTopUpViewController () <UITextFieldDelegate,
                                          SimuIndicatorDelegate>

/** 保证金充值视图 */
@property(strong, nonatomic) DepositTopUpView *depositTopUpView;
/** 顶部右侧“客服电话”按钮 */
@property(strong, nonatomic) UIButton *hotlineBtn;
/** 金额输入框右侧占位符 */
@property(strong, nonatomic) UILabel *rightPlaceholder;

/** 获取追加保证金信息出参 */
@property(strong, nonatomic) WFGetCashAmountInfoResult *cashAmountInfo;
/** 追加保证金入参 */
@property(strong, nonatomic)
    WFAddBailContractParameter *addBailContractParameter;

/** 是否有网络数据 */
@property(assign, nonatomic) BOOL isDataBinded;

/** 确认支付的视图 */
@property(strong, nonatomic) ConfirmPayView *payView;

@end

@implementation DepositTopUpViewController

- (instancetype)initWithContractNo:(NSString *)contractNo {
  if (self = [super init]) {
    self.addBailContractParameter.contractNo = contractNo;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.isDataBinded = NO;

  [self.topToolBar resetContentAndFlage:@"补充保证金" Mode:TTBM_Mode_Sideslip];

  self.depositTopUpView.backgroundColor =
      [Globle colorFromHexRGB:Color_BG_Common];
  self.depositTopUpView.infoView.backgroundColor =
      [Globle colorFromHexRGB:Color_White];

  //创建客服电话按钮
  [[CutomerServiceButton shareDataCenter]
      establisthCustomerServiceTelephonetopToolBar:_topToolBar
                                     indicatorView:_indicatorView
                                              hide:NO];
  [self setupSubviews];

  self.indicatorView.delegate = self;

  [self refreshButtonPressDown];
}

/** 设置子控件 */
- (void)setupSubviews {
  [self.clientView addSubview:self.depositTopUpView];
  self.depositTopUpView.width = self.clientView.width;
  self.depositTopUpView.height = self.clientView.height;
  self.depositTopUpView.top = 0;
  self.depositTopUpView.left = 0;

  [self setupDepositRightView];
  [self setupDepositLeftView];
  [self setupCordonAndClosePositionView];

  [self setupMarginLine];
  [self setupImputMoneyTextField];
  [self setupRightPlaceholderWithText:@""];
  [self createConfirmPayView];
}

/** 设置账户金额信息 */
- (void)setupDepositLeftView {
  [self.depositTopUpView.amountTitleLable
      setupLableWithText:@"当前资产"
            andTextColor:[Globle colorFromHexRGB:Color_Gray]
             andTextFont:[UIFont systemFontOfSize:Font_Height_11_0]
            andAlignment:NSTextAlignmentCenter];

  self.depositTopUpView.amountLable.text = @"";
  [self.depositTopUpView.amountLable
      setAttributedTextWithFirstString:@""
                          andFirstFont:[UIFont systemFontOfSize:23.0f]
                         andFirstColor:[Globle colorFromHexRGB:@"#454545"]
                       andSecondString:@""
                         andSecondFont:[UIFont
                                           systemFontOfSize:Font_Height_11_0]
                        andSecondColor:[Globle colorFromHexRGB:@"#df3031"]];
  self.depositTopUpView.amountLable.textAlignment = NSTextAlignmentCenter;
}

/** 设置保证金剩余信息 */
- (void)setupDepositRightView {
  [self.depositTopUpView.depositTitleLable
      setupLableWithText:@"保证金剩余"
            andTextColor:[Globle colorFromHexRGB:Color_Gray]
             andTextFont:[UIFont systemFontOfSize:Font_Height_11_0]
            andAlignment:NSTextAlignmentCenter];

  self.depositTopUpView.depositLeftLable.text = @"";
  [self.depositTopUpView.depositLeftLable
      setAttributedTextWithFirstString:@""
                          andFirstFont:[UIFont systemFontOfSize:23.0f]
                         andFirstColor:[Globle colorFromHexRGB:@"#454545"]
                       andSecondString:@""
                         andSecondFont:[UIFont
                                           systemFontOfSize:Font_Height_11_0]
                        andSecondColor:[Globle colorFromHexRGB:@"#df3031"]];
  self.depositTopUpView.depositLeftLable.textAlignment = NSTextAlignmentCenter;
}

/** 创建确认支付的视图 */
- (void)createConfirmPayView {
  self.payView = [ConfirmPayView createdConfirmPayInfoView];
  /** 设置frame  */
  self.payView.top = _clientView.height - 56;
  self.payView.left = 0;
  self.payView.width = WIDTH_OF_SCREEN;

  self.payView.payMoneyLabel.text = @"支付金额 ：";
  [self.payView.confirmPayButton addTarget:self
                                    action:@selector(clickOnDetermineBtn:)
                          forControlEvents:UIControlEventTouchUpInside];
  [self.clientView addSubview:self.payView];
  [self.clientView bringSubviewToFront:self.payView];
}

/** 设置分割线 */
- (void)setupMarginLine {
  self.depositTopUpView.verticalLine.backgroundColor =
      [Globle colorFromHexRGB:@"#f0f0f0"];
  self.depositTopUpView.horizontalLine.backgroundColor =
      [Globle colorFromHexRGB:@"#e7e7e7"];
  self.depositTopUpView.inputLine.backgroundColor =
      [Globle colorFromHexRGB:Color_Blue_but];
}

/** 设置平仓与警戒线相关控件 */
- (void)setupCordonAndClosePositionView {
  self.depositTopUpView.cordonImageView.image =
      [UIImage imageNamed:@"警戒线小图标.png"];
  self.depositTopUpView.closePositionImageView.image =
      [UIImage imageNamed:@"平仓线小图标.png"];

  [self.depositTopUpView.cordonInfoTitleLable
      setupLableWithText:@"警戒线"
            andTextColor:[Globle colorFromHexRGB:@"#df3031"]
             andTextFont:[UIFont systemFontOfSize:Font_Height_12_0]
            andAlignment:NSTextAlignmentCenter];
  [self.depositTopUpView.closePositionTitleLable
      setupLableWithText:@"平仓线"
            andTextColor:[Globle colorFromHexRGB:@"#df3031"]
             andTextFont:[UIFont systemFontOfSize:Font_Height_12_0]
            andAlignment:NSTextAlignmentCenter];

  [self.depositTopUpView.cordonInfoLable
      setupLableWithText:@""
            andTextColor:[Globle colorFromHexRGB:Color_Text_Common]
             andTextFont:[UIFont systemFontOfSize:Font_Height_12_0]
            andAlignment:NSTextAlignmentLeft];
  [self.depositTopUpView.closePositionLable
      setupLableWithText:@""
            andTextColor:[Globle colorFromHexRGB:Color_Text_Common]
             andTextFont:[UIFont systemFontOfSize:Font_Height_12_0]
            andAlignment:NSTextAlignmentLeft];
}

/** 设置保证金充值输入框 */
- (void)setupImputMoneyTextField {
  self.depositTopUpView.inputMoney.inputType = INPUTE_TYPE_INTEGER_NUMBER;
  self.depositTopUpView.inputMoney.inputTextField.keyboardType =
      UIKeyboardTypeNumberPad;
  self.depositTopUpView.inputMoney.inputTextField.placeholder =
      @"请输入充值保证金";
  self.depositTopUpView.inputMoney.inputTextField.textAlignment =
      NSTextAlignmentLeft;
  self.depositTopUpView.inputMoney.inputTextField.font =
      [UIFont systemFontOfSize:Font_Height_16_0];
  self.depositTopUpView.inputMoney.inputTextField.borderStyle =
      UITextBorderStyleNone;

  //支付金额
  __weak DepositTopUpViewController *weakSelf = self;
  self.depositTopUpView.inputMoney.endEditingBlock = ^(NSString *textStr) {
    if (weakSelf) {
      weakSelf.payView.payMoneyNumberLabel.text =
          ((textStr == nil || [textStr isEqualToString:@""])
               ? @"0.00元"
               : [textStr stringByAppendingString:@"元"]);
    }
  };
}

/** 设置金额输入框右侧占位符 */
- (void)setupRightPlaceholderWithText:(NSString *)text {
  [self.depositTopUpView.inputMoney addSubview:self.rightPlaceholder];

  [self.rightPlaceholder
      setupLableWithText:text
            andTextColor:[Globle colorFromHexRGB:Color_Gray]
             andTextFont:[UIFont systemFontOfSize:Font_Height_12_0]
            andAlignment:NSTextAlignmentCenter];

  [self.rightPlaceholder sizeToFit];
  self.rightPlaceholder.height = self.depositTopUpView.inputMoney.height;
  self.rightPlaceholder.right = self.depositTopUpView.inputMoney.width;
  self.rightPlaceholder.top = 0;
}

///** 有金额输入时隐藏金额输入框右侧的占位符 */
//- (void)inputMoneyDidChang {
//  self.rightPlaceholder.hidden =
//      [self.depositTopUpView.inputMoney.inputTextField.text
//          isEqualToString:@""]
//          ? NO
//          : YES;
//}

#pragma mark ——— 按钮点击响应函数 ———
/** 点击确认支付按钮响应函数 */
- (void)clickOnDetermineBtn:(UIButton *)clickedBtn {
  if (self.isDataBinded == NO) {
    [NewShowLabel setMessageContent:@"无数据，请刷新"];
    return;
  }

  NSInteger chargeAmount =
      [self.depositTopUpView.inputMoney.inputTextField.text integerValue];
  NSInteger chargeAmountCent = chargeAmount * 100;

  if (self.depositTopUpView.inputMoney.userInteractionEnabled) {
    if ([self.depositTopUpView.inputMoney.inputTextField.text
            isEqualToString:@""] ||
        chargeAmount == 0) {
      [NewShowLabel setMessageContent:@"请输入充值保证金金额"];
      return;
    }
    if (chargeAmount >= self.addLittlePrice &&
        chargeAmount <= self.addBigPrice) {
      self.addBailContractParameter.transAmount =
          [@(chargeAmountCent) stringValue];
      ;
      [self inquireCurrentBalance];
      return;
    } else if (chargeAmount < self.addLittlePrice) {
      [NewShowLabel setMessageContent:@"充值金额小于充值下限"];
      return;
    }

  } else {
    [NewShowLabel setMessageContent:@"未亏损时无需补充保证金"];
    return;
  }
}

- (void)stopLoading {
  [self.indicatorView stopAnimating];
  [NetLoadingWaitView stopAnimating];
}

#pragma mark ——— 网络访问相关 ———
/** 获取追加保证金信息网络接口 */
- (void)getCashAmount {
  [self.indicatorView startAnimating];

  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    [self.indicatorView stopAnimating];
    return;
  }
  HttpRequestCallBack *callBack = [[HttpRequestCallBack alloc] init];
  //解析
  __weak DepositTopUpViewController *weakSelf = self;
  callBack.onCheckQuitOrStopProgressBar = ^{
    DepositTopUpViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf.indicatorView stopAnimating];
      return NO;
    } else {
      return YES;
    }
  };
  callBack.onSuccess = ^(NSObject *obj) {
    DepositTopUpViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf getCashAmountInfoOnSuccessWithResult:obj];
    }
  };
  [WFProductContract
      getCashAmountInfoWithContractNo:self.addBailContractParameter.contractNo
                          andCallback:callBack];
}

/** 追加保证金网络接口 */
- (void)addBailContract {

  [NetLoadingWaitView startAnimating];
  [self.indicatorView startAnimating];

  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    [self stopLoading];
    return;
  }
  HttpRequestCallBack *callBack = [[HttpRequestCallBack alloc] init];
  //解析
  __weak DepositTopUpViewController *weakSelf = self;
  callBack.onCheckQuitOrStopProgressBar = ^{
    DepositTopUpViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf stopLoading];
      return NO;
    } else {
      return YES;
    }
  };
  callBack.onSuccess = ^(NSObject *obj) {
    DepositTopUpViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf addBailContractOnSuccessWithResult:obj];
    }
  };
  callBack.onError = ^(BaseRequestObject *obj, NSException *exc) {
    DepositTopUpViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf addBailContractOnErrorWithRequest:obj andExc:exc];
    }
  };
  [WFProductContract
      addWFProductBailContractWithContractNo:self.addBailContractParameter
                                                 .contractNo
                              andTransAmount:self.addBailContractParameter
                                                 .transAmount
                                   andRemark:@""
                                 andCallback:callBack];
}

#pragma mark ——— 网络访问结果处理 ———
#pragma mark ——— 获取追加保证金信息网络请求结果处理 ———
/** 获取追加保证金信息成功处理函数 */
- (void)getCashAmountInfoOnSuccessWithResult:(NSObject *)obj {
  WFGetCashAmountInfoResult *result = (WFGetCashAmountInfoResult *)obj;
  self.cashAmountInfo = result;
  /// 设置警戒线信息
  NSString *warningLine = [NSString
      stringWithFormat:@"≤%d",
                       (int)ceilf([result.warningLine doubleValue] / 100)];
  self.depositTopUpView.cordonInfoLable.text = warningLine;
  /// 设置平仓线信息
  NSString *flatLine = [NSString
      stringWithFormat:@"≤%d",
                       (int)ceilf([result.flatLine doubleValue] / 100)];
  self.depositTopUpView.closePositionLable.text = flatLine;

  /// 设置账户金额信息
  [self setLable:self.depositTopUpView.amountLable andAmount:result.totalAsset];
  /// 设置保证金信息
  [self setLable:self.depositTopUpView.depositLeftLable
       andAmount:result.cashAmount];
  //优顾账户余额
  self.payView.accountBalanceLabel.text =
      [[ProcessInputData convertMoneyString:result.ygBalance]
          stringByAppendingFormat:@"元"];

  /// 设置输入框提示信息
  if (!result.czFlag) {
    [self setupRightPlaceholderWithText:@""];
    self.depositTopUpView.inputMoney.inputTextField.placeholder = @"无需充值";
    self.depositTopUpView.inputMoney.userInteractionEnabled = NO;
    //确认支付按钮置灰
    [self.payView.confirmPayButton
        setBackgroundImage:[SimuUtil imageFromColor:@"#afb3b5"]
                  forState:UIControlStateNormal];
    self.payView.confirmPayButton.userInteractionEnabled = NO;
  } else {
    self.payView.confirmPayButton.userInteractionEnabled = YES;
    //最小充值保证金
    self.addLittlePrice = ceilf([result.addLittlePrice doubleValue] / 100);
    //最大充值保证金
    self.addBigPrice = ceilf([result.addBigPrice doubleValue] / 100);

    NSString *addBigPrice =
        [NSString stringWithFormat:@"%ld", (long)self.addBigPrice];
    NSString *addLittlePrice =
        [NSString stringWithFormat:@"%ld", (long)self.addLittlePrice];

    [self setupRightPlaceholderWithText:
              [NSString stringWithFormat:@"充值范围%@~%@元",
                                         addLittlePrice, addBigPrice]];

    self.depositTopUpView.inputMoney.userInteractionEnabled = YES;
    ///对输入金额进行校验
    __weak InputTextFieldView *weakInputMoney =
        self.depositTopUpView.inputMoney;
    self.depositTopUpView.inputMoney.changeTextBlock =
        ^(NSString *textStr, BOOL isChanged) {
          if (weakInputMoney && isChanged &&
              [textStr integerValue] > [addBigPrice integerValue]) {
            weakInputMoney.inputTextField.text = addBigPrice;
          }
        };
  }

  self.isDataBinded = YES;
}

- (void)setLable:(UILabel *)changedLable andAmount:(NSString *)amountStr {
  if (amountStr && ![amountStr isEqualToString:@""]) {
    NSString *cashAmountStr = [ProcessInputData convertMoneyString:amountStr];
    NSArray *cashAmountArray = [cashAmountStr componentsSeparatedByString:@"."];
    NSString *firstStr = cashAmountArray[0];
    NSString *lastStr = [@"." stringByAppendingString:cashAmountArray[1]];
    [changedLable
        setAttributedTextWithFirstString:firstStr
                            andFirstFont:[UIFont systemFontOfSize:27.0f]
                           andFirstColor:[Globle colorFromHexRGB:@"#454545"]
                         andSecondString:lastStr
                           andSecondFont:[UIFont
                                             systemFontOfSize:Font_Height_11_0]
                          andSecondColor:[Globle colorFromHexRGB:@"#454545"]];
  } else {
    changedLable.attributedText =
        [[NSAttributedString alloc] initWithString:@""];
  }
}

#pragma mark ——— 追加保证金网络请求结果处理 ———
/** 追保网络请求成功处理函数 */
- (void)addBailContractOnSuccessWithResult:(NSObject *)obj {
  WFExtendContractResult *result = (WFExtendContractResult *)obj;
  [NewShowLabel setMessageContent:result.message];
  if ([result.status isEqualToString:@"0000"]) {
    self.depositTopUpView.inputMoney.inputTextField.text = @"";
  }
  [self refreshButtonPressDown];
}

/** 追保网络请求错误处理函数 */
- (void)addBailContractOnErrorWithRequest:(BaseRequestObject *)obj
                                   andExc:(NSException *)exc {
  if ([obj.status isEqualToString:@"0015"]) {
    [self inquireCurrentBalance];
    return;
  }
  BaseRequester.defaultErrorHandler(obj, exc);
}

/** 查询账户余额网络接口 */
- (void)inquireCurrentBalance {

  [NetLoadingWaitView startAnimating];
  [self.indicatorView startAnimating];

  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    [self stopLoading];
    return;
  }

  __weak DepositTopUpViewController *weakSelf = self;
  [WFPayUtil checkWFAccountBalanceWithOwner:self
      andCleanCallBack:^{
        [weakSelf stopLoading];
      }
      andSurePayCallBack:^{
        [weakSelf addBailContract];
      }
      andTotalAmountCent:self.addBailContractParameter.transAmount];
}

#pragma mark ——— 联网指示器代理 ———
/** 点击刷新按钮响应函数 */
- (void)refreshButtonPressDown {
  [self getCashAmount];
}

#pragma mark--- 懒加载 ---
/** 懒加载右上角“客服电话”按钮 */
- (UIButton *)hotlineBtn {
  if (_hotlineBtn == nil) {
    _hotlineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  }
  return _hotlineBtn;
}

/** 懒加载保证金充值视图（通过DepositTopUpView.xib创建） */
- (DepositTopUpView *)depositTopUpView {
  if (_depositTopUpView == nil) {
    _depositTopUpView = [[[NSBundle mainBundle] loadNibNamed:@"TopUpDepositView"
                                                       owner:nil
                                                     options:nil] lastObject];
  }
  return _depositTopUpView;
}

/** 懒加载金额输入框右侧占位符 */
- (UILabel *)rightPlaceholder {
  if (_rightPlaceholder == nil) {
    _rightPlaceholder = [[UILabel alloc] init];
  }
  return _rightPlaceholder;
}

/** 懒加载追加保证金入参 */
- (WFAddBailContractParameter *)addBailContractParameter {
  if (_addBailContractParameter == nil) {
    _addBailContractParameter = [[WFAddBailContractParameter alloc] init];
  }
  return _addBailContractParameter;
}

@end
