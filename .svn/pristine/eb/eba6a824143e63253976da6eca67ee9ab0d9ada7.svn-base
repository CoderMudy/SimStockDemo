//
//  RechargeViewController.m
//  SimuStock
//
//  Created by jhss on 15/6/4.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "RechargeViewController.h"
#import "SchollWebViewController.h"
#import "UIButton+Hightlighted.h"
#import "WFRegularExpression.h"
#import "NewShowLabel.h"
#import "NetLoadingWaitView.h"
#import "WFAccountInterface.h"
#import "PaymentDetailsViewController.h"
#import "NSString+validate.h"
#import "CutomerServiceButton.h"

@implementation RechargeViewController

- (instancetype)initWithAmount:(NSString *)amount
                    andOrderNo:(NSString *)orderNo
                    andPayTips:(NSString *)payTips {
  self = [super init];
  if (self) {
    self.amount = amount;
    self.orderNo = orderNo;
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
  _clientView.alpha = 0;
  self.indicatorView.hidden = YES;
  //设置右上角“客服热线”按钮
  [[CutomerServiceButton shareDataCenter]
      establisthCustomerServiceTelephonetopToolBar:_topToolBar
                                     indicatorView:_indicatorView
                                              hide:YES];
  ///设置支持银行列表的高亮状态
  [self.bankListBtn buttonWithTitle:@"支持银行列表"
                 andNormaltextcolor:Color_Blue_but
           andHightlightedTextColor:Color_Blue_butDown];
  [self.nextStepBtn buttonWithNormal:Color_WFOrange_btn
                andHightlightedColor:Color_WFOrange_btnDown];
  [self.nextStepBtn buttonWithTitle:@"下一步"
                 andNormaltextcolor:Color_White
           andHightlightedTextColor:Color_White];
  self.nextStepBtn.layer.cornerRadius = self.nextStepBtn.bounds.size.height / 2;
  self.nextStepBtn.layer.masksToBounds = YES;

  /// 银行卡输入框
  self.bankCardTextField.delegate = self;

  /// 设置充值的金额
  self.payMoneyLab.text = self.amount;
}

- (IBAction)clickSupportBankListBtn:(BGColorUIButton *)sender {
  ///跳转的web链接待定
  [SchollWebViewController
      startWithTitle:@"支持银行列表"
             withUrl:@"http://m.youguu.com/mobile/other/html/banklist.html"];
}

- (IBAction)clickNextStepBtn:(BGColorUIButton *)sender {
  if ([self checkBankCardAuthenticity]) {
    /// 客户端判断银行卡合法，发起网络请求，后台判断银行卡是否可用
    [self getYeePayCardBinRequest];
  } else {
    /// 客户端判断银行卡非法，不进行后续处理
    return;
  }
}

/** 判断银行卡的真实性 */
- (BOOL)checkBankCardAuthenticity {
  if (self.bankCardTextField.text.length > 0) {
    //判断银行卡的位数
    BOOL isNo = [WFRegularExpression
        judgmentFullNameLegitimacy:self.bankCardTextField.text
              withBankIdentityInfo:BankCardNumber];
    if (isNo == NO) {
      [NewShowLabel setMessageContent:@"银行卡号输入有误," @"请"
                    @"重新填" @"写"];
      return NO;
    } else {
      //判断银行卡的真实性
      BOOL bankCardNo = [[WFRegularExpression shearRegularExpression]
          judgmentDetermineLegalityOfTheIdentityCardOfBankCards:
              self.bankCardTextField.text withBankIdentityInfo:BankCardNumber];
      if (bankCardNo == NO) {
        [NewShowLabel setMessageContent:@"银行卡信息填写有误"];
        return NO;
      } else {
        return YES;
      }
    }
  } else {
    [NewShowLabel setMessageContent:@"请输入银行卡号"];
    return NO;
  }
  return NO;
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
  /// 判断银行卡输入
  if (textField == self.bankCardTextField) {
    if (![NSString validataNumberInput:toBeString]) {
      return NO;
    }
    if ([toBeString length] > 19) {
      textField.text = [toBeString substringToIndex:19];
      return NO;
    }
  }

  return YES;
}

//收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [_bankCardTextField resignFirstResponder];
}

#pragma mark-----  网络请求  -----
/** 易宝支付判断银行卡是否合法可用 */
- (void)getYeePayCardBinRequest {
  [NetLoadingWaitView startAnimating];

  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    [self clearAction];
    return;
  }

  HttpRequestCallBack *callBack = [[HttpRequestCallBack alloc] init];
  __weak RechargeViewController *weakSelf = self;
  callBack.onCheckQuitOrStopProgressBar = ^{
    RechargeViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [self clearAction];
      return NO;
    } else {
      return YES;
    }
  };

  callBack.onSuccess = ^(NSObject *obj) {
    RechargeViewController *strongSelf = weakSelf;
    if (strongSelf) {
      strongSelf.bankCardInfo = (WFYeePaymentCardBinRequestResult *)obj;
      if (strongSelf.bankCardInfo) {
        if (strongSelf.bankCardInfo.isvalid) {
          if (strongSelf.bankCardInfo.support) {
            /// 银行卡合法且易宝支付支持该银行卡，发起网络请求获取支付token
            [strongSelf getYeePayTokenRequest];
          } else {
            [strongSelf clearAction];
            NSString *tempStr = [NSString
                stringWithFormat:@"易宝支付暂不支持%@%@",
                                 strongSelf.bankCardInfo.bankname,
                                 (strongSelf.bankCardInfo.cardtype == 1
                                      ? @"储蓄卡"
                                      : @"信用卡")];
            [NewShowLabel setMessageContent:tempStr];
          }
        } else {
          [strongSelf clearAction];
          [NewShowLabel setMessageContent:@"请填写正确的银行卡号"];
        }
      } else {
        [strongSelf clearAction];
      }
    }
  };

  [WFAccountInterface WFYeePaymentCardBinWithCardNo:self.bankCardTextField.text
                                       WithCallBack:callBack];
}

/** 易宝支付获取支付token */
- (void)getYeePayTokenRequest {
  [NetLoadingWaitView startAnimating];

  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    [self clearAction];
    return;
  }

  HttpRequestCallBack *callBack = [[HttpRequestCallBack alloc] init];
  __weak RechargeViewController *weakSelf = self;
  callBack.onCheckQuitOrStopProgressBar = ^{
    RechargeViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [self clearAction];
      return NO;
    } else {
      return YES;
    }
  };

  callBack.onSuccess = ^(NSObject *obj) {
    RechargeViewController *strongSelf = weakSelf;
    WFYeePayGetTokenRequestResult *result =
        (WFYeePayGetTokenRequestResult *)obj;
    if (strongSelf) {
      strongSelf.token = result.token;
      /// 跳转易宝支付绑定银行卡界面
      [AppDelegate pushViewControllerFromRight:
                       [[PaymentDetailsViewController alloc]
                            initWithAmount:strongSelf.amount
                                andOrderNo:strongSelf.orderNo
                                  andToken:result.token
                             andBankCardNo:strongSelf.bankCardTextField.text
                                andPayTips:self.payTips
                           andBandCardInfo:strongSelf.bankCardInfo]];
    }
  };

  [WFAccountInterface WFYeePayGetTokenWithCallBack:callBack];
}

- (void)clearAction {
  [NetLoadingWaitView stopAnimating];
}

@end
