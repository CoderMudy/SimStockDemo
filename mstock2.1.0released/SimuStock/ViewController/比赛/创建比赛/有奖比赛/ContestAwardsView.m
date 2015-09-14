//
//  ContestAwardsView.m
//  SimuStock
//
//  Created by 刘小龙 on 15/8/12.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ContestAwardsView.h"
#import "UIButton+Block.h"
#import "Globle.h"

@implementation ContestAwardsView

+ (ContestAwardsView *)showContestAwardsView {
  NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ContestAwardsView" owner:nil options:nil];

  ContestAwardsView *awards = [array lastObject];
  awards.frame = CGRectMake(0, 0, WIDTH_OF_SCREEN, 38);
  return awards;
}

- (void)awakeFromNib {
  [super awakeFromNib];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(textViewEditChanged:)
                                               name:UITextFieldTextDidChangeNotification
                                             object:self.awardsTextField];
  self.deleteButton.layer.cornerRadius = self.deleteButton.bounds.size.width * 0.5;
  self.deleteButton.layer.masksToBounds = YES;
  [self bringSubviewToFront:self.deleteButton];
  [self.awardsTextField setValue:[Globle colorFromHexRGB:@"#939393"]
                      forKeyPath:@"_placeholderLabel.textColor"];
  self.awardsTextField.delegate = self;
  //放重复点击
  __weak ContestAwardsView *weakSelf = self;
  [self.deleteButton setOnButtonPressedHandler:^{
    ContestAwardsView *strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf deleteButtonDownUpInside];
    }
  }];
}

- (void)dealloc {
  NSLog(@"已释放");
  self.awardsTextField.delegate = nil;
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UITextFieldTextDidChangeNotification
                                                object:nil];
}

/** 删除按钮 点击事件 */
- (void)deleteButtonDownUpInside {
  NSLog(@"删除");
  if (self.deleteButtonDownBlock) {
    self.deleteButtonDownBlock(self);
  }
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
/** 释放键盘 */
- (void)contestReceiveKeyboard {
  [self.awardsTextField resignFirstResponder];
}

- (void)layoutSubviews {
  [super layoutSubviews];
}

@end
