//
//  AwardsRankingView.m
//  SimuStock
//
//  Created by 刘小龙 on 15/8/11.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "AwardsRankingView.h"
#import "Globle.h"

@implementation AwardsRankingView
- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
    UIView *containerView =
        [[[UINib nibWithNibName:@"AwardsRankingView" bundle:nil] instantiateWithOwner:self
                                                                              options:nil] objectAtIndex:0];
    CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    containerView.frame = newFrame;
    [self addSubview:containerView];
  }
  return self;
}

/** 对外提供的 初始化 */
+ (AwardsRankingView *)showAwardsRankingView {
  return
      [[[NSBundle mainBundle] loadNibNamed:@"AwardsRankingView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
  [super awakeFromNib];
  [self.awardsTextField setValue:[Globle colorFromHexRGB:@"#939393"]
                      forKeyPath:@"_placeholderLabel.textColor"];
  self.awardsTextField.delegate = self;
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(textViewEditChanged:)
                                               name:UITextFieldTextDidChangeNotification
                                             object:self.awardsTextField];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UITextFieldTextDidChangeNotification
                                                object:nil];
}
- (void)textViewEditChanged:(NSNotification *)obj {
  UITextField *textField = (UITextField *)obj.object;
  if (textField != self.awardsTextField) {
    return;
  }
  NSInteger kMaxLength = 6;
  NSString *toBeString = textField.text;
  /// 键盘输入模式
  NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];
  if ([lang isEqualToString:@"zh-Hans"]) {
    /// 简体中文输入，包括简体拼音，健体五笔，简体手写
    UITextRange *selectedRange = [textField markedTextRange];
    /// 获取高亮部分
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    /// 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
      if (toBeString.length > kMaxLength) {
        textField.text = [toBeString substringToIndex:kMaxLength];
      }
    }
    /// 有高亮选择的字符串，则暂不对文字进行统计和限制
    else {
    }
  }
  /// 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
  else {
    if (toBeString.length > kMaxLength) {
      textField.text = [toBeString substringToIndex:kMaxLength];
    }
  }
}

#pragma mark---------UITextViewDelegate----------
- (void)textFieldDidEndEditing:(UITextView *)textField {
  textField.text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  if (textField == self.awardsTextField) {
    [textField resignFirstResponder];
  }
  return YES;
}

- (void)rankingReceiveKeyboard {
  [self.awardsTextField resignFirstResponder];
}
@end
