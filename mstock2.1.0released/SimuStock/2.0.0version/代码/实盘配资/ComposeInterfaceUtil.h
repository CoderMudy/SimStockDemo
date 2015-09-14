//
//  ComposeInterfaceUtil.h
//  SimuStock
//
//  Created by Mac on 15/5/21.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequestObject.h"
#import "BaseRequester.h"
#import "WFAccountInterface.h"
#import "WFProductContract.h"
#import "WeiBoToolTip.h"

/** 申请配资、续约、追保工具类 */
@interface WFApplyAccountUtil : NSObject

/** 申请实盘账号 */
+ (void)applyAccountWithOwner:(NSObject *)vc
            withCleanCallBack:(CleanAction)clearAction;

@end

#pragma mark

typedef void (^onWFAccountBalanceReady)(WFAccountBalance *result);

typedef void (^onWFContractReady)(WFMakeNewContractResult *result);

/** 申请配资的立即申请工具类 */
@interface WFPayUtil : NSObject

/** 检查账户余额: 1.检查资金池 2.检查余额 */
+ (void)checkWFBalanceWithOwner:(UIViewController *)vc
              withCleanCallBack:(CleanAction)clearAction
             andSurePayCallBack:(sureButtonClickBlock)surePayCallBack
             andTotalAmountCent:(NSString *)totalAmountCent;

/** 请求支付：1. 检查用户是否实名认证 2.支付 */
+ (void)requestPayWithOwner:(UIViewController *)vc
          withCleanCallBack:(CleanAction)clearAction
                productInfo:(WFMakeNewContractParameter *)productInfo
  onWFContractReadyCallback:(onWFContractReady)onWFContractReady;

/** 查询用户账户的剩余的金额 */
+ (void)checkWFAccountBalanceWithOwner:(UIViewController *)vc
                     withCleanCallBack:(CleanAction)clearAction
               onWFAccountBalanceReady:(onWFAccountBalanceReady)action;
/** 牛人计划  查询用户账户的余额*/
+ (void)masterPlanCheckAccountBalanceWithOwner:(NSObject *)vc
                              andCleanCallBack:(CleanAction)clearAction
                            andSurePayCallBack:(sureButtonClickBlock)surePayCallBack
                            andTotalAmountCent:(NSString *)totalAmountCent;
/**
 查询用户账户的剩余的金额
 需要支付的总额：totalAmountCent
 查询成功后：
 支付按钮调用surePayCallBack
 充值按钮调用rechargeCallBack
 */
+ (void)checkWFAccountBalanceWithOwner:(UIViewController *)vc
                      andCleanCallBack:(CleanAction)clearAction
                    andSurePayCallBack:(sureButtonClickBlock)surePayCallBack
                    andTotalAmountCent:(NSString *)totalAmountCent;

@end

@interface ComposeInterfaceUtil : NSObject

@end
