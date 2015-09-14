//
//  UIButton+Hightlighted.m
//  SimuStock
//
//  Created by Mac on 15/5/8.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "UIButton+Hightlighted.h"
#import "Globle.h"
#import "UIImage+colorful.h"
@implementation UIButton (Hightlighted)
///按钮的按下态设置
- (void)buttonWithNormal:(NSString *)normalColor
    andHightlightedColor:(NSString *)hightlightedcolor {
  [self setBackgroundImage:
            [UIImage imageWithColor:[Globle colorFromHexRGB:normalColor]]
                  forState:UIControlStateNormal];
  [self setBackgroundImage:
            [UIImage imageWithColor:[Globle colorFromHexRGB:hightlightedcolor]]
                  forState:UIControlStateHighlighted];
}


@end
