//
//  ConfirmPayView.m
//  SimuStock
//
//  Created by Jhss on 15/6/5.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ConfirmPayView.h"
#import "UIButton+Hightlighted.h"
#import "ProcessInputData.h"

@implementation ConfirmPayView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (ConfirmPayView *)createdConfirmPayInfoView {
  ConfirmPayView *temp_view =
      [[[NSBundle mainBundle] loadNibNamed:@"ConfirmPayView"
                                     owner:nil
                                   options:nil] lastObject];
  return temp_view;
}

- (void)awakeFromNib {

  [self.confirmPayButton buttonWithNormal:Color_Blue_but
                     andHightlightedColor:Color_Blue_butDown];
  [self.confirmPayButton buttonWithTitle:@"确认支付"
                      andNormaltextcolor:Color_White
                andHightlightedTextColor:Color_White];

  self.payMoneyNumberLabel.text = @"0.00元";
}

- (void)settingUpWithPayMoneyLabel:(NSString *)titleLabel
           WithPayMoneyNumberLabel:(NSString *)numberLabel
           WithAccountBalanceLabel:(NSString *)accounBalance {

  self.payMoneyLabel.text = titleLabel;
  self.payMoneyNumberLabel.text =
      [[ProcessInputData convertMoneyString:numberLabel]
          stringByAppendingFormat:@"元"];
  self.accountBalanceLabel.text =
      [[ProcessInputData convertMoneyString:accounBalance]
          stringByAppendingFormat:@"元"];
}

@end
