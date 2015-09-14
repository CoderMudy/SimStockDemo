//
//  PaymentDetailsViewController.m
//  SimuStock
//
//  Created by jhss on 15/6/8.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "PaymentDetailsViewController.h"
#import "PaymentDetailsClientView.h"
#import "NSString+validate.h"
#import "WFRegularExpression.h"
#import "NewShowLabel.h"
#import "SimuUtil.h"
#import "BaseRequester.h"
#import "NetLoadingWaitView.h"
#import "WFAccountInterface.h"
#import "DataEncryptTool.h"
#import "UIImageView+WebCache.h"
#import "YeePaySuccessController.h"
#import "GetVerificationCode.h"
#import "CutomerServiceButton.h"

@implementation PaymentDetailsViewController

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(keyboardWillChange:)
             name:UIKeyboardWillChangeFrameNotification
           object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [[NSNotificationCenter defaultCenter]
      removeObserver:self
                name:UIKeyboardWillChangeFrameNotification
              object:nil];
}

- (instancetype)initWithAmount:(NSString *)amount
                    andOrderNo:(NSString *)orderNo
                      andToken:(NSString *)token
                 andBankCardNo:(NSString *)bankCardNo
                    andPayTips:(NSString *)payTips
               andBandCardInfo:(WFYeePaymentCardBinRequestResult *)cardInfo {
  self = [super init];
  if (self) {
    self.amount = amount;
    self.orderNo = orderNo;
    self.token = token;
    self.bankCardNo = bankCardNo;
    self.bankCardInfo = cardInfo;
    self.payTips = payTips;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  /// 设置View上的控件
  [self setupSubviews];
}

/** 设置View上的控件 */
- (void)setupSubviews {
  /// 显示顶部“支付”
  [_topToolBar resetContentAndFlage:@"充值" Mode:TTBM_Mode_Leveltwo];
  self.indicatorView.hidden = YES;
  //设置右上角“客服热线”按钮
  [[CutomerServiceButton shareDataCenter]
      establisthCustomerServiceTelephonetopToolBar:_topToolBar
                                     indicatorView:_indicatorView
                                              hide:YES];

  [self createVerCode];
  [self setupMainScrollView];
  [self setupMainView];
}

/** 设置页面滚动视图 */
- (void)setupMainScrollView {
  UIScrollView *mainScrollView = [[UIScrollView alloc]
      initWithFrame:CGRectMake(0, 0, self.clientView.width,
                               self.clientView.height)];
  [self.clientView addSubview:mainScrollView];
  self.mainScrollView = mainScrollView;
  self.mainScrollView.showsHorizontalScrollIndicator = NO;
  self.mainScrollView.showsVerticalScrollIndicator = NO;
  self.mainScrollView.bounces = YES;
}

/** 设置内容视图 */
- (void)setupMainView {
  self.mainView.width = self.clientView.width;
  [self.mainScrollView addSubview:self.mainView];
  if (self.mainView.height < self.clientView.height) {
    self.mainView.height = self.clientView.height + 1;
  }
  self.mainScrollView.contentSize = self.mainView.size;

  /// 姓名输入框
  self.mainView.nameTextField.delegate = self;
  /// 身份证输入框
  self.mainView.idCardTextField.delegate = self;
  /// 手机号输入框
  self.mainView.phoneNumTextField.delegate = self;
  ///短信验证码输入框
  self.mainView.messageVerificationCodeTF.delegate = self;

  self.mainView.rechargeAmountLabe.text = self.amount;

  [self.mainView.bankLogoImageView
      setImageWithURL:[NSURL URLWithString:self.bankCardInfo.bank_logo]];
  self.mainView.bankNameLable.text = self.bankCardInfo.bankname;
  self.mainView.bankCardLastNoLable.text = [NSString
      stringWithFormat:@"尾号%@的%@",
                       [self.bankCardNo
                           substringFromIndex:(self.bankCardNo.length - 4)],
                       (self.bankCardInfo.cardtype == 1 ? @"储蓄卡"
                                                        : @"信用卡")];

  self.mainView.payTipsLabel.text = self.payTips;

  [self.mainView.confirmBtn addTarget:self
                               action:@selector(confirmBtnClick:)
                     forControlEvents:UIControlEventTouchUpInside];
  [self.mainView.getAuthCodeButton addTarget:self
                                      action:@selector(getAuthCodeClick:)
                            forControlEvents:UIControlEventTouchUpInside];
}

/** 创建获取用户验证码 */
- (void)createVerCode {
  self.mainView.getVerCode = [[GetVerificationCode alloc] init];
}

- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {
  if ([string isEqualToString:@"\n"] && string.length == 0) {
    return YES;
  }

  if (string.length == 0) {
    return YES;
  }

  NSString *toBeString =
      [textField.text stringByReplacingCharactersInRange:range
                                              withString:string];

  /// 判断姓名输入
  if (textField == self.mainView.nameTextField) {
    if ([toBeString length] > 16) {
      textField.text = [toBeString substringToIndex:16];
      return NO;
    }
  }

  /// 判断身份证输入
  if (textField == self.mainView.idCardTextField) {
    if (![NSString validataIdCardNumberOnInput:toBeString]) {
      return NO;
    }
    if ([toBeString length] > 18) {
      textField.text = [toBeString substringToIndex:18];
      return NO;
    }
  }

  /// 判断手机号输入
  if (textField == self.mainView.phoneNumTextField) {
    if (![NSString validataNumberInput:toBeString]) {
      return NO;
    }
    if ([toBeString length] >= 11) {
      textField.text = [toBeString substringToIndex:11];
      self.mainView.getAuthCodeButton.enabled = YES;
      self.mainView.getAuthCodeButton.alpha = 1.0;
      return NO;
    } else {
      self.mainView.getAuthCodeButton.enabled = NO;
      self.mainView.getAuthCodeButton.alpha = 0.8;
      return YES;
    }
  }

  /// 判断验证码输入
  if (textField == self.mainView.messageVerificationCodeTF) {
    if (![NSString validataPasswordOnInput:toBeString]) {
      return NO;
    }
    if ([toBeString length] > 12) {
      textField.text = [toBeString substringToIndex:12];
      return NO;
    }
  }

  return YES;
}

/** 点击确认按钮 */
- (void)confirmBtnClick:(UIButton *)sender {
  /// 收回键盘
  [self.mainView endEditing:YES];

  if (![self checkBindCardInfo]) {
    return;
  }

  if (!self.mainView.haveReadBtn.selected) {
    [NewShowLabel setMessageContent:@"请"
                  @"阅读并同意《易宝一键支付服务协议》"];
    return;
  }

  /// 校验验证码
  if ([self.mainView.messageVerificationCodeTF.text length] == 0) {
    [NewShowLabel setMessageContent:@"请输入验证码"];
    return;
  }

  NSDictionary *yeePayContent = @{
    @"token" : self.token,
    @"orderNo" : self.orderNo,
    @"cardLast" :
        [self.bankCardNo substringFromIndex:(self.bankCardNo.length - 4)],
    @"cardTop" : [self.bankCardNo substringToIndex:6],
    @"userIp" : @"127.0.0.1",
    @"ybReqId" : self.ybReqId,
    @"verifyCode" : self.mainView.messageVerificationCodeTF.text,
  };
  NSString *yeePaySign = [DataEncryptTool sortDictionary:yeePayContent];
  yeePaySign =
      [DataEncryptTool signTheDataSHA1WithRSA:yeePaySign
                        andPrivateKeyFilePath:@"yeepay_content_private_key"
                                  andPassword:@"123456"];
  self.bindCardPayParameter.token = yeePayContent[@"token"];
  self.bindCardPayParameter.orderNo = yeePayContent[@"orderNo"];
  self.bindCardPayParameter.cardLast = yeePayContent[@"cardLast"];
  self.bindCardPayParameter.cardTop = yeePayContent[@"cardTop"];
  self.bindCardPayParameter.userIp = yeePayContent[@"userIp"];
  self.bindCardPayParameter.ybReqId = yeePayContent[@"ybReqId"];
  self.bindCardPayParameter.verifyCode = yeePayContent[@"verifyCode"];
  self.bindCardPayParameter.sign = yeePaySign;
  [self yeePayBindCardPayRequest];
}

- (void)getAuthCodeClick:(UIButton *)sender {
  /// 收回键盘
  [self.mainView endEditing:YES];

  if (![self checkBindCardInfo]) {
    return;
  }

  /// 发起绑卡请求，获得验证码
  self.bindCardParameter.card_no = self.bankCardNo;
  self.bindCardParameter.id_no = self.mainView.idCardTextField.text;
  self.bindCardParameter.acct_name = self.mainView.nameTextField.text;
  self.bindCardParameter.phone = self.mainView.phoneNumTextField.text;
  self.bindCardParameter.user_ip = @"127.0.0.1";
  [self yeePayBindCardRequest];
}

- (BOOL)checkBindCardInfo {
  /// 校验姓名
  if (![self checkReaNameAuthenticity]) {
    return NO;
  }

  /// 校验身份证
  if (![self checkIdCardAuthenticity]) {
    return NO;
  }

  /// 校验手机号
  if (self.mainView.phoneNumTextField.text &&
      [self.mainView.phoneNumTextField.text isEqualToString:@""]) {
    [NewShowLabel setMessageContent:@"手机号不能为空"];
    return NO;
  } else if (![NSString
                 validataPhoneNumber:self.mainView.phoneNumTextField.text]) {
    [NewShowLabel setMessageContent:@"请输入正确的手机号"];
    return NO;
  }

  return YES;
}

/** 判断身份证的真实性 */
- (BOOL)checkIdCardAuthenticity {
  if (self.mainView.idCardTextField.text.length > 0) {
    //判断身份证位数的合法性
    BOOL isNo = [WFRegularExpression
        judgmentFullNameLegitimacy:self.mainView.idCardTextField.text
              withBankIdentityInfo:IdentityCardNumber];
    if (isNo == NO) {
      [NewShowLabel setMessageContent:@"身份证号输入有误," @"请"
                    @"重新填" @"写"];
    } else {
      //身份证的有效性
      BOOL idnetityNo = [[WFRegularExpression shearRegularExpression]
          judgmentDetermineLegalityOfTheIdentityCardOfBankCards:
              self.mainView.idCardTextField
                  .text withBankIdentityInfo:IdentityCardNumber];
      if (idnetityNo == NO) {
        [NewShowLabel setMessageContent:@"请填写正确的身份证号"];
      } else {
        return YES;
      }
    }
  } else {
    [NewShowLabel setMessageContent:@"身份证号不能为空"];
  }
  return NO;
}

/** 判断姓名的真实性 */
- (BOOL)checkReaNameAuthenticity {
  if (self.mainView.nameTextField.text.length > 0) {
    if (self.mainView.nameTextField.text.length >= 2) {
      //判断内容的是否合法
      BOOL isNo = [WFRegularExpression
          judgmentFullNameLegitimacy:self.mainView.nameTextField.text
                withBankIdentityInfo:FullName];
      if (isNo == NO) {
        [NewShowLabel setMessageContent:@"请输入中文"];
      } else {
        /// 姓名验证正确，接着验证验证身份证号
        return YES;
      }
    } else {
      [NewShowLabel setMessageContent:@"请填真实的姓名"];
    }
  } else {
    [NewShowLabel setMessageContent:@"姓名不能为空"];
  }
  return NO;
}

#pragma mark-----  网络请求  -----
/** 易宝支付绑定银行卡请求 */
- (void)yeePayBindCardRequest {
  [NetLoadingWaitView startAnimating];

  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    [self clearAction];
    return;
  }

  HttpRequestCallBack *callBack = [[HttpRequestCallBack alloc] init];
  __weak PaymentDetailsViewController *weakSelf = self;
  callBack.onCheckQuitOrStopProgressBar = ^{
    PaymentDetailsViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [self clearAction];
      return NO;
    } else {
      return YES;
    }
  };

  callBack.onSuccess = ^(NSObject *obj) {
    PaymentDetailsViewController *strongSelf = weakSelf;
    if (strongSelf) {
      WFYeePayBindCardRequestResult *result =
          (WFYeePayBindCardRequestResult *)obj;
      if ([result.status isEqualToString:@"0000"]) {
        strongSelf.ybReqId = result.yb_req_id;
        strongSelf.mainView.nameTextField.enabled = NO;
        strongSelf.mainView.idCardTextField.enabled = NO;
        strongSelf.mainView.phoneNumTextField.enabled = NO;
        strongSelf.mainView.messageVerificationCodeTF.enabled = YES;
      } else {
        [NewShowLabel setMessageContent:result.message];
      }
    }
  };

  callBack.onError = ^(BaseRequestObject *obj, NSException *exc) {
    PaymentDetailsViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [NewShowLabel setMessageContent:obj.message];
      [strongSelf.mainView.getVerCode stopTime];
      [strongSelf.mainView.getVerCode authReset];
    }
  };

  callBack.onFailed = ^{
    PaymentDetailsViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [BaseRequester defaultFailedHandler];
      [strongSelf.mainView.getVerCode stopTime];
      [strongSelf.mainView.getVerCode authReset];
    }
  };

  [WFAccountInterface WFYeePayBindCardWithRequest:self.bindCardParameter
                                     WithCallBack:callBack];
  [self.mainView.getVerCode changeButton];
  self.mainView.getVerCode.getAuthBtn = self.mainView.getAuthCodeButton;
  self.mainView.getVerCode.TPphoneNumber = self.mainView.phoneNumTextField.text;
}

