//
//  AddAwardsView.m
//  SimuStock
//
//  Created by 刘小龙 on 15/8/11.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "AddAwardsView.h"

@implementation AddAwardsView
- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
    UIView *containerView = [[[UINib nibWithNibName:@"AddAwardsView" bundle:nil]
        instantiateWithOwner:self
                     options:nil] objectAtIndex:0];
    CGRect newFrame =
        CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    containerView.frame = newFrame;
    [self addSubview:containerView];
  }
  return self;
}

/** 添加奖项按钮 */
- (IBAction)addAwardsButtonUpInside:(UIButton *)sender {
  if (self.addAwardsBlock) {
    self.addAwardsBlock();
  }
}
@end
