//
//  WFBankCarInformation.m
//  SimuStock
//
//  Created by moulin wang on 15/4/14.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "WFSearchBankViewController.h"
#import "AppDelegate.h"

@implementation WFBankCarInformation

-(void)awakeFromNib
{
  
  self.MainTextField.delegate=self;
  self.MainTextField.keyboardType = UIKeyboardTypeNumberPad;
  self.MainTextField.textColor = [Globle colorFromHexRGB:@"454545"];
  self.MainTextField.font = [UIFont systemFontOfSize:14];
  //选择银行卡按钮的高亮颜色
  [self.actionButton setBackgroundImage:[SimuUtil imageFromColor:@"#131313"] forState:UIControlStateHighlighted];
}

- (IBAction)buttonAction:(UIButton *)sender {
  WFSearchBankViewController *searchVC = [[WFSearchBankViewController alloc] init];
  [AppDelegate pushViewControllerFromRight:searchVC];
  [searchVC bankWithCallback:^(NSString *bankName,int bankID) {
    if (bankName.length > 0) {
      self.bankInformationLabel.text = bankName;
      self.bankID = bankID;
    }else{
      self.bankInformationLabel.text = @"选择银行";
      self.bankID = 0;
    }
    NSLog(@"银行名称 =  %@ ,银行ID = %d",bankName,bankID);
  }];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
  if (_delegate && [_delegate respondsToSelector:@selector(ChangeScrollviewHight)])
  {
    [_delegate ChangeScrollviewHight];
  }
}



-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  if ([string isEqualToString:@"\n"]) {
    return YES;
  }
  NSString *toBeString =
  [textField.text stringByReplacingCharactersInRange:range
                                          withString:string];
  //设置银行卡输入框
  if (textField == self.MainTextField) {
    if ([toBeString length] > 18) {
      textField.text = [toBeString substringToIndex:19];
      return NO;
    }
  }
  
  return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
