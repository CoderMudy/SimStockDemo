//
//  PanicBuyingView.m
//  SimuStock
//
//  Created by 刘小龙 on 15/7/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "PanicBuyingView.h"
#import "ProcessInputData.h"
#import "CPBuyCattlePlanData.h"
#import "NetLoadingWaitView.h"
#import "WeiboToolTip.h"
#import "RechargeAccountViewController.h"
#import "UIButton+Hightlighted.h"
#import "ExpertPlanConst.h"

@interface PanicBuyingView () {
  ProductSaleState _productState;
  RolePerspectiveState _state;
}

@end

@implementation PanicBuyingView

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (PanicBuyingView *)createPanicBuyingView {
  NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PanicBuyingView"
                                                 owner:nil
                                               options:nil];
  return [array lastObject];
}

- (void)awakeFromNib {
  [self.buyBtn buttonWithNormal:Color_Blue_but
           andHightlightedColor:Color_Blue_butDown];
  [self.buyBtn setTitleColor:[Globle colorFromHexRGB:Color_White]
                    forState:UIControlStateNormal];
  [self.buyBtn setTitleColor:[Globle colorFromHexRGB:Color_White]
                    forState:UIControlStateHighlighted];

  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(loginThenRefreshSuccess)
             name:Notification_CP_BuyPlan_RefreshSuccess
           object:nil];
}

- (void)loginThenRefreshSuccess {
  [self clickOnBuyBtn:self.buyBtn];
}

- (void)bingDataForPanicBuying:(NSDictionary *)dic {
  if (dic.count == 0) {
    return;
  }
  self.accountId = dic[@"accountID"];
  self.targetUid = [dic[@"targetUid"] stringValue];
  _state = [dic[@"userState"] integerValue];
  /// 追踪价格
  self.priceStr = [dic[@"trackPrice"] stringValue];
  if (self.priceStr && ![self.priceStr isEqualToString:@"0"]) {
    self.priceStr = [self.priceStr stringByAppendingString:@"00"];
  }
  self.tractPriceLabel.text =
      [[dic[@"trackPrice"] stringValue] stringByAppendingString:@"元"];
  /// 状态
  _productState = [dic[@"itemState"] integerValue];
  if (_productState == ProductStateSoldOut) {
    //已售完 button 禁用
    [_buyBtn setTitle:@"已售完" forState:UIControlStateNormal];
    _buyBtn.backgroundColor = [Globle colorFromHexRGB:@"Color_Gray_but"];
  }
}

- (void)bindAccountBalance:(NSInteger)balanc {
  self.balanceStr = [NSString stringWithFormat:@"%ld", (long)balanc];
  self.availableBalanceLabel.text =
      [ProcessInputData convertMoneyString:self.balanceStr];
  self.availableBalanceLabel.text =
      [self.availableBalanceLabel.text stringByAppendingString:@"元"];
}

- (IBAction)clickOnBuyBtn:(UIButton *)sender {
  __weak PanicBuyingView *weakSelf = self;
  [FullScreenLogonViewController
      checkLoginStatusWithCallBack:^(BOOL isLogined) {
        if (!isLogined) {
          /// 先刷新再抢购
          [[NSNotificationCenter defaultCenter]
              postNotificationName:Notification_CP_BuyPlan_LoginSuccess
                            object:self
                          userInfo:nil];
        } else {
          [weakSelf showBuyTip];
        }
      }];
}

- (void)showBuyTip {
  if (_state == ExpertPerspectiveState) {
    [NewShowLabel setMessageContent:@"无法追踪自己计划"];
    return;
  }
  if (_state == UserPurchasedState) {
    [NewShowLabel setMessageContent:@"该计划已购买,无需重复购买"];
    return;
  }
  if (_productState == ProductStateSoldOut) {
    [NewShowLabel setMessageContent:@"已售完"];
    return;
  }
  __weak PanicBuyingView *weakSelf = self;
  if ([self.balanceStr integerValue] >= [self.priceStr integerValue]) {
    /// 余额充足
    NSString *content = [NSString
        stringWithFormat:
            @"需要支付：%@\n账户余额：%@\n确定支付吗？",
            self.tractPriceLabel.text, self.availableBalanceLabel.text];
    [WeiboToolTip showMakeSureWithTitle:@"确认支付"
        largeContent:content
        lineSpacing:3.0f
        contentTopSpacing:10.0f
        contentBottomSpacing:14.0f
        sureButtonTitle:@"支付"
        cancelButtonTitle:nil
        sureblock:^{
          [weakSelf buyPlan];
        }
        cancleblock:^{
        }];
  } else {
    /// 余额不足
    NSString *rechargeAmountCent =
        [@(([self.priceStr integerValue] - [self.balanceStr integerValue]))
                stringValue];
    NSString *rechargeAmount =
        [ProcessInputData convertMoneyString:rechargeAmountCent];
    NSString *content = [NSString
        stringWithFormat:@"需要支付：%@\n账户余额：%@"
                         @"\n您的账户余额不足\n需要充值%@元",
                         self.tractPriceLabel.text,
                         self.availableBalanceLabel.text, rechargeAmount];
    [WeiboToolTip showMakeSureWithTitle:@"余额不足"
        largeContent:content
        lineSpacing:3.0f
        contentTopSpacing:10.0f
        contentBottomSpacing:14.0f
        sureButtonTitle:@"充值"
        cancelButtonTitle:nil
        sureblock:^{
          [FullScreenLogonViewController
              checkLoginStatusWithCallBack:^(BOOL isLogined) {
                [AppDelegate pushViewControllerFromRight:
                                 [[RechargeAccountViewController alloc] initWithFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN, HEIGHT_OF_SCREEN)]];
              }];
        }
        cancleblock:^{
        }];
  }
}

- (void)buyPlan {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    return;
  }
  [NetLoadingWaitView startAnimating];
  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  //解析
  __weak PanicBuyingView *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    PanicBuyingView *strongSelf = weakSelf;
    [NetLoadingWaitView stopAnimating];
    if (strongSelf) {
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    [NewShowLabel setMessageContent:@"购买成功"];
    [[NSNotificationCenter defaultCenter]
        postNotificationName:Notification_CP_BuyPlanSuccess
                      object:self];
  };

  [CPBuyCattlePlanData buyCattlePlanWithAccountID:self.accountId
                                     andTargetUID:self.targetUid
                                      andCallBack:callback];
}

@end