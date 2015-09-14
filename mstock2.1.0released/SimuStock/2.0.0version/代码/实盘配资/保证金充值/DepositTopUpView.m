//
//  DepositTopUpView.m
//  SimuStock
//
//  Created by jhss_wyz on 15/3/31.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "DepositTopUpView.h"
#import "InputTextFieldView.h"

@implementation DepositTopUpView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  /** 使键盘消失 */
  [self.inputMoney.inputTextField resignFirstResponder];
}

- (void)awakeFromNib {
  self.inputMoney.inputType = INPUTE_TYPE_INTEGER_NUMBER;
  /// 限制输入金额的位数为6位
  self.inputMoney.numberOfIntegerPlaces = 6;
}

@end
