//
//  RechargeAccountViewController.m
//  SimuStock
//
//  Created by Jhss on 15/4/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "RechargeAccountViewController.h"
#import "AppDelegate.h"
#import "SimuUtil.h"
#import "WFLianLianPayBindInfoViewController.h"
#import "WFLianLianPayViewController.h"
#import "NetLoadingWaitView.h"
#import "SchollWebViewController.h"
#import "RechargeViewController.h"
#import "BoundBankCardPaymentDetailsVC.h"
#import "InputTextFieldView.h"
#import "WFAccountInterface.h"
/** 通联支付 */
#import "AllInPay.h"
#import "APay.h"
/** 微信支付 */
/** 数据签名，易宝支付使用 */

#define PayChannelBtnHeight 46.0f

@interface RechargeAccountViewController () <APayDelegate, WXApiDelegate>

@end

@implementation RechargeAccountViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  /// 显示账户充值
  [_topToolBar resetContentAndFlage:@"账户充值" Mode:TTBM_Mode_Leveltwo];
  self.clientView.alpha = 0;

  self.payTipDicM = [NSMutableDictionary dictionary];
  self.openLinkDicM = [NSMutableDictionary dictionary];

  /// 判断当前网络状态
  [self isNetwork];
  /// 设置金额输入框,(数字键盘，不能含有小数点)
  [self settingPayCountTextTFStyle];

  self.channel = @"0";

  [self setupPayChannelBtn];
  [self refreshButtonPressDown];
}

/** 判断当前网络状态 */
- (void)isNetwork {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
  }
}

/** 设置金额输入框,(数字键盘，不能含有小数点) */
- (void)settingPayCountTextTFStyle {
  self.payCountTextTF.inputType = INPUTE_TYPE_INTEGER_NUMBER;
  self.payCountTextTF.numberOfIntegerPlaces = 7;
  self.payCountTextTF.inputTextField.font =
      [UIFont systemFontOfSize:Font_Height_14_0];
  self.payCountTextTF.inputTextField.textAlignment = NSTextAlignmentLeft;
  self.payCountTextTF.inputTextField.borderStyle = UITextBorderStyleNone;
  self.payCountTextTF.inputTextField.placeholder = @"请输入充值金额";
  self.payCountTextTF.inputTextField.textColor =
      [Globle colorFromHexRGB:@"454545"];
  [self.payCountTextTF.inputTextField
        setValue:[Globle colorFromHexRGB:Color_Text_Details alpha:1]
      forKeyPath:@"_placeholderLabel.textColor"];
}

/** 清除页面所有渠道的支付按钮 */
- (void)clearPayChannelBtn {
  [self.payChannelBtnArray
      enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
        NSLayoutConstraint *payBtnTop =
            (NSLayoutConstraint *)self.payBtnTopArray[idx];
        payBtnTop.constant = 0;
        obj.hidden = YES;
        UILabel *tempLabel = self.recommendLableArray[idx];
        tempLabel.hidden = YES;
      }];
  [self.payTipDicM removeAllObjects];
  [self.openLinkDicM removeAllObjects];
}

/** 重置所有渠道的支付按钮 */
- (void)resetPayChannelBtn {
  [self clearPayChannelBtn];
  if (self.payChannelList.channelListArray) {
    [self.payChannelList.channelListArray
        enumerateObjectsUsingBlock:^(WFInquirePayChannel *obj, NSUInteger idx,
                                     BOOL *stop) {
          UIButton *channelBtn = self.payChannelBtnArray[obj.channel - 1];
          NSLayoutConstraint *payBtnTop =
              (NSLayoutConstraint *)self.payBtnTopArray[obj.channel - 1];
          payBtnTop.constant = PayChannelBtnHeight * idx;
          channelBtn.hidden = NO;
          if (obj.openLink) {
            [self.openLinkDicM setObject:obj.openLink forKey:@(obj.channel)];
          }
          if (obj.payTips) {
            [self.payTipDicM setObject:obj.payTips forKey:@(obj.channel)];
          }
          if (obj.isRecommend) {
            UILabel *tempLabel = self.recommendLableArray[obj.channel - 1];
            tempLabel.hidden = NO;
          }
        }];
  }
}

