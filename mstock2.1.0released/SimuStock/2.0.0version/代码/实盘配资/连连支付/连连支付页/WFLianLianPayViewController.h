//
//  WFLianLianPayViewController.h
//  SimuStock
//
//  Created by jhss_wyz on 15/5/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"

@class WFBindedBankcardLianLianPayResult;

typedef void (^PaySuccess)(BOOL success); //检测支付状态

@interface WFLianLianPayViewController : BaseViewController

/** 显示充值金额 */
@property(weak, nonatomic) IBOutlet UILabel *amountLabel;
/** 银行卡的Logo */
@property(weak, nonatomic) IBOutlet UIImageView *bankLogoImageView;
/** 银行卡名字 */
@property(weak, nonatomic) IBOutlet UILabel *bankNameLabel;
/** 银行卡尾号 */
@property(weak, nonatomic) IBOutlet UILabel *bankTailNumber;
/** 覆盖在银行信息之上的button */
@property(weak, nonatomic) IBOutlet UIButton *paymentButton;
/** 点击调用获取订单号的网络申请，进行支付操作 */
- (IBAction)clickBankThenPaymentMethod:(id)sender;
// block函数的声明
@property(nonatomic, copy) PaySuccess paySuccess;

/** amount为充值的金额，单位元；order_no为订单号 */
- (instancetype)initWithBindCardInfoData:
                    (WFBindedBankcardLianLianPayResult *)bankInfoData
                             WithOrderNo:(NSString *)orderNo
                               andAmount:(NSString *)amount;

@end
