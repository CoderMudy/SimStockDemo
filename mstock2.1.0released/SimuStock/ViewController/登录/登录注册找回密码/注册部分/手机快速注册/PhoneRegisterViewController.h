//
//  PhoneRegisterViewController.h
//  SimuStock
//
//  Created by Jhss on 15/6/16.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "GetVerificationCode.h"
#import "UIButton+Hightlighted.h"

@protocol thirdBindPhoneDelegate <NSObject>

- (void)returnThirdBindPhoneNumber:(NSString *)phoneNumber
                         withTitle:(NSString *)title;

@end

/** 手机号注册、手机号绑定、密码修改 */
@interface PhoneRegisterViewController
    : BaseViewController <UITextFieldDelegate>

      {
  /** 定时器 */
  NSTimer *timer;
  /** 剩余的秒数 */
  NSInteger time;
  /** 获取验证码对象 */
  GetVerificationCode *getVerCode;
        /**  判断网络请求*/
    BOOL requesting;
}

/** 手机号输入框 */
@property(weak, nonatomic) IBOutlet UITextField *phoneNumberField;
/** 验证码 */
@property(weak, nonatomic) IBOutlet UITextField *authCodeTextField;
/** 密码 */
@property(weak, nonatomic) IBOutlet UITextField *passwordField;
/** 再次确认密码 */
@property(weak, nonatomic) IBOutlet UITextField *secondInputPasswordField;
/** 温馨提示的提示内容 */
@property(weak, nonatomic) IBOutlet UILabel *hintContentLabel;
/** 获得验证码按钮 */
@property(weak, nonatomic) IBOutlet UIButton *getAuthCodeButton;
/** 确认按钮  */
@property(weak, nonatomic) IBOutlet BGColorUIButton *confirmButton;

#pragma mark 绑定手机页面
@property(strong, nonatomic) NSString *titleStr;
@property(strong, nonatomic) NSString *phoneNumber;
@property(weak, nonatomic) id<thirdBindPhoneDelegate> delegagte;
///温馨提示内容
@property(copy, nonatomic) NSString *hintString;
/**  判断"重设密码"页面发送验证码的方式：yes为绑定手机的方式，no为修改方式
 * ,默认为绑定 */
@property(nonatomic) BOOL isBindPhoneGetVerifyCode;
///判断是否是登陆页面——>忘记密码进来的
@property(nonatomic) BOOL isUserLoginLossPwdInto;
///判断是否是设置页面——>绑定手机号进来的
@property (nonatomic) BOOL isSettingInfoPageInto;

/** 必须实现该方法 */
- (id)initWithFrame:(CGRect)frame
     withTitleLabel:(NSString *)titleStr
      withHintLabel:(NSString *)hintStr;



@end
