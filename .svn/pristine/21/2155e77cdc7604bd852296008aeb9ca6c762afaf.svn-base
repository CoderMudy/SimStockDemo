//
//  WithdrawScrollView.m
//  SimuStock
//
//  Created by jhss_wyz on 15/4/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

@implementation WithdrawScrollView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
  UIView *firstResponder =
      [keyWindow performSelector:@selector(firstResponder)];
  if ([firstResponder isKindOfClass:[UITextField class]]) {
    [firstResponder resignFirstResponder];
  }
}

@end
