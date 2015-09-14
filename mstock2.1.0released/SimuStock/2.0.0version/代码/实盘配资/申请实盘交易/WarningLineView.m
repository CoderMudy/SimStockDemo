//
//  WarningLineView.m
//  SimuStock
//
//  Created by Jhss on 15/6/9.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "WarningLineView.h"

@implementation WarningLineView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (WarningLineView *)createdWarningLineView {
  WarningLineView *temp_view =
      [[[NSBundle mainBundle] loadNibNamed:@"WarningLineView"
                                     owner:nil
                                   options:nil] lastObject];
  return temp_view;
}

@end
