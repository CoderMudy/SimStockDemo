//
//  ApplyActulTradingView.m
//  SimuStock
//
//  Created by jhss_wyz on 15/3/24.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "ApplyForLargeMoneyViewController.h"
#import "AppDelegate.h"

/** 当前选中按钮中添加的图片 */
#define Selected_Image_Name @"小对号图标.png"
/** 大额实盘申请右侧图片 */
#define Btn_Apply_Image @"小箭头.png"
/** 顶部与底部视图文字大小 */
#define Title_Text_Font_Height Font_Height_15_0
/** 选项按钮文字大小 */
#define Btn_Font_Height Font_Height_14_0

/** 当前选中按钮中添加的图片与选中项上侧的间距 */
#define Selected_Image_Top_Margin 2
/** 当前选中按钮中添加的图片与选中项右侧的间距 */
#define Selected_Image_Right_Margin 3
/** 当前选中按钮中添加的图片宽高 */
#define Selected_Image_Side 15

@implementation ApplyActulTradingAccountView

+ (ApplyActulTradingAccountView *)applyActulTradingAccountView {
  ApplyActulTradingAccountView *temp_view =
      [[[NSBundle mainBundle] loadNibNamed:@"ApplyActulTradingAccountView"
                                     owner:nil
                                   options:nil] lastObject];

  temp_view.backgroundColor = [Globle colorFromHexRGB:Color_Pressed_Gray];
  [temp_view.topTitleLable
      setupLableWithText:@"选择操盘金额"
            andTextColor:[Globle colorFromHexRGB:Color_Text_Common]
             andTextFont:[UIFont systemFontOfSize:Title_Text_Font_Height]
            andAlignment:NSTextAlignmentLeft];
  [temp_view setupBottomButtonWithBotttomLeftText:@"大额配资申请"];

  [temp_view addSubview:temp_view.selectedImage];
  temp_view.selectedImage.hidden = YES;

  temp_view.bottomBtn.enabled = YES;

  return temp_view;
}

- (void)awakeFromNib {
  [self refreshSelectButtons];
}

/** 设置选项按钮 */
- (void)refreshSelectButtons {
  [self.btnArray enumerateObjectsUsingBlock:^(UIButton *temp_btn,
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

/** 设置底部视图 */
- (void)setupBottomButtonWithBotttomLeftText:(NSString *)bottomLeftText {
  self.bottomBtn.backgroundColor = [Globle colorFromHexRGB:Color_White];
  [self.bottomLeftLable
      setupLableWithText:bottomLeftText
            andTextColor:[Globle colorFromHexRGB:@"#086dae"]
             andTextFont:[UIFont systemFontOfSize:Title_Text_Font_Height]
            andAlignment:NSTextAlignmentLeft];
  self.bottomBtn.userInteractionEnabled = YES;
  self.bottomBtn.enabled = YES;
  [self.bottomRightBtn setTitle:@"" forState:UIControlStateNormal];
  [self.bottomRightBtn setImage:[UIImage imageNamed:Btn_Apply_Image]
                       forState:UIControlStateNormal];
  self.bottomRightBtn.userInteractionEnabled = NO;
  self.bottomRightBtn.tintColor = [Globle colorFromHexRGB:@"#949494"];
  
  [self.bottomBtn setBackgroundImage:[SimuUtil imageFromColor:Color_White]
                      forState:UIControlStateNormal];
  [self.bottomBtn setBackgroundImage:[SimuUtil imageFromColor:Color_White]
                      forState:UIControlStateSelected];
  [self.bottomBtn setBackgroundImage:[SimuUtil imageFromColor:Color_Pressed_Gray]
                      forState:UIControlStateHighlighted];
}

/** 按钮文字处理函数（添加单位） */
- (NSString *)convertString:(NSString *)string {
  if ([string integerValue] >= 10000) {
    return [string
        stringByReplacingCharactersInRange:NSMakeRange((string.length - 4), 4)
                                withString:@"万元"];
  }
  return string;
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
