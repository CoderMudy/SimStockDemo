//
//  ApplyForLargeMoneyView.m
//  SimuStock
//
//  Created by jhss_wyz on 15/3/27.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ApplyForLargeMoneyView.h"
#import "Globle.h"
#import "InputTextFieldView.h"

@implementation ApplyForLargeMoneyView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  /** 使键盘消失 */
  [self.inputMoney.inputTextField resignFirstResponder];
}

- (void)awakeFromNib {
  self.inputMoney.inputType = INPUTE_TYPE_INTEGER_NUMBER;
  /// 限制输入金额的位数为3位
  self.inputMoney.numberOfIntegerPlaces = 3;
  self.inputMoney.inputTextField.placeholder =
      @"请" @"输" @"入金额，最低为10万元";
  self.inputMoney.inputTextField.font = [UIFont systemFontOfSize:15.0f];
  self.inputMoney.inputTextField.tintColor = [Globle colorFromHexRGB:@"939393"];
  self.inputMoney.inputTextField.textColor =
      [Globle colorFromHexRGB:Color_Text_Common];
  self.inputMoney.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
  self.inputMoney.inputTextField.borderStyle = UITextBorderStyleNone;

  self.determineBtn.normalBGColor = [Globle colorFromHexRGB:Color_WFOrange_btn];
  self.determineBtn.highlightBGColor =
      [Globle colorFromHexRGB:Color_WFOrange_btnDown];
  self.determineBtn.layer.cornerRadius = self.determineBtn.height / 2;
  self.determineBtn.layer.masksToBounds = YES;
  self.determineBtn.enabled = YES;
}

@end
