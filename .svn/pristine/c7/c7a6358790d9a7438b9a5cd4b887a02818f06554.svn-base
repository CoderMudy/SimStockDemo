//
//  ComposeInterfaceUtil.m
//  SimuStock
//
//  Created by Mac on 15/5/21.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ComposeInterfaceUtil.h"
#import "ApplyForActualTradingViewController.h"
#import "WFBindMobilePhoneViewController.h"
#import "WithCapitalHome.h"
#import "GetUserBandPhoneNumber.h"

#import "ProcessInputData.h"
#import "RealNameAuthenticationViewController.h"
#import "WFsimuUtil.h"
#import "RechargeAccountViewController.h"

/** 申请实盘账号工具类 */
@implementation WFApplyAccountUtil

/** 申请实盘账号：先检查资金池，然后检查是否手机绑定 */
+ (void)applyAccountWithOwner:(NSObject *)vc
            withCleanCallBack:(CleanAction)clearAction {
  HttpRequestCallBack *callBack =
      [HttpRequestCallBack initWithOwner:vc cleanCallback:clearAction];
  callBack.onSuccess = ^(NSObject *obj) {
    WithCapitalIsClose *IsExist = (WithCapitalIsClose *)obj;
    if (IsExist.isClose) {
      //资金池不足 关闭状态
      [NewShowLabel setMessageContent:IsExist.message];
      clearAction();
    } else {
      [WFApplyAccountUtil checkBindPhoneWithOwner:vc
                                withCleanCallBack:clearAction];
    }
  };

  [WithCapitalHome checkWFISClosewithCallback:callBack];
}

/** 检查是否手机绑定*/
+ (void)checkBindPhoneWithOwner:(NSObject *)vc
              withCleanCallBack:(CleanAction)clearAction {
  HttpRequestCallBack *callBack =
      [HttpRequestCallBack initWithOwner:vc cleanCallback:clearAction];
  callBack.onSuccess = ^(NSObject *obj) {
    clearAction();
    GetUserBandPhoneNumber *userBindPhone = (GetUserBandPhoneNumber *)obj;
    if (userBindPhone.phoneNumber && userBindPhone.phoneNumber.length > 0) {
      [AppDelegate pushViewControllerFromRight:
                       [[ApplyForActualTradingViewController alloc] init]];
    } else {
      ///如果用户还没绑定手机号，跳转手机绑定界面
      WFBindMobilePhoneViewController *wfbindphone =
          [[WFBindMobilePhoneViewController alloc]
              initWithBindMobilePhoneBlock:^(BOOL success) {
                if (success) {
                  ApplyForActualTradingViewController *applyVC =
                      [[ApplyForActualTradingViewController alloc] init];
                  [AppDelegate pushViewControllerFromRight:applyVC];
                }
              }];
      [AppDelegate pushViewControllerFromRight:wfbindphone];
    }
  };

  [GetUserBandPhoneNumber checkUserBindPhonerWithCallback:callBack];
}

@end

@implementation WFPayUtil

/** 检查账户余额：先检查资金池，然后查询账号余额 */
+ (void)checkWFBalanceWithOwner:(UIViewController *)vc
              withCleanCallBack:(CleanAction)clearAction
             andSurePayCallBack:(sureButtonClickBlock)surePayCallBack
             andTotalAmountCent:(NSString *)totalAmountCent {
  HttpRequestCallBack *callBack =
      [HttpRequestCallBack initWithOwner:vc cleanCallback:clearAction];
  callBack.onSuccess = ^(NSObject *obj) {
    WithCapitalIsClose *IsExist = (WithCapitalIsClose *)obj;
    if (IsExist.isClose) {
      /// 资金池资金不足
      [NewShowLabel setMessageContent:@"当" @"前" @"无"
                    @"法申请配资，请稍后尝试"];
      clearAction();
    } else {
      [WFPayUtil checkWFAccountBalanceWithOwner:vc
                               andCleanCallBack:clearAction
                             andSurePayCallBack:surePayCallBack
                             andTotalAmountCent:totalAmountCent];
    }
  };

  [WithCapitalHome checkWFISClosewithCallback:callBack];
}

