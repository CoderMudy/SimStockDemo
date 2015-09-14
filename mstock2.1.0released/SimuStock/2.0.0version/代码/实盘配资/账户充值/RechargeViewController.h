//
//  RechargeViewController.h
//  SimuStock
//
//  Created by jhss on 15/6/4.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"

@class WFYeePaymentCardBinRequestResult;

/**账户充值界面*/
@interface RechargeViewController : BaseViewController <UITextFieldDelegate>
/** 支持银行列表按钮 */
@property(weak, nonatomic) IBOutlet BGColorUIButton *bankListBtn;
/** 下一步按钮 */
@property(weak, nonatomic) IBOutlet BGColorUIButton *nextStepBtn;
/** 银行卡号输入框 */
@property(weak, nonatomic) IBOutlet UITextField *bankCardTextField;
/** 充值金额 */
@property(weak, nonatomic) IBOutlet UILabel *payMoneyLab;

/** 充值金额（单位：元） */
@property(copy, nonatomic) NSString *amount;
/** 订单号 */
@property(copy, nonatomic) NSString *orderNo;
/** 银行卡信息 */
@property(strong, nonatomic) WFYeePaymentCardBinRequestResult *bankCardInfo;
/** 支付token，防止重复支付 */
@property(copy, nonatomic) NSString *token;

/** 小贴士 */
@property(copy, nonatomic) NSString *payTips;

/** amount为充值的金额，单位元*/
- (instancetype)initWithAmount:(NSString *)amount
                    andOrderNo:(NSString *)orderNo
                    andPayTips:(NSString *)payTips;

@end
