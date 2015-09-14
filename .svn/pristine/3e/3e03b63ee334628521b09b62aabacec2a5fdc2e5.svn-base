//
//  UILabel+SetProperty.h
//  SimuStock
//
//  Created by jhss_wyz on 15/4/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (SetProperty)

/**
 类方法创建AttributedLable对象
 infoString：前段文字内容（颜色：Color_Text_Common；字体大小：Font_Height_12_0）
 unitString：后段文字内容（颜色：Color_Gray；字体大小：Font_Height_8_0）
 */
+ (instancetype)lableWithInfo:(NSString *)infoString
                      andUnit:(NSString *)unitString;

/**
 设置属性文字
 FirstString：前段文字内容
 FirstFont：前段文字字体
 FirstColor：前段文字颜色
 secondString：后段文字内容
 secondFont：后段文字字体
 secondColor：后段文字颜色
 */
- (void)setAttributedTextWithFirstString:(NSString *)FirstString
                            andFirstFont:(UIFont *)FirstFont
                           andFirstColor:(UIColor *)FirstColor
                         andSecondString:(NSString *)secondString
                           andSecondFont:(UIFont *)secondFont
                          andSecondColor:(UIColor *)secondColor;

/**
 设置UILable对象的文字
 text：文字内容
 textcolor：文字字体
 textfont：文字颜色
 */
- (void)setupLableWithText:(NSString *)text
              andTextColor:(UIColor *)textcolor
               andTextFont:(UIFont *)textfont;

/**
 设置UILable对象的文字
 text：文字内容
 textcolor：文字字体
 textfont：文字颜色
 alignment:文字对齐方式
 */
- (void)setupLableWithText:(NSString *)text
              andTextColor:(UIColor *)textcolor
               andTextFont:(UIFont *)textfont
              andAlignment:(NSTextAlignment)alignment;

@end
