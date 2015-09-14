//  PasswordSettingsViewController.h
//  SimuStock
//
//  Created by jhss on 13-9-26.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "SimTopBannerView.h"
#import "SimuUser.h"

#define side_edge_width 20
#define phoneregister_NavigationBar_Height                                     \
  ((7 <= [[[UIDevice currentDevice] systemVersion] floatValue]) ? 44 : 64);
#define input_feild_cutting_line_space 45

@interface PasswordSettingsViewController
    : BaseViewController <UITextFieldDelegate, UIApplicationDelegate> {
  /** 密码输入栏 */
  UITextField *passwordTextField;
  /** 二次输入密码 */
  UITextField *oncePassWordTextField;
//  /** 邀请码 */
//  UITextField *inviteCodeTextField;
}
/** 手机号 */
@property(copy, nonatomic) NSString *phoneNumber;
/** 验证码 */
@property(copy, nonatomic) NSString *verifyCode;
/** 验证后的手机号、验证码 */
- (id)initWithCode:(NSString *)action_code
    withPhoneNumber:(NSString *)phoneNumber;
@end
