//
//  BoundPaymentDetailsViewControllerVC.m
//  SimuStock
//
//  Created by jhss on 15/6/8.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BoundBankCardPaymentDetailsVC.h"
#import "UIButton+Hightlighted.h"
#import "SimuUtil.h"
#import "NSString+validate.h"
#import "NewShowLabel.h"
#import "BaseRequester.h"
#import "WFAccountInterface.h"
#import "YeePaySuccessController.h"
#import "UIImageView+WebCache.h"
#import "SchollWebViewController.h"
#import "NetLoadingWaitView.h"
#import "CutomerServiceButton.h"

@implementation BoundBankCardPaymentDetailsVC

- (instancetype)initWithAmount:(NSString *)amount
                    andOrderNo:(NSString *)orderNo
                    andPayTips:(NSString *)tips
                     andResult:(WFBindedBankcardYeePayResult *)info {
  self = [super init];
  if (self) {
    self.amount = amount;
    self.orderNo = orderNo;
    self.cardLastNum = info.card_last;
    self.bankName = info.bank_name;
    self.phoneNum = info.phone;
    self.bankCardInfo = info;
    self.payTips = tips;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  /// 设置View上的控件
  [self setupSubviews];
}
/**创建获取用户验证码*/
- (void)createVerCode {
  getVerCode = [[GetVerificationCode alloc] init];
}
/** 设置View上的控件 */
- (void)setupSubviews {
  [self createVerCode];
  /// 显示顶部“支付”
  [_topToolBar resetContentAndFlage:@"充值" Mode:TTBM_Mode_Leveltwo];
  _clientView.alpha = 0;
  self.indicatorView.hidden = YES;
  //设置右上角“客服热线”按钮
  [[CutomerServiceButton shareDataCenter]
      establisthCustomerServiceTelephonetopToolBar:_topToolBar
                                     indicatorView:_indicatorView
                                              hide:YES];
  self.moneyLabel.text = self.amount;
  self.bankCardNameLabel.text = self.bankName;
  self.tailNumberLab.text =
      [NSString stringWithFormat:@"尾号%@的储蓄卡", self.cardLastNum];
  self.phoneNumberLabel.text = [NSString
      stringWithFormat:@"%@****%@", [self.phoneNum substringToIndex:3],
                       [self.phoneNum substringFromIndex:7]];
  self.payTipsLab.text = self.payTips;

  [self.readedButton setImage:[UIImage imageNamed:@"小对号图标.png"]
                     forState:UIControlStateNormal];
  [self.readedButton setImage:[UIImage imageNamed:@"小对号图标.png"]
                     forState:UIControlStateSelected];
  [self.readedButton setImage:[UIImage imageNamed:@"小对号图标.png"]
                     forState:UIControlStateHighlighted];
  [self.readedButton setBackgroundImage:[SimuUtil imageFromColor:@"#AFB3b5"]
                               forState:UIControlStateNormal];
  [self.readedButton setBackgroundImage:[SimuUtil imageFromColor:@"#055081"]
                               forState:UIControlStateHighlighted];
  [self.readedButton setBackgroundImage:[SimuUtil imageFromColor:@"#71BB46"]
                               forState:UIControlStateSelected];
  self.readedButton.imageEdgeInsets = UIEdgeInsetsMake(2.0, 2.0, 2.0, 2.0);
  self.readedButton.layer.cornerRadius = self.readedButton.width / 2;
  self.readedButton.layer.masksToBounds = YES;
  self.readedButton.enabled = YES;
  self.readedButton.selected = YES;

  [self.bankLogoImgView
      setImageWithURL:[NSURL URLWithString:self.bankCardInfo.bank_logo]];
  ///短信验证码输入框
  self.authCodeTF.delegate = self;

  [self.getAuthCodeBtn setTitleColor:[Globle colorFromHexRGB:@"086dae"]
                            forState:UIControlStateNormal];
  [self.getAuthCodeBtn setTitleColor:[Globle colorFromHexRGB:@"4dfdff"]
                            forState:UIControlStateHighlighted];

  [self.conFirmBtn buttonWithNormal:Color_WFOrange_btn
               andHightlightedColor:Color_WFOrange_btnDown];
  self.conFirmBtn.layer.cornerRadius = self.conFirmBtn.bounds.size.height / 2;
  self.conFirmBtn.layer.masksToBounds = YES;

  [self codeVerification];
}

- (void)codeVerification {
  self.getAuthCodeBtn.userInteractionEnabled = NO;
  //按钮状态
  [self.getAuthCodeBtn setTitleColor:[Globle colorFromHexRGB:@"939393"]
                            forState:UIControlStateNormal];
  //获得验证码
  [self getVerCode];
}

- (void)getVerCode {
  [getVerCode changeButton];
  getVerCode.getAuthBtn = self.getAuthCodeBtn;
}

#pragma mark
- (void)getAuthCodeButtonAction {
  self.getAuthCodeBtn.userInteractionEnabled = YES;
}
- (IBAction)clickOnHaveReadBtn:(UIButton *)sender {
  if (sender.selected) {
    sender.selected = NO;
  } else {
    sender.selected = YES;
  }
}

- (IBAction)getAuthCodeClick:(UIButton *)sender {
  [self performSelector:@selector(getAuthCodeButtonAction)
             withObject:nil
             afterDelay:0.4];
  //收回键盘
  [self resignKeyBoardFirstResponder];

  //按钮状态
  [self.getAuthCodeBtn setTitleColor:[Globle colorFromHexRGB:@"086dae"]
                            forState:UIControlStateNormal];

  //获得验证码
  [self sendSmsAuthCode];
}
///调用接口，发送验证码
- (void)sendSmsAuthCode {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel setMessageContent:REQUEST_FAILED_MESSAGE];
    return;
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  //解析
  __weak BoundBankCardPaymentDetailsVC *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    BoundBankCardPaymentDetailsVC *strongSelf = weakSelf;
    if (strongSelf) {
      return NO;
    } else
      return YES;
  };
  callback.onSuccess = ^(NSObject *obj) {
    BoundBankCardPaymentDetailsVC *strongSelf = weakSelf;
    if (strongSelf) {
      NSLog(@"获取成功！！！！");
    }
  };
  callback.onError = ^(BaseRequestObject *error, NSException *ex) {
    if ([error.status isEqualToString:@"1001"]) {
      [self authReset];
    }
    [BaseRequester defaultErrorHandler](error, ex);
  };

  ///获取验证码请求。
  [WFAccountInterface WFYeePaymentSMSSendWithOrderNo:self.orderNo
                                        WithCallBack:callback];

  //点击就重置了button
  [self authReset];
  [getVerCode changeButton];
  getVerCode.getAuthBtn = self.getAuthCodeBtn;
}