- (void)setupPayChannelBtn {
  [self.payChannelBtnArray
      enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL *stop) {
        obj.hidden = YES;
        [obj setBackgroundImage:[SimuUtil imageFromColor:Color_BG_Common]
                       forState:UIControlStateHighlighted];
        switch (idx + 1) {
        case 1:
          [obj addTarget:self
                        action:@selector(clickAllInPayBtnPress:)
              forControlEvents:UIControlEventTouchUpInside];
          break;
        case 2:
          [obj addTarget:self
                        action:@selector(clickLianLianPayBtnPress:)
              forControlEvents:UIControlEventTouchUpInside];
          break;
        case 3:
          [obj addTarget:self
                        action:@selector(clickYeePayBtnPress:)
              forControlEvents:UIControlEventTouchUpInside];
          break;
        case 4:
          [obj addTarget:self
                        action:@selector(clickWeiXinPayBtnPress:)
              forControlEvents:UIControlEventTouchUpInside];
          break;
        case 5:
          [obj addTarget:self
                        action:@selector(clickALiPayBtnPress:)
              forControlEvents:UIControlEventTouchUpInside];
          break;
        default:
          break;
        }
      }];
}

/** 通联支付，点击跳转通联支付 */
- (void)clickAllInPayBtnPress:(id)sender {
  /// 隐藏键盘
  [self.payCountTextTF.inputTextField resignFirstResponder];
  /// 判断网络
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
  } else {
    if (self.payCountTextTF.inputTextField.text.length > 0) {
      /// 调用接口。进行充值(先获取订单号然后获取订单支付参数，最后跳转通联SDK)
      [self loadAnimating];
      self.channel = @"1";
      [self clickToPrepaidPhoneApplication];
    } else {
      [NewShowLabel setMessageContent:@"请先输入充值金额"];
    }
  }
}

/** 连连支付，点击跳转连连支付 */
- (void)clickLianLianPayBtnPress:(id)sender {

  /// 隐藏键盘
  [self.payCountTextTF.inputTextField resignFirstResponder];
  /// 判断网络
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
  } else {
    if (self.payCountTextTF.inputTextField.text.length > 0) {
      /// 调用接口。进行充值(先获取订单号然后判断是否绑定银行卡)
      [self loadAnimating];
      self.channel = @"2";
      [self clickToPrepaidPhoneApplication];
    } else {
      [NewShowLabel setMessageContent:@"请先输入充值金额"];
    }
  }
}

/** 易宝支付，点击跳转易宝支付 */
- (void)clickYeePayBtnPress:(id)sender {
  /// 隐藏键盘
  [self.payCountTextTF.inputTextField resignFirstResponder];
  /// 判断网络
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
  } else {
    if (self.payCountTextTF.inputTextField.text.length > 0) {
      /// 调用接口。进行充值(先获取订单号然后获取订单支付参数，最后跳转通联SDK)
      [self loadAnimating];
      self.channel = @"3";
      [self clickToPrepaidPhoneApplication];
    } else {
      [NewShowLabel setMessageContent:@"请先输入充值金额"];
    }
  }
}

/** 微信支付，点击跳转微信支付 */
- (void)clickWeiXinPayBtnPress:(id)sender {
  /// 隐藏键盘
  [self.payCountTextTF.inputTextField resignFirstResponder];
  /// 判断网络
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
  } else {
    if (self.payCountTextTF.inputTextField.text.length > 0) {
      /// 调用接口。进行充值(先获取订单号然后获取订单支付参数，最后跳转微信)
      [self loadAnimating];
      if ([WXApi isWXAppInstalled]) {
        self.channel = @"4";
        [self clickToPrepaidPhoneApplication];
      } else {
        [self clearAction];
        [NewShowLabel setMessageContent:@"安" @"装" @"微"
                      @"信才可使用微信支付"];
      }
    } else {
      [NewShowLabel setMessageContent:@"请先输入充值金额"];
    }
  }
}

/** 支付宝线下支付，点击跳转支付宝线下支付说明Web页 */
- (void)clickALiPayBtnPress:(id)sender {
  NSString *url = self.openLinkDicM[@5];
  [SchollWebViewController startWithTitle:@"支付宝线下转账" withUrl:url];
}

/** 查询支付渠道列表 */
- (void)inquirePayChannelList {
  [self.indicatorView startAnimating];

  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    [self.indicatorView stopAnimating];
    return;
  }
  HttpRequestCallBack *callBack = [[HttpRequestCallBack alloc] init];
  __weak RechargeAccountViewController *weakSelf = self;
  callBack.onCheckQuitOrStopProgressBar = ^{
    RechargeAccountViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [self.indicatorView stopAnimating];
      return NO;
    } else {
      return YES;
    }
  };
  callBack.onSuccess = ^(NSObject *obj) {
    RechargeAccountViewController *strongSelf = weakSelf;
    if (strongSelf) {
      strongSelf.payChannelList = (WFInquirePayChannelList *)obj;
      [strongSelf resetPayChannelBtn];
    }
  };
  [WFAccountInterface inquirePaychannelsListWithParameter:self.payChannelRequest
                                             WithCallBack:callBack];
}

