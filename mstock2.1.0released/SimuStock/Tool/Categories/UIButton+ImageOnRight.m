//
//  UIButton+ImageOnRight.m
//  SimuStock
//
//  Created by Yuemeng on 15/6/19.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "UIButton+ImageOnRight.h"
#import "SimuUtil.h"

static float const space = 2.5f;

@implementation UIButton (ImageOnRight)

- (void)resetTitleAndImageSpace {
//  [self sizeToFit];
  self.titleEdgeInsets = UIEdgeInsetsMake(0, -self.imageView.width - space, 0,
                                          self.imageView.width + space);
  self.imageEdgeInsets = UIEdgeInsetsMake(0, self.titleLabel.width + space, 0,
                                          -self.titleLabel.width - space);
}

@end