#pragma mark
#pragma mark 重置按钮
- (void)authReset {
  [self.getAuthCodeBtn setTitleColor:[Globle colorFromHexRGB:@"086dae"]
                            forState:UIControlStateNormal];
  [self.getAuthCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
  [getVerCode stopTime];
}

- (IBAction)confirmBtnClick:(UIButton *)sender {
  [self resignKeyBoardFirstResponder];

  //输入限定条件
  if ([self.authCodeTF.text length] == 0) {
    [self showMessage:@"请输入验证码"];
    return;
  }

  if (!self.readedButton.selected) {
    [NewShowLabel setMessageContent:@"请"
                  @"阅读并同意《易宝一键支付服务协议》"];
    return;
  }

  sender.userInteractionEnabled = YES;
  [NetLoadingWaitView startAnimating];
  /** 1.3手机号的绑定 发送信息进行手机号的绑定 */
  if (![SimuUtil isExistNetwork]) {

    [NetLoadingWaitView stopAnimating];
    [NewShowLabel showNoNetworkTip];
    return;
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  //解析
  __weak BoundBankCardPaymentDetailsVC *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    BoundBankCardPaymentDetailsVC *strongSelf = weakSelf;
    if (strongSelf) {
      [NetLoadingWaitView stopAnimating];
      [strongSelf authReset];
      return NO;
    } else
      return YES;
  };
  callback.onSuccess = ^(NSObject *obj) {
    BoundBankCardPaymentDetailsVC *strongSelf = weakSelf;
    BaseRequestObject *result = (BaseRequestObject *)obj;
    if (strongSelf) {
      [AppDelegate
          pushViewControllerFromRight:
              [[YeePaySuccessController alloc]
                  initWithAmount:strongSelf.amount
                    andIsSuccess:[result.status isEqualToString:@"0000"]]];
    }
  };
  callback.onError = ^(BaseRequestObject *obj, NSException *exc) {
    [BaseRequester defaultErrorHandler](obj, exc);
    sender.enabled = YES;
  };
  callback.onFailed = ^() {
    [BaseRequester defaultFailedHandler]();
    sender.enabled = YES;
  };

  ///获取验证码请求。
  [WFAccountInterface WFYeePaymentSMSPayConfirmWithOrderNo:self.orderNo
                                            WithVerifyCode:self.authCodeTF.text
                                              WithCallBack:callback];
}
- (IBAction)yibaoPaymentBtnClick:(UIButton *)sender {
  ///跳转的web链接待定
  [SchollWebViewController startWithTitle:@"易宝一键支付服务协议"
                                  withUrl:@"http://www.youguu.com/opms/html/"
                                  @"article/32/2015/0616/2717.html"];
}

#pragma textField协议函数
//比较完整的校验
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

  if (textField == self.authCodeTF) {
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self resignKeyBoardFirstResponder];
}

/**
 *释放键盘
 */
- (void)resignKeyBoardFirstResponder {
  [self.authCodeTF resignFirstResponder];
}

//提示框
- (void)showMessage:(NSString *)content {
  [NewShowLabel setMessageContent:content];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
@end
