//
//  CompetionKeyBoardView.m
//  SimuStock
//
//  Created by moulin wang on 14-7-15.
//  Copyright (c) 2014年 Mac. All rights reserved.
//

#import "CompetionKeyBoardView.h"

@implementation CompetionKeyBoardView

@synthesize delegate = _delegate;
@synthesize siShiftDown = skbv_siShiftDown;

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    // Initialization code
    [self creatviews];
    skbv_siShiftDown = NO;
  }
  return self;
}
//创建各个按钮和图片
- (void)creatviews {
  //背景图片
  UIView *backgroundImageView = [[UIImageView alloc] init];
  backgroundImageView.frame =
      CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
  backgroundImageView.backgroundColor = [self colorWithHexString:@"#dbdcdf"];

  [self addSubview:backgroundImageView];
  //创建数字键盘
  [self creatNumberKeyView];
  //创建字母键盘
  [self creatCharKeyView];
}
//创建字母键盘视图
- (void)creatCharKeyView {
  //字母键盘承载视图
  skbv_charKeyBaseView = [[UIView alloc] initWithFrame:self.bounds];
  skbv_charKeyBaseView.backgroundColor = [UIColor clearColor];
  [self addSubview:skbv_charKeyBaseView];
  skbv_charKeyBaseView.hidden = YES;

  //各个按钮
  NSArray *array = @[@"Q", @"W", @"E", @"R", @"T", @"Y", @"U", @"I", @"O",
      @"P", @"A", @"S", @"D", @"F", @"G", @"H", @"J", @"K",
      @"L", @"清空", @"Z", @"X", @"C", @"V", @"B", @"N",
      @"M", @"", @"隐藏", @"确认", @"123"];
  int i = 0;

  //删除键盘前景
  UIImage *deleteImage_delete_up = [UIImage imageNamed:@"消退"];
  UIImage *deleteImage_delete_dwon = [UIImage imageNamed:@"消退_down"];
  
  CGFloat multiply= WIDTH_OF_SCREEN / 320;

  CGFloat left_sapce = 2 * multiply;
  CGFloat top_space = 10;
  CGFloat top_space_first = 9;
  CGFloat butwidth = 28.f * multiply;
  CGFloat butheight = 41.f;
  CGFloat butspace_width = 4 * multiply;
  CGFloat butspace_height = 13;
  CGFloat second_leftspace = 18 * multiply;
  CGFloat abc_butwidth = 76.f * multiply;
  CGFloat abc_butheight = 41.f;
  CGFloat shift_buttonwidth = 38.f * multiply;
  CGFloat shift_buttonHeight = 41.f;

  for (NSString *obj in array) {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:obj forState:UIControlStateNormal];
    [button setTitle:obj forState:UIControlStateHighlighted];
    [button.layer setMasksToBounds:YES];
    button.layer.cornerRadius = 5.0;
    button.backgroundColor = [self colorWithHexString:@"#fcfcfc"];
    [button setTitleColor:[self colorWithHexString:@"#0c0c0c"]
                 forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor]
                 forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    [button addTarget:self
                  action:@selector(touchdown:)
        forControlEvents:UIControlEventTouchDown];
    [button addTarget:self
                  action:@selector(outSide:)
        forControlEvents:UIControlEventTouchUpOutside];
    [button addTarget:self
                  action:@selector(charButtonPress:)
        forControlEvents:UIControlEventTouchUpInside];
    button.tag = i;
    [skbv_charKeyBaseView addSubview:button];
    if (i < 10) {
      button.frame = CGRectMake(left_sapce + (butspace_width + butwidth) * i,
                                top_space, butwidth, butheight);
    } else if (i < 19) {
      button.frame =
          CGRectMake(second_leftspace + (butspace_width + butwidth) * (i - 10),
                     top_space_first + (butheight + butspace_height) * 1,
                     butwidth, butheight);
    } else if (i == 19) {
      //一键清空
      [button setTitleColor:[self colorWithHexString:@"#0c0c0c"]
                   forState:UIControlStateNormal];
      [button setTitleColor:[UIColor whiteColor]
                   forState:UIControlStateHighlighted];
      button.backgroundColor = [self colorWithHexString:@"#c4c6ca"];
      button.frame = CGRectMake(
          left_sapce, top_space_first + (butspace_height + butheight) * 2,
          shift_buttonwidth, shift_buttonHeight);
      [button addTarget:self
                    action:@selector(touchdown1:)
          forControlEvents:UIControlEventTouchDown];
      [button addTarget:self
                    action:@selector(outSide1:)
          forControlEvents:UIControlEventTouchUpOutside];
    } else if (i < 27) {
      button.frame =
          CGRectMake(left_sapce + shift_buttonwidth + 10 +
                         (butspace_width + butwidth) * (i - 20),
                     top_space_first + (butspace_height + butheight) * 2,
                     butwidth, butheight);
    } else if (i == 27) {
      //删除键
      button.frame =
          CGRectMake(self.bounds.size.width - shift_buttonwidth - 2,
                     top_space_first + (butspace_height + butheight) * 2,
                     shift_buttonwidth, shift_buttonHeight);
      button.backgroundColor = [self colorWithHexString:@"#c4c6ca"];
      [button setImage:deleteImage_delete_up forState:UIControlStateNormal];
      [button setImage:deleteImage_delete_dwon
              forState:UIControlStateHighlighted];
      [button setTitleColor:[self colorWithHexString:@"#0c0c0c"]
                   forState:UIControlStateNormal];
      [button setTitleColor:[UIColor whiteColor]
                   forState:UIControlStateHighlighted];
      [button addTarget:self
                    action:@selector(touchdown1:)
          forControlEvents:UIControlEventTouchDown];
      [button addTarget:self
                    action:@selector(outSide1:)
          forControlEvents:UIControlEventTouchUpOutside];

    } else if (i == 28) {
      //隐藏
      button.frame = CGRectMake(
          left_sapce, top_space_first + (butspace_height + butheight) * 3,
          abc_butwidth, abc_butheight);
      button.backgroundColor = [self colorWithHexString:@"#c4c6ca"];
      [button setTitleColor:[self colorWithHexString:@"#0c0c0c"]
                   forState:UIControlStateNormal];
      [button setTitleColor:[UIColor whiteColor]
                   forState:UIControlStateHighlighted];
      [button addTarget:self
                    action:@selector(touchdown1:)
          forControlEvents:UIControlEventTouchDown];
      [button addTarget:self
                    action:@selector(outSide1:)
          forControlEvents:UIControlEventTouchUpOutside];

    } else if (i == 29) {
      //确认键
      button.frame =
          CGRectMake(left_sapce + abc_butwidth + 4,
                     top_space_first + (butspace_height + butheight) * 3, 155,
                     abc_butheight);
      button.backgroundColor = [self colorWithHexString:@"#fcfcfc"];
      [button setTitleColor:[self colorWithHexString:@"#0c0c0c"]
                   forState:UIControlStateNormal];
      [button setTitleColor:[UIColor whiteColor]
                   forState:UIControlStateHighlighted];
      [button addTarget:self
                    action:@selector(touchdown:)
          forControlEvents:UIControlEventTouchDown];
      [button addTarget:self
                    action:@selector(outSide:)
          forControlEvents:UIControlEventTouchUpOutside];

    } else if (i == 30) {
      // 123
      button.frame =
          CGRectMake(left_sapce + abc_butwidth + 4 + 4 + 155,
                     top_space_first + (butspace_height + butheight) * 3,
                     abc_butwidth, abc_butheight);
      button.backgroundColor = [self colorWithHexString:@"#c4c6ca"];
      [button setTitleColor:[self colorWithHexString:@"#0c0c0c"]
                   forState:UIControlStateNormal];
      [button setTitleColor:[UIColor whiteColor]
                   forState:UIControlStateHighlighted];
      [button addTarget:self
                    action:@selector(touchdown1:)
          forControlEvents:UIControlEventTouchDown];
      [button addTarget:self
                    action:@selector(outSide1:)
          forControlEvents:UIControlEventTouchUpOutside];
    }
    i++;
  }
}
//创建数字键盘
- (void)creatNumberKeyView {
  //数字键盘承载视图
  skbv_NumberKeyBaseView = [[UIView alloc] initWithFrame:self.bounds];
  skbv_NumberKeyBaseView.backgroundColor = [UIColor clearColor];
  [self addSubview:skbv_NumberKeyBaseView];
  //各个按钮
  NSArray *array =
      @[@"1", @"2", @"3", @"", @"4", @"5", @"6",
          @"隐藏", @"7", @"8", @"9", @"清空", @"0",
          @"确认", @"abc"];
  int i = 0;

  //设定删除键的前景和背景
  UIImage *delete_front_Image_up = [UIImage imageNamed:@"消退_down"];
  UIImage *delete_front_Image_down = [UIImage imageNamed:@"消退"];
  
  CGFloat multiply= WIDTH_OF_SCREEN / 320;

  CGFloat left_sapce = 4 * multiply;
  CGFloat top_space = 4 ;
  CGFloat top_space_first = 9 ;
  CGFloat butwidth = (59.f + 16.0) * multiply;
  CGFloat butheight = 48.5f;
  CGFloat bacbutwidth = (122.f + 32.0 ) * multiply;

  for (NSString *obj in array) {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button.layer setMasksToBounds:YES];
    button.layer.cornerRadius = 5.0;
    [button setTitle:obj forState:UIControlStateNormal];
    [button setTitle:obj forState:UIControlStateHighlighted];
    [button setTitleColor:[self colorWithHexString:@"#0c0c0c"]
                 forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor]
                 forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:17];
    button.backgroundColor = [self colorWithHexString:@"#fcfcfc"];
    [button addTarget:self
                  action:@selector(touchdown:)
        forControlEvents:UIControlEventTouchDown];
    [button addTarget:self
                  action:@selector(outSide:)
        forControlEvents:UIControlEventTouchUpOutside];
    [button addTarget:self
                  action:@selector(buttonpress:)
        forControlEvents:UIControlEventTouchUpInside];
    button.tag = i;
    [skbv_NumberKeyBaseView addSubview:button];
    if (i < 4) {
      button.frame = CGRectMake(left_sapce + (left_sapce + butwidth) * i,
                                top_space_first, butwidth, butheight);
      if (i == 3) {
        button.backgroundColor = [self colorWithHexString:@"#c4c6ca"];
        [button setTitleColor:[self colorWithHexString:@"#0c0c0c"]
                     forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor]
                     forState:UIControlStateHighlighted];
        [button addTarget:self
                      action:@selector(touchdown1:)
            forControlEvents:UIControlEventTouchDown];
        [button addTarget:self
                      action:@selector(outSide1:)
            forControlEvents:UIControlEventTouchUpOutside];
        [button setImage:delete_front_Image_down forState:UIControlStateNormal];
        [button setImage:delete_front_Image_up
                forState:UIControlStateHighlighted];
      }
    } else if (i < 8) {
      if (i == 7) {
        button.backgroundColor = [self colorWithHexString:@"#c4c6ca"];
        [button setTitleColor:[self colorWithHexString:@"#0c0c0c"]
                     forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor]
                     forState:UIControlStateHighlighted];
        [button addTarget:self
                      action:@selector(touchdown1:)
            forControlEvents:UIControlEventTouchDown];
        [button addTarget:self
                      action:@selector(outSide1:)
            forControlEvents:UIControlEventTouchUpOutside];
      }
      button.frame = CGRectMake(left_sapce + (left_sapce + butwidth) * (i - 4),
                                top_space_first + (top_space + butheight) * 1,
                                butwidth, butheight);
    } else if (i < 11) {
      button.frame = CGRectMake(left_sapce + (left_sapce + butwidth) * (i - 8),
                                top_space_first + (top_space + butheight) * 2,
                                butwidth, butheight);
    } else if (i < 12) {
      button.backgroundColor = [self colorWithHexString:@"#c4c6ca"];
      [button setTitleColor:[self colorWithHexString:@"#0c0c0c"]
                   forState:UIControlStateNormal];
      [button setTitleColor:[UIColor whiteColor]
                   forState:UIControlStateHighlighted];
      [button addTarget:self
                    action:@selector(touchdown1:)
          forControlEvents:UIControlEventTouchDown];
      [button addTarget:self
                    action:@selector(outSide1:)
          forControlEvents:UIControlEventTouchUpOutside];
      button.frame = CGRectMake(left_sapce + (left_sapce + butwidth) * 3,
                                top_space_first + (top_space + butheight) * 2,
                                butwidth, butheight);
    } else if (i == 12) {
      button.frame = CGRectMake(left_sapce + 0,
                                top_space_first + (top_space + butheight) * 3,
                                butwidth, butheight);
    } else if (i == 13) {
      button.backgroundColor = [self colorWithHexString:@"#fcfcfc"];
      [button setTitleColor:[self colorWithHexString:@"#0c0c0c"]
                   forState:UIControlStateNormal];
      [button setTitleColor:[UIColor whiteColor]
                   forState:UIControlStateHighlighted];
      [button addTarget:self
                    action:@selector(touchdown:)
          forControlEvents:UIControlEventTouchDown];
      [button addTarget:self
                    action:@selector(outSide:)
          forControlEvents:UIControlEventTouchUpOutside];
      button.frame = CGRectMake(left_sapce + (left_sapce + butwidth) * 1,
                                top_space_first + (top_space + butheight) * 3,
                                bacbutwidth, butheight);
    } else if (i == 14) {
      button.backgroundColor = [self colorWithHexString:@"#c4c6ca"];
      button.frame = CGRectMake(left_sapce + (left_sapce + butwidth) * 3,
                                top_space_first + (top_space + butheight) * 3,
                                butwidth, butheight);
      [button setTitleColor:[self colorWithHexString:@"#0c0c0c"]
                   forState:UIControlStateNormal];
      [button setTitleColor:[UIColor whiteColor]
                   forState:UIControlStateHighlighted];
      [button addTarget:self
                    action:@selector(touchdown1:)
          forControlEvents:UIControlEventTouchDown];
      [button addTarget:self
                    action:@selector(outSide1:)
          forControlEvents:UIControlEventTouchUpOutside];
    }
    i++;
  }
}
//按钮点击效果
- (void)touchdown:(UIButton *)btn {
  btn.backgroundColor = [self colorWithHexString:@"#0493fd"];
}
- (void)outSide:(UIButton *)btn {
  btn.backgroundColor = [self colorWithHexString:@"#fcfcfc"];
}
//按钮点击效果
- (void)touchdown1:(UIButton *)btn {
  btn.backgroundColor = [self colorWithHexString:@"#a0a1a3"];
}
- (void)outSide1:(UIButton *)btn {
  btn.backgroundColor = [self colorWithHexString:@"#c4c6ca"];
}
//按钮点击
- (void)buttonpress:(UIButton *)button {
  if (button.tag == 3 || button.tag == 7 || button.tag == 11 ||
      button.tag == 14) {
    button.backgroundColor = [self colorWithHexString:@"#c4c6ca"];
  } else {
    button.backgroundColor = [self colorWithHexString:@"#fcfcfc"];
  }
  NSLog(@"%ld", (long)button.tag);
  if (button.tag != 14) {
    [_delegate keyButtonDown:button];
  } else {
    // abc 点击
    [self changKeyBoardType:YES];
  }
}
//字母键盘按钮点击
- (void)charButtonPress:(UIButton *)button {
  if (button.tag == 19 || button.tag == 27 || button.tag == 28 ||
      button.tag == 30) {
    button.backgroundColor = [self colorWithHexString:@"#c4c6ca"];
  } else {
    button.backgroundColor = [self colorWithHexString:@"#fcfcfc"];
  }
  NSLog(@"%ld", (long)button.tag);
  if (button.tag != 30) {
    if (button.tag == 19) {
      skbv_siShiftDown = !skbv_siShiftDown;
    }
    [_delegate keyButtonCharDown:button];
  } else {
    // 123数字键
    [self changKeyBoardType:NO];
  }
}
//切换字母键盘和数字键盘
- (void)changKeyBoardType:(BOOL)isToCharKeyBoard {
  if (isToCharKeyBoard == YES) {
    // 切换到字母键盘
    skbv_charKeyBaseView.hidden = NO;
    skbv_NumberKeyBaseView.hidden = YES;
  } else {
    //切换到数字键盘
    skbv_charKeyBaseView.hidden = YES;
    skbv_NumberKeyBaseView.hidden = NO;
  }
}
- (UIColor *)colorWithHexString:(NSString *)stringToConvert {
  NSString *cString = [[stringToConvert
      stringByTrimmingCharactersInSet:
          [NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];

  // String should be 6 or 8 characters
  if ([cString length] < 6)
    return [UIColor blackColor];

  // strip 0X if it appears
  if ([cString hasPrefix:@"0X"])
    cString = [cString substringFromIndex:2];
  if ([cString hasPrefix:@"#"])
    cString = [cString substringFromIndex:1];
  if ([cString length] != 6)
    return [UIColor blackColor];
  // Separate into r, g, b substrings
  NSRange range;
  range.location = 0;
  range.length = 2;
  NSString *rString = [cString substringWithRange:range];

  range.location = 2;
  NSString *gString = [cString substringWithRange:range];

  range.location = 4;
  NSString *bString = [cString substringWithRange:range];

  // Scan values
  unsigned int r, g, b;
  [[NSScanner scannerWithString:rString] scanHexInt:&r];
  [[NSScanner scannerWithString:gString] scanHexInt:&g];
  [[NSScanner scannerWithString:bString] scanHexInt:&b];

  return [UIColor colorWithRed:((float)r / 255.0f)
                         green:((float)g / 255.0f)
                          blue:((float)b / 255.0f)
                         alpha:1.0f];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
