//
//  WFLianLianPayBindInfoViewController.h
//  SimuStock
//
//  Created by Jhss on 15/5/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"

@class WFLianLianPayGetPaymentOrder;

typedef void (^paySuccess)(BOOL success); //检测支付状态

@interface WFLianLianPayBindInfoViewController
    : BaseViewController <UITextFieldDelegate>

/** 支付的金额 */
@property(weak, nonatomic) IBOutlet UILabel *pay_money_label;
/** 姓名 */
@property(weak, nonatomic) IBOutlet UITextField *nameTextField;

/** 银行卡 输入框 */
@property(weak, nonatomic) IBOutlet UITextField *bankCardTextField;
/** 身份证的输入框 */
@property(weak, nonatomic) IBOutlet UITextField *idCardField;
/** ”下一步“按钮 */
@property(weak, nonatomic) IBOutlet BGColorUIButton *nextStepBtn;
/** 下一步的点击触发方法 */
- (IBAction)clickNextStepPress:(id)sender;
/** 支持银行列表按钮 */
@property(weak, nonatomic) IBOutlet BGColorUIButton *bankListButton;
/** “支持银行列表”触发的方法 */
- (IBAction)clicklookAtSupportBankList:(id)sender;
// block函数的声明
@property(nonatomic, copy) paySuccess paySuccess;

/** amount为充值的金额，单位元；order_no为订单号 */
- (instancetype)initWithOrderNo:(NSString *)orderNo
                      andAmount:(NSString *)amount;

@end