#pragma mark - 判断是否绑定银行卡
/** 判断是否绑定银行卡 */
- (void)checkPayIsBindBankCardRequest {
  [self loadAnimating];

  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    [self clearAction];
    return;
  }
  HttpRequestCallBack *callBack = [[HttpRequestCallBack alloc] init];
  __weak RechargeAccountViewController *weakSelf = self;
  callBack.onCheckQuitOrStopProgressBar = ^{
    RechargeAccountViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [self clearAction];
      return NO;
    } else {
      return YES;
    }
  };
  callBack.onSuccess = ^(NSObject *obj) {
    RechargeAccountViewController *strongSelf = weakSelf;
    if (strongSelf) {
      if ([strongSelf.channel isEqualToString:@"3"]) {
        /// 易宝支付
        WFBindedBankcardYeePayResult *result =
            (WFBindedBankcardYeePayResult *)obj;
        [strongSelf yeePayInquireWFBindedBankcardResult:result];
      } else if ([strongSelf.channel isEqualToString:@"2"]) {
        /// 连连支付
        WFBindedBankcardLianLianPayResult *result =
            (WFBindedBankcardLianLianPayResult *)obj;
        [strongSelf lianLianPayInquireWFBindedBankcardResult:result];
      }
    }
  };
  [WFAccountInterface inquireWFBindedBankcardWithChannel:self.channel
                                            WithCallback:callBack];
}

/** 易宝支付是否绑定银行卡处理 */
- (void)yeePayInquireWFBindedBankcardResult:
    (WFBindedBankcardYeePayResult *)result {
  if (result.isbind == NO) {
    /// 首次支付，跳转输入银行卡界面
    [AppDelegate pushViewControllerFromRight:
                     [[RechargeViewController alloc]
                         initWithAmount:self.payCountTextTF.inputTextField.text
                             andOrderNo:self.order_no
                             andPayTips:self.payTipDicM[@3]]];
  } else {
    //加入非首次支付的***易宝支付（短信验证模式）***请求
    self.card_top = result.card_top;
    self.card_last = result.card_last;
    [self sendSmsPayRequest:result];
  }
}

/** 调用接口，发送验证码 */
- (void)sendSmsPayRequest:(WFBindedBankcardYeePayResult *)result {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel setMessageContent:REQUEST_FAILED_MESSAGE];
    return;
  }
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  //解析
  __weak RechargeAccountViewController *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    RechargeAccountViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [self clearAction];
      return NO;
    } else {
      return YES;
    }
  };
  callback.onSuccess = ^(NSObject *obj) {
    RechargeAccountViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [AppDelegate
          pushViewControllerFromRight:
              [[BoundBankCardPaymentDetailsVC alloc]
                  initWithAmount:self.payCountTextTF.inputTextField.text
                      andOrderNo:self.order_no
                      andPayTips:self.payTipDicM[@3]
                       andResult:result]];
    }
  };

  callback.onError = ^(BaseRequestObject *obj, NSException *exc) {
    RechargeAccountViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [self clearAction];
      [BaseRequester defaultErrorHandler];
    }
  };
  callback.onFailed = ^{
    RechargeAccountViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [self clearAction];
      [BaseRequester defaultFailedHandler];
    }
  };

  NSDictionary *yeePayContent = @{
    @"orderNo" : self.order_no,
    @"cardLast" : self.card_last,
    @"cardTop" : self.card_top,
    @"userIp" : @"127.0.0.1",
  };
  self.bindPaymentSMSPayParameter.order_no = yeePayContent[@"orderNo"];
  self.bindPaymentSMSPayParameter.card_last = yeePayContent[@"cardLast"];
  self.bindPaymentSMSPayParameter.card_top = yeePayContent[@"cardTop"];
  self.bindPaymentSMSPayParameter.user_ip = yeePayContent[@"userIp"];

  /// 获取验证码请求。
  [WFAccountInterface WFYeePaySMSPayWithRequest:self.bindPaymentSMSPayParameter
                                   WithCallBack:callback];
}

