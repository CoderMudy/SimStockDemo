//
//  UITextField+SaveStockAlarmRulesTextField.m
//  SimuStock
//
//  Created by xuming tan on 15-3-27.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "UITextField+SaveStockAlarmRulesTextField.h"

@implementation UITextField (SaveStockAlarmRulesTextField)
//重置股价涨跌输入位置（开头空一格）
- (void)resetInputPositionOfStockPriceUpAndDown {
  UILabel *leftView = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 7, 26)];
  leftView.backgroundColor = [UIColor clearColor];
  self.leftView = leftView;
  self.leftViewMode = UITextFieldViewModeAlways;
  self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
}

//重置股价涨幅输入位置（开头空一格）
- (void)resetInputPositionOfDailyGains {
  UILabel *leftView = [[UILabel alloc] initWithFrame:CGRectMake(10, 1, 14, 26)];
  leftView.backgroundColor = [UIColor clearColor];
  leftView.text = [NSString stringWithFormat:@"+"];
  leftView.textAlignment = NSTextAlignmentCenter;
  leftView.textColor = [UIColor blackColor];
  leftView.font = [UIFont systemFontOfSize:Font_Height_13_0];

  self.leftView = leftView;
  self.leftViewMode = UITextFieldViewModeAlways;
  self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
}

//重置股价跌幅输入位置（开头空一格）
- (void)resetInputPositionOfDailyDrops {
  UILabel *leftView = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 14, 26)];
  leftView.backgroundColor = [UIColor clearColor];
  leftView.text = [NSString stringWithFormat:@"-"];
  leftView.textAlignment = NSTextAlignmentCenter;
  leftView.textColor = [UIColor blackColor];
  leftView.font = [UIFont systemFontOfSize:Font_Height_13_0];

  self.leftView = leftView;
  self.leftViewMode = UITextFieldViewModeAlways;
  self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
}
@end