/** 查询用户账户的剩余的金额 */
+ (void)checkWFAccountBalanceWithOwner:(UIViewController *)vc
                     withCleanCallBack:(CleanAction)clearAction
               onWFAccountBalanceReady:(onWFAccountBalanceReady)action {
  HttpRequestCallBack *callBack =
      [HttpRequestCallBack initWithOwner:vc cleanCallback:clearAction];
  callBack.onSuccess = ^(NSObject *obj) {
    WFAccountBalance *result = (WFAccountBalance *)obj;
    action(result);
  };

  [WFAccountInterface WFCheckAccountBalanceWithCallback:callBack];
}

/** 查询用户账户的剩余的金额 */
+ (void)checkWFAccountBalanceWithOwner:(UIViewController *)vc
                      andCleanCallBack:(CleanAction)clearAction
                    andSurePayCallBack:(sureButtonClickBlock)surePayCallBack
                    andTotalAmountCent:(NSString *)totalAmountCent {
  vc.view.userInteractionEnabled = NO;
  clearAction();
  [SimuUtil performBlockOnMainThread:^{
    vc.view.userInteractionEnabled = YES;
  } withDelaySeconds:1.f];

  HttpRequestCallBack *callBack =
      [HttpRequestCallBack initWithOwner:vc cleanCallback:clearAction];
  callBack.onSuccess = ^(NSObject *obj) {
    WFAccountBalance *result = (WFAccountBalance *)obj;
    NSString *balanceCent = result.amount;
    NSString *balance = [ProcessInputData convertMoneyString:balanceCent];
    NSString *totalAmount =
        [ProcessInputData convertMoneyString:totalAmountCent];
    if ([balanceCent intValue] >= [totalAmountCent intValue]) {
      /// 余额充足
      NSString *content = [NSString
          stringWithFormat:
              @"需要支付：%@元\n账户余额：%@元\n确定支付吗？",
              totalAmount, balance];
      [WeiboToolTip showMakeSureWithTitle:@"确认支付"
                             largeContent:content
                              lineSpacing:3.0f
                        contentTopSpacing:10.0f
                     contentBottomSpacing:14.0f
                          sureButtonTitle:@"支付"
                        cancelButtonTitle:nil
                                sureblock:surePayCallBack
                              cancleblock:clearAction];
    } else {
      /// 余额不足
      NSString *rechargeAmountCent =
          [NSString stringWithFormat:@"%d", ([totalAmountCent intValue] -
                                             [balanceCent intValue])];
      NSString *rechargeAmount =
          [ProcessInputData convertMoneyString:rechargeAmountCent];
      NSString *content = [NSString
          stringWithFormat:@"需要支付：%@元\n账户余额：%@"
                           @"元\n您的账户余额不足\n需要充值%@元",
                           totalAmount, balance, rechargeAmount];
      [WeiboToolTip
          showMakeSureWithTitle:@"余额不足"
                   largeContent:content
                    lineSpacing:3.0f
              contentTopSpacing:10.0f
           contentBottomSpacing:14.0f
                sureButtonTitle:@"充值"
              cancelButtonTitle:nil
                      sureblock:^{
                        clearAction();
                        [AppDelegate
                            pushViewControllerFromRight:
                                [[RechargeAccountViewController alloc] initWithFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN, HEIGHT_OF_SCREEN)]];
                      }
                    cancleblock:clearAction];
    }
  };

  [WFAccountInterface WFCheckAccountBalanceWithCallback:callBack];
}

/** 牛人计划  查询用户账户的余额*/
+ (void)masterPlanCheckAccountBalanceWithOwner:(NSObject *)vc
                      andCleanCallBack:(CleanAction)clearAction
                    andSurePayCallBack:(sureButtonClickBlock)surePayCallBack
                    andTotalAmountCent:(NSString *)totalAmountCent {
  clearAction();
  HttpRequestCallBack *callBack =
  [HttpRequestCallBack initWithOwner:vc cleanCallback:clearAction];
  callBack.onSuccess = ^(NSObject *obj) {
    WFAccountBalance *result = (WFAccountBalance *)obj;
    NSString *balanceCent = result.amount;
    NSString *balance = [ProcessInputData convertMoneyString:balanceCent];
    NSString *totalAmount = totalAmountCent;
    if ([balanceCent intValue] >= [totalAmountCent intValue]) {
      /// 余额充足
      NSString *content = [NSString
                           stringWithFormat:
                           @"需要支付：%@元\n账户余额：%@元\n确定支付吗？",
                           totalAmount, balance];
      [WeiboToolTip showMakeSureWithTitle:@"确认支付"
                             largeContent:content
                              lineSpacing:3.0f
                        contentTopSpacing:10.0f
                     contentBottomSpacing:14.0f
                          sureButtonTitle:@"支付"
                        cancelButtonTitle:nil
                                sureblock:surePayCallBack
                              cancleblock:clearAction];
    } else {
      /// 余额不足
      NSString *rechargeAmountCent =
      [NSString stringWithFormat:@"%d", ([totalAmountCent intValue] -
                                         [balance intValue])];
      NSString *rechargeAmount = rechargeAmountCent;
      NSString *content =
      [NSString stringWithFormat:
       @"需要支付：%@元\n账户余额：%@"
       @"元\n您的账户余额不足\n需要充值%@元",
       totalAmount, balance, rechargeAmount];
      [WeiboToolTip
       showMakeSureWithTitle:@"余额不足"
       largeContent:content
       lineSpacing:3.0f
       contentTopSpacing:10.0f
       contentBottomSpacing:14.0f
       sureButtonTitle:@"充值"
       cancelButtonTitle:nil
       sureblock:^{
         clearAction();
         [AppDelegate
          pushViewControllerFromRight:
          [[RechargeAccountViewController alloc] initWithFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN, HEIGHT_OF_SCREEN)]];
       }
       cancleblock:clearAction];
    }
  };
  
  [WFAccountInterface WFCheckAccountBalanceWithCallback:callBack];
}