/** 易宝支付首次支付请求 */
- (void)yeePayBindCardPayRequest {
  [NetLoadingWaitView startAnimating];

  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    [self clearAction];
    return;
  }

  HttpRequestCallBack *callBack = [[HttpRequestCallBack alloc] init];
  __weak PaymentDetailsViewController *weakSelf = self;
  callBack.onCheckQuitOrStopProgressBar = ^{
    PaymentDetailsViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [self clearAction];
      return NO;
    } else {
      return YES;
    }
  };

  callBack.onSuccess = ^(NSObject *obj) {
    PaymentDetailsViewController *strongSelf = weakSelf;
    BaseRequestObject *result = (BaseRequestObject *)obj;
    if (strongSelf) {
      [AppDelegate
          pushViewControllerFromRight:
              [[YeePaySuccessController alloc]
                  initWithAmount:strongSelf.amount
                    andIsSuccess:[result.status isEqualToString:@"0000"]]];
    }
  };

  callBack.onError = ^(BaseRequestObject *obj, NSException *exc) {
    PaymentDetailsViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [NewShowLabel setMessageContent:obj.message];
      [strongSelf getYeePayTokenRequest];
    }
  };

  callBack.onFailed = ^{
    PaymentDetailsViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [BaseRequester defaultFailedHandler]();
      [strongSelf getYeePayTokenRequest];
    }
  };

  [WFAccountInterface
      WFYeePaymentBindPayWithPayParameter:self.bindCardPayParameter
                             WithCallBack:callBack];
}

