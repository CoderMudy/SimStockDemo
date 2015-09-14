//
//  InvitationCodeView.h
//  SimuStock
//
//  Created by moulin wang on 14-7-15.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompetionKeyBoardView.h"
//请求协议
@protocol InvitationCodeViewDelegate <NSObject>

//邀请码
- (void)invitationCode:(NSString *)code;

@end

@interface NoCursorTextField : UITextField

@end

@interface InvitationCodeView
    : UIView <CompetionKeyBoardViewDelegate, UITextFieldDelegate> {
  //自定义键盘
  CompetionKeyBoardView *ssv_keyboardView;
  NSMutableArray *labArray;
  //邀请码输入错误判断
  BOOL invitationBool;
  //白底
  UIView *_whiteView;
  //阴影
  UIView *_shadowView;
}
//邀请码
@property(nonatomic, strong) NSString *codeStr;
//确认按钮
@property(nonatomic, strong) UIButton *confirmButton;
//验证码请求提示
@property(nonatomic, strong) UILabel *showLabel;
@property(nonatomic, strong) UITextField *ssv_searchTextField;
@property(weak, nonatomic) id<InvitationCodeViewDelegate> delegate;
@end