/** 请求支付：检查用户是否实名认证 */
+ (void)requestPayWithOwner:(UIViewController *)vc
          withCleanCallBack:(CleanAction)clearAction
                productInfo:(WFMakeNewContractParameter *)productInfo
  onWFContractReadyCallback:(onWFContractReady)onWFContractReady {
  HttpRequestCallBack *callBack =
      [HttpRequestCallBack initWithOwner:vc cleanCallback:clearAction];
  callBack.onSuccess = ^(NSObject *obj) {
    WFRealUserIsRNA *result = (WFRealUserIsRNA *)obj;
    if (result.realName && result.certNo) {
      [WFPayUtil _doPayWithOwner:vc
                  withCleanCallBack:clearAction
                        productInfo:productInfo
          onWFContractReadyCallback:onWFContractReady];
    } else { //不存在实名信息
      clearAction();
      RealNameAuthenticationViewController *realNameVC =
          [[RealNameAuthenticationViewController alloc]
              initWithRealUserCertBlock:^(BOOL success) {
                if (success) {
                  [vc.navigationController popToViewController:vc animated:YES];
                }
              }];
      [AppDelegate pushViewControllerFromRight:realNameVC];
    }
  };
  callBack.onError = ^(BaseRequestObject *err, NSException *ex) {
    clearAction();
    if ([err.status isEqualToString:@"0013"]) {
      RealNameAuthenticationViewController *realNameVC =
          [[RealNameAuthenticationViewController alloc]
              initWithRealUserCertBlock:^(BOOL success) {
                if (success) {
                  [vc.navigationController popToViewController:vc animated:YES];
                }
              }];
      [AppDelegate pushViewControllerFromRight:realNameVC];
    } else {
      [BaseRequester defaultErrorHandler](err, ex);
    }
  };

  [WFinquireIsAuthRNA authUserIdentityWithCallback:callBack];
}

/** 开始申请配资 */
+ (void)_doPayWithOwner:(UIViewController *)vc
            withCleanCallBack:(CleanAction)clearAction
                  productInfo:(WFMakeNewContractParameter *)productInfo
    onWFContractReadyCallback:(onWFContractReady)onWFContractReady {
  HttpRequestCallBack *callBack =
      [HttpRequestCallBack initWithOwner:vc cleanCallback:clearAction];
  callBack.onSuccess = ^(NSObject *obj) {
    clearAction();
    onWFContractReady((WFMakeNewContractResult *)obj);
  };
  callBack.onError = ^(BaseRequestObject *err, NSException *ex) {
    clearAction();
    if (err && [@"0015" isEqualToString:err.status]) {
      //      "status" : "0015","message": "优顾帐号余额不足"
      //      //需要跳转到优顾账户充值页
      [AppDelegate pushViewControllerFromRight:
                       [[RechargeAccountViewController alloc] initWithFrame:CGRectMake(0, 0, WIDTH_OF_SCREEN, HEIGHT_OF_SCREEN)]];
    } else {
      [BaseRequester defaultErrorHandler](err, ex);
    }
  };

  [WFProductContract makeWFContractWithProductInfo:productInfo
                                       andCallback:callBack];
}

@end

@implementation ComposeInterfaceUtil

@end
