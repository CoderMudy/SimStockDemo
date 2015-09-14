//
//  WFAuthenticationViewController.h
//  SimuStock
//
//  Created by Jhss on 15/4/17.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "WFFinancingParse.h"
@interface WFAuthenticationViewController : BaseViewController




/** 获取验证码 */
@property (weak, nonatomic) IBOutlet UIButton *gain_Security_Code;
/** 获取验证码的点击事件 */
- (IBAction)clickGainSecurityCodePress:(id)sender;

/** 输入姓名 */
@property(weak, nonatomic) IBOutlet UITextField *Input_Name;
/** 输入身份证号 */
@property(weak, nonatomic) IBOutlet UITextField *Input_ID_Number;
/** 输入用来获取验证码的手机号 */
@property(weak, nonatomic) IBOutlet UITextField *Input_Cellphone_Number;
/** 输入获取到的验证码 */
@property(weak, nonatomic) IBOutlet UITextField *Input_Security_Code;
/** 确认按钮 */
@property(weak, nonatomic) IBOutlet UIButton *Countersign_Button;
/** 点击确认按钮触发方法 */
- (IBAction)clickAffirmSubmitMessages:(id)sender;
/** 右上角“客服热线”按钮 */
@property(strong, nonatomic) UIButton *Service_Tel_Btn;

@end
