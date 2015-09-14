//
//  ExchangeDiamondView.m
//  SimuStock
//
//  Created by Yuemeng on 15/5/18.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ExchangeDiamondView.h"
#import "Globle.h"
#import "WeiboToolTip.h"
#import "NSString+validate.h"

@implementation ExchangeDiamondView

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  //  NSLog(@"💎页面释放");
}

- (void)awakeFromNib {
  _diamondNumTextField.layer.borderWidth = 1;
  _diamondNumTextField.layer.borderColor =
      [[Globle colorFromHexRGB:@"#54C6EB"] CGColor];
  _diamondNumTextField.leftView = [[UIView alloc]
      initWithFrame:CGRectMake(0, 0, 5, _diamondNumTextField.height)];
  _diamondNumTextField.leftViewMode = UITextFieldViewModeAlways;
  _maxValueLabel.adjustsFontSizeToFitWidth = YES;
  [self registerForKeyboardNotifications];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)editingDidBegin:(UITextField *)textField {
  //    NSLog(@"☀️");
}
- (IBAction)editingChanged:(UITextField *)textField {
  //    NSLog(@"🌛");
  if ([textField.text integerValue] > [_maxValueLabel.text integerValue]) {
    textField.text = _maxValueLabel.text;
  }
}

- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {
  return [NSString validataNumberInput:string];
}

#pragma mark - 键盘相关
- (void)registerForKeyboardNotifications {
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(keyboardWasShown:)
             name:UIKeyboardDidShowNotification
           object:nil];
  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(keyboardWillBeHidden:)
             name:UIKeyboardWillHideNotification
           object:nil];
}

- (void)keyboardWasShown:(NSNotification *)aNotification {
  NSDictionary *info = [aNotification userInfo];
  CGSize kbSize =
      [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
  if (kbSize.height == 0) {
    return;
  }
  //  [self.weiboToolTip addHeight:-((HEIGHT_OF_SCREEN - 209) / 2.f -
  //                                (HEIGHT_OF_SCREEN - kbSize.height - 209) /
  //                                    2.f)]; // 209为提示框高度
  self.weiboToolTip.top = -112;
}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification {
  self.weiboToolTip.top = 0;
}

@end
