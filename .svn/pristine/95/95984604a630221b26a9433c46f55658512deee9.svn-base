//
//  WFBindMobilePhoneViewController.h
//  SimuStock
//
//  Created by Jhss on 15/4/26.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "GetVerificationCode.h"

typedef void (^BindMobilePhoneBlock)(BOOL success); //是否是已经绑定手机号状态

@interface WFBindMobilePhoneViewController : BaseViewController

                                             {
  /** 定时器 */
  NSTimer *timer;
  /** 剩余的秒数 */
  NSInteger time;
  /** 获取验证码对象 */
  GetVerificationCode *getVerCode;
   /** 网络请求判断*/
  BOOL requesting;
}

/** 手机号输入框 */
@property(weak, nonatomic) IBOutlet UITextField *phoneNumber;

/** 验证码输入框 */
@property(weak, nonatomic) IBOutlet UITextField *authCodeTextFeild;
/** 获得验证码按钮 */
@property(weak, nonatomic) IBOutlet UIButton *getAuthCodeButton;
/** 确定按钮 */
@property(weak, nonatomic) IBOutlet BGColorUIButton *confirmButton;
/** 点击“确定”按钮触发的方法 */
- (IBAction)confirmBindMobilePhonePress:(UIButton *)sender;

@property(nonatomic, copy) BindMobilePhoneBlock bindMobilePhoneBlock;
- (id)initWithBindMobilePhoneBlock:(BindMobilePhoneBlock)block;

@end
