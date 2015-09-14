//
//  UILabel+MoneyDetailLabel.m
//  SimuStock
//
//  Created by Wang Yugang on 15/3/29.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

@implementation UILabel (MoneyDetailLabel)
/** 设置label的样式 颜色 大小 位置 内容 */
- (UILabel *)label:(UILabel *)label
         labelText:(NSString *)text
         textColor:(UIColor *)textColor
              font:(UIFont *)font
     textAlignment:(NSTextAlignment)textAlignment {
  label.backgroundColor = [UIColor clearColor];
  label.textColor = textColor;
  label.textAlignment = textAlignment;
  label.text = text;
  label.font = font;
  return label;
}

@end