/** 易宝支付获取支付token */
- (void)getYeePayTokenRequest {
  if (![SimuUtil isExistNetwork]) {
    return;
  }

  HttpRequestCallBack *callBack = [[HttpRequestCallBack alloc] init];
  __weak PaymentDetailsViewController *weakSelf = self;
  callBack.onCheckQuitOrStopProgressBar = ^{
    PaymentDetailsViewController *strongSelf = weakSelf;
    if (strongSelf) {
      return NO;
    } else {
      return YES;
    }
  };

  callBack.onSuccess = ^(NSObject *obj) {
    PaymentDetailsViewController *strongSelf = weakSelf;
    WFYeePayGetTokenRequestResult *result =
        (WFYeePayGetTokenRequestResult *)obj;
    if (strongSelf) {
      strongSelf.token = result.token;
    }
  };

  [WFAccountInterface WFYeePayGetTokenWithCallBack:callBack];
}

- (void)clearAction {
  [NetLoadingWaitView stopAnimating];
}

- (WFYeePayBindCardRequest *)bindCardParameter {
  if (_bindCardParameter == nil) {
    _bindCardParameter = [[WFYeePayBindCardRequest alloc] init];
  }
  return _bindCardParameter;
}

- (WFYeePaymentBindPayRequest *)bindCardPayParameter {
  if (_bindCardPayParameter == nil) {
    _bindCardPayParameter = [[WFYeePaymentBindPayRequest alloc] init];
  }
  return _bindCardPayParameter;
}

