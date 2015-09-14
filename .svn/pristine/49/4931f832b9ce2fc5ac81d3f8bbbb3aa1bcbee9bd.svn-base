//
//  UILabel+CmpetitionLabel.m
//  SimuStock
//
//  Created by moulin wang on 14-5-6.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "UILabel+CmpetitionLabel.h"

@implementation UILabel (CmpetitionLabel)
// UILabel属性设置
- (UILabel *)label:(UILabel *)label
         labelText:(NSString *)text
         textColor:(UIColor *)textColor
             frame:(CGRect)rect
              font:(UIFont *)font
              wrap:(BOOL)wrap {
  if (wrap) {
    //自动折行设置
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.numberOfLines = 0;
  }
  label.backgroundColor = [UIColor clearColor];
  label.frame = rect;
  label.textColor = textColor;
  label.text = text;
  label.font = font;
  return label;
}
- (UILabel *)label:(UILabel *)label
         labelText:(NSString *)text
         textColor:(UIColor *)textColor
             frame:(CGRect)rect
              font:(UIFont *)font
     textAlignment:(NSTextAlignment)textAlignment
              wrap:(BOOL)wrap {
  if (wrap) {
    //自动折行设置
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
  }
  label.backgroundColor = [UIColor clearColor];
  label.frame = rect;
  label.textColor = textColor;
  label.textAlignment = textAlignment;
  label.text = text;
  label.font = font;
  return label;
}

@end
