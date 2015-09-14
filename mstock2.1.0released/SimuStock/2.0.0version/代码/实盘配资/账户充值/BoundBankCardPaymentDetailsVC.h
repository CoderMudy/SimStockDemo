//
//  BoundPaymentDetailsViewControllerVC.h
//  SimuStock
//
//  Created by jhss on 15/6/8.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "GetVerificationCode.h"
@class WFBindedBankcardYeePayResult;

/**已绑定银行卡支付页面*/
@interface BoundBankCardPaymentDetailsVC
    : BaseViewController <UITextFieldDelegate> {

  /** 定时器 */
  NSTimer *timer;
  /** 剩余的秒数 */
  NSInteger time;
  /** 获取验证码对象 */
  GetVerificationCode *getVerCode;
}
/** 充值金额（单位：元） */
@property(copy, nonatomic) NSString *amount;
/** 银行卡尾号 */
@property(copy, nonatomic) NSString *cardLastNum;
/** 银行卡名称 */
@property(copy, nonatomic) NSString *bankName;
/** 订单号 */
@property(copy, nonatomic) NSString *orderNo;
/** 手机号 */
@property(copy, nonatomic) NSString *phoneNum;
/** 银行卡标志 */
@property(copy, nonatomic) NSString *bankLogo;
/** 小贴士 */
@property(copy, nonatomic) NSString *payTips;

/**验证码输入框*/
@property(weak, nonatomic) IBOutlet UITextField *authCodeTF;
/**获取验证按钮*/
@property(weak, nonatomic) IBOutlet UIButton *getAuthCodeBtn;
/**确认按钮*/
@property(weak, nonatomic) IBOutlet UIButton *conFirmBtn;
/**阅读易宝一键支付服务协议按钮*/
@property(weak, nonatomic) IBOutlet UIButton *yibaoPaymentAgreementBtn;
@property(weak, nonatomic) IBOutlet UILabel *moneyLabel;
/**银行卡名称*/
@property(weak, nonatomic) IBOutlet UILabel *bankCardNameLabel;
/**尾号*/
@property(weak, nonatomic) IBOutlet UILabel *tailNumberLab;
@property(weak, nonatomic) IBOutlet UIView *verticalLineView;
@property(weak, nonatomic) IBOutlet UIButton *readedButton;
@property(weak, nonatomic) IBOutlet UIImageView *bankLogoImgView;
@property(weak, nonatomic) IBOutlet UILabel *payTipsLab;
@property(weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;

@property(strong, nonatomic) WFBindedBankcardYeePayResult *bankCardInfo;

/** amount为充值的金额，单位元*/
- (instancetype)initWithAmount:(NSString *)amount
                    andOrderNo:(NSString *)orderNo
                    andPayTips:(NSString *)tips
                     andResult:(WFBindedBankcardYeePayResult *)info;
@end
