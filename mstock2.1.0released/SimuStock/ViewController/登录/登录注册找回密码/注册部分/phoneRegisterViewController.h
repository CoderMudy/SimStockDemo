//
//  phoneRegisterViewController.h
//  SimuStock
//
//  Created by jhss on 13-9-26.
//  Copyright (c) 2013年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "SimTopBannerView.h"

#define side_edge_width 20

@interface phoneRegisterViewController
    : BaseViewController <UITextFieldDelegate> {
  /** 获得验证码按钮 */
  UIButton *getAuthCodeButton;
  /** 下一步按钮 */
  UIButton *nextStepButton;
  /** 手机号输入栏 */
  UITextField *phoneNumber;
  /** 验证码输入栏 */
  UITextField *authCodeTextFeild;
  /** 剩余秒数 */
  NSInteger time;
  /** 定时器 */
  NSTimer *timer;
}
@end
