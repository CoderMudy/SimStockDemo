//
//  FillInInviteViewController.m
//  SimuStock
//
//  Created by jhss on 15/5/18.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "FillInInvitationCodeVC.h"
@interface FillInInvitationCodeVC () <UITextFieldDelegate> {
  
}
@end
@implementation FillInInvitationCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];

}

//收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [_inviteCodeTF resignFirstResponder];
}

static const CGFloat MAXLENGTH = 16;
- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
  NSString *newString =
  [textField.text stringByReplacingCharactersInRange:range
                                          withString:string];
  //禁止输入数字以外的非法字符。
  BOOL isValidChar = YES;
  NSCharacterSet *tmpSet =
  [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"];
  int i = 0;
  while (i < string.length) {
    NSString *substring = [string substringWithRange:NSMakeRange(i, 1)];
    NSRange range = [substring rangeOfCharacterFromSet:tmpSet];
    if (range.length == 0) {
      isValidChar = NO;
      break;
    }
    i++;
  }
  if (!isValidChar) {
    return NO;
  }
  //判断总长度是否过长
  if (newString.length > MAXLENGTH) {
    return NO;
  }
  return YES;
}

@end
