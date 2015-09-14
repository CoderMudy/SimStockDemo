//
//  YL_Click_Button.m
//  SimuStock
//
//  Created by Mac on 15/1/11.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "YLClickButton.h"
#import "YLColorToimage.h"
@implementation YLClickButton

+ (YLClickButton *)buttonWithType:(UIButtonType)buttonType
{
  return (YLClickButton *)[super buttonWithType:buttonType];
}

-(void)addimage:(UIImage *)image andImageWithFrame:(CGRect)frame andColor:(UIColor *)color andHighlightedColor:(UIColor *)HighlightedColor forState:(UIControlState)state
{
  [self removeAllSubviews];
  
  if (state==UIControlStateHighlighted)
  {
    [self setBackgroundImage:[UIImage imageWithColor:HighlightedColor] forState:UIControlStateHighlighted];
  }
  else
  {
    [self setBackgroundImage:[UIImage imageWithColor:color] forState:UIControlStateNormal];
  }
  UIImageView * btn_image=[[UIImageView alloc]initWithFrame:frame];
  btn_image.image=image;
  btn_image.userInteractionEnabled=NO;
  [self addSubview:btn_image];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
