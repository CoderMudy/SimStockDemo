//
//  SearchNotFoundView.m
//  SimuStock
//
//  Created by Jhss on 15/8/17.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "SearchNotFoundView.h"

@implementation SearchNotFoundView

- (void)awakeFromNib {
  //  [self.imageView setImage:[UIImage imageNamed:@"捂嘴小牛"]];
  [self.callButton buttonWithTitle:@"010-53599702"
                andNormaltextcolor:Color_Blue_but
          andHightlightedTextColor:Color_White];
  [self.callButton addTarget:self
                      action:@selector(connetCustomerServiceClick)
            forControlEvents:UIControlEventTouchUpInside];
}
- (void)connetCustomerServiceClick {
  //操作表
  NSString *number = @"01053599702"; // 此处读入电话号码
  NSURL *backURL = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", number]];
  [[UIApplication sharedApplication] openURL:backURL];
}
@end
