//
//  DayAndMoneyView.m
//  SimuStock
//
//  Created by Mac on 15/5/15.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "DayAndMoneyView.h"
#import "Globle.h"
#import "SimuUtil.h"
#import "WFInquireProductInfo.h"
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

@implementation DayAndMoneyView

- (void)awakeFromNib {
  _section = 0;
}

- (void)addButton:(NSArray *)array {
  [self.subviews
      enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        if ([[obj class] isSubclassOfClass:[UIButton class]]) {
          [obj removeFromSuperview];
        }
      }];
  int numTimer = (int)([array count] + 3) / 4;
  if (numTimer == 0) {
    numTimer = 1;
  }
  NSMutableArray *btnArrayM = [NSMutableArray array];
  CGFloat width = (self.width - 3) / 4.0f;
  for (int i = 0; i < numTimer * 4; i++) {
    WFProductButtonStateData *wfState = nil;
    if ([array count] > i) {
      wfState = [array objectAtIndex:i];
    }

    UIButton *button = [self CreatButton];
    button.tag = 1000 + i;
    button.frame = CGRectMake(i % 4 * (width + 1), i / 4 * 41 + 1, width, 40);
    if (wfState) {
      if (!wfState.State) {
        button.enabled = YES;
        [button setTitleColor:[Globle colorFromHexRGB:Color_Text_Common]
                     forState:UIControlStateNormal];
      } else {
        [button setTitleColor:[Globle colorFromHexRGB:Color_Gray]
                     forState:UIControlStateNormal];
        button.enabled = NO;
      }
      [button setTitle:wfState.Amount forState:UIControlStateNormal];
      [button addTarget:self
                    action:@selector(setupCheckmarkImage:)
          forControlEvents:UIControlEventTouchUpInside];
    } else {
      button.enabled = NO;
      [button setTitle:@"-" forState:UIControlStateNormal];
    }

    [self addSubview:button];
    [btnArrayM addObject:button];
  }
  self.btnArray = btnArrayM;
  [self addSubview:self.selectedImage];
}

- (UIButton *)CreatButton {
  UIButton *temp_btn = [UIButton buttonWithType:UIButtonTypeCustom];
  ///防止按钮同时触发
  [temp_btn setExclusiveTouch:YES];
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
  return temp_btn;
}

/** 设置选中的选项按钮上的对勾位置 */
- (void)setupCheckmarkImage:(UIButton *)selectedBtn {
  [self setupCheckmarkImage2:selectedBtn];
  self.block(self.SelectedIndex, _section);
}

///仅仅修改本View的选中态
- (void)setupCheckmarkImage2:(UIButton *)selectedBtn {
  UIButton *tempBtn = (UIButton *)[self viewWithTag:self.SelectedIndex + 1000];
  tempBtn.selected = NO;
  self.selectedImage.hidden = NO;
  self.selectedImage.width = Selected_Image_Side;
  self.selectedImage.height = Selected_Image_Side;
  self.selectedImage.right = selectedBtn.right - Selected_Image_Right_Margin;
  self.selectedImage.top = selectedBtn.top + Selected_Image_Top_Margin;
  self.SelectedIndex = selectedBtn.tag - 1000;
  selectedBtn.selected = YES;
}

- (void)clearAllChecked {
  [self.btnArray
      enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
        btn.selected = NO;
      }];
  self.SelectedIndex = -1;
  self.selectedImage.hidden = YES;
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
