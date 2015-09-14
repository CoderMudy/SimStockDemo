//
//  StoreUtil.m
//  SimuStock
//
//  Created by Mac on 14-11-11.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "StoreUtil.h"
#import "NewShowLabel.h"
#import "SimuUtil.h"
#import "BaseRequester.h"

@implementation StoreUtil

- (id)initWithUIViewController:(BaseViewController *)vc {
  self = [super init];
  if (self) {
    self.viewController = vc;
  }
  return self;
}

//移除视图
- (void)removeCompetitionCycleView {
  if (ssvc_alartVeiw) {
    [ssvc_alartVeiw removeFromSuperview];
  }
}

//购买钻石弹窗接口
- (void)showBuyingDiamondView {
  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    [NetLoadingWaitView stopAnimating];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak StoreUtil *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    StoreUtil *strongSelf = weakSelf;
    if (strongSelf) {
      [NetLoadingWaitView stopAnimating];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    StoreUtil *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf bindQueryDiamondList:(QueryDiamondList *)obj];
    }
  };
  callback.onError = ^(BaseRequestObject *obj, NSException *ex) {
    [weakSelf dealExchangeError:obj exception:ex];
  };

  callback.onFailed = ^{
    [NewShowLabel showNoNetworkTip];
  };

  [QueryDiamondList requestDiamondListWithCallback:callback];
}

- (void)bindQueryDiamondList:(QueryDiamondList *)obj {
  [self resetAlertView];
  //钻石购买弹出窗口
  if ([obj.dataArray count] == 0) {
    return;
  }

  //购买钻石弹窗视图
  [ssvc_alartVeiw buyDiamondsView:obj.dataArray
                 rightButtonColor:[Globle colorFromHexRGB:@"#31bce9"]];
  [self.viewController.view addSubview:ssvc_alartVeiw];
}

- (void)diamondInadequateWarningsView:(NSString *)message withButtonTitle:(NSString *)buttonTitle {
  [self resetAlertView];
  [ssvc_alartVeiw diamondInadequateWarningsView:message withButtonTitle:buttonTitle];
  [self.viewController.view addSubview:ssvc_alartVeiw];
}

- (void)buyProductWithDiamonds:(ProductListItem *)item {

  [FullScreenLogonViewController checkLoginStatusWithCallBack:^(BOOL isLogined) {
    if (![SimuUtil isExistNetwork]) {
      [NewShowLabel showNoNetworkTip];
      return;
    }

    [self resetAlertView];
    ssvc_alartVeiw.delegate = (id<CompetitionCycleViewDelegate>)self.viewController;
    NSString *price = item.mNoCountPrice;
    if ([item.mSale integerValue] != 0) {
      price = item.mPrice;
    }
    NSString *name = item.mName;
    NSString *diamondOrGold;
    //根据商品的类型 更换左下角的图标
    if ([item.mProductId isEqualToString:@"D040100005"] ||
        [item.mProductId isEqualToString:@"D040100002"] ||
        [item.mProductId isEqualToString:@"D040100001"]) {
      diamondOrGold = @"金币";
    } else {
      diamondOrGold = @"钻石";
    }

    NSString *message = [NSString
        stringWithFormat:@"您确定要花%@%@兑换%@吗？", price, diamondOrGold, name];
    [ssvc_alartVeiw mallExchangeViewTitle:@"兑换"
                                  message:message
                           rightButtonTag:5101
                          rightButtonName:@"兑换"
                            WithproductId:item.mProductId];
    [self.viewController.view addSubview:ssvc_alartVeiw];
  }];
}

- (void)changeProductWithDiamonds:(NSString *)productID
               andSuccessCallBack:(SuccessCallBack)successCallBack {
  self.successCallBack = successCallBack;
  [self changeProductWithDiamonds:productID];
}

- (void)changeProductWithDiamonds:(NSString *)productID {

  [NetLoadingWaitView startAnimating];

  if (![SimuUtil isExistNetwork]) {
    [NewShowLabel showNoNetworkTip];
    [NetLoadingWaitView stopAnimating];
    return;
  }

  HttpRequestCallBack *callback = [[HttpRequestCallBack alloc] init];
  __weak StoreUtil *weakSelf = self;
  callback.onCheckQuitOrStopProgressBar = ^{
    StoreUtil *strongSelf = weakSelf;
    if (strongSelf) {
      [NetLoadingWaitView stopAnimating];
      return NO;
    } else {
      return YES;
    }
  };

  callback.onSuccess = ^(NSObject *obj) {
    StoreUtil *strongSelf = weakSelf;
    if (strongSelf) {
      if ([productID hasPrefix:@"D050000"]) {
        if (self.successCallBack) {
          [NewShowLabel setMessageContent:((ExchangeProps *)obj).message];
          self.successCallBack();
        } else {
          [strongSelf bindExchangeProps:(ExchangeProps *)obj];
        }
      } else {
        [strongSelf bindExchangeProps:(ExchangeProps *)obj];
      }
    }
  };
  callback.onError = ^(BaseRequestObject *obj, NSException *ex) {
    [weakSelf dealExchangeError:obj exception:ex];
  };

  callback.onFailed = ^{
    [NewShowLabel showNoNetworkTip];
  };
  NSString *userName = [CommonFunc base64StringFromText:[SimuUtil getUserName]];
  [ExchangeProps requestExchangePropsWithUserName:userName
                                    withProductId:productID
                                     withCallback:callback];
}

- (void)resetAlertView {
  int height = self.viewController.topToolBar.frame.size.height;
  CGRect frame = self.viewController.view.frame;
  if (ssvc_alartVeiw) {
    [ssvc_alartVeiw removeFromSuperview];
    ssvc_alartVeiw = nil;
  }
  ssvc_alartVeiw = [[CompetitionCycleView alloc]
      initWithFrame:CGRectMake(0, -height, frame.size.width, frame.size.height + height)];
  ssvc_alartVeiw.delegate = (id<CompetitionCycleViewDelegate>)self.viewController;
}

- (void)dealExchangeError:(BaseRequestObject *)obj exception:(NSException *)ex {
  if (obj && ![obj.status isEqualToString:@"0101"]) {
    if ([obj.status isEqualToString:@"0002"]) {
      //钻石不足
      [self resetAlertView];

      [ssvc_alartVeiw
          mallExchangeViewTitle:@"充值"
                        message:@"您" @"的钻石数量不足，请先充值购买钻石"
                 rightButtonTag:5102
                rightButtonName:@"充值"
                  WithproductId:@""];
      [self.viewController.view addSubview:ssvc_alartVeiw];
    } else {
      //钻石兑换商品失败
      NSLog(@"obj.message:%@", obj.message);
      UIAlertView *alartView = [[UIAlertView alloc] initWithTitle:@"兑换"
                                                          message:obj.message
                                                         delegate:nil
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil, nil];
      [alartView show];
    }
  } else {
    [BaseRequester defaultErrorHandler](obj, ex);
  }
}

- (void)bindExchangeProps:(ExchangeProps *)result {
  [ViewController updateMyInfo];
  //钻石兑换商品成功
  UIAlertView *alartView = [[UIAlertView alloc] initWithTitle:@"兑换"
                                                      message:result.message
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];

  [alartView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (self.afterPurchaseDelegate &&
      [self.afterPurchaseDelegate
          respondsToSelector:@selector(afterPurchaseRefreshControllerData)]) {
    [self.afterPurchaseDelegate afterPurchaseRefreshControllerData];
  }
}

@end