- (PaymentDetailsClientView *)mainView {
  if (_mainView == nil) {
    _mainView = [[[NSBundle mainBundle] loadNibNamed:@"PaymentDetailsClientView"
                                               owner:self
                                             options:nil] lastObject];
  }
  return _mainView;
}

#pragma mark--- 键盘监听相关响应函数 ---

/** 键盘出现时的响应函数 */
- (void)keyboardWillChange:(NSNotification *)notification {
  CGRect keyboardRect = [[notification.userInfo
      objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
  UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
  UIView *firstResponder =
      [keyWindow performSelector:@selector(firstResponder)];
  CGPoint temp_point = [[firstResponder superview]
      convertPoint:firstResponder.origin
            toView:[UIApplication sharedApplication].keyWindow];
  CGFloat height = keyboardRect.origin.y - temp_point.y - firstResponder.height;
  if (keyboardRect.origin.y != HEIGHT_OF_SCREEN && height < 0.0) {

    CGFloat heightkey = self.mainScrollView.contentOffset.y - height + 100;
    /// 键盘将要出现且会遮盖输入框时的处理
    [UIView animateWithDuration:
                [[notification.userInfo
                    objectForKey:
                        UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                     animations:^{
                       [self.mainScrollView
                           setContentOffset:CGPointMake(0, heightkey)
                                   animated:YES];
                     }];
  } else if (keyboardRect.origin.y == HEIGHT_OF_SCREEN) {
    CGFloat heightKey =
        self.mainScrollView.contentOffset.y - keyboardRect.size.height;
    if (heightKey <= 0) {
      heightKey = 0;
    }
    /// 键盘将要消失时且键盘出现时发生过滚动的处理
    [self.mainScrollView setContentOffset:CGPointMake(0, heightKey)
                                 animated:YES];
  }
}

@end
