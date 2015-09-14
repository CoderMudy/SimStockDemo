//
//  ApplyActulTradingDayView.m
//  SimuStock
//
//  Created by jhss_wyz on 15/4/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ApplyActulTradingDayView.h"
#import "Globle.h"
#import "UILabel+SetProperty.h"
#import "SimuUtil.h"

/** 当前选中按钮中添加的图片 */
#define Selected_Image_Name @"小对号图标.png"
/** 顶部与底部视图文字大小 */
#define Title_Text_Font_Height Font_Height_15_0
/** 顶部视图灰色说明文字大小 */
#define Title_Text_Small_Font_Height Font_Height_12_0
/** 选项按钮文字大小 */
#define Btn_Font_Height Font_Height_14_0

/** 当前选中按钮中添加的图片与选中项上侧的间距 */
#define Selected_Image_Top_Margin 2
/** 当前选中按钮中添加的图片与选中项右侧的间距 */
#define Selected_Image_Right_Margin 3
/** 当前选中按钮中添加的图片宽高 */
#define Selected_Image_Side 15

@implementation ApplyActulTradingDayView

+ (ApplyActulTradingDayView *)applyActulTradingDayView {
  ApplyActulTradingDayView *temp_view =
      [[[NSBundle mainBundle] loadNibNamed:@"ApplyActulTradingDayView"
                                     owner:nil
                                   options:nil] lastObject];

  temp_view.backgroundColor = [Globle colorFromHexRGB:Color_Pressed_Gray];
  [temp_view.topLeftTitleLable
      setAttributedTextWithFirstString:@"选择操盘天数"
                          andFirstFont:
                              [UIFont systemFontOfSize:Title_Text_Font_Height]
                         andFirstColor:[Globle
                                           colorFromHexRGB:Color_Text_Common]
                       andSecondString:@"（交易日）"
                         andSecondFont:[UIFont systemFontOfSize:
                                                   Title_Text_Small_Font_Height]
                        andSecondColor:[Globle colorFromHexRGB:Color_Gray]];

  [temp_view addSubview:temp_view.selectedImage];
  temp_view.selectedImage.hidden = YES;

  return temp_view;
}

- (void)awakeFromNib {
  [self refreshSelectButtons];
}

/** 设置选项按钮 */
- (void)refreshSelectButtons {
  [self.btnArrays enumerateObjectsUsingBlock:^(UIButton *temp_btn,
                                               NSUInteger idx, BOOL *stop) {
    temp_btn.titleLabel.font = [UIFont systemFontOfSize:Btn_Font_Height];
    temp_btn.backgroundColor = [Globle colorFromHexRGB:Color_White];
    [temp_btn setTitleColor:[Globle colorFromHexRGB:Color_Text_Common]
                   forState:UIControlStateNormal];
    [temp_btn setTitleColor:[Globle colorFromHexRGB:@"#fe8519"]
                   forState:UIControlStateSelected];
    [temp_btn setTitleColor:[Globle colorFromHexRGB:Color_Text_Common]
                   forState:UIControlStateHighlighted];

    [temp_btn setBackgroundImage:[SimuUtil imageFromColor:Color_White]
                        forState:UIControlStateNormal];
    [temp_btn setBackgroundImage:[SimuUtil imageFromColor:Color_White]
                        forState:UIControlStateSelected];
    [temp_btn setBackgroundImage:[SimuUtil imageFromColor:Color_Pressed_Gray]
                        forState:UIControlStateHighlighted];

    if (self.infoArray == nil) {
      temp_btn.userInteractionEnabled = NO;
      [temp_btn setTitle:@"" forState:UIControlStateNormal];
    } else if (idx >= self.infoArray.count ||
               [self.infoArray[idx] isEqualToString:@""]) {
      temp_btn.userInteractionEnabled = NO;
      [temp_btn setTitleColor:[Globle colorFromHexRGB:Color_Gray]
                     forState:UIControlStateNormal];
      [temp_btn setTitle:@"-" forState:UIControlStateNormal];
    } else {
      temp_btn.userInteractionEnabled = YES;
      temp_btn.enabled = YES;
      [temp_btn setTitle:[self convertString:(NSString *)self.infoArray[idx]]
                forState:UIControlStateNormal];
    }
  }];
}

/** 按钮文字处理函数（添加单位） */
- (NSString *)convertString:(NSString *)string {
  return [string stringByAppendingString:@"天"];
}

/** 设置选中的选项按钮上的对勾位置 */
- (void)setupCheckmarkImage {
  self.selectedImage.width = Selected_Image_Side;
  self.selectedImage.height = Selected_Image_Side;
  self.selectedImage.right =
      self.selectedBtn.right - Selected_Image_Right_Margin;
  self.selectedImage.top = self.selectedBtn.top + Selected_Image_Top_Margin;
}

#pragma mark--- 懒加载 ---
- (UIButton *)selectedImage {
  if (_selectedImage == nil) {
    _selectedImage = [UIButton buttonWithType:UIButtonTypeCustom];
    [_selectedImage setImage:[UIImage imageNamed:Selected_Image_Name]
                    forState:UIControlStateNormal];
    _selectedImage.userInteractionEnabled = NO;
  }
  _selectedImage.imageEdgeInsets = UIEdgeInsetsMake(3.0, 3.0, 3.0, 3.0);
  _selectedImage.backgroundColor = [Globle colorFromHexRGB:@"#fe8519"];
  _selectedImage.layer.cornerRadius = _selectedImage.size.width / 2;
  _selectedImage.layer.masksToBounds = YES;
  return _selectedImage;
}

@end
