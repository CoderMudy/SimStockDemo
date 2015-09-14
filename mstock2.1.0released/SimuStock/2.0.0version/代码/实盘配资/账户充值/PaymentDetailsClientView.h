//
//  PaymentDetailsClientView.h
//  SimuStock
//
//  Created by jhss_wyz on 15/6/17.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GetVerificationCode;

@interface PaymentDetailsClientView : UIView

/** 充值金额 */
@property(weak, nonatomic) IBOutlet UILabel *rechargeAmountLabe;

/** 银行Logo */
@property(weak, nonatomic) IBOutlet UIImageView *bankLogoImageView;
/** 银行名称 */
@property(weak, nonatomic) IBOutlet UILabel *bankNameLable;
/** 银行卡尾号 */
@property(weak, nonatomic) IBOutlet UILabel *bankCardLastNoLable;

/** 姓名输入框 */
@property(weak, nonatomic) IBOutlet UITextField *nameTextField;
/** 身份证输入框 */
@property(weak, nonatomic) IBOutlet UITextField *idCardTextField;
/** 手机号输入框 */
@property(weak, nonatomic) IBOutlet UITextField *phoneNumTextField;
/** 短信验证码输入框 */
@property(weak, nonatomic) IBOutlet UITextField *messageVerificationCodeTF;
/** 确认按钮 */
@property(weak, nonatomic) IBOutlet UIButton *confirmBtn;
/** 获取验证码按钮 */
@property(weak, nonatomic) IBOutlet UIButton *getAuthCodeButton;
/** 支付提示Lable */
@property(weak, nonatomic) IBOutlet UILabel *payTipsLabel;

/** 同意协议按钮 */
@property(weak, nonatomic) IBOutlet UIButton *haveReadBtn;

/** 获取验证码对象 */
@property(strong, nonatomic) GetVerificationCode *getVerCode;

@end