/** 连连支付是否绑定银行卡处理 */
- (void)lianLianPayInquireWFBindedBankcardResult:
    (WFBindedBankcardLianLianPayResult *)result {
  if (result.isbind == NO) {
    /// 首次支付
    WFLianLianPayBindInfoViewController *LLPayBindInfoVC =
        [[WFLianLianPayBindInfoViewController alloc]
            initWithOrderNo:self.order_no
                  andAmount:self.payCountTextTF.inputTextField.text];
    [AppDelegate pushViewControllerFromRight:LLPayBindInfoVC];
    LLPayBindInfoVC.paySuccess = ^(BOOL success) {
      if (success == YES) {
        self.payCountTextTF.inputTextField.text = @"";
      }
    };

  } else {
    /// 非首次支付
    WFLianLianPayViewController *llPayVC = [[WFLianLianPayViewController alloc]
        initWithBindCardInfoData:result
                     WithOrderNo:self.order_no
                       andAmount:self.payCountTextTF.inputTextField.text];
    [AppDelegate pushViewControllerFromRight:llPayVC];
    llPayVC.paySuccess = ^(BOOL success) {
      if (success == YES) {
        self.payCountTextTF.inputTextField.text = @"";
      }
    };
  }
}

#pragma mark - 1.3账户充值
/** 1.3账户充值的网络，解析获得订单号(order_no) */
- (void)clickToPrepaidPhoneApplication {
  [self loadAnimating];

  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    [self clearAction];
    return;
  }
  HttpRequestCallBack *callBack = [[HttpRequestCallBack alloc] init];
  __weak RechargeAccountViewController *weakSelf = self;
  callBack.onSuccess = ^(NSObject *obj) {
    RechargeAccountViewController *strongSelf = weakSelf;
    if (strongSelf) {
      WFPayAccountResult *payaccountResclt = (WFPayAccountResult *)obj;
      [strongSelf bindData:payaccountResclt];
      if ([strongSelf.channel isEqualToString:@"1"]) {
        [strongSelf getPayOrderParametersList];
      } else if ([strongSelf.channel isEqualToString:@"2"]) {
        [strongSelf checkPayIsBindBankCardRequest];
      } else if ([strongSelf.channel isEqualToString:@"3"]) {
        [strongSelf checkPayIsBindBankCardRequest];
      } else if ([strongSelf.channel isEqualToString:@"4"]) {
        [strongSelf getPayOrderParametersList];
      }
    }
  };
  callBack.onError = ^(BaseRequestObject *obj, NSException *exc) {
    RechargeAccountViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [self clearAction];
      [BaseRequester defaultErrorHandler];
    }
  };
  callBack.onFailed = ^{
    RechargeAccountViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [self clearAction];
      [BaseRequester defaultFailedHandler];
    }
  };
  /// 获取输入框中输入的金额（以元为单位）并且将输入框的金额转换为以分为单位
  NSString *rechargeMoney =
      [self.payCountTextTF.inputTextField.text stringByAppendingString:@"00"];
  [WFAccountInterface accountsPrepaidWithAmount:rechargeMoney
                                     andChannel:self.channel
                                    andCallback:callBack];
}

