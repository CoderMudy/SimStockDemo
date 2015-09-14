//
//  SimuTextField.m
//  SimuStock
//
//  Created by Mac on 14-10-27.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "SimuTextField.h"

@implementation SimuTextField

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
  }
  return self;
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
  if (action == @selector(cut:)) {
    return NO;
  } else if (action == @selector(copy:)) {
    return NO;
  } else if (action == @selector(paste:)) {
    return NO;
  } else if (action == @selector(select:)) {
    return NO;
  } else if (action == @selector(selectAll:)) {
    return NO;
  } else {

    return NO; //[super canPerformAction:action withSender:sender];
  }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
