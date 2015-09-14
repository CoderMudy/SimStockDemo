//
//  WFLianLianPayViewController.m
//  SimuStock
//
//  Created by jhss_wyz on 15/5/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "WFLianLianPayViewController.h"
#import "WFAccountInterface.h"
#import "UIImageView+WebCache.h"
#import "LLPaySdk.h"
#import "LianLianPay.h"
#import "NetLoadingWaitView.h"

@interface WFLianLianPayViewController () <LLPaySdkDelegate>

/** 订单号 */
@property(copy, nonatomic) NSString *orderNo;
/** 充值金额（单位：元） */
@property(copy, nonatomic) NSString *amount;
/** 绑定的银行卡信息 */
@property(strong, nonatomic) WFBindedBankcardLianLianPayResult *bankInfoData;

/** 连连支付 */
@property(strong, nonatomic) LLPaySdk *llPaySdk;

@end

@implementation WFLianLianPayViewController

- (instancetype)initWithBindCardInfoData:(WFBindedBankcardLianLianPayResult *)bankInfoData
                             WithOrderNo:(NSString *)orderNo
                               andAmount:(NSString *)amount {
  if (self = [super init]) {
    self.bankInfoData = bankInfoData;
    self.orderNo = orderNo;
    self.amount = amount;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.llPaySdk = [[LLPaySdk alloc] init];
  self.llPaySdk.sdkDelegate = self;
  [self bindBankCardInfoDataAndRechargeMoney];
}

/** 页面信息显示 */
- (void)bindBankCardInfoDataAndRechargeMoney {
  //显示标题"支付"；隐藏刷新按钮；去掉上层的视图(clientView)
  [_topToolBar resetContentAndFlage:@"支付" Mode:TTBM_Mode_Leveltwo];
  _indicatorView.hidden = YES;
  self.clientView.alpha = 0;

  self.amountLabel.text = [self.amount stringByAppendingString:@"元"];
  self.bankNameLabel.text = self.bankInfoData.bank_name;
  self.bankTailNumber.text = [NSString
      stringWithFormat:@"尾号为%@的卡", self.bankInfoData.card_no];
  [self.bankLogoImageView
      setImageWithURL:[NSURL URLWithString:self.bankInfoData.bank_logo]];
}

/** 点击调用获取订单号的网络申请，进行支付操作 */
- (IBAction)clickBankThenPaymentMethod:(id)sender {
  if (![SimuUtil isExistNetwork]) {
    //无网络
    [NewShowLabel showNoNetworkTip];
  } else {
    //有网络,进行网络请求
    [self getPayOrderParametersList];
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
  __weak WFLianLianPayViewController *weakSelf = self;
  callBack.onCheckQuitOrStopProgressBar = ^{
    WFLianLianPayViewController *strongSelf = weakSelf;
    if (strongSelf) {
      [NetLoadingWaitView stopAnimating];
      return NO;
    } else {
      return YES;
    }
  };
  callBack.onSuccess = ^(NSObject *obj) {
    WFLianLianPayViewController *strongSelf = weakSelf;
    if (strongSelf) {
      WFGetLianLianPaymentOrder *getPaymentOrder =
          (WFGetLianLianPaymentOrder *)obj;
      [self.llPaySdk
          presentPaySdkInViewController:self
                         withTraderInfo:[LianLianPay
                                            createLianLianOrderWithParameter:
                                                getPaymentOrder]];
    }
  };

  [WFAccountInterface
      getPayOrderParametersWithOrder_no:self.orderNo
                              withId_no:@""
                           withAgree_no:self.bankInfoData.no_agree
                          withAcct_name:@""
                            withCard_no:@""
                            withChannel:@"2"
                           withCallback:callBack];
}

- (void)paymentEnd:(LLPayResult)resultCode withResultDic:(NSDictionary *)dic {
  if (resultCode == kLLPayResultSuccess) {
    [NewShowLabel setMessageContent:@"支付成功"];
    //进行网络请求后，清空充值页面的输入框内容
    if (self.paySuccess) {
      self.paySuccess(YES);
    }
    [NetLoadingWaitView stopAnimating];
    [self leftButtonPress];
  } else if (resultCode == kLLPayResultFail) {
    [NewShowLabel setMessageContent:@"支付失败"];
  } else if (resultCode == kLLPayResultCancel) {
    [NewShowLabel setMessageContent:@"支付取消"];
  }
  [NetLoadingWaitView stopAnimating];
}

@end
