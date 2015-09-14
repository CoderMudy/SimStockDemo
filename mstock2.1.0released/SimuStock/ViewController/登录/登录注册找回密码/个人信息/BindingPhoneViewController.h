//
//  BindingPhoneViewController.h
//  SimuStock
//
//  Created by Jhss on 15/6/29.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "GetVerificationCode.h"
#import "UIButton+Block.h"

@protocol verifyPhoneDelegate <NSObject>

- (void)returnVerifyPhoneNumber:(NSString *)phoneNumber
                      withTitle:(NSString *)title;

@end

@interface BindingPhoneViewController : BaseViewController <UITextFieldDelegate>

                                        {
  /** 定时器 */
  NSTimer *timer;
  /** 剩余的秒数 */
  NSInteger time;
  /** 获取验证码对象 */
  GetVerificationCode *getVerCode;
  //判断网络请求
  BOOL requesting ;
                                          
}

/** 手机号输入框 */
@property(weak, nonatomic) IBOutlet UITextField *phoneNumberField;
/** 验证码输入框 */
@property(weak, nonatomic) IBOutlet UITextField *authCodeTextField;
/** 获取验证码按钮 */
@property(weak, nonatomic) IBOutlet UIButton *getAuthCodeButton;
/** 确定按钮 */
@property(weak, nonatomic) IBOutlet BGColorUIButton *confirmButton;
/** 提示语内容 */
@property(weak, nonatomic) IBOutlet UILabel *hintContentLabel;

@property(copy, nonatomic) NSString *titleStr;
///温馨提示内容
@property(copy, nonatomic) NSString *hintString;
@property(weak, nonatomic) id<verifyPhoneDelegate> delegagte;

@end
