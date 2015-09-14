//
//  UILabel+MoneyDetailLabel.h
//  SimuStock
//
//  Created by Wang Yugang on 15/3/29.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (MoneyDetailLabel)
/** 设置label的样式 颜色 大小 位置 内容 */
- (UILabel *)label:(UILabel *)label
         labelText:(NSString *)text
         textColor:(UIColor *)textColor
              font:(UIFont *)font
     textAlignment:(NSTextAlignment)textAlignment;

@end
