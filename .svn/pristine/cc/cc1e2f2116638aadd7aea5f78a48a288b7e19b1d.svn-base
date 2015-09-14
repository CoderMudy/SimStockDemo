//
//  BindBankCardViewController.h
//  SimuStock
//
//  Created by Yuemeng on 15/5/19.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "BaseViewController.h"
#import "BankInitDrawData.h"

typedef void (^submitSuccessed)(void);

typedef NS_ENUM(NSUInteger, BankBindedStatus) {
  BankBinded,     //已绑定银行卡
  BankUnBinded,   //未绑定银行卡
  BankProcessing, //提现处理中
};

/*
 *  提现绑定银行卡页面
 */
@interface BindBankCardViewController
    : BaseViewController <UITextFieldDelegate, UIScrollViewDelegate,
                          UITextViewDelegate> {
  UIScrollView *_scrollView;
  ///未绑定银行卡时的textField数组
  NSMutableArray *_unbindedTextFieldArray;
  ///验证码计时器
  NSTimer *_timer;
  ///验证码button
  UIButton *_verifyButton;
  ///初始化类型
  BankBindedStatus _bankStatus;
  ///绑定信息
  BankInitDrawData *_bankInitDrawData;
  ///倒计时
  NSInteger _remainTime;
  ///手机验证码textField
  UITextField *_verifyCodeTextField;
  ///说明button
  UIButton *_introButton;
                            
  //判断网络请求
  BOOL requesting ;
}

@property(nonatomic, copy) submitSuccessed submitSuccessed;

///根据银行卡绑定状态初始化
- (id)initWithBankBindedStatus:(BankBindedStatus)status
                          data:(BankInitDrawData *)data;

@end
