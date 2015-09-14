//
//  IntroductionCattleView.m
//  SimuStock
//
//  Created by 刘小龙 on 15/7/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "IntroductionCattleView.h"

@implementation IntroductionCattleView

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
    UIView *containerView =
        [[[UINib nibWithNibName:@"IntroductionCattleView" bundle:nil]
            instantiateWithOwner:self
                         options:nil] objectAtIndex:0];
    CGRect newFrame =
        CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    containerView.frame = newFrame;
    [self addSubview:containerView];
  }
  return self;
}

- (void)awakeFromNib {
  
}

// 牛人简介
- (CGFloat)bindData:(UserDescData *)desc {

  CGFloat height = 0.0f;
  float width = self.introductionView.bounds.size.width;
  height = [FTCoreTextView heightWithText:desc.userDesc
                                    width:width
                                     font:Font_Height_12_0];
  if (height < 50) {
    height = 50;
  }
  self.introductionView.text = desc.userDesc;
  [self.introductionView setTextSize:Font_Height_12_0];
  [self.introductionView
      setTextColor:[Globle colorFromHexRGB:Color_Icon_Title]];
  [self.introductionView fitToSuggestedHeight];
  self.introduceHeight.constant = height;
  //返回 高度
  return height + 59; 
}

@end
