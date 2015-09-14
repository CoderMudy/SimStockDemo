//
//  ExtendedTextField.m
//  SimuStock
//
//  Created by Mac on 15-2-25.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ExtendedTextField.h"

@implementation ExtendedTextField

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
  }
  return self;
}
- (void)setMaxLength:(NSInteger)maxLength {
  textMaxLenth = maxLength;
  //注册监听
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(textFiledEditChanged:)
             name:@"UITextFieldTextDidChangeNotification"
           object:self];
}
/** 实现监听 */
- (void)textFiledEditChanged:(NSNotification *)obj {
  UITextField *textField = (UITextField *)obj.object;

  NSString *toBeString = textField.text;
  NSString *lang =
      [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
  if ([lang isEqualToString:
                @"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
    UITextRange *selectedRange = [textField markedTextRange];
    //获取高亮部分
    UITextPosition *position =
        [textField positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position) {
      if (toBeString.length > textMaxLenth) {
        textField.text = [toBeString substringToIndex:textMaxLenth];
      }
    }
    // 有高亮选择的字符串，则暂不对文字进行统计和限制
    else {
    }
  } // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
  else {
    if (toBeString.length > textMaxLenth) {
      textField.text = [toBeString substringToIndex:textMaxLenth];
    }
  }
}

- (void)dealloc {
  //注销监听
  [[NSNotificationCenter defaultCenter]
      removeObserver:self
                name:@"UITextFieldTextDidChangeNotification"
              object:self];
}


@end
