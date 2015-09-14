//
//  UILabel+SetProperty.m
//  SimuStock
//
//  Created by jhss_wyz on 15/4/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "UILabel+SetProperty.h"
#import "Globle.h"

@implementation UILabel (SetProperty)

+ (UILabel *)lableWithInfo:(NSString *)infoString
                   andUnit:(NSString *)unitString {
  UILabel *attributed_label = [[UILabel alloc] init];

  [attributed_label
      setAttributedTextWithFirstString:infoString
                          andFirstFont:[UIFont
                                           systemFontOfSize:Font_Height_12_0]
                         andFirstColor:[Globle
                                           colorFromHexRGB:Color_Text_Common]
                       andSecondString:unitString
                         andSecondFont:[UIFont systemFontOfSize:Font_Height_08_0]
                        andSecondColor:[Globle colorFromHexRGB:Color_Gray]];

  return attributed_label;
}

- (void)setAttributedTextWithFirstString:(NSString *)FirstString
                            andFirstFont:(UIFont *)FirstFont
                           andFirstColor:(UIColor *)FirstColor
                         andSecondString:(NSString *)secondString
                           andSecondFont:(UIFont *)secondFont
                          andSecondColor:(UIColor *)secondColor {
  NSString *str =
      [NSString stringWithFormat:@"%@%@", FirstString, secondString];
  NSMutableAttributedString *str_ma =
      [[NSMutableAttributedString alloc] initWithString:str];

  [str_ma addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                          FirstFont, NSFontAttributeName,
                                          FirstColor,
                                          NSForegroundColorAttributeName, nil]
                  range:[str rangeOfString:FirstString]];
  [str_ma addAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                          secondFont, NSFontAttributeName,
                                          secondColor,
                                          NSForegroundColorAttributeName, nil]
                  range:[str rangeOfString:secondString]];

  self.attributedText = str_ma;
}

- (void)setupLableWithText:(NSString *)text
              andTextColor:(UIColor *)textcolor
               andTextFont:(UIFont *)textfont {
  self.text = text;
  self.textColor = textcolor;
  self.font = textfont;
}

- (void)setupLableWithText:(NSString *)text
              andTextColor:(UIColor *)textcolor
               andTextFont:(UIFont *)textfont
              andAlignment:(NSTextAlignment)alignment {
  [self setupLableWithText:text andTextColor:textcolor andTextFont:textfont];
  self.textAlignment = alignment;
}

@end
