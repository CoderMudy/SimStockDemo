//
//  MoreCell.m
//  SimuStock
//
//  Created by moulin wang on 15/4/7.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "MoreCell.h"
#import "Globle.h"



@implementation MoreCell



- (void)layoutSubviews {
  [super layoutSubviews];
  float leftwidth = 0;
  //初始化一些东西
  UIImage *arrowImage = [UIImage imageNamed:@"箭头.png"];
  if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
    // ios7及以上版本
    leftwidth = WIDTH_OF_SCREEN - 12 - arrowImage.size.width;
  } else {
    leftwidth = WIDTH_OF_SCREEN - 32 - arrowImage.size.width;
  }
  self.arrowImageView.image = arrowImage;
  self.arrowImageView.frame = CGRectMake(
      leftwidth, (self.bounds.size.height - arrowImage.size.height) * 0.5,
      arrowImage.size.width, arrowImage.size.height);
  self.titleLable.frame =
      CGRectMake(CGRectGetMaxX(self.titleImageView.frame) + 7,
                 (self.bounds.size.height - 16) / 2 + 1,
                 WIDTH_OF_SCREEN -
                     (CGRectGetMaxX(self.titleImageView.frame) + 3 - 40),
                 16);
  self.titleLable.font = [UIFont systemFontOfSize:Font_Height_17_0];
  self.titleLable.textAlignment = NSTextAlignmentLeft;
  self.titleLable.textColor = [Globle colorFromHexRGB:Color_Text_Common];
  self.titleLable.backgroundColor = [UIColor clearColor];
}



@end
