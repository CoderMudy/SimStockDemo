//
//  ColorBackgroundImageButton.h
//  SimuStock
//
//  Created by Mac on 14-8-19.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorBackgroundImageButton : UIButton

@property(nonatomic, copy) UIColor *highlightBgColor; //高亮时显示的背景颜色
@property(nonatomic, copy) UIColor *normalBgColor; //通常情况下现实的背景颜色

//设置高亮背景颜色和通常的背景颜色
- (void)setHighlightBgColor:(UIColor *)highlightColor
              normalBgColor:(UIColor *)normalColor;

@end