/** 1.10 获取订单支付参数的网络数据解析 */
- (void)getPayOrderParametersList {
  [self loadAnimating];
  if (![SimuUtil isExistNetwork]) {
    [self clearAction];
    return;
  }
  HttpRequestCallBack *callBack = [[HttpRequestCallBack alloc] init];
  __weak RechargeAccountViewController *weakSelf = self;

  callBack.onSuccess = ^(NSObject *obj) {
    RechargeAccountViewController *strongSelf = weakSelf;
    if (strongSelf) {
      if ([strongSelf.channel isEqualToString:@"1"]) {
        WFAllInPaymentPayData *getPaymentOrder = (WFAllInPaymentPayData *)obj;
        NSString *payParameter =
            [AllInPay makePaaWithParameter:getPaymentOrder];
        [strongSelf clearAction];
        [APay startPay:payParameter
            viewController:strongSelf
                  delegate:strongSelf
                      mode:@"00"];
      } else if ([strongSelf.channel isEqualToString:@"4"]) {
        WFWeiXinPaymentPayData *getPaymentOrder = (WFWeiXinPaymentPayData *)obj;
        if ([WXApi registerApp:getPaymentOrder.appid]) {
          PayReq *weiXinPayRequest = [[PayReq alloc] init];
          weiXinPayRequest.partnerId = getPaymentOrder.partnerid;
          weiXinPayRequest.prepayId = getPaymentOrder.prepayId;
          weiXinPayRequest.package = getPaymentOrder.packageValue;
          weiXinPayRequest.nonceStr = getPaymentOrder.noncestr;
          weiXinPayRequest.timeStamp =
              (unsigned int)[getPaymentOrder.timestamp longLongValue];
          weiXinPayRequest.sign = getPaymentOrder.sign;
          [strongSelf clearAction];
          [WXApi sendReq:weiXinPayRequest];
        } else {
          [strongSelf clearAction];
          [NewShowLabel setMessageContent:@"暂时不可使用微信支付"];
        }
      }
    }
  };

  callBack.onError = ^(BaseRequestObject *obj, NSException *exc) {
    RechargeAccountViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [self clearAction];
      [BaseRequester defaultErrorHandler];
    }
  };
  callBack.onFailed = ^{
    RechargeAccountViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [self clearAction];
      [BaseRequester defaultFailedHandler];
    }
  };

  [WFAccountInterface getPayOrderParametersWithOrder_no:self.order_no
                                              withId_no:@""
                                           withAgree_no:@""
                                          withAcct_name:@""
                                            withCard_no:@""
                                            withChannel:self.channel
                                           withCallback:callBack];
}

/** 绑定1.3解析出来的订单号 */
- (void)bindData:(WFPayAccountResult *)payaccountResclt {
  if (payaccountResclt) {
    //账户充值的订单号
    self.order_no = payaccountResclt.order_no;
  }
}

/** 网络结束的处理 */
- (void)clearAction {
  [NetLoadingWaitView stopAnimating];
  [self.indicatorView stopAnimating];
}

/** 网络结束的处理 */
- (void)loadAnimating {
  [NetLoadingWaitView startAnimating];
  [self.indicatorView startAnimating];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  /// 使键盘消失
  [self.payCountTextTF.inputTextField resignFirstResponder];
}

#pragma-- - 通联支付代理实现-- -
/** 通联支付代理实现 */
- (void)APayResult:(NSString *)result {
  if (result == nil) {
    return;
  }

  result = [result stringByReplacingOccurrencesOfString:@"\n" withString:@""];
  result = [result stringByReplacingOccurrencesOfString:@"\r" withString:@""];
  result = [result stringByReplacingOccurrencesOfString:@"\t" withString:@""];
  result = [result stringByReplacingOccurrencesOfString:@" " withString:@""];
  result =
      [result stringByReplacingOccurrencesOfString:@"result=" withString:@""];

  NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
  NSError *err;
  NSDictionary *dic =
      [NSJSONSerialization JSONObjectWithData:jsonData
                                      options:NSJSONReadingMutableContainers
                                        error:&err];
  if (err || dic == nil) {
    return;
  }

  NSString *payResult = dic[@"payResult"];
  if ([payResult isEqualToString:@"0"]) {
    //请求通联支付之后清空输入框的内容
    self.payCountTextTF.inputTextField.text = @"";
    [NetLoadingWaitView stopAnimating];
  }
}

/** 微信支付结果回调 */
- (void)onResp:(BaseResp *)resp {
  if ([resp isKindOfClass:[PayResp class]]) {
    PayResp *response = (PayResp *)resp;
    switch (response.errCode) {
    case WXSuccess:
      //服务器端查询支付通知或查询API返回的结果再提示成功
      [NewShowLabel setMessageContent:@"支付成功"];
      break;
    default:
      [NewShowLabel setMessageContent:@"支付失败"];
      NSLog(@"支付失败， retcode=%d", resp.errCode);
      break;
    }
  }
}
- (WFYeePaymentSMSPayRequest *)bindPaymentSMSPayParameter {
  if (_bindPaymentSMSPayParameter == nil) {
    _bindPaymentSMSPayParameter = [[WFYeePaymentSMSPayRequest alloc] init];
  }
  return _bindPaymentSMSPayParameter;
}
- (void)refreshButtonPressDown {
  [self inquirePayChannelList];
}

- (WFInquirePayChannelListRequest *)payChannelRequest {
  if (!_payChannelRequest) {
    _payChannelRequest = [[WFInquirePayChannelListRequest alloc] init];
    _payChannelRequest.os_type = @"1";
    _payChannelRequest.type = @"1";
  }
  return _payChannelRequest;
}

@end
