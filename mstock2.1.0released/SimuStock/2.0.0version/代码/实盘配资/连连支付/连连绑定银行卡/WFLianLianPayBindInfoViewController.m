//
//  WFLianLianPayBindInfoViewController.m
//  SimuStock
//
//  Created by Jhss on 15/5/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "WFLianLianPayBindInfoViewController.h"
#import "UIButton+Hightlighted.h"
#import "AppDelegate.h"
#import "NSString+validate.h"
#import "WFRegularExpression.h"
#import "WFAccountInterface.h"
#import "LianLianPay.h"
#import "LLPaySdk.h"
#import "SchollWebViewController.h"
#import "NetLoadingWaitView.h"

@interface WFLianLianPayBindInfoViewController () <LLPaySdkDelegate>

/** 连连支付 */
@property(strong, nonatomic) LLPaySdk *llPaySdk;

/** 订单号 */
@property(copy, nonatomic) NSString *orderNo;
/** 充值金额（单位：元） */
@property(copy, nonatomic) NSString *amount;

@end

@implementation WFLianLianPayBindInfoViewController

- (instancetype)initWithOrderNo:(NSString *)orderNo
                      andAmount:(NSString *)amount {
  if (self = [super init]) {
    self.orderNo = orderNo;
    self.amount = amount;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.llPaySdk = [[LLPaySdk alloc] init];
  self.llPaySdk.sdkDelegate = self;

  /// 设置View上的控件
  [self setupSubviews];
}

/** 设置View上的控件 */
- (void)setupSubviews {
  /// 显示顶部“支付”
  [_topToolBar resetContentAndFlage:@"支付" Mode:TTBM_Mode_Leveltwo];
  _clientView.alpha = 0;
  self.indicatorView.hidden = YES;
  /// 设置按钮“下一步”的高亮状态

  [self.nextStepBtn buttonWithNormal:Color_WFOrange_btn
                andHightlightedColor:Color_WFOrange_btnDown];
  [self.nextStepBtn buttonWithTitle:@"下一步"
                 andNormaltextcolor:Color_White
           andHightlightedTextColor:Color_White];
  ///设置支持银行列表的高亮状态
  [self.bankListButton buttonWithTitle:@"支持银行列表"
                    andNormaltextcolor:Color_Blue_but
              andHightlightedTextColor:Color_Blue_butDown];

  /// 姓名输入框
  self.nameTextField.delegate = self;
  self.nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
  self.nameTextField.textColor = [Globle colorFromHexRGB:@"454545"];
  self.nameTextField.font = [UIFont systemFontOfSize:14];

  /// 身份证输入框
  self.idCardField.delegate = self;
  self.idCardField.clearButtonMode = UITextFieldViewModeWhileEditing;
  self.idCardField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
  self.idCardField.textColor = [Globle colorFromHexRGB:@"454545"];
  self.idCardField.font = [UIFont systemFontOfSize:14];
  /// 银行卡输入框
  self.bankCardTextField.delegate = self;
  self.bankCardTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
  self.bankCardTextField.keyboardType = UIKeyboardTypeNumberPad;
  self.bankCardTextField.textColor = [Globle colorFromHexRGB:@"454545"];
  self.bankCardTextField.font = [UIFont systemFontOfSize:14];

  /// 设置充值的金额
  self.pay_money_label.text = [self.amount stringByAppendingString:@"元"];
}

- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {
  if ([string isEqualToString:@"\n"] && string.length == 0) {
    return YES;
  }
  NSString *toBeString =
      [textField.text stringByReplacingCharactersInRange:range
                                              withString:string];

  /// 判断姓名
  if (textField == self.nameTextField) {
    if ([toBeString length] > 16) {
      textField.text = [toBeString substringToIndex:16];
      return NO;
    }
  }

  /// 判断身份证输入框
  if (textField == self.idCardField) {
    /// 设定输入身份证号码
    if (![NSString validataIdCardNumberOnInput:[textField text]]) {
      return NO;
    }
    if ([toBeString length] > 18) {
      textField.text = [toBeString substringToIndex:18];
      return NO;
    }
  }
  /// 判断银行卡输入框
  if (textField == self.bankCardTextField) {
    /// 设定输入银行卡号码
    if (![NSString validataNumberInput:[textField text]]) {
      return NO;
    }
    if ([toBeString length] > 19) {
      textField.text = [toBeString substringToIndex:19];
      return NO;
    }
  }

  return YES;
}
#pragma mark---- 按钮点击响应函数 ----
/** 下一步的点击触发方法:发起连连支付请求*/
- (IBAction)clickNextStepPress:(id)sender {

  // 【1.姓名的真实性】
  [self checkRealNameAuthenticity];
}

/** 判断姓名的真实性 */
- (void)checkRealNameAuthenticity {
  if (self.nameTextField.text.length > 0) {
    if (self.nameTextField.text.length >= 2) {
      //判断内容的是否合法
      BOOL isNo = [WFRegularExpression
          judgmentFullNameLegitimacy:self.nameTextField.text
                withBankIdentityInfo:FullName];
      if (isNo == NO) {
        [NewShowLabel setMessageContent:@"请输入中文"];
        return;
      } else {
        //姓名正确 【2.判断银行卡的真实性】
        [self checkBankCardAuthenticity];
      }
    } else {
      [NewShowLabel setMessageContent:@"请填真实的姓名"];
      return;
    }
  } else {
    [NewShowLabel setMessageContent:@"姓名不能为空"];
  }
}
/** 判断银行卡的真实性 */
- (void)checkBankCardAuthenticity {
  if (self.bankCardTextField.text.length > 0) {
    //判断银行卡的位数
    BOOL isNo = [WFRegularExpression
        judgmentFullNameLegitimacy:self.bankCardTextField.text
              withBankIdentityInfo:BankCardNumber];
    if (isNo == NO) {
      [NewShowLabel setMessageContent:@"银行卡号输入有误," @"请"
                    @"重新填" @"写"];
      return;
    } else {
      //判断银行卡的真实性
      BOOL bankCardNo = [[WFRegularExpression shearRegularExpression]
          judgmentDetermineLegalityOfTheIdentityCardOfBankCards:
              self.bankCardTextField.text withBankIdentityInfo:BankCardNumber];
      if (bankCardNo == NO) {
        [NewShowLabel setMessageContent:@"请填写正确的银行卡号"];
        return;
      } else {
        //银行卡正确 【3.判断身份证】
        [self checkIdCardAuthenticity];
      }
    }
  } else {
    [NewShowLabel setMessageContent:@"银行卡号不能为空"];
  }
}
/** 判断身份证的真实性 */
- (void)checkIdCardAuthenticity {
  if (self.idCardField.text.length > 0) {
    //判断身份证位数的合法性
    BOOL isNo =
        [WFRegularExpression judgmentFullNameLegitimacy:self.idCardField.text
                                   withBankIdentityInfo:IdentityCardNumber];
    if (isNo == NO) {
      [NewShowLabel setMessageContent:@"身份证号输入有误," @"请"
                    @"重新填" @"写"];
      return;
    } else {
      //身份证的有效性
      BOOL idnetityNo = [[WFRegularExpression shearRegularExpression]
          judgmentDetermineLegalityOfTheIdentityCardOfBankCards:
              self.idCardField.text withBankIdentityInfo:IdentityCardNumber];
      if (idnetityNo == NO) {
        [NewShowLabel setMessageContent:@"请填写正确的身份证号"];
        return;
      } else {
        //请求连连支付
        [self getPayOrderParametersList];
      }
    }
  } else {
    [NewShowLabel setMessageContent:@"身份证号不能为空"];
  }
}

#pragma mark - 1.10获取订单支付参数列表
/** 1.10 获取订单支付参数的网络数据解析 */
- (void)getPayOrderParametersList {
  [NetLoadingWaitView startAnimating];
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    [NetLoadingWaitView stopAnimating];
    return;
  }
  HttpRequestCallBack *callBack = [[HttpRequestCallBack alloc] init];
  __weak WFLianLianPayBindInfoViewController *weakSelf = self;
  callBack.onCheckQuitOrStopProgressBar = ^{
    WFLianLianPayBindInfoViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [NetLoadingWaitView stopAnimating];
      return NO;
    } else {
      return YES;
    }
  };
  callBack.onSuccess = ^(NSObject *obj) {
    WFLianLianPayBindInfoViewController *strongSelf = weakSelf;
    if (strongSelf) {
      WFGetLianLianPaymentOrder *getPaymentOrder =
          (WFGetLianLianPaymentOrder *)obj;
      [strongSelf.llPaySdk
          presentPaySdkInViewController:strongSelf
                         withTraderInfo:[LianLianPay
                                            createLianLianOrderWithParameter:getPaymentOrder]];
      //进行网络请求后，清空充值页面的输入框内容
      if (strongSelf.paySuccess) {
        strongSelf.paySuccess(YES);
      }
    }
  };

  [WFAccountInterface
      getPayOrderParametersWithOrder_no:self.orderNo
                              withId_no:self.idCardField.text
                           withAgree_no:@""
                          withAcct_name:self.nameTextField.text
                            withCard_no:self.bankCardTextField.text
                            withChannel:@"2"
                           withCallback:callBack];
}

/** 隐藏键盘 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  /** 使键盘消失 */
  [self.view endEditing:YES];
}

- (void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary *)dic {
  if (resultCode == kLLPayResultSuccess) {
    [NewShowLabel setMessageContent:@"支付成功"];
    [NetLoadingWaitView stopAnimating];
    [self leftButtonPress];
  } else if (resultCode == kLLPayResultFail) {
    [NewShowLabel setMessageContent:@"支付失败"];
  } else if (resultCode == kLLPayResultCancel) {
    [NewShowLabel setMessageContent:@"支付取消"];
  }
  [NetLoadingWaitView stopAnimating];
}

/** “支持银行列表”触发的方法 */
- (IBAction)clicklookAtSupportBankList:(id)sender {

  [SchollWebViewController startWithTitle:@"支持银行列表"
                                  withUrl:@"http://www.youguu.com/opms/html/"
                                          @"article/32/2015/0513/2702.html"];
}

@end
